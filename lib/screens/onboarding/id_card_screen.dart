import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Onboarding screen showcasing personalized ID card feature
/// Displays example ID card with sample data
class IDCardScreen extends StatelessWidget {
  const IDCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightBlue.withValues(alpha: 0.3),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Title with underline
              Column(
                children: [
                  const Text(
                    'Personalized',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'ID Card',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomPaint(
                    size: const Size(250, 20),
                    painter: UnderlinePainter(),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // ID Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.lightPink,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.black, width: 3),
                ),
                child: Row(
                  children: [
                    // Photo placeholder
                    Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: const Icon(Icons.person, size: 60),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NAME',
                            style: TextStyle(fontSize: 10, color: AppTheme.labelGrey),
                          ),
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'SCHOOL',
                            style: TextStyle(fontSize: 10, color: AppTheme.labelGrey),
                          ),
                          const Text(
                            'Davao del Norte State College',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BIRTHDAY',
                                    style: TextStyle(fontSize: 10, color: AppTheme.labelGrey),
                                  ),
                                  Text(
                                    '06-04-2003',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YEAR LEVEL',
                                    style: TextStyle(fontSize: 10, color: AppTheme.labelGrey),
                                  ),
                                  Text(
                                    '3RD YEAR',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Be part of the organized club and create a personalized ID card that resonates your academic journey!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

class UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height / 2,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}