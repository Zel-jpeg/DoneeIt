import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Onboarding screen showcasing to-do list feature
/// Displays example todo items with different statuses
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightPink.withValues(alpha: 0.3),
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
                  const Text(
                    'Intuitive',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'To-do List ',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('✏️', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomPaint(
                    size: const Size(280, 20),
                    painter: UnderlinePainter(),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Filter dropdown
              Row(
                children: [
                  const Text(
                    'To-do',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontStyle: FontStyle.italic,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPink,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.black, width: 2),
                    ),
                    child: Row(
                      children: const [
                        Text('Missed'),
                        SizedBox(width: 8),
                        Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Todo items
              _buildTodoItem(
                icon: '📚',
                title: 'Read Chapter 5',
                course: 'Philosophy',
                time: 'Wednesday 11:59 PM',
                status: 'Ongoing',
              ),
              
              const SizedBox(height: 16),
              
              _buildTodoItem(
                icon: '💻',
                title: 'Final Presentation',
                course: 'Philosophy',
                time: 'Thursday 11:59 PM',
                status: 'Completed',
              ),
              
              const SizedBox(height: 16),
              
              _buildTodoItem(
                icon: '🔬',
                title: 'Laboratory Report',
                course: 'Biology',
                time: 'Friday 11:59 PM',
                status: 'Ongoing',
              ),
              
              const Spacer(),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Stay organized and meet deadlines effortlessly with DoneeIt\'s intuitive to-do list feature, ensuring you stay on course and accomplish your goals with ease.',
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

  Widget _buildTodoItem({
    required String icon,
    required String title,
    required String course,
    required String time,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.black, width: 2),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$course | $time',
                  style: TextStyle(
                    fontSize: 12,
                    color: status == 'Completed' ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: status == 'Completed',
            onChanged: (val) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
// ... your HomeScreen and HomeContent classes

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