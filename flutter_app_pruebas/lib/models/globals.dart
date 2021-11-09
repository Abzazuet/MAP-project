library my_prj.globals;
import 'dart:core';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'listaParametros.dart';
BluetoothDevice device;
BluetoothConnection connection;
List messages;
String sys;
String dys;
String ppm;
String tem;
String fecha;
List<Parametro> parametros=[//Se declara una lista de <tipo_de_variable>nombreVariable=[datos]
  Parametro(nombreParametro:'SYS',medicion:sys),
  Parametro(nombreParametro:'DYS',medicion:dys),
  Parametro(nombreParametro:'PPM',medicion:ppm),
  Parametro(nombreParametro:'TEM',medicion:tem),
];
