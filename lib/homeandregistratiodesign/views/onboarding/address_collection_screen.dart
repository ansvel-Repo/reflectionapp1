// import 'package:ansvel/controllers/onboarding_controller.dart';
// import 'package:ansvel/views/onboarding/7_create_wallet_summary_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/create_wallet_summary_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const String kGoogleApiKey = "YOUR_GOOGLE_API_KEY";
const Uuid uuid = Uuid();

class AddressCollectionScreen extends StatefulWidget {
  const AddressCollectionScreen({super.key});

  @override
  State<AddressCollectionScreen> createState() => _AddressCollectionScreenState();
}

class _AddressCollectionScreenState extends State<AddressCollectionScreen> {
  final _manualAddressController = TextEditingController();
  final _searchController = SearchController();
  late GoogleMapsPlaces _places;
  String? _sessionToken;

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  }

  void _startSearchSession() => _sessionToken = uuid.v4();

  Future<void> _getPlaceDetail(String placeId) async {
    final response = await _places.getDetailsByPlaceId(placeId, sessionToken: _sessionToken);
    _sessionToken = null;
    if (response.isOkay) {
      setState(() => _manualAddressController.text = response.result.formattedAddress ?? '');
    }
  }

  void _openMapPicker() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MapPickerScreen(
      onLocationSelected: (lat, lng) async {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() => _manualAddressController.text = "${p.street}, ${p.locality}, ${p.administrativeArea}");
        }
      }
    )));
  }

  @override
  Widget build(BuildContext context) {
    final onboardingController = Provider.of<OnboardingController>(context, listen: false);

    return OnboardingStepScreen(
      title: "Residential Address",
      subtitle: "Please provide your current home address.",
      step: 4, totalSteps: 6,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SearchAnchor(
                    searchController: _searchController,
                    builder: (BuildContext context, SearchController controller) => SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () { _startSearchSession(); controller.openView(); },
                      onChanged: (_) { if (!controller.isOpen) { _startSearchSession(); controller.openView(); } },
                      leading: const Icon(Icons.search),
                      hintText: "Search for your address...",
                    ),
                    suggestionsBuilder: (BuildContext context, SearchController controller) async {
                      if (controller.text.isEmpty) return [const Padding(padding: EdgeInsets.all(16.0), child: Text('Start typing an address...'))];
                      final response = await _places.autocomplete(controller.text, sessionToken: _sessionToken, components: [Component(Component.country, "ng")]);
                      if (!response.isOkay) return [const Padding(padding: EdgeInsets.all(16.0), child: Text('Something went wrong.'))];
                      return response.predictions.map((p) => ListTile(
                        title: Text(p.description ?? ''),
                        onTap: () { controller.closeView(p.description); _getPlaceDetail(p.placeId!); },
                      )).toList();
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(child: OutlinedButton.icon(icon: const Icon(FontAwesomeIcons.mapLocationDot), label: const Text("Select on Map"), onPressed: _openMapPicker)),
                  const SizedBox(height: 15),
                  const Text("Or Enter Manually", style: TextStyle(color: Colors.grey)),
                  const Divider(),
                  TextFormField(controller: _manualAddressController, decoration: const InputDecoration(labelText: "Street Address")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_manualAddressController.text.isNotEmpty) {
                  onboardingController.updateField(address: _manualAddressController.text);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const CreateWalletSummaryScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please provide your address.")),
                  );
                }
              },
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPickerScreen extends StatefulWidget {
  final Function(double, double) onLocationSelected;
  const MapPickerScreen({super.key, required this.onLocationSelected});
  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final LatLng _initialPosition = const LatLng(9.0765, 7.3986);
  late LatLng _markerPosition = _initialPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Address")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 15),
            onCameraMove: (position) => setState(() => _markerPosition = position.target),
          ),
          const Center(child: Icon(Icons.location_pin, color: Colors.red, size: 50)),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: FilledButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
              onPressed: () {
                widget.onLocationSelected(_markerPosition.latitude, _markerPosition.longitude);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}