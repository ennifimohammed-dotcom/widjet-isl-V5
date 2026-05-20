import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../theme/app_theme.dart';

class TasbihScreen extends StatefulWidget {
  final int targetCount;
  final String? dhikrName;

  const TasbihScreen({
    super.key,
    this.targetCount = 33,
    this.dhikrName,
  });

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _totalCount = 0;
  late int _target;
  bool _isComplete = false;
  List<int> _rounds = [];
  int _currentRound = 1;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _target = widget.targetCount;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _increment() {
    if (_isComplete) return;

    HapticFeedback.selectionClick();
    setState(() {
      _count++;
      _totalCount++;

      if (_count >= _target) {
        _rounds.add(_count);
        _count = 0;
        _currentRound++;

        if (_currentRound > 3 && widget.targetCount == 33) {
          // Mode Subhanallah/Alhamdulillah/Allahu Akbar complet
          _isComplete = true;
          _showCompletionDialog();
        } else {
          _pulseController.forward().then((_) => _pulseController.reverse());
        }
      } else {
        _pulseController.forward().then((_) => _pulseController.reverse());
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _totalCount = 0;
      _rounds = [];
      _currentRound = 1;
      _isComplete = false;
    });
  }

  void _undoLast() {
    if (_totalCount <= 0) return;
    setState(() {
      if (_count > 0) {
        _count--;
        _totalCount--;
      } else if (_rounds.isNotEmpty) {
        _count = _rounds.removeLast() - 1;
        _totalCount--;
        _currentRound--;
        _isComplete = false;
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 60),
            const SizedBox(height: 16),
            const Text(
              '🤲 Allahu Akbar !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.dhikrName != null
                  ? 'Vous avez complété ${widget.dhikrName}!'
                  : 'Tasbih complété avec succès !',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: $_totalCount invocations',
              style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Recommencer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _count / _target;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dhikrName ?? '📿 Tasbih Numérique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showTargetPicker,
            tooltip: 'Changer le nombre',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 📊 Stats
            _buildStats(),
            const SizedBox(height: 20),
            // 💧 Indicateur de progression
            _buildProgressIndicator(progress),
            const SizedBox(height: 30),
            // 🔴 Bouton principal
            _buildMainButton(),
            const SizedBox(height: 20),
            // 🎛️ Contrôles
            _buildControls(),
            const Spacer(),
            // 📋 Rounds
            if (_rounds.isNotEmpty) _buildRoundsList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Tour', '$_currentRound/3'),
          _buildStatItem('Actuel', '$_count'),
          _buildStatItem('Cible', '$_target'),
          _buildStatItem('Total', '$_totalCount'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
      ],
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        height: 180,
        child: LiquidCircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          borderColor: AppTheme.primaryGreen.withOpacity(0.3),
          borderWidth: 2,
          direction: Axis.vertical,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_count',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              Text(
                '/ $_target',
                style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnim.value,
          child: GestureDetector(
            onTap: _increment,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _isComplete
                    ? const LinearGradient(
                        colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                      )
                    : const LinearGradient(
                        colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
                      ),
                boxShadow: [
                  BoxShadow(
                    color: (_isComplete ? AppTheme.accentGold : AppTheme.primaryGreen)
                        .withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _isComplete
                    ? const Icon(Icons.check, color: Colors.white, size: 50)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app, color: Colors.white, size: 36),
                          const SizedBox(height: 4),
                          Text(
                            'Appuyez',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Annuler
        IconButton(
          icon: const Icon(Icons.undo, size: 28),
          onPressed: _undoLast,
          tooltip: 'Annuler le dernier',
          color: AppTheme.textLight,
        ),
        const SizedBox(width: 20),
        // Réinitialiser
        IconButton(
          icon: const Icon(Icons.refresh, size: 28),
          onPressed: _reset,
          tooltip: 'Réinitialiser',
          color: AppTheme.errorRed,
        ),
      ],
    );
  }

  Widget _buildRoundsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 16, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            ...List.generate(_rounds.length, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tour ${i + 1}: ${_rounds[i]}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.primaryGreen),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showTargetPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final targets = [33, 34, 100, 1000];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choisir le nombre cible',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: targets.map((t) => ChoiceChip(
                  label: Text('$t'),
                  selected: _target == t,
                  selectedColor: AppTheme.primaryGreen,
                  labelStyle: TextStyle(
                    color: _target == t ? Colors.white : AppTheme.textDark,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _target = t;
                      _count = 0;
                    });
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
