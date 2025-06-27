import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TremPositionProvider(),
      child: const MyApp(),
    ),
  );
}

class TremPosition {
  final double latitude;
  final double longitude;
  final String proximoPonto;
  final String status;
  final double progresso;

  TremPosition({
    required this.latitude,
    required this.longitude,
    required this.proximoPonto,
    required this.status,
    required this.progresso,
  });

  factory TremPosition.fromJson(Map<String, dynamic> json) {
    return TremPosition(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      proximoPonto: json['proximo_ponto'],
      status: json['status'],
      progresso: json['progresso'].toDouble(),
    );
  }
}

class TremPositionProvider with ChangeNotifier {
  TremPosition? _position;
  String? _error;

  TremPosition? get position => _position;
  String? get error => _error;

  Future<void> fetchPosition() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:3000/posicao'),

      );

      if (response.statusCode == 200) {
        _position = TremPosition.fromJson(json.decode(response.body));
        _error = null;
      } else {
        _error = 'Falha ao carregar dados: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trem Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TremPositionProvider>(context, listen: false).fetchPosition();
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        Provider.of<TremPositionProvider>(context, listen: false).fetchPosition();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreamento do Trem'),
      ),
      body: Consumer<TremPositionProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.position == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final position = provider.position!;
          final marker = Marker(
            markerId: const MarkerId('trem'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: 'Trem',
              snippet:
                  'Status: ${position.status}\nPróximo: ${position.proximoPonto}\nProgresso: ${position.progresso.toStringAsFixed(2)}%',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 12,
                ),
                markers: {marker},
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Status: ${position.status}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Próximo ponto: ${position.proximoPonto}'),
                        Text('Progresso: ${position.progresso.toStringAsFixed(2)}%'),
                        LinearProgressIndicator(
                          value: position.progresso / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
