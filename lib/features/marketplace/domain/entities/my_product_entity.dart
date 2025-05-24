enum MyProductSortOption { newFirst, oldFirst }

extension MyProductSortOptionExtension on MyProductSortOption {
  String get value {
    switch (this) {
      case MyProductSortOption.newFirst:
        return 'new';
      case MyProductSortOption.oldFirst:
        return 'old';
    }
  }

  static MyProductSortOption? from(String? raw) {
    switch (raw) {
      case 'new':
        return MyProductSortOption.newFirst;
      case 'old':
        return MyProductSortOption.oldFirst;
      default:
        return null;
    }
  }
}

enum MyProductStatus { sold, unsold }

extension MyProductStatusExtension on MyProductStatus {
  String get value {
    switch (this) {
      case MyProductStatus.sold:
        return 'sold';
      case MyProductStatus.unsold:
        return 'unsold';
    }
  }

  static MyProductStatus? from(String? raw) {
    switch (raw) {
      case 'sold':
        return MyProductStatus.sold;
      case 'unsold':
        return MyProductStatus.unsold;
      default:
        return null;
    }
  }
}

/// Class used for filtering params from UI to API
class MyProductFilter {
  final String? category;
  final DateTime? date;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final MyProductSortOption? sort;
  final MyProductStatus? status;
  final int page;
  final int limit;

  const MyProductFilter({
    this.category,
    this.date,
    this.dateFrom,
    this.dateTo,
    this.sort,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, String> toQueryParams() {
    return {
      if (category != null) 'category': category!,
      if (date != null) 'date': date!.toIso8601String(),
      if (dateFrom != null) 'dateFrom': dateFrom!.toIso8601String(),
      if (dateTo != null) 'dateTo': dateTo!.toIso8601String(),
      if (sort != null) 'sort': sort!.value,
      if (status != null) 'status': status!.value,
      'page': page.toString(),
      'limit': limit.toString(),
    };
  }
}
