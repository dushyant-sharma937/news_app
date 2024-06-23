import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _comments = [];
  int _currentPage = 1;
  bool _hasMore = true;
  String? _error;

  bool _isLoading2 = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  CommentsProvider() {
    _fetchComments();
  }

  List<Map<String, dynamic>> get comments => _comments;

  Future<bool> _fetchComments() async {
    if (_isLoading2 || !_hasMore) return true;
    _isLoading2 = true;
    setLoading(true);
    try {
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
        _error = null;
        setLoading(false);
        _isLoading2 = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to fetch comments: ${response.statusCode}';
        setLoading(false);
        _isLoading2 = false;
        debugPrint('Failed to fetch comments: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _error = e.toString();
      setLoading(false);
      _isLoading2 = false;
      debugPrint(e.toString());
      return false;
    }
  }

  bool shouldLoadMore(int index) {
    if (!_isLoading2 && _hasMore && index >= _comments.length - 1) {
      _fetchComments();
      return true;
    }
    return false;
  }

  void retryFetchingComments() {
    _error = null;
    _currentPage = 1;
    _comments.clear();
    _hasMore = true;
    _fetchComments();
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
