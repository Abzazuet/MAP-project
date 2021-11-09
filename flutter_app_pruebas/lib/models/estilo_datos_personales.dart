import 'package:flutter/material.dart';
import 'package:flutter_app/pages/datosPersonales.dart';
class DatoEstilo extends StatelessWidget {
  final PersonalInfo lInfo;//Se poe final para indicar que es su valor final, dado que es un widget que no va a cambiar se debe especificar final dato
  DatoEstilo({this.lInfo});//SE le pasan dos paramateros, el primero es un dato y el segundo es una funcion
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:new EdgeInsets.fromLTRB(0, 30, 0, 30),
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,//Horizontal
          children: [
            Text(
              lInfo.Dato,
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[300],
              ),
            ),
            Text(
              lInfo.Informacion,
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
