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
  String get themeSwitchToLight => 'Chế độ sáng';

  @override
  String get themeSwitchToDark => 'Chế độ tối';

  @override
  String get splashTagline => 'Nơi kết nối cộng đồng sự kiện và nghệ thuật';

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
  String get registerPhoneLabel => 'Số điện thoại';

  @override
  String get registerPhoneHint => 'Nhập số điện thoại';

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
  String get validationPhoneRequired => 'Vui lòng nhập số điện thoại';

  @override
  String get validationPhoneInvalid => 'Số điện thoại không hợp lệ';

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
  String get navNotifications => 'Thông báo';

  @override
  String get navAccount => 'Tài khoản';

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
  String get authHomeSearchHint => 'Tìm kiếm sự kiện, nghệ sĩ...';

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
  String get authHomeNotificationsEmpty => 'Chưa có thông báo mới.';

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
  String get rulesIntro =>
      'Vui lòng đọc kỹ các quy định dưới đây để đảm bảo một kỳ triển lãm an toàn, chuyên nghiệp và đáng nhớ cho tất cả mọi người.';

  @override
  String get rulesAttendanceTitle => 'Nội quy tham dự';

  @override
  String get rulesAttendance1 => 'Xuất trình vé hợp lệ tại cổng.';

  @override
  String get rulesAttendance2 => 'Không mang vũ khí, chất cháy nổ.';

  @override
  String get rulesAttendance3 => 'Tôn trọng không gian chung.';

  @override
  String get rulesCosplayTitle => 'Quy định cosplay';

  @override
  String get rulesCosplay1 => 'Trang phục phù hợp thuần phong mỹ tục.';

  @override
  String get rulesCosplay2 => 'Đạo cụ không sắc nhọn, nguy hiểm.';

  @override
  String get rulesCosplay3 => 'Sử dụng khu vực thay đồ đúng quy định.';

  @override
  String get rulesBoothTitle => 'Quy định gian hàng';

  @override
  String get rulesBooth1 => 'Kinh doanh đúng danh mục đăng ký.';

  @override
  String get rulesBooth2 => 'Không lấn chiếm lối đi chung.';

  @override
  String get rulesBooth3 => 'Đảm bảo vệ sinh khu vực.';

  @override
  String get rulesConductTitle => 'Quy định hành vi';

  @override
  String get rulesConduct1 => 'Nghiêm cấm quấy rối dưới mọi hình thức.';

  @override
  String get rulesConduct2 => 'Không xả rác bừa bãi.';

  @override
  String get rulesConduct3 => 'Tuân thủ hướng dẫn của BTC.';

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
  String get artbookTitle => 'Conbook FUVEKON';

  @override
  String get artbookSubtitle => 'Hành trình Nghệ thuật - 2024';

  @override
  String get artbookDescription =>
      'Cuốn sách tổng hợp hơn 50 tác phẩm nghệ thuật từ cộng đồng sáng tạo FUVEKON, được in trên giấy mỹ thuật cao cấp.';

  @override
  String get artbookPageCount => '120 Trang';

  @override
  String get artbookPaperType => 'Giấy Couche 150gsm';

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
  String get artbookRulesTitle => 'Quy định nộp bài';

  @override
  String get artbookRuleSizeTitle => 'KÍCH THƯỚC';

  @override
  String get artbookRuleSizeBody => 'A4 (210 x 297mm), lề an toàn 5mm.';

  @override
  String get artbookRuleFormatTitle => 'ĐỊNH DẠNG';

  @override
  String get artbookRuleFormatBody => 'Chế độ màu CMYK, tối thiểu 300dpi.';

  @override
  String get artbookRuleCopyrightTitle => 'BẢN QUYỀN';

  @override
  String get artbookRuleCopyrightBody =>
      'Tác phẩm phải là nguyên bản, chưa từng xuất bản thương mại.';

  @override
  String get artbookDeadline => 'Hạn chót nộp tác phẩm: 20 Tháng 11, 2023';

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
}
