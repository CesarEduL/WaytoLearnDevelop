import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _googleInitialized = false;

  // Getters públicos
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Setters públicos opcionales
  set currentUser(UserModel? user) => _currentUser = user;
  set isLoading(bool loading) => _isLoading = loading;
  set errorMessage(String? error) => _errorMessage = error;

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
      debugPrint('UserService: Starting Google Sign-In...');

      if (!_googleInitialized) {
        try {
          final clientId = dotenv.env['FIREBASE_WEB_CLIENT_ID'];
          debugPrint('UserService: Initializing GoogleSignIn with clientId: ${clientId != null ? "FOUND" : "MISSING"}');

          if (clientId != null && clientId.isNotEmpty) {
            await GoogleSignIn.instance.initialize(
              serverClientId: clientId,
            );
          } else {
            await GoogleSignIn.instance.initialize();
          }
          _googleInitialized = true;
          debugPrint('UserService: GoogleSignIn initialized successfully');
        } catch (e) {
          debugPrint('UserService: Warning - GoogleSignIn initialization failed: $e');
        }
      }

      GoogleSignInAccount? googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate();
        debugPrint('UserService: Google authentication completed. User: ${googleUser?.email}');
      } on GoogleSignInException catch (e) {
        debugPrint('UserService: GoogleSignInException: ${e.code} - $e');
        if (e.code == GoogleSignInExceptionCode.canceled ||
            e.code == GoogleSignInExceptionCode.interrupted ||
            e.code == GoogleSignInExceptionCode.uiUnavailable) {
          _setError('Inicio de sesión cancelado por el usuario');
          return false;
        }
        rethrow;
      } catch (e) {
        debugPrint('UserService: Unknown error during authenticate: $e');
        rethrow;
      }

      if (googleUser == null) {
        _setError('No se pudo obtener la cuenta de Google');
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        _setError('No se obtuvieron credenciales de Google (idToken nulo)');
        return false;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      debugPrint('UserService: Signing in to Firebase with credential...');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        debugPrint('UserService: Firebase sign in successful. User UID: ${user.uid}');
        await _handleUserSignIn(user);
        return true;
      } else {
        _setError('Error al crear la cuenta de usuario en Firebase');
        return false;
      }
    } catch (e) {
      debugPrint('UserService: Critical error in signInWithGoogle: $e');
      _setError('Error durante el inicio de sesión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInAsGuest() async {
    try {
      _setLoading(true);
      _clearError();
      debugPrint('UserService: Starting Guest Sign-In...');

      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;

      if (user != null) {
        debugPrint('UserService: Guest sign in successful. User UID: ${user.uid}');
        await _handleUserSignIn(user);
        return true;
      } else {
        _setError('Error al iniciar sesión como invitado (User es null)');
        return false;
      }
    } catch (e) {
      debugPrint('UserService: Error in signInAsGuest: $e');
      if (e is FirebaseAuthException) {
         _setError('Error de Firebase: [${e.code}] ${e.message}');
      } else {
         _setError('Error al ingresar como invitado: $e');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleUserSignIn(User user) async {
    try {
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        await _loadUserData(user.uid);
        await _updateLastLogin(user.uid);
      } else {
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
        age: 0,
        grade: 'Primer grado',
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
      
      // Inicializar sesiones para el nuevo usuario
      // Nota: SessionService se inicializará desde el login
      debugPrint('User profile created successfully for ${user.uid}');
      
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
      debugPrint('Error al actualizar último login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.signOut();
      try { await GoogleSignIn.instance.signOut(); } catch (_) {}

      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    } finally {
      _setLoading(false);
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

  Future<void> unlockNextStory(String subject, int currentStoryIndex) async {
    if (_currentUser != null) {
      try {
        final Map<String, dynamic> currentProgress = Map.from(_currentUser!.progress);
        final Map<String, dynamic> subjectProgress = 
            Map.from(currentProgress[subject] ?? {'highestUnlockedIndex': 0, 'completedStories': []});
        
        int highestUnlocked = subjectProgress['highestUnlockedIndex'] ?? 0;
        List<String> completedStories = List<String>.from(subjectProgress['completedStories'] ?? []);

        // Marcar actual como completada
        final String storyId = 'STORY_$currentStoryIndex';
        if (!completedStories.contains(storyId)) {
          completedStories.add(storyId);
        }

        // Desbloquear siguiente si es el actual el más alto
        if (currentStoryIndex >= highestUnlocked) {
          highestUnlocked = currentStoryIndex + 1;
        }

        subjectProgress['highestUnlockedIndex'] = highestUnlocked;
        subjectProgress['completedStories'] = completedStories;
        currentProgress[subject] = subjectProgress;

        final UserModel updatedUser = _currentUser!.copyWith(
          progress: currentProgress,
        );

        await updateUserProfile(updatedUser);
      } catch (e) {
        _setError('Error al desbloquear siguiente nivel: $e');
      }
    }
  }
}
