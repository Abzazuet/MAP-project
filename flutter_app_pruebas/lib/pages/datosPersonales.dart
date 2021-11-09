import 'package:flutter/material.dart';
import 'package:flutter_app/db/operation.dart';
import 'package:flutter_app/models/estilo_datos_personales.dart';
class Datos extends StatefulWidget {
  @override
  _DatosState createState() => _DatosState();
}
class PersonalInfo{
  String Dato;
  String Informacion;
  PersonalInfo({this.Dato, this.Informacion});
}
class _DatosState extends State<Datos> {
  List<PersonalInfo> informacionPersonal=[
    PersonalInfo(Dato: 'Nombre', Informacion: 'Abel Zazueta'),
    PersonalInfo(Dato: 'Nacimiento', Informacion: '12/04/1999'),
    PersonalInfo(Dato: 'Medicion', Informacion: '25/25/2021'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex:20,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'DATOS',
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
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey[850],
        child:Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,//Horizontal
            children: [
              Expanded(
                flex: 4,
                  child: Image.asset('assets/images/user.png',width: 150,height: 150),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 1,
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                children: informacionPersonal.map((lInfo) => Expanded(
                  flex: 1,
                  child: DatoEstilo(
                    lInfo: lInfo,
                  ),
                )).toList(),
              ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
      Container(
        width: 250,
        height: 40,
        child: Center(
          child: ListTile(
            leading: Icon(
              Icons.delete_forever,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              'Eliminar todo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            onTap: (){
              Operation.db.deleteAll();
            },
          ),
        ),
      ),
    );
  }
}
