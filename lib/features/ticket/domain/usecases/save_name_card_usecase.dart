import 'package:fuvekonmobile/core/errors/failures.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/services/s3_upload_service.dart';
import 'package:fuvekonmobile/core/utils/ticket/render_namecard.dart';
import 'package:fuvekonmobile/features/profile/domain/entities/account.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/update_badge_details_input.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/user_ticket.dart';
import 'package:fuvekonmobile/features/ticket/domain/repositories/ticket_repository.dart';

/// Renders name card PNG, uploads to S3, then PATCHes badge details (web flow).
class SaveNameCardUseCase {
  SaveNameCardUseCase({
    required TicketRepository ticketRepository,
    required S3UploadService s3UploadService,
    required NamecardRenderer namecardRenderer,
  })  : _ticketRepository = ticketRepository,
        _s3UploadService = s3UploadService,
        _namecardRenderer = namecardRenderer;

  final TicketRepository _ticketRepository;
  final S3UploadService _s3UploadService;
  final NamecardRenderer _namecardRenderer;

  Future<Result<UserTicket>> call({
    required UserTicket ticket,
    required Account account,
    required String badgeName,
    required bool isFursuiter,
    required bool isFursuitStaff,
  }) async {
    final name = badgeName.trim();
    if (name.isEmpty) {
      return const Error(
        ServerFailure('Please enter a badge name'),
      );
    }

    String? namecardUrl;
    try {
      final tierCode = tierCodeFromTierCodeString(ticket.tier?.tierCode);
      if (ticket.referenceCode.isNotEmpty && tierCode >= 1) {
        final pngBytes = await _namecardRenderer.renderPng(
          RenderNamecardOptions(
            tierCodeNumber: tierCode,
            avatarUrl: account.avatar,
            previewName: name,
            referenceCode: ticket.referenceCode,
            isFursuiter: isFursuiter,
            isFursuitStaff: isFursuitStaff,
            isDealer: account.isDealer == true,
          ),
        );
        final uploaded = await _s3UploadService.uploadBytes(
          bytes: pngBytes,
          fileName: 'namecard-${ticket.referenceCode}.png',
          contentType: 'image/png',
          folder: 'namecards',
        );
        namecardUrl = uploaded.fileUrl;
      }
    } catch (_) {
      // Non-blocking: still save text/flags if render/upload fails (web parity).
    }

    return _ticketRepository.updateBadgeDetails(
      UpdateBadgeDetailsInput(
        conBadgeName: name,
        namecardUrl: namecardUrl,
        isFursuiter: isFursuiter,
        isFursuitStaff: isFursuitStaff,
      ),
    );
  }
}
