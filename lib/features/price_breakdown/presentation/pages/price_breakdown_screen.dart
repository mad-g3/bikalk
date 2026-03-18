import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class PriceBreakdownScreen extends StatefulWidget {
  const PriceBreakdownScreen({super.key});

  @override
  State<PriceBreakdownScreen> createState() => _PriceBreakdownScreenState();
}

class _PriceBreakdownScreenState extends State<PriceBreakdownScreen> {
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.ctaFill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 18, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Breakdown',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Card container
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Scrollable body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Map
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: CustomPaint(
                                  painter: _MapPainter(),
                                  child: Container(color: const Color(0xFFD6E4C7)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Price
                            const Text(
                              '3000 Rwf',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Details rows
                            _buildDetailRow('from', 'Kimironko', 'to', 'Remera'),
                            const SizedBox(height: 14),
                            _buildDetailRow(
                              'distance',
                              '12 km',
                              'fuel per km',
                              '0.25L',
                            ),
                            const SizedBox(height: 14),
                            _buildDetailRow('min price', '2500', 'max price', '3000'),
                          ],
                        ),
                      ),
                    ),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        children: [
                          // All Good button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _showToast('✓ Confirmed!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.ctaFill,
                                foregroundColor: AppColors.ctaText,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'All Good',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Report a Problem button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/privacy'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                backgroundColor: AppColors.secondaryFill,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Report a Problem',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String leftLabel,
    String leftValue,
    String rightLabel,
    String rightValue,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftLabel,
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
            const SizedBox(height: 2),
            Text(
              leftValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightLabel,
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
            const SizedBox(height: 2),
            Text(
              rightValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFD6E4C7),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFC0D4A8)
      ..strokeWidth = 1;

    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(0, 30 + i * 32.0),
        Offset(size.width, 30 + i * 32.0),
        gridPaint,
      );
    }
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(30 + i * 36.0, 0),
        Offset(30 + i * 36.0, size.height),
        gridPaint,
      );
    }

    final roadPaint = Paint()
      ..color = const Color(0xFFB8CCAA)
      ..strokeWidth = 3;
    canvas.drawLine(const Offset(60, 0), Offset(60, size.height), roadPaint);
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      roadPaint,
    );

    final routePaint = Paint()
      ..color = const Color(0xFF3B6FD4)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(85, size.height - 30)
      ..lineTo(90, size.height - 60)
      ..lineTo(105, size.height - 80)
      ..lineTo(130, size.height - 105)
      ..lineTo(155, size.height - 125)
      ..lineTo(175, size.height - 145)
      ..lineTo(200, size.height - 162)
      ..lineTo(215, size.height - 175);
    canvas.drawPath(path, routePaint);

    final pinRed = Paint()..color = const Color(0xFFE74C3C);
    final pinWhite = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(85, size.height - 30), 6, pinRed);
    canvas.drawCircle(Offset(85, size.height - 30), 3, pinWhite);
    canvas.drawCircle(Offset(215, size.height - 175), 6, pinRed);
    canvas.drawCircle(Offset(215, size.height - 175), 3, pinWhite);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
