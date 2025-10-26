import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/services/user_service.dart';
import 'core/providers/game_provider.dart';
import 'core/services/story_service.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/story_exercise_provider.dart';
import 'core/providers/math_exercise_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'core/theme/app_theme.dart';





import 'presentation/screens/communication/session_progress_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const WaytoLearnApp());
}

class WaytoLearnApp extends StatelessWidget {
  const WaytoLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => StoryService()),
        ChangeNotifierProvider(create: (_) => StoryExerciseProvider()),
        ChangeNotifierProvider(create: (_) => MathExerciseProvider()),

      ],
      
      child: MaterialApp(
        title: 'WaytoLearn',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
