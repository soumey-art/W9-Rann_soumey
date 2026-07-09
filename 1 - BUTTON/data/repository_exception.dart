/// Thrown by repositories whenever a call to Firebase fails:
/// - no internet connection
/// - unexpected / missing data structure
/// - non-200 status code
class RepositoryException implements Exception {
  final String message;

  const RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
