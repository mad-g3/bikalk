import 'package:bikalk/core/widgets/continue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/screen_heading.dart';
import '../../application/location_cubit.dart';
import '../../application/current_location_state.dart';
import '../../domain/entities/location_entity.dart';
import '../widgets/location_search_field.dart';
import '../widgets/location_suggestions_overlay.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  static const _defaultLatLng = LatLng(-1.9403, 29.8739); // Rwanda overview

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  // Global keys to track the positions of text fields at runtime
  final _searchFieldKey = GlobalKey();
  final _stackKey = GlobalKey();
  GoogleMapController? _mapController;

  bool _cameraHandled = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
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
    if (mounted) setState(() => _hasFocus = _focusNode.hasFocus);
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

  Future<void> _panTo(LatLng target) async {
    await _mapController?.animateCamera(CameraUpdate.newLatLng(target));
  }

  void _onSuggestionSelected(LocationEntity location) {
    _searchController.text = location.primaryLabel;
    _cameraHandled = true;
    context.read<LocationCubit>().selectLocation(location);
    _flyTo(LatLng(location.latitude, location.longitude));
    FocusScope.of(context).unfocus();
  }

  void _onMapLongPress(LatLng position) {
    _cameraHandled = true;
    context.read<LocationCubit>().pinLocation(
      position.latitude,
      position.longitude,
    );
    _panTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, CurrentLocationState>(
      listenWhen: (_, curr) =>
          curr is CurrentLocationSelected || curr is CurrentLocationError,
      listener: (context, state) {
        if (state is CurrentLocationSelected) {
          if (_cameraHandled) {
            _cameraHandled = false;
          } else {
            // GPS detect — fly in with zoom
            _flyTo(LatLng(state.lat, state.lng));
          }
          if (_searchController.text.isEmpty) {
            _searchController.text = state.displayName;
          }
        }
        if (state is CurrentLocationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<LocationCubit>().clearError();
        }
      },
      builder: (context, state) {
        final markerLatLng = state is CurrentLocationSelected
            ? LatLng(state.lat, state.lng)
            : null;

        final isSearching =
            state is CurrentLocationSearchResults && state.isSearching;
        final isDetecting = state is CurrentLocationDetecting;

        final home = sl<PreferencesService>().getHomeLocation();
        final homeEntity = home != null
            ? LocationEntity(
                latitude: home.lat,
                longitude: home.lng,
                displayName: home.label,
              )
            : null;

        final searchResults = state is CurrentLocationSearchResults
            ? state.results
            : const <LocationEntity>[];

        final suggestions = [
          if (homeEntity != null && _hasFocus) homeEntity,
          ...searchResults,
        ];
        final homeIndex = homeEntity != null && _hasFocus ? 0 : -1;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Stack(
              key: _stackKey,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      const ScreenHeading(
                        title: 'Location',
                        subtitle: 'Where are you now?',
                      ),
                      const SizedBox(height: 22),
                      LocationSearchField(
                        key: _searchFieldKey,
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (q) =>
                            context.read<LocationCubit>().scheduleSearch(q),
                        onDetectLocation: () =>
                            context.read<LocationCubit>().detectLocation(),
                        isSearching: isSearching,
                        isDetecting: isDetecting,
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: RepaintBoundary(
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
                                        markerId: const MarkerId(
                                          'current-location',
                                        ),
                                        position: markerLatLng,
                                      ),
                                    },
                              onLongPress: _onMapLongPress,
                            ),
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
                      ContinueButton(
                        onPressed: state is CurrentLocationSelected
                            ? () => context.push(AppRoutes.priceBreakdown)
                            : null,
                        label: 'Calculate',
                      ),
                    ],
                  ),
                ),
                if (suggestions.isNotEmpty)
                  LocationSuggestionsOverlay(
                    anchorKey: _searchFieldKey,
                    stackKey: _stackKey,
                    suggestions: suggestions,
                    onSelected: _onSuggestionSelected,
                    homeIndex: homeIndex,
                  ),
              ],
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
