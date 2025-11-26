import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/session_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/models/session_model.dart';
import '../../../core/theme/child_colors.dart';
import '../../../core/theme/child_text_styles.dart';
import '../../../core/widgets/modern_child_card.dart';
import 'progress_map_screen.dart';

/// Pantalla de selección de sesiones para Comunicación
class CommunicationSessionsScreen extends StatefulWidget {
  const CommunicationSessionsScreen({super.key});

  @override
  State<CommunicationSessionsScreen> createState() => _CommunicationSessionsScreenState();
}

class _CommunicationSessionsScreenState extends State<CommunicationSessionsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSessions();
  }

  Future<void> _initializeSessions() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);
    final userId = userService.currentUser?.id;
    
    if (userId != null) {
      await sessionService.initializeUserSessions(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final sessionService = Provider.of<SessionService>(context);
    final userId = userService.currentUser?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    return Scaffold(
      backgroundColor: ChildColors.background,
      appBar: AppBar(
        title: const Text('Comunicación', style: ChildTextStyles.subtitleWhite),
        backgroundColor: ChildColors.blueSky,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<SessionModel>>(
        future: sessionService.getSessions(userId, 'communication'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ChildColors.blueSky,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: ChildColors.pinkSweet),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', style: ChildTextStyles.body),
                ],
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No hay sesiones disponibles', style: ChildTextStyles.body),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _buildSessionCard(session, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(SessionModel session, int index) {
    final isLocked = !session.unlocked;
    final gradient = ChildColors.getSessionGradient(index);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ModernChildCard(
        onTap: isLocked ? () => _showLockedDialog() : () => _navigateToSession(session),
        gradient: isLocked ? null : gradient,
        color: isLocked ? ChildColors.locked : null,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Número de sesión
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${session.order}',
                      style: ChildTextStyles.bigNumber.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Título y progreso
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: ChildTextStyles.subtitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: Colors.white.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.completedStories}/${session.totalStories} cuentos',
                            style: ChildTextStyles.body.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icono de estado
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isLocked
                        ? Icons.lock
                        : session.completed
                            ? Icons.check_circle
                            : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso',
                      style: ChildTextStyles.body.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${session.progress.toStringAsFixed(0)}%',
                      style: ChildTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: session.progress / 100,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
            
            // Mensaje de estado
            if (isLocked) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Completa la sesión anterior',
                      style: ChildTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock, color: ChildColors.yellowSun),
            const SizedBox(width: 12),
            const Text('Sesión Bloqueada'),
          ],
        ),
        content: const Text(
          '¡Primero debes completar la sesión anterior para desbloquear esta!',
          style: ChildTextStyles.body,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ChildColors.blueSky,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _navigateToSession(SessionModel session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgressMapScreen(sessionNumber: session.order),
      ),
    );
  }
}
