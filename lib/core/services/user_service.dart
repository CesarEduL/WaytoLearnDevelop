import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['FIREBASE_WEB_CLIENT_ID'],
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _auth.currentUser != null;
  User? get firebaseUser => _auth.currentUser;

  UserService() {
    _initializeAuthStateListener();
  }

  void _initializeAuthStateListener() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setError('Inicio de sesión cancelado');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _handleUserSignIn(user);
        return true;
      } else {
        _setError('Error al crear la cuenta de usuario');
        return false;
      }
    } catch (e) {
      _setError('Error durante el inicio de sesión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleUserSignIn(User user) async {
    try {
      // Verificar si el usuario ya existe en Firestore
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Usuario existente - cargar datos
        await _loadUserData(user.uid);
        await _updateLastLogin(user.uid);
      } else {
        // Usuario nuevo - crear perfil
        await _createUserProfile(user);
      }
    } catch (e) {
      _setError('Error al manejar el inicio de sesión: $e');
    }
  }

  Future<void> _createUserProfile(User user) async {
    try {
      final UserModel newUser = UserModel(
        id: user.uid,
        name: user.displayName ?? 'Usuario',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        age: 0, // Valor por defecto
        grade: 'Primer grado', // Valor por defecto
        avatar: 'default_avatar',
        totalPoints: 0,
        currentLevel: 1,
        experiencePoints: 0,
        subjectLevels: const {'mathematics': 1, 'communication': 1},
        achievements: const [],
        unlockedAvatars: const ['default_avatar'],
        progress: const {},
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUser.toMap());

      _currentUser = newUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al crear el perfil del usuario: $e');
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _currentUser = UserModel.fromMap(userData, userId);
        notifyListeners();
      }
    } catch (e) {
      _setError('Error al cargar datos del usuario: $e');
    }
  }

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
        'lastLoginAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      // No es crítico si falla la actualización del último login
      debugPrint('Error al actualizar último login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      _setLoading(true);
      _clearError();

      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toMap());

      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar el perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPoints(int points) async {
    if (_currentUser != null) {
      try {
        final UserModel updatedUser = _currentUser!.addExperience(points);
        await updateUserProfile(updatedUser);
      } catch (e) {
        _setError('Error al agregar puntos: $e');
      }
    }
  }

  Future<void> addAchievement(String achievement) async {
    if (_currentUser != null && !_currentUser!.achievements.contains(achievement)) {
      try {
        final List<String> newAchievements = [..._currentUser!.achievements, achievement];
        final UserModel updatedUser = _currentUser!.copyWith(
          achievements: newAchievements,
        );

        await updateUserProfile(updatedUser);
      } catch (e) {
        _setError('Error al agregar logro: $e');
      }
    }
  }

  Future<void> addSubject(String subject) async {
    if (_currentUser != null && !_currentUser!.subjectLevels.containsKey(subject)) {
      try {
        final Map<String, int> newSubjectLevels = Map.from(_currentUser!.subjectLevels);
        newSubjectLevels[subject] = 1;
        
        final UserModel updatedUser = _currentUser!.copyWith(
          subjectLevels: newSubjectLevels,
        );

        await updateUserProfile(updatedUser);
      } catch (e) {
        _setError('Error al agregar materia: $e');
      }
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

  void clearError() {
    _clearError();
  }
}
