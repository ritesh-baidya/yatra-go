import { BadRequestException } from '@nestjs/common';
import { ReportsService } from './reports.service';

/**
 * Regression tests for F-5: report creation is rate-limited per reporter to
 * stop the moderation queue being flooded / weaponised for harassment, while
 * legitimate reporting still works.
 */
describe('ReportsService.create rate limiting', () => {
  const REPORTER = 'reporter-1';
  const REPORTED = 'reported-1';

  function buildService(recentReportCount: number) {
    const prisma = {
      user: { findUnique: jest.fn().mockResolvedValue({ id: REPORTED }) },
      userReport: {
        count: jest.fn().mockResolvedValue(recentReportCount),
        create: jest.fn().mockResolvedValue({ id: 'report-1' }),
      },
      booking: { findUnique: jest.fn() },
      driverProfile: { findUnique: jest.fn() },
    };
    const svc = new ReportsService(prisma as any);
    return { svc, prisma };
  }

  it('allows a report when under the hourly cap', async () => {
    const { svc, prisma } = buildService(2);
    await svc.create(REPORTER, { reportedId: REPORTED, reason: 'spam' });
    expect(prisma.userReport.create).toHaveBeenCalledTimes(1);
  });

  it('rejects a report once the hourly cap is reached', async () => {
    const { svc, prisma } = buildService(10);
    await expect(
      svc.create(REPORTER, { reportedId: REPORTED, reason: 'spam' } as any),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(prisma.userReport.create).not.toHaveBeenCalled();
  });

  it('still blocks self-reporting before the rate-limit check', async () => {
    const { svc, prisma } = buildService(0);
    await expect(
      svc.create(REPORTER, { reportedId: REPORTER, reason: 'x' } as any),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(prisma.userReport.create).not.toHaveBeenCalled();
  });
});
