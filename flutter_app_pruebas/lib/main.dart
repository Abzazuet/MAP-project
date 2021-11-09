import 'package:flutter_app/models/listaParametros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/programacionMedicion.dart';
import 'models/bluetooth.dart';
import 'package:flutter_app/pages/cargaPantalla.dart';
import 'package:flutter_app/pages/datosPersonales.dart';
import 'package:flutter_app/pages/informes.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() =>runApp(MaterialApp(
    localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
        const Locale('es'),
        const Locale('en'),
    ],
initialRoute: '/',
  routes:{
    '/':(context)=>Cargar(),
    '/bluetooth':(context)=>BluetoothApp(),
    '/home':(context)=>Home(),
    '/personalData':(context)=>Datos(),
    '/informe':(context)=>Informe(),
    '/programarMed':(context)=>DoMedicion(),
    '/parametros':(context)=>ListaParametros(),
  }

)

);




