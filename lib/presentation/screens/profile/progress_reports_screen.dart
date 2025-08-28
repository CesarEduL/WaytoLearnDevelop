import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressReportsScreen extends StatelessWidget {
  const ProgressReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informes de progreso'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _upgradeBanner(context),
          const SizedBox(height: 12),
          _mostPlayedSubjectsCard(context),
          const SizedBox(height: 12),
          _topSkillsCard(context),
          const SizedBox(height: 24),
          _helpCard(context),
        ],
      ),
    );
  }

  Widget _upgradeBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.secondaryColor),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Dale a tu hijo/a la experiencia completa. ¡Hazte Plus!'),
          ),
          TextButton(onPressed: () {}, child: const Text('Ver planes')),
        ],
      ),
    );
  }

  Widget _mostPlayedSubjectsCard(BuildContext context) {
    Widget row(Color dot, String label) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, borderRadius: BorderRadius.circular(5))),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text('- Activities', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textLight)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Most Played Subjects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFFF7E6), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                row(const Color(0xFFFACC15), 'Subject'),
                row(const Color(0xFF22D3EE), 'Subject'),
                row(const Color(0xFFEF4444), 'Subject'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _topSkillsCard(BuildContext context) {
    Widget tile(int number) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Text('$number', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppTheme.textSecondary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Skill', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Achieved by playing', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: Text('Game:', style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(children: [tile(1), const SizedBox(width: 12), tile(2), const SizedBox(width: 12), tile(3)]),
      ],
    );
  }

  Widget _helpCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: const [
          Icon(Icons.help_outline, size: 40, color: AppTheme.primaryColor),
          SizedBox(height: 8),
          Text("We're here to help"),
        ],
      ),
    );
  }
}


