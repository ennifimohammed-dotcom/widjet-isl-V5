import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double? _qiblaDirection;

  // Qibla direction from Paris = ~119° (varies by location)
  // Calculated via adhan_dart Qibla class
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _calculateQibla();
  }

  void _calculateQibla() {
    final provider = context.read<PrayerProvider>();
    final lat = provider.latitude;
    final lng = provider.longitude;

    if (lat != null && lng != null) {
      _qiblaDirection = _getQiblaDirection(lat, lng);
    } else {
      // Default: Paris
      _qiblaDirection = _getQiblaDirection(48.8566, 2.3522);
    }
  }

  /// Calculate Qibla direction using spherical trigonometry
  double _getQiblaDirection(double lat, double lng) {
    final latRad = lat * pi / 180;
    final lngRad = lng * pi / 180;
    final kaabaLatRad = _kaabaLat * pi / 180;
    final kaabaLngRad = _kaabaLng * pi / 180;

    final deltaLng = kaabaLngRad - lngRad;
    final y = sin(deltaLng);
    final x = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLng);
    var qibla = atan2(y, x) * 180 / pi;
    if (qibla < 0) qibla += 360;
    return qibla;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🕋 Direction Qibla'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showQiblaInfo(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF0D3B0F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Dirigez-vous vers la Qibla',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Al-Masjid Al-Haram • Makkah',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              _buildQiblaCompass(),
              const Spacer(),
              _buildLocationInfo(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQiblaCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorCompass();
        }

        double northAngle = 0;
        if (snapshot.hasData && snapshot.data!.heading != null) {
          northAngle = snapshot.data!.heading!;
        }

        // Calculer l'angle de rotation pour pointer vers la Qibla
        final qiblaAngle = _qiblaDirection ?? 119.0;
        final rotationAngle = (qiblaAngle - northAngle);

        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cercle externe
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                    // Graduations
                    ...List.generate(72, (i) {
                      final angle = i * 5 * pi / 180;
                      final isMajor = i % 18 == 0;
                      return Transform.rotate(
                        angle: angle,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 14),
                            width: isMajor ? 3 : 1,
                            height: isMajor ? 14 : 8,
                            color: isMajor
                                ? const Color(0xFFFFB300)
                                : Colors.white.withOpacity(0.4),
                          ),
                        ),
                      );
                    }),
                    // Aiguille Qibla (tourne selon le Nord magnétique)
                    Transform.rotate(
                      angle: rotationAngle * pi / 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mosque,
                            color: Color(0xFFFFB300),
                            size: 40,
                          ),
                          Container(
                            width: 4,
                            height: 60,
                            color: const Color(0xFFFFB300),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFB300),
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 60,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Centre
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    // NORD
                    const Positioned(
                      top: 22,
                      child: Text(
                        'N',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorCompass() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sensors_off, color: Colors.white70, size: 40),
              SizedBox(height: 10),
              Text(
                'Boussole non disponible\nVeuillez vérifier les capteurs',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    final prayerProvider = context.watch<PrayerProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFFFB300), size: 18),
          const SizedBox(width: 8),
          Text(
            prayerProvider.city,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, color: Color(0xFFFFB300), size: 18),
          const SizedBox(width: 8),
          const Text(
            'Makkah 🕋',
            style: TextStyle(
              color: Color(0xFFFFB300),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showQiblaInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.explore, color: AppTheme.primaryGreen),
            SizedBox(width: 10),
            Text('Direction Qibla'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'La Qibla est la direction vers laquelle les musulmans se '
              'tournent pour prier, c\'est-à-dire vers la Kaaba à La Mecque.',
            ),
            SizedBox(height: 12),
            Text(
              '🧭 Pour une précision optimale :\n'
              '• Éloignez-vous des sources magnétiques\n'
              '• Maintenez le téléphone à plat\n'
              '• Calibrez la boussole si nécessaire\n'
              '• Activez la localisation GPS',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }
}
