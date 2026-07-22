import { BadRequestException } from '@nestjs/common';
import { CouponsService } from './coupons.service';

/**
 * Regression tests for F-1: coupon usage-limit enforcement and the count-then-
 * insert race.
 *
 * `quote` accepts the transaction client so BookingsService can run the limit
 * READ and the redemption INSERT in one Serializable transaction. These tests
 * drive quote through a client backed by a shared in-memory redemption ledger:
 * once a redemption is recorded, a second quote on the same client sees it and
 * correctly rejects — the behaviour the Serializable transaction guarantees
 * across concurrent bookings at runtime.
 */
describe('CouponsService.quote usage limits', () => {
  const USER = 'user-1';
  const OTHER = 'user-2';

  interface Redemption {
    couponId: string;
    userId: string;
    status: string;
  }

  // A fake Prisma client sharing one redemption ledger between count() reads
  // and recordRedemption() writes, mirroring a single open transaction.
  function buildClient(coupon: any) {
    const ledger: Redemption[] = [];
    const client = {
      coupon: { findUnique: jest.fn(async () => coupon) },
      couponRedemption: {
        count: jest.fn(
          async ({ where }: any) =>
            ledger.filter(
              (r) =>
                r.couponId === where.couponId &&
                r.status === where.status &&
                (where.userId === undefined || r.userId === where.userId),
            ).length,
        ),
        create: jest.fn(async ({ data }: any) => {
          ledger.push({
            couponId: data.couponId,
            userId: data.userId,
            status: data.status,
          });
        }),
      },
    };
    return { client, ledger };
  }

  const baseCoupon = {
    id: 'c1',
    code: 'SAVE10',
    isActive: true,
    validFrom: null,
    validUntil: null,
    audience: 'all',
    minAmount: 0,
    discountType: 'percentage',
    discountValue: 10,
    maxDiscount: null,
    usageLimit: null,
    perUserLimit: null,
  };

  it('computes a server-side percentage discount', async () => {
    const svc = new CouponsService({} as any);
    const { client } = buildClient(baseCoupon);
    const quote = await svc.quote(
      USER,
      'save10',
      1000,
      'passenger',
      client as any,
    );
    expect(quote.discountAmount).toBe(100);
    expect(quote.finalAmount).toBe(900);
  });

  it('enforces perUserLimit: a second redemption on the same client is rejected', async () => {
    const svc = new CouponsService({} as any);
    const { client } = buildClient({ ...baseCoupon, perUserLimit: 1 });

    const quote = await svc.quote(
      USER,
      'save10',
      1000,
      'passenger',
      client as any,
    );
    await svc.recordRedemption(client as any, {
      couponId: quote.couponId,
      userId: USER,
      bookingId: 'b1',
      discountAmount: quote.discountAmount,
    });

    // Same user, same coupon, same (transaction) client → the just-recorded
    // redemption is visible, so the second quote must fail. This is the race
    // that Serializable isolation closes at runtime.
    await expect(
      svc.quote(USER, 'save10', 1000, 'passenger', client as any),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('enforces a global usageLimit across users', async () => {
    const svc = new CouponsService({} as any);
    const { client } = buildClient({ ...baseCoupon, usageLimit: 1 });

    const quote = await svc.quote(
      USER,
      'save10',
      1000,
      'passenger',
      client as any,
    );
    await svc.recordRedemption(client as any, {
      couponId: quote.couponId,
      userId: USER,
      bookingId: 'b1',
      discountAmount: quote.discountAmount,
    });

    await expect(
      svc.quote(OTHER, 'save10', 1000, 'passenger', client as any),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('a reversed redemption does not count toward limits', async () => {
    const svc = new CouponsService({} as any);
    const { client, ledger } = buildClient({ ...baseCoupon, perUserLimit: 1 });

    const quote = await svc.quote(
      USER,
      'save10',
      1000,
      'passenger',
      client as any,
    );
    await svc.recordRedemption(client as any, {
      couponId: quote.couponId,
      userId: USER,
      bookingId: 'b1',
      discountAmount: quote.discountAmount,
    });
    // Simulate the booking being cancelled → redemption reversed.
    ledger[0].status = 'reversed';

    // The user may redeem again since the prior redemption no longer counts.
    await expect(
      svc.quote(USER, 'save10', 1000, 'passenger', client as any),
    ).resolves.toMatchObject({ discountAmount: 100 });
  });
});
