import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget de chargement avec motif islamique
class IslamicLoader extends StatelessWidget {
  final String message;
  final double size;

  const IslamicLoader({
    super.key,
    this.message = 'Chargement...',
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
