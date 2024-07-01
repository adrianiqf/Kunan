import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_reporte_asistencia.dart';
import 'package:kunan_v01/widgets/estudiantes_widget.dart';
import '../../widgets/custom_navigationbar.dart';

class ProfTomarAsistencia extends StatefulWidget {
  const ProfTomarAsistencia({super.key});

  @override
  _ProfTomarAsistenciaState createState() => _ProfTomarAsistenciaState();
}

class _ProfTomarAsistenciaState extends State<ProfTomarAsistencia> {
  List<ScanResult> devices = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  BluetoothDevice? selectedDevice;
  List<BluetoothService> services = [];
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth no es compatible con este dispositivo");
      return;
    }

    _adapterStateSubscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        _adapterState = state;
      });
      if (state == BluetoothAdapterState.on) {
        _startScan();
      } else {
        _showBluetoothOffDialog();
      }
    });

    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        print("No se pudo activar el Bluetooth: $e");
      }
    }
  }

  void _showBluetoothOffDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bluetooth desactivado'),
          content:
              Text('Por favor, active el Bluetooth para usar esta función.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startScan() async {
    if (_adapterState != BluetoothAdapterState.on) return;

    setState(() {
      devices.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          devices = results;
        });
      });
    } catch (e) {
      print('Error al escanear dispositivos BLE: $e');
    }
  }

  Future<void> _connectToDevice() async {
    if (selectedDevice == null) return;

    setState(() {
      isConnecting = true;
    });

    try {
      await selectedDevice!.connect();
      services = await selectedDevice!.discoverServices();
      setState(() {});
    } catch (e) {
      print('Error al conectar con el dispositivo: $e');
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: const Color.fromRGBO(1, 6, 24, 1),
        padding: EdgeInsets.only(top: 30, left: screenSize.width * 0.1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_left_outlined,
                      size: 36,
                      color: Colors.white,
                    ),
                    Text(
                      'Volver',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(right: screenSize.width * 0.2),
                child: const Text(
                  'Iniciar Asistencia',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Clase:',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Taller de Software Móvil',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Horario de Asistencia',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: screenSize.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inicio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 120),
                          Text(
                            'Fin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      width: screenSize.width * 0.8,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 120),
                          Text(
                            '10:10',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(128, 179, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Iniciar',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(128, 179, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfReporteAsistencia()),
                  );
                },
                child: const Text(
                  'Reporte de asistencias',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DropdownButton<BluetoothDevice>(
                value: selectedDevice,
                hint: Text('Seleccionar dispositivo',
                    style: TextStyle(color: Colors.white)),
                dropdownColor: Color.fromRGBO(1, 6, 24, 1),
                items: devices.map((result) {
                  return DropdownMenuItem(
                    value: result.device,
                    child: Text(
                      result.device.platformName ?? 'Dispositivo desconocido',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (BluetoothDevice? value) {
                  setState(() {
                    selectedDevice = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isConnecting ? null : _connectToDevice,
                child: Text(
                    isConnecting ? 'Conectando...' : 'Conectar al dispositivo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(128, 179, 255, 1),
                  foregroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenSize.width * 0.8,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      services.isEmpty
                          ? 'No hay servicios disponibles'
                          : services.map((s) => s.uuid.toString()).join('\n'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Estudiantes inasistentes:',
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              const EstudianteWidget(
                imagen: '2',
                nombre: 'Juan Lino Gutierrez',
                estado: 'Ausente',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Profesor',
      ),
    );
  }
}
