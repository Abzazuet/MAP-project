import 'dart:io';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}
class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device

  int _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => globals.connection != null && globals.connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      globals.connection.dispose();
      globals.connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Configuracion BT"),
        backgroundColor: Colors.grey[800],
        actions: [
          FlatButton.icon(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            label: Text(
              "Refresh",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            splashColor: Colors.black,
            onPressed: () async {
              // So, that when new devices are paired
              // while the app is running, user can refresh
              // the paired devices list.
              await getPairedDevices().then((_) {
                show('Device list refreshed');
              });
            },
          ),
        ],
      ),
      body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Habilitar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "DISPOSITIVOS",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Seleccionar:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              width: 103,
                              height: 30,
                              child: DropdownButton(
                                items: _getDeviceItems(),
                                onChanged: (value) =>
                                    setState(() => globals.device = value),
                                value: _devicesList.isNotEmpty ? globals.device : null,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (_isButtonUnavailable
                                  ? null
                                  : _connected ? _disconnect : _connect
                              ),
                              child:
                              Text(
                                _connected ? 'Disconnect' : 'Connect',
                              ),

                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(
                              color: _deviceState == 0
                                  ? colors['neutralBorderColor']
                                  : _deviceState == 1
                                  ? colors['onBorderColor']
                                  : colors['offBorderColor'],
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "PANI",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _connected
                                      ? _sendOnMessageToBluetooth
                                      : null,
                                  child: Text("Tomar Medicion"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "NOTA: Si el dispositivo no aparece vaya a los ajustes y sincorice por primera vez con celular.",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          child: Text("Bluetooth Settings"),
                          onPressed: () {
                            FlutterBluetoothSerial.instance.openSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
        ),
      drawer: MenuLateral(),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text(
          'NONE',
          style: TextStyle(
          fontSize: 8,
          ),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(
              device.name,
            style: TextStyle(
              fontSize: 8,
            ),

          ),
          value: device,
        ));
      });
    }
    return items;
  }
  // Method to connect to bluetooths
  void _connect() async {
    /////////////////////////////////////////////////////////////////////////////////////
//    Navigator.pushNamed(context, '/home');
    setState(() {
      _isButtonUnavailable = true;
    });
    if (globals.device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(globals.device.address)
            .then((_connection) {
          show('Connected to the device');
          globals.connection = _connection;
          setState(() {
            _connected = true;
          });
          show('Device connected');
        }).catchError((error) {
          show('Desconectado');
        });

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await globals.connection.close();
    show('Device disconnected');
    if (!globals.connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    globals.connection.output.add(utf8.encode("m" + "\r\n"));
    await globals.connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1; // device on
      globals.sys='Cargando...';
      globals.dys='Cargando...';
      globals.ppm='Cargando...';
      globals.tem='Cargando...';
    });
    Navigator.pushNamed(context, '/home');
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));

    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 80, 40, 0),
      child: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex:10,
              child: ListView(
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.contact_mail,
                          size: 20,
                        ),
                        title: Text(
                          'Datos',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/personalData');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          size: 20,
                        ),
                        title: Text(
                          'Informe',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/informe');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.date_range,
                          size: 20,
                        ),
                        title: Text(
                          'Programar',
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/programarMed');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex:3,
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.exit_to_app_sharp,size:30.0),
                  onPressed: (){
                    _sendOffMessageToBluetooth();
                    //Salir aplicacion
                    exit(0);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    globals.connection.output.add(utf8.encode("0" + "\r\n"));
    await globals.connection.output.allSent;
  }
}