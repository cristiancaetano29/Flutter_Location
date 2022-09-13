import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

String lblMsg = "Usando o Gps";
String MsgCoordenada = "Sem valor";
String MsgCoordenadaAtualizada = "Sem valor";

class Principal extends StatefulWidget {
  const Principal({ Key? key }) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  var location = new Location();
  late LocationData _locationData;

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  void serviceStatus() async {
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return;
      }
    }
  }

  void obterPermissao() async {
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
        if(_permissionGranted != PermissionStatus.granted){
          return;
        }
    }
  }

  Future obterLocalizacao() async {
    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  void initState() {
    super.initState();
    location.changeSettings(interval: 300);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(
        () {
          MsgCoordenadaAtualizada = currentLocation.latitude.toString() + 
          "\n" +
          currentLocation.longitude.toString();
          print(currentLocation);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Localização"), backgroundColor: Colors.blueGrey,),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(lblMsg),
            ElevatedButton(
              onPressed: (()  {
                serviceStatus();
                if(_permissionGranted == PermissionStatus.denied){
                  obterLocalizacao();
                }
                else{
                  obterLocalizacao().then((value) {
                    MsgCoordenada = _locationData.latitude.toString() + 
                    "\n" +
                    _locationData.longitude.toString();
                  });
                }
              }), 
              child: Text("click para obter coordenada")),
              Text(MsgCoordenada),
              Text("Atualizada:"),
              Text(MsgCoordenadaAtualizada),
          ],
        ),
      ),
    );
  }
}