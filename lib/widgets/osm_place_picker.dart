import 'dart:convert';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

const _aiGreen = Color(0xFF00C853);

class OSMPlacePicker extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String name, LatLng coord)? onSelected;

  const OSMPlacePicker({super.key, required this.controller, this.onSelected});

  @override
  State<OSMPlacePicker> createState() => _OSMPlacePickerState();
}

class _OSMPlacePickerState extends State<OSMPlacePicker> {
  List<Map<String, dynamic>> _results = [];
  LatLng? _selected;
  final mapCtrl = MapController();

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5&countrycodes=SN',
    );
    final res = await http.get(url, headers: {'User-Agent': 'fanexp/1.0'});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      setState(() {
        _results = data
            .map(
              (e) => {
                'name': e['display_name'],
                'lat': double.tryParse(e['lat']),
                'lon': double.tryParse(e['lon']),
              },
            )
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: 'Choisir une localité',
            prefixIcon: const Icon(Icons.place_outlined, color: Colors.black87),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outline.withOpacity(.25)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: gaindeGreen, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_results.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListView.builder(
              itemCount: _results.length,
              shrinkWrap: true,
              itemBuilder: (_, i) {
                final r = _results[i];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(r['name']),
                  onTap: () {
                    final pos = LatLng(r['lat'], r['lon']);
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selected = pos;
                      widget.controller.text = r['name'];
                      _results.clear();
                    });
                    widget.onSelected?.call(r['name'], pos);
                    mapCtrl.move(pos, 13);
                  },
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: FlutterMap(
              mapController: mapCtrl,
              options: MapOptions(
                initialCenter:
                    _selected ?? const LatLng(14.6937, -17.4441), // Dakar
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'fanexp.app',
                ),
                if (_selected != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selected!,
                        width: 60,
                        height: 60,
                        child: const Icon(
                          Icons.location_pin,
                          size: 45,
                          color: _aiGreen,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
