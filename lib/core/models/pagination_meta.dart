/// Pagination metadata returned by list endpoints (`meta` in API envelope).
class PaginationMeta {
  const PaginationMeta({
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
    );
  }

  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  bool get hasMore => currentPage < totalPages;
}
