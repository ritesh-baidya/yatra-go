import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma.service';
import { CreateReportDto } from './dto/create-report.dto';

// Anti-abuse: a genuine user files a handful of reports, not dozens. Cap the
// volume per reporter per rolling hour so the moderation queue can't be
// flooded / weaponised for harassment (CWE-799). Generous for real use.
const MAX_REPORTS_PER_HOUR = 10;

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  // ── POST /reports ────────────────────────────────────────────
  async create(userId: string, dto: CreateReportDto) {
    if (dto.reportedId === userId) {
      throw new BadRequestException('You cannot report yourself');
    }

    // Rate limit before any further work so spam never touches report state.
    const recentReports = await this.prisma.userReport.count({
      where: {
        reporterId: userId,
        createdAt: { gte: new Date(Date.now() - 3600_000) },
      },
    });
    if (recentReports >= MAX_REPORTS_PER_HOUR) {
      throw new BadRequestException(
        'Too many reports submitted. Please try again later.',
      );
    }

    const reported = await this.prisma.user.findUnique({
      where: { id: dto.reportedId },
      select: { id: true },
    });
    if (!reported) throw new NotFoundException('Reported user not found');

    // If a booking is referenced, the reporter must be a participant
    if (dto.bookingId) {
      const booking = await this.prisma.booking.findUnique({
        where: { id: dto.bookingId },
        include: {
          ride: {
            include: { driver: true },
          },
        },
      });
      if (!booking) throw new NotFoundException('Booking not found');

      const driver = await this.prisma.driverProfile.findUnique({
        where: { userId },
      });

      const isPassenger = booking.passengerId === userId;
      const isDriver = driver && booking.ride.driverId === driver.id;

      if (!isPassenger && !isDriver) {
        throw new ForbiddenException('You are not part of this booking');
      }
    }

    const report = await this.prisma.userReport.create({
      data: {
        reporterId: userId,
        reportedId: dto.reportedId,
        bookingId: dto.bookingId,
        reason: dto.reason,
        description: dto.description,
      },
    });

    return { message: 'Report submitted successfully', report };
  }

  // ── GET /reports/mine ────────────────────────────────────────
  async findMine(userId: string) {
    const reports = await this.prisma.userReport.findMany({
      where: { reporterId: userId },
      include: {
        reported: {
          select: {
            id: true,
            fullName: true,
            profilePhotoUrl: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return { reports, total: reports.length };
  }
}
