import 'package:flutter/material.dart';
import 'package:flutter_app/db/operation.dart';
import 'package:flutter_app/models/datos.dart';
import 'package:flutter_app/models/globals.dart' as globals;
import 'package:intl/intl.dart';
// Lista parametros incluye mediciones y guardar fecha tambien
class Informe extends StatefulWidget {
  @override
  _InformeState createState() => _InformeState();
}

class _InformeState extends State<Informe> {
  List<Datos> registros=List<Datos>();
  @override
  void initState(){
    _cargar();
    super.initState();
  }
  @override
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
                  'INFORME',
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
      body:ListView.builder(
      itemCount: registros.length,
      itemBuilder: (_, i) =>_crearRegistro(i),
      ),
    );
  }
  _cargar() async{
    List <Datos> lecturaBase = await Operation.db.read();
    if (lecturaBase.isEmpty){
      globals.fecha=DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now());
      Operation.db.insert(Datos(sys:'', dys:'',ppm:'', tem:'', fecha: 'No hay registros'));
      lecturaBase = await Operation.db.read();
    }
    setState(() {
      registros=lecturaBase;
    });
  }
  _crearRegistro(int i){
    String sys=registros[i].sys;
    String dys=registros[i].dys;
    String ppm=registros[i].ppm;
    String tem=registros[i].tem;
    String fecha=registros[i].fecha;
    String id=registros[i].id.toString();
    return Card(
      color: Colors.blueGrey[900],
      child: ListTile(
          leading: Icon(Icons.accessibility, size: 40,color: Colors.indigo[700],),
          title: Text(
              fecha,
            style: TextStyle(
              color: Colors.indigo[700],
            ),
          ),
          subtitle: Text(
            'SYS'+sys+'\n'+
                'DYS'+dys+'\n'+
                'PPM'+ppm+'\n'+
                'TEM'+tem,
            maxLines: 12,
            style: TextStyle(
              color: Colors.blueGrey[300],
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.indigo[700],
            ),
            splashColor: Colors.indigoAccent[200],
            onPressed: (){
              setState(() {
                Operation.db.delete(registros[i]);
                _cargar();
                ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (_, i) =>_crearRegistro(i),
                );
              });
            },
          )
      ),
    );
  }
}



