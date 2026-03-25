import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/continue_button.dart';
import '../../../current_location/domain/entities/location_entity.dart';
import '../../../current_location/presentation/widgets/location_suggestion_list.dart';
import '../../application/destination_location_cubit.dart';
import '../../application/destination_location_state.dart';
import '../widgets/destination_search_field.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  static const _defaultLatLng = LatLng(-1.9403, 29.8739); // Rwanda overview preview

  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  GoogleMapController? _mapController;

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
    if (!_focusNode.hasFocus && mounted) {
      // Small delay so suggestion tap handlers fire before results are cleared
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (!mounted || _focusNode.hasFocus) return;
        context.read<DestinationLocationCubit>().clearSearchResults();
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
    context.read<DestinationLocationCubit>().selectFromSuggestion(location);
    FocusScope.of(context).unfocus();
  }

  void _onMapLongPress(LatLng latLng) {
    context.read<DestinationLocationCubit>().selectFromMapPin(
      latLng.latitude,
      latLng.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DestinationLocationCubit, DestinationLocationState>(
      listenWhen: (_, curr) => curr is DestinationLocationSelected,
      listener: (context, state) {
        if (state is DestinationLocationSelected) {
          _flyTo(LatLng(state.lat, state.lng));
          // Sync text field for map pin selections; suggestions set it in _onSuggestionSelected
          if (_searchController.text.isEmpty) {
            _searchController.text = state.displayName;
          }
        }
      },
      builder: (context, state) {
        final markerLatLng = state is DestinationLocationSelected
            ? LatLng(state.lat, state.lng)
            : null;

        final isSearching =
            state is DestinationLocationSearchResults && state.isSearching;

        final suggestions = state is DestinationLocationSearchResults
            ? state.results
            : const <LocationEntity>[];

        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
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
                    'Destination',
                    style: AppTextStyles.titleLarge.copyWith(fontSize: 38),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Where do you want to go?',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  DestinationSearchField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    isSearching: isSearching,
                    onChanged: (q) =>
                        context.read<DestinationLocationCubit>().scheduleSearch(q),
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
                                  markerId: const MarkerId('destination'),
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
                      'Long press to change the destination',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ContinueButton(
                    onPressed: state is DestinationLocationSelected
                        ? () => context.push(AppRoutes.currentLocation)
                        : null,
                    label: 'Continue',
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

// Provides DestinationLocationCubit from DI for this screen
class DestinationScreenWrapper extends StatelessWidget {
  const DestinationScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<DestinationLocationCubit>(),
      child: const DestinationScreen(),
    );
  }
}
