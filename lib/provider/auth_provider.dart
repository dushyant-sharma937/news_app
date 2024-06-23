import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  String _username = '';

  String get username => _username;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      setLoading(true);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });
      }
      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setError(e.code.toString().toUpperCase());
      if (e.code == 'weak-password') {
        setError('The password provided is too weak.');
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setError('The account already exists for that email.');
        debugPrint('The account already exists for that email.');
      }
      setLoading(false);
      return false;
    } catch (e) {
      setLoading(false);
      return false;
    }
  }

  Future<bool> signin(String email, String password) async {
    try {
      setLoading(true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        String userName = userDoc['name'];
        _username = userName;
      }
      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setError(e.code.toString().toUpperCase());
      if (e.code == 'user-not-found') {
        setError('No user found for that email.');
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setError('Wrong password provided for that user.');
        debugPrint('Wrong password provided for that user.');
      }
      setLoading(false);
      return false;
    } catch (e) {
      print(e.toString());
      setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
