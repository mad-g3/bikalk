import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/location_entity.dart';

/// Dropdown suggestion list shown below the search field.
/// Purely presentational — fires [onSelected] when the user taps a row.
class LocationSuggestionList extends StatelessWidget {
  const LocationSuggestionList({
    super.key,
    required this.suggestions,
    required this.onSelected,
    this.homeIndex = -1,
  });

  final List<LocationEntity> suggestions;
  final ValueChanged<LocationEntity> onSelected;

  /// Index of the pinned home entry; -1 means no home entry.
  final int homeIndex;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 180),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView.separated(
          itemCount: suggestions.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = suggestions[index];
            return ListTile(
              dense: true,
              leading: index == homeIndex
                  ? const Icon(Icons.home_outlined, size: 18)
                  : null,
              title: Text(
                item.primaryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyLarge,
              ),
              subtitle: item.secondaryLabel.isEmpty
                  ? null
                  : Text(
                      item.secondaryLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
              onTap: () => onSelected(item),
            );
          },
          separatorBuilder: (context, _) => const Divider(height: 1),
        ),
      ),
    );
  }
}
