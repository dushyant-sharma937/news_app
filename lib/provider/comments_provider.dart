import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _comments = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  CommentsProvider() {
    _fetchComments();
  }

  List<Map<String, dynamic>> get comments => _comments;

  Future<void> _fetchComments() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;

    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/comments?_page=$_currentPage&_limit=10'));
    if (response.statusCode == 200) {
      final List<dynamic> fetchedComments = json.decode(response.body);
      if (fetchedComments.isEmpty) {
        _hasMore = false;
      } else {
        _comments.addAll(fetchedComments
            .map((comment) => comment as Map<String, dynamic>)
            .toList());
        _currentPage++;
      }
    } else {
      debugPrint('Failed to fetch comments: ${response.statusCode}');
    }

    _isLoading = false;
    notifyListeners();
  }

  bool shouldLoadMore(int index) {
    if (!_isLoading && _hasMore && index >= _comments.length - 1) {
      _fetchComments();
      return true;
    }
    return false;
  }

  String maskEmail(String email) {
    if (email.contains('@')) {
      final parts = email.split('@');
      if (parts[0].length > 3) {
        final maskedName =
            parts[0].substring(0, 3) + '*' * (parts[0].length - 3);
        return '$maskedName@${parts[1]}';
      } else {
        return email;
      }
    } else {
      return email;
    }
  }
}
