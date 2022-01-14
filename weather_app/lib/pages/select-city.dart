// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/commons/config.dart';
import 'package:weather_app/entities/near-city.dart';
import 'package:weather_app/entities/weekly-weather-location.dart';
import 'package:weather_app/pages/detail-weather-city.dart';
import 'package:weather_app/pages/no-internet.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/utils/connectivity_provider.dart';
import 'package:weather_app/widgets/background.dart';
import 'package:weather_app/widgets/modal.dart';

class SelectCityPage extends StatefulWidget {
  static int woeid = 0;
  Map pushLocationData;

  SelectCityPage({Key? key, required this.pushLocationData}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<StatefulWidget> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  String latitude = "";
  String longitude = "";
  String currentCity = "";
  List<NearCityResponse> nearCityList = [];
  List<DropdownMenuItem> _items_near_city_dropdown = [];
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    latitude = widget.pushLocationData["latitude"];
    longitude = widget.pushLocationData["longitude"];
    getNearCities();
  }

  Future<void> firebaseLogEvent(selectedCityWoeid) async {
    await SelectCityPage.analytics.logEvent(
      name: 'select_city',
      parameters: <String, dynamic>{
        'woeid': selectedCityWoeid,
      },
    );

  }

  Future<void> getNearCities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Future.delayed(Duration(milliseconds: 200)).then((_) async {
        await LocationService().getNearLocations(latitude, longitude).then((value) {
          var cityObjsJson = jsonDecode(value.body) as List;
          nearCityList = cityObjsJson.map((tagJson) => NearCityResponse.fromJson(tagJson)).toList();
          currentCity = nearCityList.length > 0 ? nearCityList[0].title : "";

          nearCityList.forEach((city) {
            _items_near_city_dropdown.add(
              (DropdownMenuItem(
                child: Text(
                  "${city.title}",
                  style: TextStyle(color: Colors.lightBlue),
                ),
                value: city.woeid,
              )),
            );
          });
        }).whenComplete(() {
          print("getNearLocations service completed");
          setState(() => _isLoading = false);
        });
      });
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (consumerContext, model, child) {
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
                                    "Searching for cities near you...",
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
                          backgroundColor: Colors.transparent,
                          body: SafeArea(
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 100),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${currentCity}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24, right: 18),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 200),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              children: <Widget>[
                                                Text("Select a city", style: TextStyle(fontSize: 28, color: Colors.white)),
                                                SizedBox(height: 9),
                                                Text(
                                                  "Please select the city you want to view the weather forecast for below.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 65),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: ModalPicker(
                                                        key: UniqueKey(),
                                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                                        label: "Cities",
                                                        items: _items_near_city_dropdown,
                                                        valueChanged: (val) async {
                                                          SelectCityPage.woeid = val;
                                                          await firebaseLogEvent(SelectCityPage.woeid);
                                                          Future.delayed(Duration(milliseconds: 100)).then((_) {
                                                            Navigator.pushNamed(context, "/detail-weather-city");
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
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
    });
  }
}
