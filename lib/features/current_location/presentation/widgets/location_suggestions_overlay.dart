import 'package:flutter/material.dart';

import '../../domain/entities/location_entity.dart';
import '../../../../app/theme/app_colors.dart';
import 'location_suggestion_list.dart';

// Renders the suggestion list as a floating overlay positioned immediately
// below the search field, without affecting the map's space in the layout.
class LocationSuggestionsOverlay extends StatefulWidget {
  const LocationSuggestionsOverlay({
    super.key,
    required this.anchorKey,
    required this.stackKey,
    required this.suggestions,
    required this.onSelected,
    this.horizontalPadding = 24.0,
    this.homeIndex = -1,
  });

  final GlobalKey anchorKey;
  final GlobalKey stackKey;
  final List<LocationEntity> suggestions;
  final ValueChanged<LocationEntity> onSelected;
  final double horizontalPadding;
  final int homeIndex;

  @override
  State<LocationSuggestionsOverlay> createState() =>
      _LocationSuggestionsOverlayState();
}

class _LocationSuggestionsOverlayState
    extends State<LocationSuggestionsOverlay> {
  double? _top;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(LocationSuggestionsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final fieldBox =
        widget.anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final stackBox =
        widget.stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null || stackBox == null) return;
    final offset = fieldBox.localToGlobal(Offset.zero, ancestor: stackBox);
    if (!mounted) return;
    setState(() => _top = offset.dy + fieldBox.size.height + 4);
  }

  @override
  Widget build(BuildContext context) {
    final top = _top;
    if (top == null) return const SizedBox.shrink();
    return Positioned(
      top: top,
      left: widget.horizontalPadding,
      right: widget.horizontalPadding,
      child: Material(
        color: AppColors.cardSurface,
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LocationSuggestionList(
              suggestions: widget.suggestions,
              onSelected: widget.onSelected,
              homeIndex: widget.homeIndex,
            ),
          ),
        ),
      ),
    );
  }
}
