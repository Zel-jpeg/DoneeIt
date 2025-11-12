import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Onboarding screen showcasing course folders feature
/// Displays example course folders in a grid layout
class CourseFoldersScreen extends StatelessWidget {
  const CourseFoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.yellow.withValues(alpha: 0.3),
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
              
              // Title
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Organize with',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Course Folders ',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('📁', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomPaint(
                    size: const Size(280, 20),
                    painter: UnderlinePainter(),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // Folders Grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.2,
                children: [
                  _buildFolder('Networking', AppTheme.lightBlue),
                  _buildFolder('Programming', AppTheme.lavender),
                  _buildFolder('Math', AppTheme.lightPink),
                  _buildFolder('P.E.', AppTheme.yellow),
                ],
              ),
              
              const Spacer(),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Effortlessly manage and access course-related files with DoneeIt\'s dedicated course files feature.',
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

  Widget _buildFolder(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.black, width: 2),
      ),
      child: Stack(
        children: [
          // Folder tab
          Positioned(
            left: 16,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: const Border(
                  left: BorderSide(color: AppTheme.black, width: 2),
                  right: BorderSide(color: AppTheme.black, width: 2),
                  bottom: BorderSide(color: AppTheme.black, width: 2),
                ),
              ),
            ),
          ),
          
          // Label
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.black, width: 2),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add at the end of the file
class UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}