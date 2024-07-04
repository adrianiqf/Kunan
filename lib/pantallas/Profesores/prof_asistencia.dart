import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_reporte_asistencia.dart';
import 'package:kunan_v01/widgets/estudiantes_widget.dart';

import '../../widgets/custom_navigationbar.dart';

class ProfTomarAsistencia extends StatefulWidget {
  const ProfTomarAsistencia({super.key});

  @override
  State<ProfTomarAsistencia> createState() => _ProfTomarAsistenciaState();
}

class _ProfTomarAsistenciaState extends State<ProfTomarAsistencia> {

  List<ScanResult> devices = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  BluetoothDevice? selectedDevice;
  List<BluetoothService> services = [];
  bool isConnecting = false;

  static const String SERVICE_UUID_CAMBIO_ESTADO =
      "2da27884-06ee-4a0d-9102-9eadb3e6629c";
  static const String CHARACTERISTIC_UUID_CAMBIO_ESTADO =
      "11111111-1111-1111-1111-111111111112";
  static const String SERVICE_UUID_LEER =
      "c4997186-5979-40ae-81ec-013a0a4313e2";
  static const String CHARACTERISTIC_UUID_LEER =
      "33333333-3333-3333-3333-333333333334";

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
          title: const Text('Bluetooth desactivado'),
          content:
          const Text('Por favor, active el Bluetooth para usar esta función.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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

  Future<void> _iniciarAsistencia() async {
    if (selectedDevice == null) {
      print('No hay dispositivo seleccionado');
      return;
    }

    try {
      BluetoothService? targetService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_CAMBIO_ESTADO) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        print('Servicio no encontrado');
        return;
      }

      BluetoothCharacteristic? targetCharacteristic;
      for (var characteristic in targetService.characteristics) {
        if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_CAMBIO_ESTADO) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        print('Característica no encontrada');
        return;
      }

      await targetCharacteristic.write(utf8.encode('start'));
      print('Se envió "start" a la característica');
    } catch (e) {
      print('Error al iniciar asistencia: $e');
    }
  }

  Future<void> _cerrarAsistencia() async {
    if (selectedDevice == null) {
      print('No hay dispositivo seleccionado');
      return;
    }

    try {
      // Primero, enviamos 'stop' al servicio de cambio de estado
      BluetoothService? targetService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == SERVICE_UUID_CAMBIO_ESTADO) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        print('Servicio de cambio de estado no encontrado');
        return;
      }

      BluetoothCharacteristic? targetCharacteristic;
      for (var characteristic in targetService.characteristics) {
        if (characteristic.uuid.toString() ==
            CHARACTERISTIC_UUID_CAMBIO_ESTADO) {
          targetCharacteristic = characteristic;
          break;
        }
      }

      if (targetCharacteristic == null) {
        print('Característica de cambio de estado no encontrada');
        return;
      }

      await targetCharacteristic.write(utf8.encode('stop'));
      print('Se envió "stop" a la característica de cambio de estado');

      // Ahora, leemos la lista de asistentes del servicio de lectura
      BluetoothService? leerService;
      for (var service in services) {
        print(service);
        if (service.uuid.toString() == "c4997186-5979-40ae-81ec-013a0a4313e2") {
          leerService = service;
          break;
        }
      }

      if (leerService == null) {
        print('Servicio de lectura no encontrado');
        return;
      }

      BluetoothCharacteristic? leerCharacteristic;
      for (var characteristic in leerService.characteristics) {
        if (characteristic.uuid.toString() ==
            "33333333-3333-3333-3333-333333333334") {
          leerCharacteristic = characteristic;
          break;
        }
      }

      if (leerCharacteristic == null) {
        print('Característica de lectura no encontrada');
        return;
      }
      //convetimos en una lista los codigos que nos devuelve
      List<int> value = await leerCharacteristic.read();
      String asistentes = utf8.decode(value);
      print('Lista de asistentes:');
      print(asistentes.runtimeType);
      print(asistentes);

      // logica para crear la lista de asistentes
    } catch (e) {
      print('Error al cerrar asistencia: $e');
    }
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(1, 6, 24, 1),
        padding: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.09, right: size.width * 0.09),
        width: double.infinity,
        height: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_left_outlined,
                          size: size.width * 0.07,
                          color: Colors.white,
                        ),
                        const Text(
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
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                margin: EdgeInsets.only(right: size.width * 0.1),
                child: Text(
                  'Iniciar Asistencia',
                  style: TextStyle(
                    fontSize: size.width * 0.09,
                    color: const Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Clase:',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Taller de Software Móvil',
                style: TextStyle(
                  fontSize: size.width * 0.055,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.03),
               Text(
                'Horario de Asistencia',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.031),
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inicio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: size.width * 0.2),
                          Text(
                            'Fin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      margin: EdgeInsets.only(left: size.width * 0.05),
                      width: size.width * 0.7,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: size.width * 0.22),
                          Text(
                            '10:10',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(size.width * 0.021),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _iniciarAsistencia,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: size.width * 0.011),
                                  Text(
                                    'Iniciar',
                                    style: TextStyle(
                                      fontSize:  size.width * 0.05,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.01),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _cerrarAsistencia,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout, color: Colors.white),
                                  SizedBox(width:  size.width * 0.0011),
                                  Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize:  size.width * 0.05,
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
              SizedBox(height: size.height * 0.04),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfReporteAsistencia()),
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
              SizedBox(height: size.height * 0.03),
              DropdownButton<BluetoothDevice>(
                value: selectedDevice,
                hint: const Text('Seleccionar dispositivo',
                    style: TextStyle(color: Colors.white)),
                dropdownColor: const Color.fromRGBO(1, 6, 24, 1),
                items: devices.map((result) {
                  return DropdownMenuItem(
                    value: result.device,
                    child: Text(
                      result.device.platformName ?? 'Dispositivo desconocido',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (BluetoothDevice? value) {
                  setState(() {
                    selectedDevice = value;
                  });
                },
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: isConnecting ? null : _connectToDevice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                  foregroundColor: Colors.black,
                ),
                child: Text(
                    isConnecting ? 'Conectando...' : 'Conectar al dispositivo'),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.01),
                width: size.width * 0.8,
                height: size.height * 0.2,
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Estudiantes inasistentes:',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: const Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.04),
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
