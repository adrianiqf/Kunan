import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/Alumnos/alum_pantalla_principal.dart';
import '../../Controladores/save_preferences.dart';
import '../../widgets/custom_navigationbar.dart';

class AlumTomarAsistencia extends StatefulWidget {
  const AlumTomarAsistencia({super.key});

  @override
  _AlumTomarAsistenciaState createState() => _AlumTomarAsistenciaState();
}

class _AlumTomarAsistenciaState extends State<AlumTomarAsistencia> {
  bool asistenciaMarcada = false;
  List<ScanResult> devices = [];
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  BluetoothDevice? selectedDevice;
  List<BluetoothService> services = [];
  bool isConnecting = false;

  static const String SERVICE_UUID_REGISTRAR =
      "68cce3a1-a94d-4b2f-Ac00-747066e80f05";
  static const String CHARACTERISTIC_UUID_REGISTRAR =
      "22222222-2222-2222-2222-222222222223";

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

  Future<void> _registrarAsistencia() async {
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
        if (characteristic.uuid.toString() ==
            CHARACTERISTIC_UUID_CAMBIO_ESTADO) {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(1, 6, 24, 1),
        padding: const EdgeInsets.only(top: 30, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LOGO
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EstMainMenuScreen(
                                idUsuario: 'OuVmuk1gaojmulu9AnhQ')));
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
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 60),
              child: const Text(
                'Marcar Asistencia',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Clase activa
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
            // Horario de asistencia
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
              width: 400,
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
                    width: 345,
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
                            onPressed: () {
                              setState(() {
                                asistenciaMarcada = true;
                                SharedPrefUtils.saveBool(
                                    "asistenciaMarcada", asistenciaMarcada);
                              });
                            },
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
                                Icon(
                                  Icons.domain_verification,
                                  color: Colors.black,
                                  size: 32,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Marcar Asistencia',
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
            const SizedBox(height: 60),

            if (asistenciaMarcada)
              const SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Text(
                      'Asistencia registrada correctamente a las 10:05',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Alumno',
      ),
    );
  }
}
