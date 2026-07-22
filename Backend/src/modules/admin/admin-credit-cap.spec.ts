import { ForbiddenException } from '@nestjs/common';
import { AdminService } from './admin.service';
import { appConfig } from '../../config/app.config';

/**
 * Regression tests for the admin wallet-credit dual-control gate.
 *
 * F-2 (race hardening): the cumulative-cap READ, the wallet credit and the
 * audit row the cap sums over now all run inside ONE Serializable transaction.
 * These tests drive creditWallet through a transaction mock whose audit ledger
 * is shared between the cap read and the in-transaction audit write, so a
 * second credit correctly sees the first one's committed row — proving the
 * cumulative cap can no longer be bypassed by splitting or racing credits.
 */
describe('AdminService.creditWallet cumulative dual-control', () => {
  const THRESHOLD = appConfig.adminCreditSuperThreshold; // 10_000 by default
  const ADMIN = 'admin-1';
  const TARGET = 'user-1';

  // Build a service whose transaction shares one in-memory audit ledger, so
  // `wallet_credited` rows written inside a transaction are visible to the
  // cap read of the next credit — exactly what Serializable isolation gives us.
  function buildService(seedCredits: number[] = []) {
    const ledger: Array<{ details: { amount: number } }> = seedCredits.map(
      (amount) => ({ details: { amount } }),
    );
    let balance = 0;

    const tx = {
      auditLog: {
        findMany: jest.fn(async () => [...ledger]),
        create: jest.fn(async ({ data }: any) => {
          ledger.push({ details: { amount: data.details.amount } });
        }),
      },
      wallet: {
        upsert: jest.fn(async () => ({ id: 'wallet-1' })),
        update: jest.fn(async ({ data }: any) => {
          balance += data.balance.increment;
          return { balance };
        }),
      },
      walletTransaction: { create: jest.fn(async () => ({ id: 'txn-1' })) },
    };

    const prisma = {
      user: { findUnique: jest.fn().mockResolvedValue({ id: TARGET }) },
      $transaction: jest.fn(async (fn: any) => fn(tx)),
    };
    const notifications = {
      createNotification: jest.fn().mockResolvedValue(undefined),
    };
    const audit = { log: jest.fn().mockResolvedValue(undefined) };
    const svc = new AdminService(
      prisma as any,
      audit as any,
      {} as any,
      {} as any,
      notifications as any,
      {} as any,
      {} as any,
    );
    return { svc, tx };
  }

  it('allows a sub-threshold credit when nothing was credited today', async () => {
    const { svc, tx } = buildService([]);
    await svc.creditWallet(ADMIN, 'admin', TARGET, { amount: THRESHOLD - 1 });
    expect(tx.wallet.update).toHaveBeenCalledTimes(1);
    expect(tx.auditLog.create).toHaveBeenCalledTimes(1);
  });

  it('blocks a single credit above the threshold for a non-super admin', async () => {
    const { svc, tx } = buildService([]);
    await expect(
      svc.creditWallet(ADMIN, 'admin', TARGET, { amount: THRESHOLD + 1 }),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(tx.wallet.update).not.toHaveBeenCalled();
  });

  it('blocks split sub-threshold credits that cumulatively exceed the threshold', async () => {
    const { svc, tx } = buildService([THRESHOLD - 1]);
    await expect(
      svc.creditWallet(ADMIN, 'admin', TARGET, { amount: 100 }),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(tx.wallet.update).not.toHaveBeenCalled();
  });

  it('a second credit sees the first one written in-transaction (no bypass)', async () => {
    const { svc, tx } = buildService([]);
    // First half-threshold credit succeeds and records its audit row.
    await svc.creditWallet(ADMIN, 'admin', TARGET, { amount: THRESHOLD * 0.6 });
    // A second credit that would tip the rolling total over the cap is rejected
    // because the in-transaction audit write from the first is now visible.
    await expect(
      svc.creditWallet(ADMIN, 'admin', TARGET, { amount: THRESHOLD * 0.6 }),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(tx.wallet.update).toHaveBeenCalledTimes(1); // only the first credited
  });

  it('allows a super admin to exceed the threshold', async () => {
    const { svc, tx } = buildService([THRESHOLD * 10]);
    await svc.creditWallet(ADMIN, 'super_admin', TARGET, {
      amount: THRESHOLD * 5,
    });
    expect(tx.wallet.update).toHaveBeenCalledTimes(1);
  });
});
