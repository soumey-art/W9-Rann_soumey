
/// Used across the app so every screen handles async calls the same way.
class AsyncData<T> {
  final T? data;
  final String? errorMessage;
  final bool isLoading;

  const AsyncData._({this.data, this.errorMessage, this.isLoading = false});

  factory AsyncData.idle() => const AsyncData._();

  factory AsyncData.loading() => const AsyncData._(isLoading: true);

  factory AsyncData.success(T data) => AsyncData._(data: data);

  factory AsyncData.error(String message) => AsyncData._(errorMessage: message);

  bool get hasError => errorMessage != null;
  bool get hasData => data != null;
}
