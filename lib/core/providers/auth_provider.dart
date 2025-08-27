import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['FIREBASE_WEB_CLIENT_ID'],
  );
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

      // Iniciar el flujo de Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      // Obtener las credenciales de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Verificar si es un usuario nuevo
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        
        if (isNewUser) {
          // Crear perfil de usuario para niños
          await _createChildProfile(user, googleUser);
        } else {
          // Actualizar último login
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

  Future<void> _createChildProfile(User user, GoogleSignInAccount googleUser) async {
    try {
      // Crear perfil básico para niños
      final userModel = UserModel(
        id: user.uid,
        name: googleUser.displayName ?? 'Niño',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        age: 8, // Edad por defecto, se puede cambiar después
        grade: '2do Grado', // Grado por defecto
        avatar: 'default_avatar',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Guardar en Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      _userModel = userModel;
      notifyListeners();
    } catch (e) {
      _setError('Error al crear perfil: $e');
    }
  }

  Future<void> _updateLastLogin(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      // Error no crítico, solo logging
      print('Error al actualizar último login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
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

      await _firestore
          .collection('users')
          .doc(_userModel!.id)
          .update(updates);

      // Actualizar modelo local
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
