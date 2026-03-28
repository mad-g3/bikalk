import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../app/di.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_text_styles.dart';
import '../../../../../core/services/preferences_service.dart';
import '../../../../../features/current_location/application/current_location_state.dart';
import '../../../../../features/current_location/application/location_cubit.dart';
import '../../../../../features/current_location/domain/entities/location_entity.dart';
import '../../../../../features/current_location/domain/repositories/i_location_repository.dart';

class HomeLocationPickerSheet extends StatefulWidget {
  const HomeLocationPickerSheet({super.key, required this.onSaved});

  final void Function(double lat, double lng, String label) onSaved;

  @override
  State<HomeLocationPickerSheet> createState() =>
      _HomeLocationPickerSheetState();
}

class _HomeLocationPickerSheetState extends State<HomeLocationPickerSheet> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<LocationEntity> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    try {
      final results = await sl<ILocationRepository>().searchLocations(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _useCurrentGps() {
    final locationState = sl<LocationCubit>().state;
    if (locationState is CurrentLocationSelected) {
      _save(locationState.lat, locationState.lng, locationState.displayName);
    }
  }

  void _save(double lat, double lng, String label) {
    sl<PreferencesService>().saveHomeLocation(lat: lat, lng: lng, label: label);
    widget.onSaved(lat, lng, label);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final gpsState = sl<LocationCubit>().state;
    final hasGps = gpsState is CurrentLocationSelected;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Set home location', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtrl,
            onChanged: _onQueryChanged,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search a location…',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          if (hasGps) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _useCurrentGps,
              icon: const Icon(Icons.my_location, size: 16),
              label: const Text('Use current GPS location'),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
          if (_results.isNotEmpty) ...[
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _results.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = _results[i];
                  return ListTile(
                    dense: true,
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
                    onTap: () =>
                        _save(item.latitude, item.longitude, item.displayName),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
