import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as useLocation;
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/pages/no-internet.dart';
import 'package:weather_app/pages/select-city.dart';
import 'package:weather_app/utils/connectivity_provider.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/widgets/background.dart';

class RedirectPage extends StatefulWidget {
  static Map<String, String> pushLocationData = {};

  @override
  State<StatefulWidget> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late bool _isLoading = true;
  useLocation.Location location = new useLocation.Location();
  late bool _serviceEnabled;
  late useLocation.PermissionStatus _permissionGranted;
  late useLocation.LocationData _locationData;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    checkLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkLocation() async {
    setState(() {
      _isLoading = true;
    });
    _serviceEnabled = await location.serviceEnabled();
    _permissionGranted = await location.hasPermission();

    if (_serviceEnabled && (_permissionGranted == useLocation.PermissionStatus.granted)) {
      _locationData = await location.getLocation();
      RedirectPage.pushLocationData = {'latitude': _locationData.latitude.toString(), 'longitude': _locationData.longitude.toString()};

      Future.delayed(Duration(milliseconds: 200)).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCityPage(
              pushLocationData: RedirectPage.pushLocationData,
            ),
          ),
        );
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkLocationServicePermission() async {
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _serviceEnabled ? checkLocationAppPermission() : null;
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> checkLocationAppPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == useLocation.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == useLocation.PermissionStatus.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(
              seconds: 3,
            ),
            backgroundColor: Colors.white,
            content: Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      Flexible(
                        child: Text(
                          'Please turn on location permission in app settings!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 100,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(primary: Colors.white, backgroundColor: Colors.lightBlue),
                        onPressed: () => _openAppSettings(),
                        child: Text(
                          "Go",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      if (_permissionGranted != useLocation.PermissionStatus.granted) {
        return;
      }
    }

    _permissionGranted == useLocation.PermissionStatus.granted ? currentLocation() : null;
  }

  Future<void> currentLocation() async {
    _locationData = await location.getLocation();

    RedirectPage.pushLocationData = {'latitude': _locationData.latitude.toString(), 'longitude': _locationData.longitude.toString()};

    Future.delayed(Duration(milliseconds: 200)).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SelectCityPage(
            pushLocationData: RedirectPage.pushLocationData,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (consumerContext, model, child) {
        if (model.isOnline != null) {
          return model.isOnline
              ? Stack(
                  children: [
                    Background(),
                    _isLoading
                        ? Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Center(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "Checking your location information",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Scaffold(
                            key: _scaffoldKey,
                            backgroundColor: Colors.transparent,
                            body: SafeArea(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 18),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Text("Location Permission", style: TextStyle(fontSize: 28, color: Colors.white)),
                                                  SizedBox(height: 9),
                                                  Text(
                                                    "In order to use the application, you need to give location permission.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 45),
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 125,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 100),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(width: 2.0, color: Colors.white),
                                                minimumSize: Size(150, 50),
                                                primary: Colors.white,
                                                backgroundColor: Colors.transparent,
                                              ),
                                              onPressed: () => checkLocationServicePermission(),
                                              child: Text("Allow", style: TextStyle(fontSize: 16)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                )
              : NoInternetPage();
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
