import 'package:flutter/material.dart';
import 'package:fuvekonmobile/features/ticket/domain/entities/ticket_tier.dart';
import 'package:intl/intl.dart';

String formatTicketPriceVndCompact(double price) {
  return '${NumberFormat.decimalPattern('vi-VN').format(price)}đ';
}

String formatTicketPriceVnd(double price) {
  return '${NumberFormat.decimalPattern('vi-VN').format(price)} VNĐ';
}

String formatTierPriceDiff(double diff) {
  return '+ ${formatTicketPriceVndCompact(diff)} chênh lệch';
}

String formatTicketPriceUsd(double price) {
  return NumberFormat.simpleCurrency(
    locale: 'en_US',
    name: 'USD',
  ).format(price);
}

String formatTierPrice(TicketTier tier, {Locale? locale}) {
  final useVnd = locale?.languageCode == 'vi';
  if (useVnd) {
    return formatTicketPriceVnd(tier.price);
  }
  final usd = tier.priceUsd;
  if (usd != null && usd > 0) {
    return formatTicketPriceUsd(usd);
  }
  return formatTicketPriceVnd(tier.price);
}
