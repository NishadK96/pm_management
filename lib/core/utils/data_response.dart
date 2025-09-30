class DataResponse {
  final String? error;
  final dynamic data;

  bool get hasData => data != null;

  bool get hasError => error != null;

  DataResponse({
    this.error,
    this.data,
  });
}

class DoubleResponse<T, R> {
  DoubleResponse(
    this.data1,
    this.data2,
  );
  final T? data1;
  final R? data2;

  DoubleResponse<T, R> copyWith({
    T? data1,
    R? data2,
  }) {
    return DoubleResponse<T, R>(
      data1 ?? this.data1,
      data2 ?? this.data2,
    );
  }
}

class PaginatedResponse<T> {
  PaginatedResponse(
    this.isSuccess,
    this.data,
    this.nextPageUrl,
    this.count, {
    this.previousUrl,
  });
  final bool? isSuccess;
  final T? data;
  final String? count;
  final String? nextPageUrl;
  final String? previousUrl;
  bool get hasReachedMax => nextPageUrl == null || nextPageUrl == "null";
  String? get nextPage => nextPageUrl != null && nextPageUrl != "null"
      ? nextPageUrl?.split("?")[1]
      : null;

  String? get previousPage => previousUrl != null && previousUrl != "null"
      ? previousUrl!.contains('?')
          ? previousUrl?.split("?")[1]
          : null
      : null;

  PaginatedResponse<T> copyWith({
    bool? isSuccess,
    T? data,
    String? count,
    String? nextPageUrl,
    String? previousPageUrl,
  }) {
    return PaginatedResponse<T>(
      isSuccess ?? this.isSuccess,
      data ?? this.data,
      count ?? this.count,
      nextPageUrl ?? this.nextPageUrl,
      previousUrl: previousUrl ?? this.previousUrl,
    );
  }
}

class PaginatedDoubleDataResponse<T, R> {
  PaginatedDoubleDataResponse(this.data, this.nextPageUrl, this.count,
      {this.previousUrl, this.data2});

  final T? data;
  final R? data2;
  final String? count;
  final String? nextPageUrl;
  final String? previousUrl;
  bool get hasReachedMax => nextPageUrl == null || nextPageUrl == "null";
  String? get nextPage => nextPageUrl != null && nextPageUrl != "null"
      ? nextPageUrl?.split("?")[1]
      : null;

  String? get previousPage => previousUrl != null && previousUrl != "null"
      ? previousUrl!.contains('?')
          ? previousUrl?.split("?")[1]
          : null
      : null;

  PaginatedDoubleDataResponse<T, R> copyWith({
    T? data,
    R? data2,
    String? count,
    String? nextPageUrl,
    String? previousPageUrl,
  }) {
    return PaginatedDoubleDataResponse<T, R>(
        data ?? this.data, count ?? this.count, nextPageUrl ?? this.nextPageUrl,
        previousUrl: previousUrl ?? this.previousUrl,
        data2: data2 ?? this.data2);
  }
}

class PaginatedTripleDataResponse<T, R, S> {
  PaginatedTripleDataResponse(this.data, this.nextPageUrl, this.count,
      {this.previousUrl, this.data2, this.data3});

  final T? data;
  final R? data2;
  final S? data3;
  final String? count;
  final String? nextPageUrl;
  final String? previousUrl;
  bool get hasReachedMax => nextPageUrl == null || nextPageUrl == "null";
  String? get nextPage => nextPageUrl != null && nextPageUrl != "null"
      ? nextPageUrl?.split("?")[1]
      : null;

  String? get previousPage => previousUrl != null && previousUrl != "null"
      ? previousUrl!.contains('?')
          ? previousUrl?.split("?")[1]
          : null
      : null;

  PaginatedTripleDataResponse<T, R, S> copyWith({
    T? data,
    R? data2,
    S? data3,
    String? count,
    String? nextPageUrl,
    String? previousPageUrl,
  }) {
    return PaginatedTripleDataResponse<T, R, S>(
        data ?? this.data, count ?? this.count, nextPageUrl ?? this.nextPageUrl,
        previousUrl: previousUrl ?? this.previousUrl,
        data3: data3 ?? this.data3,
        data2: data2 ?? this.data2);
  }
}
