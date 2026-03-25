import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/models/fare_rate_model.dart';
import '../../data/services/fare_rate_service.dart';

/// Arguments passed to this screen when navigating to it.
/// Other screens should push with these args via:
///
///   Navigator.pushNamed(
///     context,
///     '/price-breakdown',
///     arguments: PriceBreakdownArgs(
///       fromLocation: 'Kimironko',
///       toLocation:   'Remera',
///       distanceKm:   12.0,
///       bikeType:     'Fuel',   // "Electric" or "Fuel"
///     ),
///   );
class PriceBreakdownArgs {
  final String fromLocation;
  final String toLocation;
  final double distanceKm;
  final String bikeType; // "Electric" or "Fuel"

  const PriceBreakdownArgs({
    required this.fromLocation,
    required this.toLocation,
    required this.distanceKm,
    required this.bikeType,
  });
}

class PriceBreakdownScreen extends StatefulWidget {
  const PriceBreakdownScreen({super.key});

  @override
  State<PriceBreakdownScreen> createState() => _PriceBreakdownScreenState();
}

class _PriceBreakdownScreenState extends State<PriceBreakdownScreen> {
  final FareRateService _fareRateService = FareRateService();

  // Will be set from route arguments in didChangeDependencies
  PriceBreakdownArgs? _args;

  FareRate? _fareRate;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read route arguments once dependencies are ready
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PriceBreakdownArgs && _args == null) {
      _args = args;
      _loadFareRate();
    } else if (args == null && _args == null) {
      // Fallback: screen opened without args (e.g. direct navigation during dev)
      _args = const PriceBreakdownArgs(
        fromLocation: 'Kimironko',
        toLocation: 'Remera',
        distanceKm: 12.0,
        bikeType: 'Fuel',
      );
      _loadFareRate();
    }
  }

  Future<void> _loadFareRate() async {
    if (_args == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rate =
          await _fareRateService.getFareRateByBikeType(_args!.bikeType);
      if (!mounted) return;
      setState(() {
        _fareRate = rate;
        _isLoading = false;
        if (rate == null) {
          _errorMessage =
              'No fare rate found for bike type "${_args!.bikeType}"';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load fare data. Please try again.';
      });
    }
  }

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
            // ── Top bar ──────────────────────────────────────────────────────
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

            // ── Card container ───────────────────────────────────────────────
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage != null
                        ? _buildErrorState()
                        : _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loading state ──────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.ctaFill),
          SizedBox(height: 16),
          Text(
            'Loading fare data…',
            style: TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadFareRate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ctaFill,
                foregroundColor: AppColors.ctaText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content ───────────────────────────────────────────────────────────
  Widget _buildContent() {
    final args = _args!;
    final rate = _fareRate!;

    final double estimatedFare = rate.estimateFare(args.distanceKm);
    final double? totalFuel = rate.totalFuel(args.distanceKm);

    return Column(
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

                // Bike type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: rate.isElectric
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rate.isElectric ? '⚡ Electric' : '⛽ Fuel',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: rate.isElectric
                          ? const Color(0xFF388E3C)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Estimated price (dynamic)
                Text(
                  '${estimatedFare.toStringAsFixed(0)} Rwf',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Estimated fare',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),

                const SizedBox(height: 16),

                // Row 1: From → To
                _buildDetailRow(
                  'from',
                  args.fromLocation,
                  'to',
                  args.toLocation,
                ),
                const SizedBox(height: 14),

                // Row 2: Distance + rate per km
                _buildDetailRow(
                  'distance',
                  '${args.distanceKm.toStringAsFixed(1)} km',
                  'rate per km',
                  '${rate.pricePerKm.toStringAsFixed(0)} Rwf',
                ),
                const SizedBox(height: 14),

                // Row 3: Min price + Max price
                _buildDetailRow(
                  'min price',
                  '${rate.minPrice.toStringAsFixed(0)} Rwf',
                  'max price',
                  '${rate.maxPrice.toStringAsFixed(0)} Rwf',
                ),

                // Row 4: Fuel per km (only for Fuel bikes)
                if (totalFuel != null) ...[
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    'fuel per km',
                    '${rate.fuelPerKm!.toStringAsFixed(2)} L',
                    'total fuel',
                    '${totalFuel.toStringAsFixed(2)} L',
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Buttons ──────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            children: [
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
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/report-problem'),
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

// ── Map painter (unchanged from original) ────────────────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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