import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../app/di.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/location_cubit.dart';
import '../../application/location_state.dart';
import '../../domain/entities/location_entity.dart';
import '../widgets/location_search_field.dart';
import '../widgets/location_suggestion_list.dart';

/// Entry point for the current-location screen.
/// Sets up [LocationCubit] from DI and delegates rendering to [_LocationView].
class CurrentLocationScreen extends StatelessWidget {
  const CurrentLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationCubit>(),
      child: const _LocationView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Private view widget — pure Flutter UI, no business logic
// ---------------------------------------------------------------------------

class _LocationView extends StatefulWidget {
  const _LocationView();

  @override
  State<_LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<_LocationView> {
  static const _defaultLatLng = LatLng(-1.9403, 29.8739); // Rwanda overview

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && mounted) {
      // Delay clear slightly so suggestion tap handlers can run first.
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (!mounted || _focusNode.hasFocus) return;
        context.read<LocationCubit>().clearSearchResults();
      });
    }
  }

  Future<void> _flyTo(LatLng target) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15.5),
      ),
    );
  }

  void _onSuggestionSelected(LocationEntity location) {
    _searchController.text = location.primaryLabel;
    context.read<LocationCubit>().selectLocation(location);
    // Fly using the exact tapped suggestion coordinates.
    _flyTo(LatLng(location.latitude, location.longitude));
    FocusScope.of(context).unfocus();
  }

  void _onMapLongPress(LatLng position) {
    context.read<LocationCubit>().pinLocation(
      position.latitude,
      position.longitude,
    );
  }

  void _onCalculatePressed() {
    // Placeholder — processing will be implemented later.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Calculate tapped. Processing will be implemented later.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      // Side effects: fly the map & sync text when a new location is selected.
      listenWhen: (prev, curr) =>
          curr.selectedLocation != prev.selectedLocation ||
          curr.errorMessage != prev.errorMessage,
      listener: (context, state) {
        final loc = state.selectedLocation;
        if (loc != null) {
          _flyTo(LatLng(loc.latitude, loc.longitude));
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<LocationCubit>().clearError();
        }
      },
      builder: (context, state) {
        final selectedLocation = state.selectedLocation;
        final markerPosition = selectedLocation == null
            ? null
            : LatLng(selectedLocation.latitude, selectedLocation.longitude);

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, size: 30),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Location',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 38),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Where are you now?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  LocationSearchField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    autofocus: true,
                    onChanged: (q) =>
                        context.read<LocationCubit>().scheduleSearch(q),
                    onDetectLocation: () =>
                        context.read<LocationCubit>().detectLocation(),
                    isSearching: state.isSearching,
                    isDetecting: state.isDetecting,
                  ),
                  if (state.searchResults.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    LocationSuggestionList(
                      suggestions: state.searchResults,
                      onSelected: _onSuggestionSelected,
                    ),
                  ],
                  const SizedBox(height: 18),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _defaultLatLng,
                          zoom: 8,
                        ),
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (markerPosition != null) {
                            _flyTo(markerPosition);
                          }
                        },
                        markers: markerPosition == null
                            ? const <Marker>{}
                            : {
                                Marker(
                                  markerId: const MarkerId('selected-location'),
                                  position: markerPosition,
                                ),
                              },
                        onLongPress: _onMapLongPress,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Long press to change the location',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onCalculatePressed,
                      child: const Text('Calculate'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
