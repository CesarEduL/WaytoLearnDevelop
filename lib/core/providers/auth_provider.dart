import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      _loadUserData(user.uid);
    } else {
      _userModel = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data()!, uid);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar datos del usuario: $e';
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      await GoogleSignIn.instance.initialize(
        serverClientId: dotenv.env['FIREBASE_WEB_CLIENT_ID'],
      );

      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          await _createChildProfile(user, googleUser);
        } else {
          await _updateLastLogin(user.uid);
        }

        _setLoading(false);
        return true;
      } else {
        _setError('Error al iniciar sesión con Google');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error durante el inicio de sesión: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInAsGuest() async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          final guestProfile = UserModel(
            id: user.uid,
            name: 'Invitado',
            email: 'guest@waytolearn.com',
            age: 0,
            grade: 'N/A',
            avatar: 'default_avatar',
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
            isGuest: true,
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(guestProfile.toMap());
          _userModel = guestProfile;
        } else {
          _userModel = UserModel.fromMap(userDoc.data()!, user.uid);
        }
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Error al ingresar como invitado: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<void> _createChildProfile(
      User user, GoogleSignInAccount googleUser) async {
    try {
      final userModel = UserModel(
        id: user.uid,
        name: googleUser.displayName ?? 'Niño',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        age: 8,
        grade: '2do Grado',
        avatar: 'default_avatar',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        isGuest: false,
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      _userModel = userModel;
      notifyListeners();
    } catch (e) {
      _setError('Error al crear perfil: $e');
    }
  }

  Future<void> _updateLastLogin(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error al actualizar último login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _auth.signOut();
      _userModel = null;
      _setLoading(false);
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile({
    String? name,
    int? age,
    String? grade,
    String? avatar,
  }) async {
    if (_userModel == null) return;

    try {
      _setLoading(true);
      _clearError();

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (age != null) updates['age'] = age;
      if (grade != null) updates['grade'] = grade;
      if (avatar != null) updates['avatar'] = avatar;

      await _firestore.collection('users').doc(_userModel!.id).update(updates);

      _userModel = _userModel!.copyWith(
        name: name ?? _userModel!.name,
        age: age ?? _userModel!.age,
        grade: grade ?? _userModel!.grade,
        avatar: avatar ?? _userModel!.avatar,
      );

      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar perfil: $e');
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _auth.authStateChanges().listen(null);
    super.dispose();
  }
}
