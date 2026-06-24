// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String versionLabel(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get supportLabel => 'Hỗ trợ';

  @override
  String get languageTitle => 'Chọn ngôn ngữ';

  @override
  String get languageSubtitle => 'Vui lòng chọn ngôn ngữ để tiếp tục';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String get splashTagline => 'Nơi kết nối cộng đồng sự kiện và nghệ thuật';

  @override
  String get startupHydrationFailedTitle => 'Không thể kết nối máy chủ';

  @override
  String get startupHydrationFailedBody =>
      'Kiểm tra kết nối mạng hoặc cấu hình API, rồi thử lại.';

  @override
  String get startupRetry => 'Thử lại';

  @override
  String get brandTagline => 'Cổng thông tin sự kiện chuyên nghiệp';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginEmailLabel => 'Email hoặc Số điện thoại';

  @override
  String get loginEmailHint => 'Nhập email hoặc SĐT';

  @override
  String get loginPasswordLabel => 'Mật khẩu';

  @override
  String get loginForgotPassword => 'Quên mật khẩu?';

  @override
  String get loginSubmit => 'Đăng nhập';

  @override
  String get loginOrDivider => 'HOẶC';

  @override
  String get loginGoogle => 'Đăng nhập với Google';

  @override
  String get authGoogleNotConfigured =>
      'Chưa cấu hình Google Sign-In. Thêm GOOGLE_CLIENT_ID vào file .env rồi khởi động lại app.';

  @override
  String get authGoogleUnsupportedPlatform =>
      'Google Sign-In chưa hỗ trợ trên Linux/Windows. Hãy chạy app trên Android, iOS, Web (Chrome) hoặc macOS.';

  @override
  String get authGoogleLoginFailed =>
      'Đăng nhập Google thất bại. Vui lòng thử lại hoặc dùng email/mật khẩu.';

  @override
  String get authGoogleDeveloperError =>
      'Lỗi cấu hình Google OAuth trên Android. Trong Google Cloud Console, tạo OAuth client Android với package com.example.fuvekonmobile và thêm SHA-1 của debug keystore (Android Studio → Gradle → signingReport).';

  @override
  String get authGoogleIdTokenMissing =>
      'Google không trả về ID token. Kiểm tra GOOGLE_CLIENT_ID (Web client) trong .env và OAuth client Android trên Google Cloud.';

  @override
  String get authGoogleRegistrationDetailsRequired =>
      'Vui lòng hoàn tất đăng ký với thông tin cá nhân.';

  @override
  String get loginNoAccount => 'Chưa có tài khoản?';

  @override
  String get loginRegisterLink => 'Đăng ký';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập email hoặc số điện thoại để nhận hướng dẫn đặt lại mật khẩu.';

  @override
  String get forgotPasswordEmailHint => 'VD: user@example.com';

  @override
  String get forgotPasswordSubmit => 'Gửi liên kết đặt lại mật khẩu';

  @override
  String get forgotPasswordBackToLogin => 'Quay lại đăng nhập';

  @override
  String get forgotPasswordSuccessMessage =>
      'Nếu tài khoản tồn tại, liên kết đặt lại mật khẩu đã được gửi tới email của bạn.';

  @override
  String get forgotPasswordSentHint =>
      'Vui lòng kiểm tra hộp thư và làm theo hướng dẫn.';

  @override
  String get forgotPasswordFailureMessage =>
      'Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại.';

  @override
  String get resetPasswordTitle => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordSubtitle =>
      'Nhập mật khẩu mới cho tài khoản của bạn.';

  @override
  String get resetPasswordNewLabel => 'Mật khẩu mới';

  @override
  String get resetPasswordNewHint => 'Tối thiểu 8 ký tự';

  @override
  String get resetPasswordConfirmLabel => 'Xác nhận mật khẩu';

  @override
  String get resetPasswordConfirmHint => 'Nhập lại mật khẩu mới';

  @override
  String get resetPasswordSubmit => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordBackToLogin => 'Quay lại đăng nhập';

  @override
  String get resetPasswordSuccessMessage =>
      'Đặt lại mật khẩu thành công. Bạn có thể đăng nhập ngay.';

  @override
  String get resetPasswordFailureMessage =>
      'Không thể đặt lại mật khẩu. Liên kết có thể đã hết hạn.';

  @override
  String get resetPasswordInvalidLink =>
      'Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn. Vui lòng yêu cầu liên kết mới.';

  @override
  String get resetPasswordMinLength => 'Mật khẩu tối thiểu 8 ký tự';

  @override
  String get resetPasswordMismatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Bắt đầu hành trình quản lý sự kiện của bạn';

  @override
  String get registerFullNameLabel => 'Họ và tên';

  @override
  String get registerFullNameHint => 'Nhập họ và tên';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'example@domain.com';

  @override
  String get registerCountryLabel => 'Country';

  @override
  String get registerCountryHint => 'Select your country';

  @override
  String get registerPasswordLabel => 'Mật khẩu';

  @override
  String get registerPasswordHint => 'Tạo mật khẩu';

  @override
  String get registerConfirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get registerConfirmPasswordHint => 'Nhập lại mật khẩu';

  @override
  String get registerTermsPrefix => 'Tôi đồng ý với ';

  @override
  String get registerTermsTos => 'Điều khoản dịch vụ';

  @override
  String get registerTermsAnd => ' và ';

  @override
  String get registerTermsPrivacy => 'Chính sách bảo mật';

  @override
  String get registerTermsSuffix => ' của FUVEKON.';

  @override
  String get registerSubmit => 'Tạo tài khoản';

  @override
  String get registerHasAccount => 'Đã có tài khoản?';

  @override
  String get registerLoginLink => 'Đăng nhập';

  @override
  String get registerSuccessMessage =>
      'Tạo tài khoản thành công. Vui lòng kiểm tra email để nhận mã xác minh.';

  @override
  String get registerFailureMessage => 'Đăng ký thất bại. Vui lòng thử lại.';

  @override
  String get validationEmailRequired => 'Vui lòng nhập email hoặc SĐT';

  @override
  String get validationEmailInvalid => 'Email không hợp lệ';

  @override
  String get validationPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get validationPasswordMin => 'Mật khẩu tối thiểu 6 ký tự';

  @override
  String get validationFullNameRequired => 'Vui lòng nhập họ và tên';

  @override
  String get validationFullNameMin => 'Họ và tên phải có ít nhất 2 ký tự';

  @override
  String get validationCountryRequired => 'Please select your country';

  @override
  String get validationConfirmPasswordRequired => 'Vui lòng xác nhận mật khẩu';

  @override
  String get validationPasswordMismatch => 'Mật khẩu không khớp';

  @override
  String get validationTermsRequired =>
      'Vui lòng đồng ý với điều khoản để tiếp tục';

  @override
  String get introBadge => 'GIỚI THIỆU';

  @override
  String get introHeroLine1 => 'Khám phá\n';

  @override
  String get introHeroBrand => 'FUVEKON';

  @override
  String get introHeroSubtitle =>
      'Lễ hội văn hóa Anime và quản lý sự kiện chuyên nghiệp hàng đầu.';

  @override
  String get introWhatIsTitle => 'FUVEKON là gì?';

  @override
  String get introWhatIsBody =>
      'FUVEKON là điểm giao thoa độc đáo giữa thẩm mỹ văn hóa Anime và nền tảng quản lý sự kiện chuyên nghiệp.';

  @override
  String get introAudienceTitle => 'Dành cho ai?';

  @override
  String get introAudienceArtistTitle => 'Nghệ sĩ & Creator';

  @override
  String get introAudienceArtistBody => 'Giao lưu và trưng bày tác phẩm.';

  @override
  String get introAudienceFanTitle => 'Fan hâm mộ';

  @override
  String get introAudienceFanBody => 'Trải nghiệm không gian văn hóa đặc sắc.';

  @override
  String get introAudienceOrganizerTitle => 'Nhà tổ chức sự kiện';

  @override
  String get introAudienceOrganizerBody =>
      'Tìm kiếm cơ hội hợp tác và nền tảng quản lý chuyên nghiệp.';

  @override
  String get introViewRules => 'Xem nội quy';

  @override
  String get introViewFaq => 'Xem FAQ';

  @override
  String get navIntroduction => 'Giới thiệu';

  @override
  String get navArtbook => 'Conbook';

  @override
  String get navFaq => 'FAQ';

  @override
  String get navRules => 'Nội quy';

  @override
  String get navLogin => 'Đăng nhập';

  @override
  String get navLogout => 'Đăng xuất';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navSchedule => 'Lịch trình';

  @override
  String get navMyTickets => 'Vé của tôi';

  @override
  String get scheduleMyItinerary => 'Lịch trình cá nhân';

  @override
  String get scheduleViewMap => 'Bản đồ';

  @override
  String get scheduleActivityDetail => 'Chi tiết hoạt động';

  @override
  String get scheduleEventDetail => 'Chi tiết sự kiện';

  @override
  String get scheduleVenueDetail => 'Chi tiết địa điểm';

  @override
  String get scheduleDayFilter => 'Chọn ngày';

  @override
  String get scheduleActivities => 'Hoạt động';

  @override
  String get scheduleNoActivities => 'Không có hoạt động trong ngày này';

  @override
  String get scheduleBookmark => 'Thêm vào lịch cá nhân';

  @override
  String get scheduleBookmarked => 'Đã lưu vào lịch';

  @override
  String get scheduleAddedToItinerary => 'Đã thêm vào lịch trình cá nhân';

  @override
  String get scheduleConflictTitle => 'Trùng lịch';

  @override
  String scheduleConflictMessage(String title) {
    return 'Hoạt động này trùng khung giờ với \"$title\" trong lịch cá nhân. Bạn có muốn thay thế không?';
  }

  @override
  String get scheduleConflictReplace => 'Thay thế';

  @override
  String get scheduleConflictCancel => 'Hủy';

  @override
  String get scheduleEmptyItinerary => 'Chưa có mục nào';

  @override
  String get scheduleEmptyItineraryHint =>
      'Bookmark panel, talent hoặc workshop từ lịch trình tổng.';

  @override
  String get scheduleRemoveBookmark => 'Xóa khỏi lịch';

  @override
  String get scheduleTime => 'Thời gian';

  @override
  String get scheduleLocation => 'Địa điểm';

  @override
  String get scheduleSpeakers => 'Diễn giả';

  @override
  String get scheduleDescription => 'Mô tả';

  @override
  String get scheduleVenues => 'Khu vực';

  @override
  String get scheduleLocations => 'Vị trí';

  @override
  String get scheduleKindPanel => 'Panel';

  @override
  String get scheduleKindTalent => 'Talent';

  @override
  String get scheduleKindWorkshop => 'Workshop';

  @override
  String get scheduleKindCeremony => 'Lễ';

  @override
  String get scheduleKindOther => 'Khác';

  @override
  String get navNotifications => 'Thông báo';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get navSwitchToAdmin => 'Chế độ quản trị';

  @override
  String get navSwitchToUser => 'Chế độ người dùng';

  @override
  String get myTicketsFilterActive => 'Đang hiệu lực';

  @override
  String get myTicketsFilterUsed => 'Đã dùng';

  @override
  String get myTicketsFilterAll => 'Tất cả';

  @override
  String get myTicketsStatusActive => 'Đang hiệu lực';

  @override
  String get myTicketsStatusUsed => 'Đã dùng';

  @override
  String get myTicketsViewTicket => 'Xem vé →';

  @override
  String get myTicketsPayNow => 'Thanh toán ngay →';

  @override
  String get myTicketsEventDateRange => '20-22/10/2024';

  @override
  String get myTicketsEmptyTitle => 'Bạn chưa có vé';

  @override
  String get myTicketsEmptySubtitle => 'Mua vé để tham gia sự kiện.';

  @override
  String get myTicketsEmptyFilter => 'Không có vé trong mục này';

  @override
  String get myTicketsBrowse => 'Xem các hạng vé';

  @override
  String get eTicketEventLabel => 'SỰ KIỆN';

  @override
  String get eTicketValid => 'Hợp lệ';

  @override
  String get eTicketOwner => 'Người sở hữu';

  @override
  String get eTicketTier => 'Hạng vé';

  @override
  String get eTicketDay => 'Ngày';

  @override
  String get eTicketScanHint => 'Quét mã QR tại cổng kiểm soát';

  @override
  String get eTicketCodeLabel => 'Mã vé';

  @override
  String eTicketBenefitsTitle(String tier) {
    return 'Quyền lợi vé $tier';
  }

  @override
  String get eTicketUpgrade => 'Nâng cấp vé';

  @override
  String get eTicketSaveWallet => 'Lưu vào ví Apple/Google';

  @override
  String get eTicketWalletSoon => 'Tính năng lưu ví sẽ có sau.';

  @override
  String get ticketUpgradeTitle => 'Nâng cấp hạng vé';

  @override
  String get ticketUpgradeCurrentLabel => 'VÉ HIỆN TẠI CỦA BẠN';

  @override
  String get ticketUpgradeOptionsLabel => 'Lựa chọn nâng cấp';

  @override
  String get ticketUpgradeExtraBenefits => 'QUYỀN LỢI BỔ SUNG';

  @override
  String get ticketUpgradeTotalLabel => 'TỔNG THANH TOÁN THÊM';

  @override
  String get ticketUpgradeContinue => 'Tiếp tục nâng cấp';

  @override
  String get ticketUpgradeInfoNote =>
      'Việc nâng cấp vé VIP lên Super VIP sẽ được hệ thống xử lý và xác nhận trong vòng 24h làm việc.';

  @override
  String get ticketUpgradeNoTicket => 'Bạn chưa có vé để nâng cấp.';

  @override
  String ticketUpgradeMaxTier(String tier) {
    return 'Bạn đang ở hạng vé cao nhất ($tier).';
  }

  @override
  String get authHomeUpcomingBadge => 'Sự kiện sắp diễn ra';

  @override
  String get authHomeHeroTitle => 'Lễ Hội Giao Lưu Văn Hóa Anime';

  @override
  String get authHomeHeroSubtitle =>
      'Khám phá không gian nghệ thuật và trải nghiệm độc đáo.';

  @override
  String get authHomeFeaturedTitle => 'Sự kiện nổi bật';

  @override
  String get authHomeSeeAll => 'Xem tất cả';

  @override
  String get authHomeHotBadge => 'Hot';

  @override
  String get authHomeFeaturedEventTitle => 'Triển Lãm Nghệ Thuật Đương Đại';

  @override
  String get authHomeFeaturedEventDate => '20 Tháng 10, 2023';

  @override
  String get authHomeFeaturedEventLocation => 'Trung Tâm SECC';

  @override
  String get authHomeBuyTicket => 'Mua vé';

  @override
  String get authHomeViewDetails => 'Xem chi tiết';

  @override
  String get authHomeViewTickets => 'Xem vé';

  @override
  String get authHomeNotificationsEmpty => 'Chưa có thông báo mới.';

  @override
  String get authHomeBentoTitle => 'Tổng quan';

  @override
  String get authHomeMyTicketTitle => 'Vé của tôi';

  @override
  String get authHomeMyTicketSubtitle => 'Xem e-ticket & QR';

  @override
  String get authHomeTodayScheduleTitle => 'Lịch hôm nay';

  @override
  String get authHomeTodaySchedulePreview => 'Panel Voice Actor · 14:00';

  @override
  String get authHomeBuyTicketBanner => 'Mua vé FUVEKON';

  @override
  String get authHomeBuyTicketBannerSubtitle => 'Early bird đang mở bán';

  @override
  String get authHomeShortcutsTitle => 'Tiện ích';

  @override
  String get authHomeShortcutArtbook => 'Artbook';

  @override
  String get authHomeShortcutLostFound => 'L&F';

  @override
  String get authHomeShortcutTalent => 'Talent';

  @override
  String get authHomeShortcutPanel => 'Panel';

  @override
  String get authHomeShortcutDealer => 'Dealer';

  @override
  String get landingBadge => 'SỰ KIỆN HÀNG ĐẦU';

  @override
  String get landingHeroTitle => 'Sự kiện Anime';

  @override
  String get landingHeroBody =>
      'Trải nghiệm không gian văn hóa độc bản với hệ thống quản lý vé và lịch trình thông minh. Tham gia ngay để không bỏ lỡ những khoảnh khắc tuyệt vời nhất.';

  @override
  String get landingRegister => 'Đăng ký';

  @override
  String get landingViewTickets => 'Xem vé';

  @override
  String get exploreTicketsTitle => 'Khám phá các loại vé';

  @override
  String get exploreTicketsSubtitle =>
      'Lựa chọn trải nghiệm phù hợp nhất với bạn tại triển lãm.';

  @override
  String get exploreTicketsFooterInfo =>
      'Bạn có thể xem thông tin vé trước. Để mua vé, vui lòng đăng ký hoặc đăng nhập.';

  @override
  String get exploreTicketsRegisterCta => 'Đăng ký để mua vé';

  @override
  String get exploreTicketsBuyCta => 'Mua vé ngay';

  @override
  String get exploreTicketsLoginPrompt => 'Đã có tài khoản?';

  @override
  String get exploreTicketsLoginLink => 'Đăng nhập ngay';

  @override
  String get exploreTicketsPopularBadge => 'Phổ biến nhất';

  @override
  String get exploreTicketsSoldOut => 'Hết vé';

  @override
  String get exploreTicketsEmpty => 'Hiện chưa có hạng vé nào.';

  @override
  String get exploreTicketsRetry => 'Thử lại';

  @override
  String get ticketDetailBenefitsTitle => 'Quyền lợi đi kèm';

  @override
  String ticketDetailCompareTitle(String standardTier) {
    return 'So sánh với $standardTier';
  }

  @override
  String get ticketDetailTotal => 'Tổng cộng';

  @override
  String get ticketDetailCompareAccess => 'Quyền truy cập';

  @override
  String get ticketDetailCompareCheckIn => 'Check-in';

  @override
  String get ticketDetailComparePriority => 'Ưu tiên';

  @override
  String get ticketDetailCompareShared => 'Thông thường';

  @override
  String get ticketDetailCompareBadge => 'Badge';

  @override
  String get ticketDetailCompareCustom => 'Tùy chỉnh';

  @override
  String get ticketDetailCompareNormal => 'Tiêu chuẩn';

  @override
  String get ticketDetailCompareGifts => 'Quà tặng thêm';

  @override
  String get landingExperienceTitle => 'Trải Nghiệm Hoàn Hảo';

  @override
  String get landingExperienceBody =>
      'Quản lý hành trình của bạn tại sự kiện một cách dễ dàng.';

  @override
  String get rulesTitle => 'Nội quy sự kiện';

  @override
  String get rulesLastUpdated => 'Last updated: April 2, 2026';

  @override
  String get rulesIntro =>
      'Vui lòng đọc kỹ các quy định dưới đây để đảm bảo một kỳ triển lãm an toàn, chuyên nghiệp và đáng nhớ cho tất cả mọi người.';

  @override
  String get rulesAttendeeSection => 'Rule for Attendee';

  @override
  String get rulesTicketsTitle => 'Attendee Tickets';

  @override
  String get rulesTickets1 =>
      'All attendees must wear their identification badges at all times while in the event area.';

  @override
  String get rulesTickets2 =>
      'Badges must be displayed in a visible location (chest, neck, or sleeve).';

  @override
  String get rulesTickets3 =>
      'Tickets and badges are the property of the organizing committee and may not be transferred, lent, or duplicated without the consent of the organizing committee.';

  @override
  String get rulesTickets4 =>
      'Attendees are responsible for safeguarding their badges.';

  @override
  String get rulesConductTitle => 'Quy định hành vi';

  @override
  String get rulesConduct1 => 'Nghiêm cấm quấy rối dưới mọi hình thức.';

  @override
  String get rulesConduct2 => 'Không xả rác bừa bãi.';

  @override
  String get rulesConduct3 => 'Tuân thủ hướng dẫn của BTC.';

  @override
  String get rulesConduct4 =>
      'Prohibited acts of discrimination, prejudice, defamation, or actions that cause division within the community.';

  @override
  String get rulesConduct5 =>
      'Prohibited acts of propagating or inciting content related to religion, politics, or of a military nature.';

  @override
  String get rulesConduct6 =>
      'Prohibited acts that disrupt order or negatively affect attendees, staff, or general building operations.';

  @override
  String get rulesProhibitedItemsTitle => 'Prohibited Items';

  @override
  String get rulesProhibitedItems1 =>
      'No items that can cause bodily harm, explosives, or items resembling weapons.';

  @override
  String get rulesProhibitedItems2 =>
      'No pornographic publications, sensitive or inappropriate content, 16+, or related to politics and religions.';

  @override
  String get rulesProhibitedItems3 =>
      'No alcohol, cigarettes, and all stimulants inside the venue.';

  @override
  String get rulesProhibitedItems4 =>
      'Food is not allowed inside the event venue.';

  @override
  String get rulesProhibitedItems5 =>
      'Avoid heavy smelling items, loud noises or bright flashing lights causing discomfort for others.';

  @override
  String get rulesProhibitedItems6 =>
      'Avoid big bulky items taking up space or causing blockades.';

  @override
  String get rulesClothingTitle => 'Clothing and Accessories';

  @override
  String get rulesClothingIntro =>
      'The event is attended by participants of various age groups; attire must be appropriate for a public setting.';

  @override
  String get rulesClothingProhibitedIntro =>
      'Attendees must be dressed appropriately at the event. Prohibited costumes and accessories include:';

  @override
  String get rulesClothingProhibited1 => 'Revealing, suggestive clothing';

  @override
  String get rulesClothingProhibited2 =>
      'Political, religious or military, intended for propaganda, incitement of hostility, or causing division';

  @override
  String get rulesClothingProhibited3 => 'Weapon-shaped or able to cause harm';

  @override
  String get rulesClothingProhibited4 =>
      'Oversized costume making it difficult for other guests to move';

  @override
  String get rulesClothingNote1 =>
      'Should the attendees dress too suggestively or revealing, organizers will ask you to change your costumes or cover yourself up.';

  @override
  String get rulesClothingNote2 =>
      'Organizers has the right to ask you to leave the venue if you do not cooperate.';

  @override
  String get rulesClothingNote3 =>
      'The final decision regarding the appropriateness of attire rests with the Organizing Committee.';

  @override
  String get rulesClothingNote4 =>
      'Appropriate attire is clothing that is comfortable and convenient for the wearer, suitable for the public and community nature of the event, maintaining decency and must not display offensive images, symbols, or text that incite violence, are discriminatory, or contrary to public morals. Additionally, attire must not obstruct event activities or compromise safety and public order.';

  @override
  String get rulesPhotographyTitle => 'Videography and Photography';

  @override
  String get rulesPhotography1 =>
      'Attendees may record the event for personal use. However, organizers may still ask you to take the post down if it contains images affecting the event or other attendees.';

  @override
  String get rulesPhotography2 =>
      'Attendees must act accordingly when recording at the event. Respect other attendees\' personal space and do not record them if they\'re not comfortable with it.';

  @override
  String get rulesPhotography3 =>
      'Participants must comply with instructions from the Organizing Team and/or Security staff when they request all photography, filming, or recording activities to stop or cease in specific areas or at certain times. Photography, videography, and audio recording are strictly prohibited in restrooms, changing rooms, private dressing areas, and other sensitive locations.';

  @override
  String get rulesPhotography4 =>
      'Attendees acknowledges that being accidentally recorded is unavoidable.';

  @override
  String get rulesPhotography5 =>
      'Organizers reserve the rights to use videos/images containing attendees for marketing purposes.';

  @override
  String get rulesPhotography6 =>
      'The use of editing tools, AI, or any form of modification to alter images, videos, or audio - as well as the posting or distribution of content created or modified using such tools - for the purpose of defamation, harassment, or causing negative impact to participants or the event is strictly prohibited.';

  @override
  String get rulesOrganizerAttendeeTitle => 'Organizer\'s Decision';

  @override
  String get rulesOrganizerAttendee1 =>
      'The organizing committee reserves the right to issue warnings and cautions to first-time offenders. Upon violation, attendees must comply with the organizing committee\'s directives and have the right to provide immediate feedback at the location of the violation if they find the decision unsatisfactory.';

  @override
  String get rulesOrganizerAttendee2 =>
      'For prohibited items, the organizing committee may require attendees to store items outside the event area or temporarily hold them until the event concludes.';

  @override
  String get rulesOrganizerAttendee3 =>
      'Repeat offenders after receiving warnings or those committing serious violations will be required to leave the event premises, have their badges revoked, and forfeit participation fees.';

  @override
  String get rulesOrganizerAttendee4 =>
      'Serious violations or repeated offenses will be documented and may affect eligibility to attend future FUVE events.';

  @override
  String get rulesOrganizerAttendee5 =>
      'The organizing committee reserves the right to address behaviors or items not explicitly listed that negatively impact the event, attendees, or violate the spirit of these regulations.';

  @override
  String get rulesOrganizerAttendee6 =>
      'All individuals are responsible for promptly reporting any violations to the organizing committee.';

  @override
  String get rulesProductSection => 'Product Regulations';

  @override
  String get rulesProductIntro =>
      'Dealers must prepare a product list of products for sale during the event.';

  @override
  String get rulesProductAllowedIntro =>
      'Listed products must satisfy the following conditions:';

  @override
  String get rulesProductAllowed1 => 'Handmade';

  @override
  String get rulesProductAllowed2 =>
      'Reselling products are proved allowed by the makers/artists';

  @override
  String get rulesProductAllowed3 =>
      'Products must have a minimum of 25% of the Dealers/Sellers participation during the product developing process.';

  @override
  String get rulesProductProhibitedIntro => 'Prohibited products at the event:';

  @override
  String get rulesProductProhibited1 => 'Sensitive products, 16+';

  @override
  String get rulesProductProhibited2 => 'Food, beverage';

  @override
  String get rulesProductProhibited3 => 'Sharp objects';

  @override
  String get rulesProductProhibited4 => 'Alcohols and stimulants';

  @override
  String get rulesProductProhibited5 => 'Flammable products';

  @override
  String get rulesProductFireSafety =>
      'All acts of using stimulants, flammable items at the event and booth areas are prohibited. Avoid placing flammable objects (paper cups, dry towels, papers, …) near open electric sockets and wires.';

  @override
  String get rulesProductViolation1 =>
      'All violated products will be revoked by the Organizers.';

  @override
  String get rulesProductViolation2 =>
      'Booths violating the regulations once will be warned by the Organizers, the second violation will result in force to stop all booth related activities by the Organizers.';

  @override
  String get rulesProductLiability =>
      'The Organizer is not responsible for any losses inside and outside of the event.';

  @override
  String get rulesDealerSection => 'Rule for Dealer';

  @override
  String get rulesDealerAreaTitle => 'Dealer Den Area';

  @override
  String get rulesDealerArea1 =>
      'Dealers must arrive and receive their ticket and booth on informed time.';

  @override
  String get rulesDealerArea2 =>
      'All behaviours of violating other booth\'s area are prohibited, including decorations, personnel and customer lines.';

  @override
  String get rulesDealerArea3 =>
      'Avoid decorating your booth with decorations associated with sensitive topics, religions.';

  @override
  String get rulesDealerArea4 =>
      'All Dealers must keep their booth clean and well-organized.';

  @override
  String get rulesDealerArea5 =>
      'Keep an eye out for your personal belongings, Building\'s and Organizer\'s properties.';

  @override
  String get rulesDealerArea6 =>
      'Dealers/Sellers are responsible for handling customer queues, avoiding affecting common walkways and other booths.';

  @override
  String get rulesOrganizerDealerTitle => 'Organizer\'s Decision';

  @override
  String get rulesOrganizerDealer1 =>
      'The Organizer has all the rights to require the Dealers to stop all activities related to the booth and leave the event area if the dealer violated the regulations.';

  @override
  String get rulesOrganizerDealer2 =>
      'The Organizer has all the rights to decide the Dealer\'s booth location.';

  @override
  String get rulesAgreeCheckbox =>
      'Tôi đã đọc, hiểu và đồng ý với các nội quy trên.';

  @override
  String get rulesConfirmButton => 'Xác nhận đồng ý';

  @override
  String get faqPageTitle => 'Câu hỏi thường gặp';

  @override
  String get faqPageSubtitle =>
      'Tìm kiếm câu trả lời nhanh chóng cho các thắc mắc của bạn.';

  @override
  String get faqSearchHint => 'Bạn cần tìm gì?';

  @override
  String get faqNoResults => 'Không tìm thấy kết quả phù hợp.';

  @override
  String get faqNeedHelp => 'Bạn cần hỗ trợ thêm? ';

  @override
  String get faqContactUs => 'Liên hệ chúng tôi →';

  @override
  String get faqCatTickets => 'Vé';

  @override
  String get faqTicketsQ1 => 'Mua vé ở đâu?';

  @override
  String get faqTicketsA1 =>
      'Vào mục Vé trên app FUVEKON, chọn hạng vé phù hợp và hoàn tất thanh toán theo hướng dẫn. Mỗi tài khoản chỉ được sở hữu một vé active tại một thời điểm.';

  @override
  String get faqTicketsQ2 => 'Có những hạng vé nào?';

  @override
  String get faqTicketsA2 =>
      'BTC công bố các hạng vé (Standard, VIP, v.v.) kèm quyền lợi tương ứng trên app. Giá và số lượng có thể thay đổi theo từng đợt mở bán.';

  @override
  String get faqTicketsQ3 => 'Thanh toán vé bằng cách nào?';

  @override
  String get faqTicketsA3 =>
      'Sau khi đặt vé, bạn chuyển khoản qua mã QR ngân hàng hoặc PayPal như hướng dẫn, rồi bấm \"Tôi đã thanh toán\". BTC sẽ xác minh và duyệt vé trong thời gian sớm nhất.';

  @override
  String get faqTicketsQ4 => 'Vé điện tử có hợp lệ không?';

  @override
  String get faqTicketsA4 =>
      'Có. Sau khi vé được duyệt, mã QR check-in và badge điện tử sẽ được gửi qua email và hiển thị trong app. Xuất trình QR tại cổng soát vé.';

  @override
  String get faqTicketsQ5 => 'Tôi có thể nâng cấp vé không?';

  @override
  String get faqTicketsA5 =>
      'Có. Chủ vé đã được duyệt có thể nâng cấp lên hạng cao hơn bằng cách trả phần chênh lệch. Vé nâng cấp cũng cần được BTC xác minh thanh toán trước khi có hiệu lực.';

  @override
  String get faqTicketsQ6 => 'Tôi có thể hoàn vé không?';

  @override
  String get faqTicketsA6 =>
      'Vé đã mua không được hoàn tiền, trừ khi BTC có thông báo chính thức (ví dụ: sự kiện hủy hoặc thay đổi lớn).';

  @override
  String get faqCatRegister => 'Đăng ký';

  @override
  String get faqRegisterQ1 => 'Làm sao để tạo tài khoản?';

  @override
  String get faqRegisterA1 =>
      'Chọn Đăng ký trên màn hình đăng nhập, điền email và mật khẩu, sau đó xác minh OTP gửi về email để kích hoạt tài khoản.';

  @override
  String get faqRegisterQ2 => 'Có thể đăng nhập bằng Google không?';

  @override
  String get faqRegisterA2 =>
      'Có. FUVEKON hỗ trợ đăng nhập nhanh qua tài khoản Google. Lần đầu đăng nhập có thể cần bổ sung thông tin hồ sơ.';

  @override
  String get faqRegisterQ3 => 'Tại sao cần xác minh email?';

  @override
  String get faqRegisterA3 =>
      'Xác minh email giúp bảo vệ tài khoản và cho phép bạn chỉnh sửa hồ sơ, mua vé, đăng ký panel/talent/dealer sau khi verify.';

  @override
  String get faqRegisterQ4 => 'Quên mật khẩu thì làm sao?';

  @override
  String get faqRegisterA4 =>
      'Chọn Quên mật khẩu trên màn đăng nhập, nhập email đã đăng ký và làm theo link/OTP để đặt lại mật khẩu mới.';

  @override
  String get faqRegisterQ5 => 'Không nhận được mã OTP?';

  @override
  String get faqRegisterA5 =>
      'Kiểm tra hộp thư spam. Nếu vẫn không thấy, dùng nút Gửi lại OTP trên app hoặc liên hệ contact@fuvekon.vn.';

  @override
  String get faqCatDealer => 'Dealer';

  @override
  String get faqDealerQ1 => 'Làm sao đăng ký gian hàng?';

  @override
  String get faqDealerA1 =>
      'Vào mục Dealer trên app, đọc quy định gian hàng, điền form đăng ký và tải lên tối đa 5 bảng giá. Hồ sơ sẽ được BTC xem xét.';

  @override
  String get faqDealerQ2 => 'Điều kiện để trở thành Dealer?';

  @override
  String get faqDealerA2 =>
      'Bạn cần tài khoản đã xác minh email và tuân thủ quy định sản phẩm, bản quyền của BTC. Chi tiết xem tại mục Dealer trên app.';

  @override
  String get faqDealerQ3 => 'Phí gian hàng bao nhiêu?';

  @override
  String get faqDealerA3 =>
      'Phí phụ thuộc loại gian hàng, diện tích và vị trí. BTC sẽ gửi thông tin chi phí sau khi duyệt hồ sơ đăng ký.';

  @override
  String get faqDealerQ4 => 'Thêm nhân viên gian hàng thế nào?';

  @override
  String get faqDealerA4 =>
      'Chủ gian hàng tạo mã mời (booth code) trong app. Nhân viên nhập mã này tại mục Tham gia gian hàng để được thêm vào booth.';

  @override
  String get faqDealerQ5 => 'Bao lâu thì biết kết quả duyệt?';

  @override
  String get faqDealerA5 =>
      'Thời gian duyệt thường từ 3–7 ngày làm việc. Bạn sẽ nhận thông báo qua email và trong app khi hồ sơ được duyệt hoặc từ chối.';

  @override
  String get faqCatTalent => 'Talent Show';

  @override
  String get faqTalentQ1 => 'Ai có thể đăng ký biểu diễn?';

  @override
  String get faqTalentA1 =>
      'Nghệ sĩ, cosplayer, ca sĩ, vũ công và creator có thể nộp hồ sơ qua mục Talent trên app.';

  @override
  String get faqTalentQ2 => 'Có cần vé sự kiện không?';

  @override
  String get faqTalentA2 =>
      'Có. Bạn cần sở hữu vé đã được duyệt và tài khoản đã xác minh email trước khi gửi đơn đăng ký talent.';

  @override
  String get faqTalentQ3 => 'Hồ sơ talent cần gì?';

  @override
  String get faqTalentA3 =>
      'Giới thiệu bản thân, mô tả tiết mục dự kiến, hình ảnh/video tham khảo và thông tin liên hệ. Form chi tiết có trên app.';

  @override
  String get faqTalentQ4 => 'Thời hạn đăng ký?';

  @override
  String get faqTalentA4 =>
      'Thời hạn đóng đơn được công bố trên app, website và fanpage chính thức FUVEKON. Nộp sớm để BTC sắp xếp lịch biểu diễn.';

  @override
  String get faqCatPanel => 'Panel';

  @override
  String get faqPanelQ1 => 'Panel là gì?';

  @override
  String get faqPanelA1 =>
      'Panel là buổi giao lưu, thảo luận chuyên đề với khách mời, diễn giả và người hâm mộ trong không gian sự kiện.';

  @override
  String get faqPanelQ2 => 'Đăng ký panel như thế nào?';

  @override
  String get faqPanelA2 =>
      'Vào mục Panel, điền đề xuất chủ đề, thông tin diễn giả và nội dung dự kiến. BTC sẽ duyệt và xếp lịch nếu phù hợp.';

  @override
  String get faqPanelQ3 => 'Có cần vé để đăng ký panel không?';

  @override
  String get faqPanelA3 =>
      'Có. Người đăng ký cần vé active đã duyệt và tài khoản email đã xác minh, tương tự đăng ký talent.';

  @override
  String get faqPanelQ4 => 'Lịch panel công bố khi nào?';

  @override
  String get faqPanelA4 =>
      'Lịch panel chính thức được đăng tại mục Lịch trình sau khi BTC duyệt xong các đơn. Bạn có thể bookmark để nhận nhắc nhở.';

  @override
  String get faqCatSchedule => 'Lịch trình';

  @override
  String get faqScheduleQ1 => 'Xem lịch trình ở đâu?';

  @override
  String get faqScheduleA1 =>
      'Mục Lịch trình trên app hiển thị toàn bộ hoạt động theo ngày, khung giờ và sân khấu/khu vực.';

  @override
  String get faqScheduleQ2 => 'Lịch có thay đổi không?';

  @override
  String get faqScheduleA2 =>
      'BTC có thể điều chỉnh lịch vì lý do vận hành. Thay đổi sẽ được cập nhật trên app và gửi thông báo nếu bạn đã bookmark mục đó.';

  @override
  String get faqScheduleQ3 => 'Lịch cá nhân (My Schedule) là gì?';

  @override
  String get faqScheduleA3 =>
      'Bạn có thể bookmark panel, talent show hoặc workshop yêu thích để xem trên timeline cá nhân và nhận nhắc trước 10–15 phút.';

  @override
  String get faqScheduleQ4 => 'Sự kiện diễn ra mấy ngày?';

  @override
  String get faqScheduleA4 =>
      'Thời gian và địa điểm chính thức được công bố trên trang sự kiện và mục Giới thiệu trên app.';

  @override
  String get faqCatLostFound => 'Lost & Found';

  @override
  String get faqLostFoundQ1 => 'Tôi bị mất đồ tại sự kiện?';

  @override
  String get faqLostFoundA1 =>
      'Đến quầy Lost & Found tại venue hoặc gửi báo mất trên app (mô tả, hình ảnh, thời gian và vị trí ước tính).';

  @override
  String get faqLostFoundQ2 => 'Xem danh sách đồ tìm thấy ở đâu?';

  @override
  String get faqLostFoundA2 =>
      'Bảng tin Lost & Found công khai trên app liệt kê đồ được ghi nhận (ẩn thông tin nhận dạng nhạy cảm để tránh gian lận).';

  @override
  String get faqLostFoundQ3 => 'Nhận lại đồ bị mất thế nào?';

  @override
  String get faqLostFoundA3 =>
      'Mang giấy tờ tùy thân đến quầy hỗ trợ, mô tả vật dụng và thời gian mất. Staff sẽ đối chiếu và bàn giao nếu khớp.';

  @override
  String get faqLostFoundQ4 => 'Đồ mất bao lâu thì được xử lý?';

  @override
  String get faqLostFoundA4 =>
      'Staff cập nhật trạng thái (Lost / Found / Claimed) trên hệ thống. Bạn theo dõi tiến trình trong app hoặc liên hệ quầy.';

  @override
  String get artbookTitle => 'Tham gia Conbook';

  @override
  String get artbookDescription =>
      'Conbook là ấn phẩm tổng hợp các hướng dẫn cho người tham dự sự kiện và bao gồm cả các tác phẩm nghệ thuật do chính những nhà sáng tạo trong cộng đồng sáng tác, mang đậm màu sắc cá nhân và tinh thần của sự kiện. Nếu bạn yêu nghệ thuật và muốn đóng góp một phần tinh thần cho sự kiện thì hãy gửi ngay tác phẩm của bạn đến FUVE để tham gia conbook nhé.';

  @override
  String get artbookSubmitCta => 'Gửi tác phẩm cho Conbook';

  @override
  String get artbookSubmitBack => 'QUAY LẠI';

  @override
  String get artbookSubmitTitle => 'Gửi Conbook';

  @override
  String get artbookSubmitIntro =>
      'Nơi tôn vinh những tác phẩm xuất sắc. Hãy gửi kiệt tác của bạn để được BTC xem xét đưa vào cuốn Conbook FUVEKON.';

  @override
  String get artbookFormSectionTitle => 'Thông tin tác phẩm';

  @override
  String get artbookFieldTitle => 'Tên tác phẩm';

  @override
  String get artbookFieldTitleHint => 'Ví dụ: Giấc mơ chiều thu';

  @override
  String get artbookFieldAuthor => 'Tác giả / Bút danh';

  @override
  String get artbookFieldAuthorHint => 'Nhập bút danh của bạn';

  @override
  String get artbookFieldGenre => 'Thể loại';

  @override
  String get artbookFieldGenreHint => 'Chọn thể loại';

  @override
  String get artbookFieldDescription => 'Mô tả ý tưởng (Không bắt buộc)';

  @override
  String get artbookFieldDescriptionHint =>
      'Chia sẻ câu chuyện đằng sau tác phẩm của bạn...';

  @override
  String get artbookFieldPortfolio => 'Link Portfolio';

  @override
  String get artbookFieldPortfolioHint => 'https://';

  @override
  String get artbookFieldPreview => 'Preview Tác phẩm';

  @override
  String get artbookFieldRequired => 'Vui lòng điền thông tin này';

  @override
  String get artbookUploadLabel => 'Kéo thả file hoặc Click để tải lên';

  @override
  String get artbookUploadHint => 'Hỗ trợ JPG, PNG, PDF. Tối đa 20MB.';

  @override
  String get artbookPreviewRequired => 'Vui lòng tải lên preview tác phẩm';

  @override
  String get artbookSubmitButton => 'Gửi tác phẩm cho Conbook';

  @override
  String get artbookRulesTitle => 'QUY ĐỊNH KHI NỘP TÁC PHẨM CHO CONBOOK';

  @override
  String get artbookRulesFormatSection => 'YÊU CẦU ĐỊNH DẠNG:';

  @override
  String get artbookRulesFormat1 =>
      'Kích thước: Khổ A5 (2480x3508px), cỡ ngang hay dọc đều được nha!';

  @override
  String get artbookRulesFormat2 => 'Độ phân giải: 300dpi, hệ màu CMYK';

  @override
  String get artbookRulesFormat3 => 'Định dạng tệp: JPG/PNG';

  @override
  String get artbookRulesFormat4 =>
      'Sản phẩm cho phép khác: Tranh vẽ, ảnh chụp, văn ngắn';

  @override
  String get artbookRulesTipsSection => 'MỘT VÀI LƯU Ý NHỎ:';

  @override
  String get artbookRulesTip1 =>
      'Tác phẩm bạn tạo ra phải là của chính bạn, chưa từng xuất hiện công khai trên bất cứ nền tảng nào trước ngày diễn ra FUVE 2026.';

  @override
  String get artbookRulesTip2 =>
      'Tác phẩm gửi đến FUVE phải là phiên bản đã hoàn thiện, không phải là bản vẽ nháp.';

  @override
  String get artbookRulesTip3 =>
      'Đối với tác phẩm viết văn, bạn chỉ nên viết khoảng 300-500 từ. Hãy nộp tác phẩm của bạn dưới dạng file Word.';

  @override
  String get artbookRulesTip4 =>
      'Đối với tác phẩm chụp hình, hình ảnh cần ghi rõ thông tin người chụp ảnh, model hoặc fursuiter.';

  @override
  String get artbookRulesTip5 =>
      'Không nhất thiết phải có linh vật FUVE nhưng cần có liên quan đến chủ đề của sự kiện.';

  @override
  String get artbookRulesTip6 =>
      'Tất cả tác phẩm sẽ được chiếu trong video bế mạc hoặc đính kèm trong folder được đăng lên page sau sự kiện. Tuy nhiên, chỉ có một lượng tác phẩm được chọn góp mặt trong sổ tay sự kiện vì giới hạn số lượng trong handbook.';

  @override
  String get artbookRulesTip7 =>
      'Tác phẩm của bạn có thể được sử dụng dưới các hình thức phi lợi nhuận ở sự kiện (bao gồm truyền thông trên mạng xã hội, bìa và nội dung trong sổ tay sự kiện, các sản phẩm in ấn phục vụ quảng bá như poster, thư mời, vòng tay...). Chúng mình sẽ gửi xin phép qua email nếu tác phẩm của bạn được lựa chọn.';

  @override
  String get artbookRulesTip8 =>
      'Tác phẩm của bạn sẽ không được chọn nếu không có thông tin tác giả, không phù hợp với quy tắc ứng xử hoặc có chủ đề nhạy cảm, bạo lực, chính trị, tôn giáo.';

  @override
  String get artbookRulesTip9 =>
      'Khi tham gia gửi tác phẩm, FUVE xin chân thành cảm ơn bạn đã dành thời gian đóng góp cho sự kiện của chúng mình.';

  @override
  String get artbookLoginRequired =>
      'Vui lòng đăng nhập để gửi tác phẩm Conbook';

  @override
  String get artbookSubmitSuccess => 'Đã gửi tác phẩm thành công!';

  @override
  String get artbookSubmitFailed => 'Không thể gửi tác phẩm. Vui lòng thử lại.';

  @override
  String get artbookGenreIllustration => 'Minh họa';

  @override
  String get artbookGenreComic => 'Truyện tranh';

  @override
  String get artbookGenrePhoto => 'Nhiếp ảnh';

  @override
  String get artbookGenreDigital => 'Digital Art';

  @override
  String get artbookGenreOther => 'Khác';

  @override
  String get adminCancel => 'Hủy';

  @override
  String get adminSave => 'Lưu';

  @override
  String get adminSaveChanges => 'Lưu thay đổi';

  @override
  String get adminDelete => 'Xóa';

  @override
  String get adminEdit => 'Chỉnh sửa';

  @override
  String get adminRetry => 'Thử lại';

  @override
  String get adminConfirm => 'Xác nhận';

  @override
  String get adminBack => 'Quay lại';

  @override
  String get adminCancelAction => 'Hủy bỏ';

  @override
  String get adminAdd => 'Thêm';

  @override
  String get adminCreate => 'Tạo';

  @override
  String get adminViewAll => 'Xem tất cả';

  @override
  String get adminUpdateSuccess => 'Cập nhật thành công.';

  @override
  String adminErrorWithDetail(String detail) {
    return 'Lỗi: $detail';
  }

  @override
  String get adminCannotUndo => 'Hành động này không thể hoàn tác.';

  @override
  String get adminYes => 'Có';

  @override
  String get adminNo => 'Không';

  @override
  String get adminAll => 'Tất cả';

  @override
  String get adminNone => 'Không có';

  @override
  String get adminFieldStatus => 'Trạng thái';

  @override
  String get adminFieldDescription => 'Mô tả';

  @override
  String get adminFieldTitle => 'Tiêu đề';

  @override
  String get adminStatusPending => 'Chờ duyệt';

  @override
  String get adminStatusApproved => 'Đã duyệt';

  @override
  String get adminStatusRequireChanges => 'Cần chỉnh sửa';

  @override
  String get adminStatusDenied => 'Từ chối';

  @override
  String get adminApprove => 'Duyệt';

  @override
  String get adminRequireChanges => 'Yêu cầu chỉnh sửa';

  @override
  String get adminDeny => 'Từ chối';

  @override
  String get adminMarkPending => 'Chờ duyệt lại';

  @override
  String get adminMarkPendingReturn => 'Đưa về chờ duyệt';

  @override
  String get adminDenyReason => 'Lý do từ chối';

  @override
  String get adminDenyReasonHint => 'Nhập lý do từ chối vé...';

  @override
  String get adminEmptyList => 'Không có mục nào';

  @override
  String adminEmptyTabList(String tab) {
    return 'Danh sách $tab trống.';
  }

  @override
  String get adminNavHome => 'Trang chủ';

  @override
  String get adminNavStats => 'Thống kê';

  @override
  String get adminNavScan => 'Quét mã';

  @override
  String get adminNavHistory => 'Lịch sử';

  @override
  String get adminNavLostFound => 'Thất lạc';

  @override
  String get adminNavSystem => 'Hệ thống';

  @override
  String get adminBrandTitle => 'FUVEKON Admin';

  @override
  String get adminFieldEmail => 'Email';

  @override
  String get adminFieldFursona => 'Fursona';

  @override
  String get adminFieldFirstName => 'Họ';

  @override
  String get adminFieldLastName => 'Tên';

  @override
  String get adminFieldCountry => 'Quốc gia';

  @override
  String get adminFieldIdCard => 'CCCD/CMND';

  @override
  String get adminFieldDisplayName => 'Tên hiển thị';

  @override
  String get adminFieldRole => 'Vai trò';

  @override
  String get adminFieldVerified => 'Xác minh';

  @override
  String get adminFieldVerifiedYes => 'Đã xác minh';

  @override
  String get adminFieldVerifiedNo => 'Chưa xác minh';

  @override
  String get adminFieldHasTicket => 'Có vé';

  @override
  String get adminFieldAvatar => 'Ảnh đại diện';

  @override
  String get adminFieldCreatedAt => 'Ngày tạo';

  @override
  String get adminFieldLastUpdated => 'Cập nhật lần cuối';

  @override
  String get adminFieldDateOfBirth => 'Ngày sinh';

  @override
  String get adminFieldPermissions => 'Quyền';

  @override
  String get adminFieldDealer => 'Dealer';

  @override
  String get adminFieldAccount => 'Tài khoản';

  @override
  String get adminFieldUser => 'Người dùng';

  @override
  String get adminFieldBoothName => 'Tên gian hàng';

  @override
  String get adminFieldBoothCode => 'Mã gian';

  @override
  String get adminFieldPriceSheet => 'Bảng giá';

  @override
  String adminFieldPriceSheetN(int n) {
    return 'Bảng giá $n';
  }

  @override
  String get adminFieldRegisteredAt => 'Ngày đăng ký';

  @override
  String get adminFieldNickname => 'Nickname';

  @override
  String get adminFieldGenre => 'Thể loại';

  @override
  String get adminFieldParticipantCount => 'Số người tham gia';

  @override
  String get adminFieldDuration => 'Thời lượng';

  @override
  String get adminFieldTimeSlot => 'Khung giờ';

  @override
  String get adminFieldIntroduction => 'Giới thiệu';

  @override
  String get adminFieldSubmittedAt => 'Ngày gửi';

  @override
  String get adminFieldHandle => 'Handle';

  @override
  String get adminFieldConbookImage => 'Ảnh conbook';

  @override
  String get adminFieldTicketCode => 'Mã vé';

  @override
  String get adminFieldTicketNumber => 'Số vé';

  @override
  String get adminFieldTier => 'Hạng vé';

  @override
  String get adminFieldTierCode => 'Mã hạng';

  @override
  String get adminFieldBadgeName => 'Tên badge';

  @override
  String get adminFieldFursuiter => 'Fursuiter';

  @override
  String get adminFieldFursuitStaff => 'Fursuit staff';

  @override
  String get adminFieldTshirtSize => 'Size áo';

  @override
  String get adminFieldCheckIn => 'Check-in';

  @override
  String get adminFieldBadgeImage => 'Ảnh badge';

  @override
  String get adminFieldNamecard => 'Namecard';

  @override
  String get adminFieldApprovedAt => 'Ngày duyệt';

  @override
  String get adminFieldDeniedAt => 'Ngày từ chối';

  @override
  String get adminFieldItemCode => 'Mã vật phẩm';

  @override
  String get adminFieldType => 'Loại';

  @override
  String get adminFieldLocation => 'Vị trí';

  @override
  String get adminFieldContact => 'Liên hệ';

  @override
  String get adminFieldImage => 'Ảnh';

  @override
  String get adminFieldStaffNotes => 'Ghi chú nhân viên';

  @override
  String get adminFieldRecipient => 'Người nhận';

  @override
  String get adminFieldRecipientIdCard => 'CCCD người nhận';

  @override
  String get adminFieldRecipientPhone => 'SĐT người nhận';

  @override
  String get adminFieldReturnedAt => 'Hoàn trả lúc';

  @override
  String get adminFieldUpdatedAt => 'Cập nhật';

  @override
  String get adminRoleAdminLabel => 'Quản trị viên';

  @override
  String get adminRoleDealerLabel => 'Dealer';

  @override
  String get adminRoleStaffLabel => 'Nhân viên';

  @override
  String get adminRoleUserLabel => 'Người dùng';

  @override
  String get adminRoleCodeAdmin => 'Admin';

  @override
  String get adminRoleCodeDealer => 'Dealer';

  @override
  String get adminRoleCodeStaff => 'Staff';

  @override
  String get adminRoleCodeAttendee => 'Attendee';

  @override
  String get adminRoleExhibitor => 'Nhà triển lãm';

  @override
  String get adminRoleStaffSupport => 'Nhân viên hỗ trợ';

  @override
  String get adminRoleAttendee => 'Khách tham quan';

  @override
  String get adminPermissionManageTickets => 'Quản lý vé';

  @override
  String get adminPermissionScanTickets => 'Quét vé';

  @override
  String get adminPermissionApproveProfiles => 'Duyệt hồ sơ';

  @override
  String get adminPermissionSendNotifications => 'Gửi thông báo';

  @override
  String get adminPermissionViewDashboard => 'Xem dashboard';

  @override
  String get adminPermissionManageUsers => 'Quản lý người dùng';

  @override
  String get adminUserActive => 'Hoạt động';

  @override
  String get adminUserBlacklisted => 'Bị cấm';

  @override
  String get adminUserBannedFromTickets => 'Bị cấm mua vé';

  @override
  String get adminBanReason => 'Lý do cấm';

  @override
  String get adminBanDate => 'Ngày cấm';

  @override
  String get adminDenialCount => 'Số lần từ chối vé';

  @override
  String get adminAccountDeleted => 'Đã xóa';

  @override
  String get adminTicketStatusPending => 'Chờ thanh toán';

  @override
  String get adminTicketStatusAwaitingApproval => 'Chờ duyệt';

  @override
  String get adminTicketStatusApproved => 'Đã duyệt';

  @override
  String get adminTicketStatusDenied => 'Từ chối';

  @override
  String get adminTicketStatusAdminGranted => 'Cấp bởi admin';

  @override
  String get adminCheckedIn => 'Đã check-in';

  @override
  String get adminNotCheckedIn => 'Chưa check-in';

  @override
  String get adminLostFoundTypeLost => 'Thất lạc';

  @override
  String get adminLostFoundTypeFound => 'Nhặt được';

  @override
  String get adminLostFoundStatusClaimed => 'Đã nhận';

  @override
  String get adminLostFoundStatusResolved => 'Đã xử lý';

  @override
  String get adminLostFoundStatusOpen => 'Đang mở';

  @override
  String adminDealerBoothCode(String code) {
    return 'Mã gian: $code';
  }

  @override
  String adminDurationMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get adminErrorLoadUsers => 'Không thể tải danh sách người dùng.';

  @override
  String get adminErrorLoadBlacklistedUsers =>
      'Không thể tải danh sách người bị cấm.';

  @override
  String get adminErrorLoadDealers => 'Không thể tải danh sách dealer.';

  @override
  String get adminErrorLoadDealer => 'Không thể tải thông tin gian hàng.';

  @override
  String get adminErrorLoadPanels => 'Không thể tải danh sách panel.';

  @override
  String get adminErrorLoadConbook => 'Không thể tải danh sách conbook.';

  @override
  String get adminErrorLoadSchedules => 'Không thể tải danh sách lịch trình.';

  @override
  String get adminErrorLoadSchedule => 'Không thể tải lịch trình.';

  @override
  String get adminErrorLoadTickets => 'Không thể tải danh sách vé.';

  @override
  String get adminErrorLoadTiers => 'Không thể tải danh sách hạng vé.';

  @override
  String get adminErrorLoadTicket => 'Không thể tải thông tin vé.';

  @override
  String get adminErrorLoadTicketStats => 'Không thể tải thống kê vé.';

  @override
  String get adminErrorLoadLostFound => 'Không thể tải danh sách thất lạc.';

  @override
  String get adminErrorUpdateEventSettings =>
      'Không cập nhật được cài đặt sự kiện';

  @override
  String get adminScanInvalidCode => 'Mã vé không hợp lệ.';

  @override
  String get adminScanNotApproved => 'Vé chưa được duyệt hoặc đã bị từ chối.';

  @override
  String get adminScanAlreadyCheckedIn => 'Vé đã được check-in trước đó.';

  @override
  String get adminScanConfirmBeforeCheckIn =>
      'Xác nhận thông tin vé trước khi check-in.';

  @override
  String get adminScanCheckInSuccess => 'Check-in thành công.';

  @override
  String get adminUserDetailTitle => 'Chi tiết người dùng';

  @override
  String get adminDeleteUserTitle => 'Xóa người dùng?';

  @override
  String get adminDeleteUserBody =>
      'Tài khoản sẽ bị xóa mềm và không thể đăng nhập lại.';

  @override
  String get adminBanTicketsTitle => 'Cấm mua vé';

  @override
  String get adminBanReasonLabel => 'Lý do cấm';

  @override
  String get adminBanReasonHint => 'Nhập lý do cấm người dùng...';

  @override
  String get adminBanAction => 'Cấm';

  @override
  String get adminBanReasonRequired => 'Vui lòng nhập lý do cấm.';

  @override
  String get adminQuickActions => 'Thao tác nhanh';

  @override
  String get adminRecentHistory => 'Lịch sử gần đây';

  @override
  String get adminDetailInfo => 'Thông tin chi tiết';

  @override
  String get adminDetailInfoSubtitle =>
      'Hồ sơ, quyền hạn và trạng thái tài khoản';

  @override
  String get adminVerify => 'Xác minh';

  @override
  String get adminPermissions => 'Phân quyền';

  @override
  String get adminUnban => 'Gỡ cấm';

  @override
  String get adminBanTickets => 'Cấm mua vé';

  @override
  String get adminDeleteUser => 'Xóa người dùng';

  @override
  String get adminTimelineBanned => 'Bị cấm mua vé';

  @override
  String get adminTimelineHasTicket => 'Có vé sự kiện';

  @override
  String get adminTimelineVerified => 'Đã xác minh';

  @override
  String get adminTimelineCreated => 'Tạo tài khoản';

  @override
  String get adminTagBanned => 'CẤM';

  @override
  String get adminTagVerified => 'XÁC MINH';

  @override
  String get adminTagNew => 'MỚI';

  @override
  String get adminUsersTitle => 'Quản lý người dùng';

  @override
  String get adminUsersTabBlacklisted => 'Bị cấm';

  @override
  String get adminUsersSearchHint => 'Tìm email, tên, fursona...';

  @override
  String get adminUsersEmpty => 'Không có người dùng';

  @override
  String get adminUsersEmptyBlacklisted => 'Không có người bị cấm.';

  @override
  String get adminUsersEmptySearch => 'Không tìm thấy người dùng phù hợp.';

  @override
  String get adminTicketsTitle => 'Quản lý vé';

  @override
  String get adminTicketsTabTiers => 'Hạng vé';

  @override
  String get adminTicketsTabList => 'Danh sách vé';

  @override
  String get adminTicketsNewTier => 'Hạng vé mới';

  @override
  String get adminTicketsCreateTier => 'Tạo hạng vé';

  @override
  String get adminTicketsPendingOver24h => 'Chờ > 24 giờ';

  @override
  String get adminTicketsSearchHint => 'Tìm mã vé, email, tên...';

  @override
  String get adminTicketsViewUser => 'View user profile';

  @override
  String get adminTicketsDisableSales => 'Tắt bán';

  @override
  String get adminTicketsEnableSales => 'Bật bán';

  @override
  String get adminTicketsHideStore => 'Ẩn khỏi cửa hàng';

  @override
  String get adminTicketsShowStore => 'Hiện trên cửa hàng';

  @override
  String get adminTicketsDeleteTier => 'Xóa hạng vé';

  @override
  String get adminTicketsStock => 'Tồn kho';

  @override
  String get adminTicketsBenefits => 'Quyền lợi';

  @override
  String get adminTicketsSelling => 'Đang bán';

  @override
  String get adminTicketsSalesOff => 'Tắt bán';

  @override
  String get adminTicketsStoreVisible => 'Hiện cửa hàng';

  @override
  String get adminTicketsStoreHidden => 'Ẩn';

  @override
  String get adminTicketsDeleteTierTitle => 'Xóa hạng vé?';

  @override
  String get adminTicketsDeleteTierBody =>
      'Hành động này không thể hoàn tác và sẽ xóa vĩnh viễn hạng vé.';

  @override
  String get adminTicketsEmpty => 'Không có vé';

  @override
  String get adminTicketsEmptyTiers => 'Chưa có hạng vé.';

  @override
  String get adminTierEditCreate => 'Tạo hạng vé';

  @override
  String get adminTierEditEdit => 'Chỉnh sửa hạng vé';

  @override
  String get adminTierNameLabel => 'Tên hạng vé';

  @override
  String get adminTierPriceLabel => 'Giá vé (VND)';

  @override
  String get adminTierStockLabel => 'Số lượng';

  @override
  String get adminTierDescriptionLabel => 'Mô tả hạng vé';

  @override
  String get adminTierBenefitsList => 'Danh sách quyền lợi';

  @override
  String get adminTierAddBenefit => 'Thêm quyền lợi';

  @override
  String get adminTierSalesStatus => 'Trạng thái bán';

  @override
  String get adminTierPreview => 'Preview Hiển Thị';

  @override
  String get adminTierCreated => 'Đã tạo hạng vé.';

  @override
  String get adminTierUpdated => 'Đã cập nhật hạng vé.';

  @override
  String get adminSchedulesTitle => 'Quản lý lịch trình';

  @override
  String get adminSchedulesCreate => 'Tạo lịch';

  @override
  String get adminSchedulesEmpty => 'Chưa có lịch trình';

  @override
  String get adminSchedulesEdit => 'Chỉnh sửa lịch trình';

  @override
  String get adminSchedulesCreateNew => 'Tạo lịch trình mới';

  @override
  String get adminSchedulesNameLabel => 'Tên lịch trình';

  @override
  String get adminScheduleEndAfterStart =>
      'Thời gian kết thúc phải sau thời gian bắt đầu.';

  @override
  String get adminScheduleDeleteTitle => 'Xóa lịch trình?';

  @override
  String get adminScheduleDeleteBody => 'Tất cả mục trong lịch sẽ bị xóa.';

  @override
  String get adminScheduleDeleteItemTitle => 'Xóa mục lịch trình?';

  @override
  String adminScheduleDeleteItemBody(String title) {
    return 'Xóa \"$title\"?';
  }

  @override
  String get adminScheduleEditMenu => 'Chỉnh sửa lịch';

  @override
  String get adminScheduleDeleteMenu => 'Xóa lịch trình';

  @override
  String get adminScheduleNoItems => 'Chưa có mục lịch trình';

  @override
  String get adminScheduleEditItem => 'Chỉnh sửa mục';

  @override
  String get adminScheduleAddItem => 'Thêm mục lịch trình';

  @override
  String get adminScheduleOverlapBadge => 'Trùng địa điểm';

  @override
  String get adminDashboardTitle => 'Tổng quan sự kiện';

  @override
  String get adminDashboardSubtitle => 'Dữ liệu 90 ngày gần nhất';

  @override
  String get adminDashboardTickets => 'Vé';

  @override
  String get adminDashboardByTier => 'Theo hạng vé';

  @override
  String get adminDashboardRevenue => 'Doanh thu';

  @override
  String get adminDashboardUsers => 'Người dùng';

  @override
  String get adminDashboardDealers => 'Dealer';

  @override
  String get adminDashboardTotalTickets => 'Tổng vé';

  @override
  String get adminDashboardApproved => 'Đã duyệt';

  @override
  String get adminDashboardPending => 'Chờ duyệt';

  @override
  String get adminDashboardDenied => 'Từ chối';

  @override
  String adminDashboardSold(int sold, int total) {
    return 'Đã bán $sold / $total';
  }

  @override
  String adminDashboardRemaining(int count) {
    return 'Còn $count';
  }

  @override
  String get adminDashboardUsersByCountry => 'Người dùng theo quốc gia';

  @override
  String get adminDashboardUnknownCountry => 'Không rõ';

  @override
  String get adminDashboardUsersByCountryEmpty => 'Chưa có dữ liệu quốc gia';

  @override
  String adminDashboardUsersByCountryMore(int count) {
    return '+$count quốc gia khác';
  }

  @override
  String get adminConbookTitle => 'Duyệt Conbook';

  @override
  String get adminConbookApprove => 'Duyệt conbook';

  @override
  String get adminConbookDeny => 'Từ chối conbook';

  @override
  String get adminPanelsTitle => 'Quản lý Panel';

  @override
  String get adminPanelsApprove => 'Duyệt panel';

  @override
  String get adminPanelsDeny => 'Từ chối panel';

  @override
  String get adminDealersTitle => 'Quản lý Dealer';

  @override
  String get adminDealersApprove => 'Duyệt gian hàng';

  @override
  String get adminDealersDeny => 'Từ chối đăng ký';

  @override
  String get adminDealerDetailTitle => 'Chi tiết gian hàng';

  @override
  String get adminDealerInfo => 'Thông tin gian hàng';

  @override
  String get adminDealerPriceSheets => 'Bảng giá';

  @override
  String get adminDealerStaff => 'Nhân viên gian hàng';

  @override
  String get adminDealerNoStaff => 'Chưa có nhân viên nào.';

  @override
  String get adminDealerActions => 'Thao tác';

  @override
  String get adminDealerOwner => 'Chủ gian';

  @override
  String get adminDealerJoined => 'Tham gia:';

  @override
  String get adminLostFoundTitle => 'Quản lý thất lạc';

  @override
  String get adminLostFoundSearchHint => 'Tìm tiêu đề, mã, vị trí...';

  @override
  String get adminLostFoundEmpty => 'Không có vật phẩm';

  @override
  String get adminLostFoundDetailTitle => 'Chi tiết vật phẩm';

  @override
  String get adminLostFoundRecipientClaimed => 'Người nhận (đã claim)';

  @override
  String get adminLostFoundNoClaim => 'Chưa có claim cho vật phẩm này.';

  @override
  String get adminLostFoundConfirmReturn => 'Xác nhận hoàn trả';

  @override
  String get adminLostFoundMarkResolved => 'Đánh dấu đã xử lý';

  @override
  String get adminLostFoundDeleteTitle => 'Xóa vật phẩm?';

  @override
  String get adminLostFoundReturnTitle => 'Xác nhận hoàn trả';

  @override
  String get adminLostFoundReturnSuccess => 'Đã xác nhận hoàn trả thành công.';

  @override
  String get adminLostFoundVerifyDescription => 'Mô tả đúng vật phẩm';

  @override
  String get adminLostFoundVerifyOwnership => 'Có bằng chứng sở hữu';

  @override
  String get adminLostFoundVerifyIdentity => 'Đã xác minh danh tính';

  @override
  String get adminLostFoundAuditNote =>
      'Hành động này sẽ được ghi vào nhật ký hệ thống';

  @override
  String get adminScanHistoryTitle => 'Lịch sử quét vé';

  @override
  String get adminScanHistoryEmpty => 'Chưa có lượt quét nào được ghi nhận.';

  @override
  String get adminScanOutcomeValid => 'Hợp lệ';

  @override
  String get adminScanOutcomeReused => 'Dùng lại';

  @override
  String get adminScanOutcomeRejected => 'Từ chối';

  @override
  String get adminUserEditPermissions => 'Phân quyền';

  @override
  String get adminUserEditTitle => 'Chỉnh sửa người dùng';

  @override
  String get adminUserEditPersonalInfo => 'Thông tin cá nhân';

  @override
  String get adminUserEditAccountStatus => 'Trạng thái tài khoản';

  @override
  String get adminUserEditRoles => 'Vai trò';

  @override
  String get adminUserEditPermissionGroup => 'Permission Group';

  @override
  String get adminUserEditVerified => 'Đã xác minh';

  @override
  String get adminUserEditVerifiedSubtitle =>
      'Tài khoản đã được xác minh email';

  @override
  String get adminUserEditAdminNote => 'Quản trị viên có toàn bộ quyền.';

  @override
  String get adminUserTicketsTitle => 'Vé của người dùng';

  @override
  String get adminUserTicketsSubtitle => 'Cấp, duyệt, chỉnh sửa hoặc xóa vé';

  @override
  String get adminUserTicketsNoTiers => 'Chưa có hạng vé để cấp.';

  @override
  String get adminUserTicketsGrant => 'Cấp vé';

  @override
  String get adminUserTicketsGrantSuccess => 'Đã cấp vé cho người dùng.';

  @override
  String get adminUserTicketsDeleteTitle => 'Xóa vé?';

  @override
  String adminUserTicketsDeleteBody(String code) {
    return 'Xóa vé $code? Hành động không thể hoàn tác.';
  }

  @override
  String get adminUserTicketsDeleted => 'Đã xóa vé.';

  @override
  String get adminUserTicketsApprove => 'Duyệt vé';

  @override
  String get adminUserTicketsApproveSuccess => 'Đã duyệt vé.';

  @override
  String get adminUserTicketsDeny => 'Từ chối vé';

  @override
  String get adminUserTicketsDenySuccess => 'Đã từ chối vé.';

  @override
  String get adminUserTicketsResendQr => 'Gửi lại email QR';

  @override
  String get adminUserTicketsResendQrSuccess => 'Đã gửi lại email QR.';

  @override
  String get adminUserTicketsEdit => 'Chỉnh sửa vé';

  @override
  String get adminUserTicketsDelete => 'Xóa vé';

  @override
  String get adminUserTicketsEmpty => 'Người dùng chưa có vé.';

  @override
  String get adminUserTicketsGrantDialog => 'Cấp vé';

  @override
  String get adminUserTicketsTierLabel => 'Hạng vé';

  @override
  String get adminUserTicketsEditTitle => 'Chỉnh sửa vé';

  @override
  String get adminUserTicketsNotSelected => 'Chưa chọn';

  @override
  String get adminSectionOnSite => 'Vận hành tại chỗ';

  @override
  String get adminSectionOnSiteSubtitle =>
      'Check-in, lịch sử quét và đồ thất lạc.';

  @override
  String get adminSectionEvent => 'Quản lý sự kiện';

  @override
  String get adminSectionEventSubtitle => 'Vé, cấu hình và vận hành sự kiện.';

  @override
  String get adminSectionContent => 'Duyệt nội dung';

  @override
  String get adminSectionContentSubtitle =>
      'Conbook, panel và gian hàng dealer.';

  @override
  String get adminSectionUsersReports => 'Người dùng & báo cáo';

  @override
  String get adminSectionUsersReportsSubtitle => 'Tài khoản và số liệu bán vé.';

  @override
  String get adminSectionOther => 'Khác';

  @override
  String get adminSectionOtherSubtitle => 'Lịch trình, thông báo và hệ thống.';

  @override
  String get adminMenuScanTicket => 'Quét vé';

  @override
  String get adminMenuScanHistory => 'Lịch sử quét';

  @override
  String get adminMenuLostFound => 'Thất lạc';

  @override
  String get adminMenuTickets => 'Quản lý vé';

  @override
  String get adminMenuConbook => 'Duyệt Conbook';

  @override
  String get adminMenuPanels => 'Quản lý Panel';

  @override
  String get adminMenuDealers => 'Quản lý Dealer';

  @override
  String get adminMenuUsers => 'Người dùng';

  @override
  String get adminMenuStats => 'Thống kê';

  @override
  String get adminMenuNotifications => 'Thông báo';

  @override
  String get adminNotificationCreateTitle => 'Gửi thông báo';

  @override
  String get adminNotificationCreateSubtitle =>
      'Tạo thông báo trong app cho người dùng. Có thể gửi kèm push và email.';

  @override
  String get adminNotificationRecipientLabel => 'Người nhận';

  @override
  String get adminNotificationSearchUserHint => 'Tìm theo tên hoặc email';

  @override
  String get adminNotificationSelectUserRequired => 'Vui lòng chọn người nhận.';

  @override
  String get adminNotificationTitleLabel => 'Tiêu đề';

  @override
  String get adminNotificationTitleRequired => 'Tiêu đề là bắt buộc.';

  @override
  String get adminNotificationBodyLabel => 'Nội dung';

  @override
  String get adminNotificationKindLabel => 'Loại (tuỳ chọn)';

  @override
  String get adminNotificationKindHint => 'vd: announcement';

  @override
  String get adminNotificationSendPush => 'Gửi push notification';

  @override
  String get adminNotificationSendPushHint =>
      'Gửi qua FCM tới thiết bị đã đăng ký.';

  @override
  String get adminNotificationSendEmail => 'Gửi email';

  @override
  String get adminNotificationSendEmailHint =>
      'Gửi email cùng tiêu đề và nội dung cho người dùng.';

  @override
  String get adminNotificationSend => 'Gửi thông báo';

  @override
  String get adminNotificationSendAction => 'Thông báo';

  @override
  String get adminNotificationCreateSuccess => 'Đã tạo thông báo.';

  @override
  String adminNotificationPushSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thiết bị',
      one: '1 thiết bị',
      zero: '0 thiết bị',
    );
    return 'Đã gửi push tới $_temp0.';
  }

  @override
  String adminNotificationPushFailed(String error) {
    return 'Gửi push thất bại: $error';
  }

  @override
  String get adminNotificationEmailSent => 'Đã gửi email.';

  @override
  String adminNotificationEmailFailed(String error) {
    return 'Gửi email thất bại: $error';
  }

  @override
  String get notificationsMarkAllRead => 'Đánh dấu tất cả đã đọc';

  @override
  String get notificationsMarkAllReadSuccess =>
      'Đã đánh dấu tất cả thông báo là đã đọc.';

  @override
  String get notificationsMarkAllReadFailed =>
      'Không thể đánh dấu đã đọc. Vui lòng thử lại.';

  @override
  String get notificationsUnreadOnly => 'Chỉ chưa đọc';

  @override
  String get notificationsEmptyUnread => 'Không có thông báo chưa đọc.';

  @override
  String get adminNotificationsHubTitle => 'Thông báo';

  @override
  String get adminNotificationsHubSubtitle =>
      'Gửi cho một người dùng hoặc phát sóng theo nhóm.';

  @override
  String get adminNotificationSendToUser => 'Gửi cho người dùng';

  @override
  String get adminNotificationSendToUserHint =>
      'Tạo thông báo in-app cho một tài khoản cụ thể.';

  @override
  String get adminNotificationBroadcastAction => 'Phát sóng';

  @override
  String get adminNotificationBroadcastTitle => 'Phát sóng thông báo';

  @override
  String get adminNotificationBroadcastSubtitle =>
      'Gửi cùng nội dung tới tất cả người dùng hoặc theo vai trò.';

  @override
  String get adminNotificationBroadcastAudienceLabel => 'Đối tượng';

  @override
  String get adminNotificationBroadcastAudienceAll => 'Tất cả người dùng';

  @override
  String get adminNotificationBroadcastAudienceUser => 'User';

  @override
  String get adminNotificationBroadcastAudienceDealer => 'Dealer';

  @override
  String get adminNotificationBroadcastAudienceStaff => 'Staff';

  @override
  String get adminNotificationBroadcastAudienceAdmin => 'Admin';

  @override
  String get adminNotificationBroadcastSuccess => 'Đã phát sóng thông báo.';

  @override
  String adminNotificationBroadcastRecipients(int count) {
    return 'Đã gửi tới $count người nhận.';
  }

  @override
  String get adminMenuSchedules => 'Lịch trình';

  @override
  String get adminEventSchedulesTitle => 'Quản lý lịch trình';

  @override
  String get adminEventSchedulesSubtitle =>
      'Lịch trình theo ngày và khung giờ.';

  @override
  String get adminEventSchedulesEmpty => 'Chưa có lịch trình';

  @override
  String get adminEventSchedulesCreate => 'Tạo lịch trình mới';

  @override
  String get adminEventSchedulesCreateShort => 'Tạo lịch trình';

  @override
  String get adminEventSchedulesNoTime => 'Chưa đặt thời gian';

  @override
  String get adminEventSchedulesFrom => 'Từ';

  @override
  String get adminEventSchedulesTo => 'Đến';

  @override
  String adminEventSchedulesDaysItems(int days, int items) {
    return '$days ngày · $items mục';
  }

  @override
  String get adminEventControlsTitle => 'Điều khiển sự kiện';

  @override
  String get adminSystemStatusTitle => 'Trạng thái hệ thống';

  @override
  String get adminSystemStatusSubtitle =>
      'Giám sát các dịch vụ cốt lõi theo thời gian thực.';

  @override
  String get adminSystemHealthy => 'Hoạt động';

  @override
  String get adminSystemWarning => 'Cảnh báo';

  @override
  String get adminSystemError => 'Lỗi';

  @override
  String get adminSystemUnknown => 'Không rõ';

  @override
  String get adminStaffReadySubtitle =>
      'Sẵn sàng phục vụ khách tham dự tại sự kiện.';

  @override
  String get adminStaffCheckInGate => 'Check-in tại cổng';

  @override
  String get adminStaffReadyBadge => 'Sẵn sàng';

  @override
  String get adminStaffScanHint => 'Quét mã QR vé để check-in khách tham dự.';

  @override
  String get adminStaffGreetingMorning => 'Chào buổi sáng,';

  @override
  String get adminStaffGreetingAfternoon => 'Chào buổi chiều,';

  @override
  String get adminStaffGreetingEvening => 'Chào buổi tối,';

  @override
  String get adminStaffShiftStats => 'Thống kê ca trực';

  @override
  String get adminStaffShiftNoData => 'Chưa có dữ liệu';

  @override
  String get adminStaffShiftUpdatedAt => 'Cập nhật lúc';

  @override
  String get adminStaffShiftScannedToday => 'Vé đã quét hôm nay';

  @override
  String get adminStaffTrafficWarning => 'CẢNH BÁO LƯU LƯỢNG';

  @override
  String get adminSalesTimelineDefault => 'Bán vé theo ngày';

  @override
  String get adminQrContinueScan => 'Tiếp tục quét';

  @override
  String get adminQrProcessing => 'Đang xử lý vé...';

  @override
  String get adminQrAlignFrame => 'Đưa mã QR vé vào khung hình';

  @override
  String get adminQrManualEntry => 'Nhập mã thủ công';

  @override
  String get adminQrCheckIn => 'Check-in';

  @override
  String get adminQrEnterCodeTitle => 'Nhập mã vé';

  @override
  String get adminQrTicketInfo => 'Thông tin vé';

  @override
  String get adminQrGuest => 'Guest';

  @override
  String get adminQrNoTicketImage => 'Không có ảnh vé';

  @override
  String get adminQrReadyCheckIn => 'Sẵn sàng check-in';

  @override
  String get adminQrConnecting => 'Đang kết nối...';

  @override
  String get adminQrScanNow => 'QUÉT VÉ NGAY';

  @override
  String get adminTierBadgeSoldOut => 'HẾT VÉ';

  @override
  String get adminTierBadgePaused => 'TẠM DỪNG';

  @override
  String get adminTierBadgeSelling => 'ĐANG BÁN';

  @override
  String get adminTierViewDetails => 'Xem chi tiết vé →';

  @override
  String get adminTierLowStock => 'Sắp hết';

  @override
  String get adminPlaceholderDashboardUsers => 'Dashboard Users';

  @override
  String get adminPlaceholderDashboardUsersSubtitle =>
      'User analytics and breakdowns.';

  @override
  String get adminPlaceholderTalent => 'Talent Management';

  @override
  String get adminPlaceholderTalentSubtitle =>
      'Review and manage talent applications.';

  @override
  String get adminTierUpdateSuccess => 'Cập nhật hạng vé thành công.';

  @override
  String get adminLostFoundFormTitle => 'Ghi nhận vật phẩm';

  @override
  String get adminLostFoundFormType => 'Loại vật phẩm';

  @override
  String get adminLostFoundFormTitleLabel => 'Tiêu đề';

  @override
  String get adminLostFoundFormDescription => 'Mô tả';

  @override
  String get adminLostFoundFormLocation => 'Vị trí';

  @override
  String get adminLostFoundFormContact => 'Thông tin liên hệ';

  @override
  String get adminLostFoundFormNotes => 'Ghi chú nhân viên';

  @override
  String get adminLostFoundFormImage => 'Hình ảnh';

  @override
  String get adminLostFoundFormRequired => 'Vui lòng điền thông tin này';

  @override
  String adminRoleCurrent(String role) {
    return '$role Hiện tại';
  }

  @override
  String get adminStatusPillDeleted => 'Đã xóa';

  @override
  String get adminStatusPillBlacklisted => 'Bị cấm';

  @override
  String get adminStatusPillActive => 'Hoạt động';

  @override
  String get adminTimelineBannedSubtitle => 'Tài khoản bị hạn chế mua vé.';

  @override
  String get adminTimelineHasTicketSubtitle =>
      'Người dùng đã đăng ký hoặc được cấp vé.';

  @override
  String get adminTimelineVerifiedSubtitle =>
      'Tài khoản đã được xác minh danh tính.';

  @override
  String get adminTimelineCreatedSubtitle => 'Đăng ký tài khoản trên hệ thống.';

  @override
  String get adminTagTicket => 'VÉ';

  @override
  String adminEventCount(int count) {
    return '$count sự kiện';
  }

  @override
  String get adminLostFoundEmptySubtitle =>
      'Nhấn + để thêm vật thất lạc hoặc nhặt được.';

  @override
  String get adminUserEditPersonalSubtitle =>
      'Cập nhật hồ sơ và liên hệ của người dùng';

  @override
  String get adminUserTicketsManage => 'Quản lý vé';

  @override
  String get adminLostFoundFormEditTitle => 'Chỉnh sửa mục thất lạc';

  @override
  String get adminLostFoundFormAddItem => 'Thêm mục';

  @override
  String get adminLostFoundItemInfo => 'Thông tin vật phẩm';

  @override
  String get adminLostFoundRecipientInfo => 'Thông tin người nhận';

  @override
  String get adminLostFoundUserConfirmed =>
      'Người dùng đã xác nhận đây là vật phẩm của họ';

  @override
  String get adminLostFoundVerifyChecklist => 'Checklist xác minh';

  @override
  String get adminLostFoundReturnNoClaim =>
      'Chưa có người dùng nào nhận vật phẩm này.';

  @override
  String get adminLostFoundReturnCannot => 'Vật phẩm này không thể hoàn trả.';

  @override
  String get adminLostFoundReturnNoRecipient =>
      'Không tìm thấy thông tin người nhận.';

  @override
  String get adminLostFoundVerifyRequired =>
      'Vui lòng hoàn tất checklist xác minh trước khi xác nhận.';

  @override
  String get adminLostFoundUserNote => 'Ghi chú từ người dùng';

  @override
  String adminDealerStaffCount(int count) {
    return 'Nhân viên gian hàng ($count)';
  }

  @override
  String adminDealerPriceSheetsCount(int count) {
    return 'Bảng giá ($count)';
  }

  @override
  String get adminEventControlsSubtitle =>
      'Bật hoặc tắt bán vé và các kênh đăng ký.';

  @override
  String get adminEventToggleTicketSales => 'Mở bán vé';

  @override
  String get adminEventToggleTicketSalesSubtitle =>
      'Cho phép người dùng mua và nâng cấp vé sự kiện.';

  @override
  String get adminEventTogglePanelRegistration => 'Đăng ký Panel';

  @override
  String get adminEventTogglePanelRegistrationSubtitle =>
      'Cho phép đăng ký tham gia panel trên app.';

  @override
  String get adminEventToggleTalentRegistration => 'Đăng ký Talent';

  @override
  String get adminEventToggleTalentRegistrationSubtitle =>
      'Cho phép đăng ký talent trên app.';

  @override
  String get adminEventToggleDealerRegistration => 'Đăng ký Dealer';

  @override
  String get adminEventToggleDealerRegistrationSubtitle =>
      'Cho phép đăng ký gian hàng dealer trên app.';

  @override
  String get adminTicketsTabAll => 'Tất cả';

  @override
  String get adminTicketsTabPendingReview => 'Chờ duyệt';

  @override
  String get adminTicketsTabApproved => 'Đã duyệt';

  @override
  String get adminTicketsTabDenied => 'Từ chối';

  @override
  String get adminTicketsEmptySubtitle =>
      'Không tìm thấy vé phù hợp với bộ lọc.';

  @override
  String get adminTicketsEmptyTiersSubtitle =>
      'Tạo hạng vé đầu tiên để bắt đầu bán.';

  @override
  String adminTicketsEmptyFilter(String filter) {
    return 'Không có hạng vé nào trong bộ lọc \"$filter\".';
  }

  @override
  String adminTicketsDeleteTierBodyNamed(String name) {
    return 'Xóa \"$name\" sẽ xóa vĩnh viễn hạng vé này và tất cả vé đã bán thuộc hạng. Hành động không thể hoàn tác.';
  }

  @override
  String get adminTicketsStockSoldOut => ' (hết vé)';

  @override
  String get adminTierFilterAll => 'Tất cả';

  @override
  String get adminTierFilterSelling => 'Đang bán';

  @override
  String get adminTierFilterPaused => 'Tạm dừng';

  @override
  String get adminTierFilterSoldOut => 'Hết vé';

  @override
  String get adminTierStatTotal => 'Tổng vé';

  @override
  String get adminTierStatSold => 'Vé đã bán';

  @override
  String get adminTierStatRemaining => 'Vé còn lại';

  @override
  String get adminTierStatApproved => 'Vé đã duyệt';

  @override
  String adminTierSoldCount(int sold, int total) {
    return 'Đã bán: $sold / $total';
  }

  @override
  String get adminTierNameRequired => 'Vui lòng nhập tên hạng vé';

  @override
  String get adminTierMaxChars255 => 'Tối đa 255 ký tự';

  @override
  String get adminTierEnterPrice => 'Nhập giá';

  @override
  String get adminTierInvalidPrice => 'Giá không hợp lệ';

  @override
  String get adminTierEnterStockQty => 'Nhập SL';

  @override
  String get adminTierInvalidStock => 'Không hợp lệ';

  @override
  String get adminTierBenefitHint => 'Nhập quyền lợi...';

  @override
  String get adminTierDescriptionHint =>
      'Mô tả ngắn gọn về đối tượng và đặc quyền...';

  @override
  String get adminTierNameHint => 'VD: VIP Pass - Early Bird';

  @override
  String get adminTierAllowPurchaseSubtitle =>
      'Cho phép người dùng mua hạng vé này';

  @override
  String get adminTierSaveCreate => 'Tạo hạng vé';

  @override
  String get adminTierSaveEdit => 'Lưu hạng vé';

  @override
  String get adminTierDiscard => 'Hủy bỏ';

  @override
  String get adminTierSystemWarningTitle => 'Cảnh báo hệ thống';

  @override
  String get adminTierSystemWarningBody =>
      'Thay đổi thông tin có thể ảnh hưởng đến người dùng đã mua vé. Vui lòng cân nhắc kỹ trước khi lưu.';

  @override
  String get adminTierPreviewNamePlaceholder => 'Tên hạng vé';

  @override
  String get adminSchedulesEmptySubtitle =>
      'Tạo lịch trình theo ngày và khung giờ.';

  @override
  String adminSchedulesDaysCount(int count) {
    return '$count ngày';
  }

  @override
  String adminSchedulesItemsCount(int count) {
    return '$count mục';
  }

  @override
  String get adminScheduleDefaultTitle => 'Lịch trình';

  @override
  String get adminScheduleSelectDay => 'Chọn ngày để xem lịch trình.';

  @override
  String adminScheduleEmptyDayOnDate(String date) {
    return 'Chưa có mục nào vào ngày $date.';
  }

  @override
  String get adminScheduleOverlapSchedule => ' (Trùng lịch)';

  @override
  String get adminScheduleItemTitleLabel => 'Tiêu đề';

  @override
  String get adminScheduleItemDescriptionLabel => 'Diễn giả / mô tả (tuỳ chọn)';

  @override
  String get adminScheduleItemCategoryLabel => 'Hạng mục (tuỳ chọn)';

  @override
  String get adminScheduleItemCategoryHint => 'Panel, Workshop...';

  @override
  String get adminScheduleItemLocationLabel => 'Địa điểm (tuỳ chọn)';

  @override
  String get adminScheduleItemLocationHint => 'Hall A, Sân khấu chính...';

  @override
  String get adminScheduleStartLabel => 'Bắt đầu';

  @override
  String get adminScheduleEndLabel => 'Kết thúc';

  @override
  String get adminScheduleTitleRequired => 'Vui lòng nhập tiêu đề.';

  @override
  String get adminSchedulesNameRequired => 'Vui lòng nhập tên.';

  @override
  String get adminDashboardLoadFailed => 'Không tải được thống kê';

  @override
  String get adminDashboardLoadFailedSubtitle => 'Vui lòng thử lại sau.';

  @override
  String get adminChartPeriod7Days => '7 ngày';

  @override
  String get adminChartPeriod30Days => '30 ngày';

  @override
  String get adminChartPeriod90Days => '90 ngày';

  @override
  String get adminStaffReadyConnected =>
      'Hệ thống đã kết nối và sẵn sàng quét vé.';

  @override
  String get adminStaffConnectingHint => 'Vui lòng chờ trong giây lát.';

  @override
  String get adminStaffTrafficWarningBody =>
      'Khu vực Dealer A đang quá tải (90%). Yêu cầu phân luồng khách tham quan.';

  @override
  String get adminQrCameraPermission =>
      'Cần quyền camera để quét vé. Hãy bật trong Cài đặt.';

  @override
  String get adminQrUnsupported => 'Thiết bị không hỗ trợ quét mã QR.';

  @override
  String get adminQrCameraOpenFailed => 'Không thể mở camera.';

  @override
  String get adminQrTicketLabel => 'Vé';

  @override
  String get adminQrGuestLabel => 'Khách';
}
