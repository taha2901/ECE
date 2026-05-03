import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:real_ecommerce/core/helpers/location_service.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/address/data/models/address_model.dart';

class MapPage extends StatefulWidget {
  // لو بتفتح للتعديل، بتبعت العنوان الحالي
  final AddressModel? existingAddress;

  const MapPage({super.key, this.existingAddress});

  // الـ result اللي بترجعه للصفحة اللي فتحتك
  static Future<AddressModel?> open(
    BuildContext context, {
    AddressModel? existingAddress,
  }) {
    return Navigator.push<AddressModel>(
      context,
      MaterialPageRoute(
        builder: (_) => MapPage(existingAddress: existingAddress),
      ),
    );
  }

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _labelCtrl = TextEditingController();

  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Cairo default
  String _selectedAddress = '';
  bool _isLoading = false;
  bool _isSearching = false;
  List<Location> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      _selectedLocation = widget.existingAddress!.latLng;
      _selectedAddress = widget.existingAddress!.fullAddress;
      _labelCtrl.text = widget.existingAddress!.label;
      _searchCtrl.text = _selectedAddress;
    } else {
      _loadCurrentLocation();
    }
  }

  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoading = true);
    final location = await LocationService().getCurrentLocation();
    if (location != null && mounted) {
      _selectedLocation = location;
      _mapController.move(location, 15);
      _selectedAddress = await LocationService().getAddressFromCoordinates(location);
      _searchCtrl.text = _selectedAddress;
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onMapTap(TapPosition _, LatLng point) async {
    setState(() {
      _selectedLocation = point;
      _isLoading = true;
    });
    _selectedAddress = await LocationService().getAddressFromCoordinates(point);
    _searchCtrl.text = _selectedAddress;
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    final results = await LocationService().searchPlaces(query);
    if (mounted) setState(() { _searchResults = results; _isSearching = false; });
  }

  Future<void> _selectSearchResult(Location loc) async {
    final point = LatLng(loc.latitude, loc.longitude);
    _mapController.move(point, 15);
    setState(() { _selectedLocation = point; _searchResults = []; _isLoading = true; });
    _selectedAddress = await LocationService().getAddressFromCoordinates(point);
    _searchCtrl.text = _selectedAddress;
    if (mounted) setState(() => _isLoading = false);
  }

  void _confirmLocation() {
    if (_selectedAddress.isEmpty) return;

    final label = _labelCtrl.text.trim().isEmpty ? 'Home' : _labelCtrl.text.trim();

    final address = AddressModel(
      id: widget.existingAddress?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      fullAddress: _selectedAddress,
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
      isDefault: widget.existingAddress?.isDefault ?? false,
    );

    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingAddress != null ? 'Edit Address' : 'Select Location',
          style: AppTypography.h3,
        ),
        actions: [
          TextButton(
            onPressed: _selectedAddress.isEmpty ? null : _confirmLocation,
            child: const Text('Confirm', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 14,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourapp.ecommerce',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Search Bar (فوق الخريطة) ─────────────
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search for a place...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: _searchPlaces,
                  ),
                ),

                // نتائج البحث
                if (_searchResults.isNotEmpty)
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: const Icon(Icons.place_outlined),
                            title: FutureBuilder<String>(
                              future: LocationService().getAddressFromCoordinates(
                                LatLng(_searchResults[i].latitude, _searchResults[i].longitude),
                              ),
                              builder: (_, snap) => Text(snap.data ?? 'Loading...', maxLines: 2),
                            ),
                            onTap: () => _selectSearchResult(_searchResults[i]),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── My Location Button ───────────────────
          Positioned(
            bottom: 180,
            right: 12,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: _loadCurrentLocation,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // ── Bottom Sheet: Label + Confirm ────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Text(
                      _selectedAddress.isEmpty ? 'Tap on the map to select location' : _selectedAddress,
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _labelCtrl,
                    decoration: InputDecoration(
                      labelText: 'Address Label (Home, Work...)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedAddress.isEmpty ? null : _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Address', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}