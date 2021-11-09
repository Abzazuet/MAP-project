import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'estilo_parametro.dart';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:flutter_app/db/operation.dart';
import 'package:flutter_app/models/datos.dart';

class ListaParametros extends StatefulWidget {
  @override
  _ListaParametrosState createState() => _ListaParametrosState();
}

class Parametro{
  String nombreParametro;
  String medicion;
  Parametro({this.nombreParametro, this.medicion});
}

class _Message {
  String text;
  _Message(this.text);
}

//CLase donde se haran los cam  bios y los estilos, y donde se definen los datos
class _ListaParametrosState extends State<ListaParametros> {
  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';
  /////////////////////////////////////////////////////////////////////
  void initState() {
    super.initState();
    globals.connection.input.listen(_onDataReceived);
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////
    int longitud=messages.length;
    if (longitud==5){
      print(messages[1].text);
      print(messages[2].text);
      print(messages[3].text);
      print(messages[4].text);
      globals.sys=messages[1].text;
      globals.dys=messages[2].text;
      globals.ppm=messages[3].text;
      globals.tem=messages[4].text;
    }
    else if(longitud==6){
      print(messages[1].text);
      print(messages[3].text);
      print(messages[4].text);
      print(messages[5].text);
      globals.sys=messages[1].text;
      globals.dys=messages[3].text;
      globals.ppm=messages[4].text;
      globals.tem=messages[5].text;
    }

    globals.parametros=[//Se declara una lista de <tipo_de_variable>nombreVariable=[datos]
      Parametro(nombreParametro:'SYS',medicion:globals.sys),
      Parametro(nombreParametro:'DYS',medicion:globals.dys),
      Parametro(nombreParametro:'PPM',medicion:globals.ppm),
      Parametro(nombreParametro:'TEM',medicion:globals.tem),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
            //=>Significa return y map sirve para recorrer todos los valores de una lista
            children: globals.parametros.map((lParametro)=>ParametroEstilo(
              lParametro: lParametro,//Primer parametro, que es el de datos
            )).toList(),
          ),
      persistentFooterButtons: [Row(
          children:[
            FloatingActionButton(
                heroTag: "Guardar",
                onPressed: (){
                  globals.fecha=DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now());
                  Operation.db.insert(Datos(sys: globals.sys, dys: globals.dys,ppm: globals.ppm, tem: globals.tem, fecha: globals.fecha));
                  print(globals.sys);
                  deleteDatoInicial('No hay registros');
                  },
              child: Icon(Icons.save,size: 50,),
              backgroundColor: Colors.black,
              foregroundColor: Colors.grey[800],
              focusColor: Colors.amberAccent,
            ),
            SizedBox(
              width: 50,
            ),
            FloatingActionButton(
              heroTag: "Refrescar",
              onPressed: () {
                _medicion();
                setState(() {
                  messages = List<_Message>();
                  _messageBuffer = '';
                  globals.sys='Cargando...';
                  globals.dys='Cargando...';
                  globals.ppm='Cargando...';
                  globals.tem='Cargando...';
                });
              },
              child: Icon(Icons.autorenew_sharp,size: 50,),
              backgroundColor: Colors.black,
              foregroundColor: Colors.grey[800],
              focusColor: Colors.amberAccent,
            ),
          ],
        )],
    );
  }
  static Future<Database> openDB() async{
    return openDatabase(
        join(await getDatabasesPath(), 'pani.db'),
        onCreate: (db,version){
          return db.execute("CREATE TABLE datos("
              "id  INTEGER PRIMARY KEY AUTOINCREMENT,"
              "sys STRING,"
              "dys STRING,"
              "ppm STRING,"
              "tem STRING,"
              "fecha STRING"
              ")"
          );
        },
        version:1
    );
  }
  static Future<void> deleteDatoInicial (String fecha) async{
    Database database = await openDB();
    return database.delete("datos", where: 'fecha=?',whereArgs:[fecha='No hay registros']);
  }
  void _medicion () async {
    globals.connection.output.add(utf8.encode("m"+"\r\n"));
    await globals.connection.output.allSent;
  }
  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            backspacesCounter > 0
                ? _messageBuffer.substring(
                0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
}

