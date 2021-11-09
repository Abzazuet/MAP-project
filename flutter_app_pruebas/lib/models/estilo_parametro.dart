import 'package:flutter/material.dart';
import 'listaParametros.dart';
class ParametroEstilo extends StatelessWidget {
  final Parametro lParametro;//Se poe final para indicar que es su valor final, dado que es un widget que no va a cambiar se debe especificar final dato
  ParametroEstilo({this.lParametro});//SE le pasan dos paramateros, el primero es un dato y el segundo es una funcion
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,//Horizontal
          children: [
            Text(
              lParametro.nombreParametro,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            //Sirve para dar espacio entre widgets
            Align(
              alignment: Alignment.center,
              child: Text(
                lParametro.medicion,
                style: TextStyle(
                  fontSize: 20,
                  color:Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
