import 'package:equatable/equatable.dart';

enum SubmissionType { panel, talent, conbook }

class SubmissionSummary extends Equatable {
  const SubmissionSummary({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    this.subtitle,
    this.imageUrl,
    this.createdAt,
  });

  final String id;
  final SubmissionType type;
  final String title;
  final String status;
  final String? subtitle;
  final String? imageUrl;
  final DateTime? createdAt;

  factory SubmissionSummary.panel(Map<String, dynamic> json) {
    return SubmissionSummary(
      id: json['id']?.toString() ?? '',
      type: SubmissionType.panel,
      title: json['title'] as String? ?? 'Panel',
      status: json['status'] as String? ?? 'pending',
      subtitle: json['performance_genre'] as String?,
      imageUrl: json['representative_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  factory SubmissionSummary.talent(Map<String, dynamic> json) {
    return SubmissionSummary(
      id: json['id']?.toString() ?? '',
      type: SubmissionType.talent,
      title: json['title'] as String? ?? 'Talent',
      status: json['status'] as String? ?? 'pending',
      subtitle: json['performance_genre'] as String?,
      imageUrl: json['representative_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  factory SubmissionSummary.conbook(Map<String, dynamic> json) {
    return SubmissionSummary(
      id: json['id']?.toString() ?? '',
      type: SubmissionType.conbook,
      title: json['title'] as String? ?? 'Conbook',
      status: json['status'] as String? ?? 'pending',
      subtitle: json['handle'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  @override
  List<Object?> get props => [id, type, title, status, subtitle, imageUrl, createdAt];
}
