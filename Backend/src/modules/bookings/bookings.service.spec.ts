import { Prisma } from '@prisma/client';
import { BookingsService } from './bookings.service';

/**
 * Regression tests for F-3 (booking + coupon redemption atomicity) and the
 * F-1 coupon race: when a coupon is applied, the coupon validation, the
 * booking INSERT and the redemption INSERT must all run inside ONE Serializable
 * transaction, on the SAME transaction client — so a failure rolls back both,
 * and concurrent redemptions are serialized by the DB.
 */
describe('BookingsService.create coupon transaction', () => {
  const USER = 'passenger-1';
  const RIDE = 'ride-1';

  function buildService() {
    const ride = {
      id: RIDE,
      status: 'published',
      pricePerSeat: 500,
      availableSeats: 3,
      womenOnly: false,
      originName: 'A',
      destName: 'B',
      departureAt: new Date(Date.now() + 3600_000),
      driver: { userId: 'driver-1', user: {} },
    };

    // The single transaction client — booking.create + recordRedemption must
    // both be called with THIS object.
    const tx = {
      booking: {
        create: jest.fn(async () => ({ id: 'booking-1', ride })),
      },
    };

    const prisma = {
      idempotencyKey: { findUnique: jest.fn(), create: jest.fn() },
      booking: {
        count: jest.fn().mockResolvedValue(0),
        findFirst: jest.fn().mockResolvedValue(null),
        create: jest.fn(), // must NOT be used on the coupon path
      },
      ride: { findUnique: jest.fn().mockResolvedValue(ride) },
      user: { findUnique: jest.fn() },
      $transaction: jest.fn(async (fn: any, _opts?: any) => fn(tx)),
    };

    const notifications = {
      createNotification: jest.fn().mockResolvedValue(undefined),
    };
    const coupons = {
      quote: jest.fn().mockResolvedValue({
        couponId: 'c1',
        code: 'SAVE10',
        discountAmount: 100,
        finalAmount: 900,
      }),
      recordRedemption: jest.fn().mockResolvedValue(undefined),
    };

    const svc = new BookingsService(
      prisma as any,
      notifications as any,
      {} as any,
      {} as any,
      {} as any,
      { record: jest.fn() } as any,
      {} as any,
      coupons as any,
    );
    return { svc, prisma, tx, coupons };
  }

  it('runs quote + booking.create + recordRedemption inside one Serializable tx', async () => {
    const { svc, prisma, tx, coupons } = buildService();

    await svc.create(USER, {
      rideId: RIDE,
      seatsBooked: 1,
      couponCode: 'SAVE10',
    });

    // A transaction was opened with Serializable isolation.
    expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(prisma.$transaction.mock.calls[0][1]).toMatchObject({
      isolationLevel: Prisma.TransactionIsolationLevel.Serializable,
    });

    // quote received the tx client (5th arg) so the limit read is in-transaction.
    expect(coupons.quote).toHaveBeenCalledWith(
      USER,
      'SAVE10',
      500,
      'passenger',
      tx,
    );

    // The booking was created on the tx client, never the base client.
    expect(tx.booking.create).toHaveBeenCalledTimes(1);
    expect(prisma.booking.create).not.toHaveBeenCalled();

    // The redemption was recorded on the SAME tx client, bound to the booking.
    expect(coupons.recordRedemption).toHaveBeenCalledWith(tx, {
      couponId: 'c1',
      userId: USER,
      bookingId: 'booking-1',
      discountAmount: 100,
    });
  });

  it('does not open a transaction for a booking without a coupon', async () => {
    const { svc, prisma, coupons } = buildService();
    prisma.booking.create.mockResolvedValue({ id: 'booking-2' });

    await svc.create(USER, { rideId: RIDE, seatsBooked: 1 });

    expect(prisma.$transaction).not.toHaveBeenCalled();
    expect(prisma.booking.create).toHaveBeenCalledTimes(1);
    expect(coupons.quote).not.toHaveBeenCalled();
    expect(coupons.recordRedemption).not.toHaveBeenCalled();
  });
});
