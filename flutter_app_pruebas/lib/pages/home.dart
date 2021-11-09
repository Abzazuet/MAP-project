import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/models/listaParametros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/globals.dart' as globals;
class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override//REemplaza lo de la clase padre
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex:20,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'PANI',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color:Colors.white,
                    //fontFamily:
                  ),
                ),
              ),
            ),
            Expanded(
              flex:1,
              child: Align(
                alignment: Alignment.topCenter,
                child: IconButton(
                  icon: Icon(Icons.bluetooth),
                  onPressed: () {
                    Navigator.pushNamed(context, '/bluetooth');
                  },
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
        elevation: 0.0,
      ),
      drawer: Container(
        width: 250,
        child: MenuLateral(),
      ),
      //Hacer archivos aparte para reducir codigo en main, por ejemplo los text y mensajes mostrados
      //Comentar para probar en compu
      body:ListaParametros(),
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