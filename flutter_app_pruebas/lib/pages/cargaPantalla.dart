import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/db/operation.dart';
import 'package:flutter_app/models/datos.dart';
import 'package:flutter_app/models/globals.dart' as globals;
import 'package:intl/intl.dart';

class Cargar extends StatefulWidget {
  @override
  _CargarState createState() => _CargarState();
}

class _CargarState extends State<Cargar> {
  @override
  void initState(){
    super.initState();
  Timer(Duration(seconds: 3),()=>Navigator.pushNamed(context, '/bluetooth'));
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[700],
        body: Center(
          child: SpinKitPumpingHeart(
            color: Colors.white,
            size: 80,
          ),
        )
    );
  }
}
