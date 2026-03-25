import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../application/location_cubit.dart';
import '../../application/location_state.dart';
import '../../domain/entities/location_entity.dart';
import '../widgets/location_search_field.dart';
import '../widgets/location_suggestion_list.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
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
      // Small delay so suggestion tap handlers fire before results are cleared
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
    FocusScope.of(context).unfocus();
  }

  void _onMapLongPress(LatLng position) {
    context.read<LocationCubit>().pinLocation(
      position.latitude,
      position.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listenWhen: (_, curr) =>
          curr is LocationSelected || curr is LocationError,
      listener: (context, state) {
        if (state is LocationSelected) {
          _flyTo(LatLng(state.lat, state.lng));
          // Sync text field for GPS/map-pin selections; suggestions set it in _onSuggestionSelected
          if (_searchController.text.isEmpty) {
            _searchController.text = state.displayName;
          }
        }
        if (state is LocationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<LocationCubit>().clearError();
        }
      },
      builder: (context, state) {
        final markerLatLng = state is LocationSelected
            ? LatLng(state.lat, state.lng)
            : null;

        final isSearching = state is LocationSearchResults && state.isSearching;

        final isDetecting = state is LocationDetecting;

        final suggestions = state is LocationSearchResults
            ? state.results
            : const <LocationEntity>[];

        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                    isSearching: isSearching,
                    isDetecting: isDetecting,
                  ),
                  if (suggestions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    LocationSuggestionList(
                      suggestions: suggestions,
                      onSelected: _onSuggestionSelected,
                    ),
                  ],
                  const SizedBox(height: 18),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: _defaultLatLng,
                          zoom: 8,
                        ),
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (markerLatLng != null) {
                            _flyTo(markerLatLng);
                          }
                        },
                        markers: markerLatLng == null
                            ? const <Marker>{}
                            : {
                                Marker(
                                  markerId: const MarkerId('current-location'),
                                  position: markerLatLng,
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
                      onPressed: state is LocationSelected
                          ? () => context.push(AppRoutes.priceBreakdown)
                          : null,
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

// Provides LocationCubit from DI for this screen
class CurrentLocationScreenWrapper extends StatelessWidget {
  const CurrentLocationScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<LocationCubit>(),
      child: const CurrentLocationScreen(),
    );
  }
}
