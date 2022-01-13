import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app/entities/near-city.dart';
import 'package:weather_app/pages/no-internet.dart';
import 'package:weather_app/utils/connectivity_provider.dart';
import 'package:weather_app/widgets/modal.dart';

class SelectCityPage extends StatefulWidget {
  Map pushLocationData;

  SelectCityPage({Key? key, required this.pushLocationData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  String latitude = "";
  String longitude = "";
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

  Future<void> getNearCities() async {
    setState(() {
      _isLoading = true;
    });
    var response = await http.get(Uri.parse("https://www.metaweather.com/api/location/search/?lattlong=$latitude,$longitude")).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    if (response.statusCode == 200) {
      var cityObjsJson = jsonDecode(response.body) as List;
      nearCityList = cityObjsJson.map((tagJson) => NearCityResponse.fromJson(tagJson)).toList();

      nearCityList.forEach((city) {
        _items_near_city_dropdown.add(
          (DropdownMenuItem(
            child: Text(
              "${city.title}",
              style: TextStyle(color: Color(0xFF117BD6)),
            ),
            value: city.woeid,
          )),
        );
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (consumerContext, model, child) {
      if (model.isOnline != null) {
        return model.isOnline
            ? Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple,
                          Colors.orange,
                        ],
                      ),
                    ),
                  ),
                  _isLoading
                      ? Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Center(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Yakın bölgenizdeki şehirler aranıyor...",
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
                                        "${nearCityList[0].title}",
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
                                                Text("Şehir Seçiniz", style: TextStyle(fontSize: 28, color: Colors.white)),
                                                SizedBox(height: 9),
                                                Text(
                                                  "Hava durumunu görüntülemek istediğiniz şehri aşağıdan seçiniz.",
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
                                                        label: "Şehirler",
                                                        items: _items_near_city_dropdown,
                                                        valueChanged: (val) {
                                                          print(val.toString());
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
