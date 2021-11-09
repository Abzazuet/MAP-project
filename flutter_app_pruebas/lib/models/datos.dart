class Datos{
  int id;
  String sys;
  String dys;
  String ppm;
  String tem;
  String fecha;
  Datos({this.id, this.sys, this.dys, this.ppm, this.tem, this.fecha});
  Datos.fromMap(Map<String, dynamic> res):
      id = res["id"],
        sys = res["sys"],
        dys = res["dys"],
        ppm = res["ppm"],
        tem = res["tem"],
        fecha = res["fecha"];
  Map<String, dynamic> toMap() {
    return {'id': id, 'sys': sys, 'dys': dys, 'ppm': ppm, 'tem': tem, 'fecha':fecha};
  }
}