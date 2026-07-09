import 'dart:convert';
import 'package:http/http.dart' as http;

import 'repository_exception.dart';
import '../model/button_status.dart';

/// Repository responsible for talking to Firebase for the "button status"
/// node. Uses the Firebase Realtime Database REST API:
/// https://firebase.google.com/docs/reference/rest/database
class ButtonStatusRepository {

  static const String _baseUrl = 'https://w9-ex1-5ee69-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String _node = 'buttonStatus';

  /// 1- Fetch the data from firebase (Map<String, dynamic>)
  /// 2- Create a ButtonStatus to handle the data and return it
  /// 3- Handle possible errors (no connection, bad data...)
  Future<ButtonStatus> getButtonStatus() async {
    final uri = Uri.parse('$_baseUrl/$_node.json');

    late final http.Response response;
    try {
      response = await http.get(uri);
    } catch (_) {
      // Typically thrown when there is no wifi / no connection at all.
      throw const RepositoryException(
        'No internet connection. Please check your network and try again.',
      );
    }

    if (response.statusCode != 200) {
      throw RepositoryException(
        'Firebase returned an error (status code ${response.statusCode})',
      );
    }

    if (response.body == 'null') {
      throw const RepositoryException(
        'No button data found in Firebase. Create the "buttonStatus" node first.',
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ButtonStatus.fromJson(json);
    } on RepositoryException {
      rethrow;
    } catch (_) {
      // Any parsing / cast error -> the Firebase structure was unexpected.
      throw const RepositoryException(
        'The data received from Firebase does not match the expected structure.',
      );
    }
  }

  /// Updates only the `selected` field in Firebase using PATCH, so the
  /// rest of the node (title) is left untouched.
  Future<void> updateSelected(bool selected) async {
    final uri = Uri.parse('$_baseUrl/$_node.json');

    late final http.Response response;
    try {
      response = await http.patch(
        uri,
        body: jsonEncode({'selected': selected}),
      );
    } catch (_) {
      throw const RepositoryException(
        'No internet connection. Please check your network and try again.',
      );
    }

    if (response.statusCode != 200) {
      throw RepositoryException(
        'Failed to update the button status (status code ${response.statusCode})',
      );
    }
  }
}
