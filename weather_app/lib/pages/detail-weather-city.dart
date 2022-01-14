// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/entities/weekly-weather-location.dart';
import 'package:weather_app/pages/no-internet.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/utils/connectivity_provider.dart';
import 'package:weather_app/commons/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/widgets/background.dart';

class DetailWeatherCityPage extends StatefulWidget {
  int woeid;

  DetailWeatherCityPage({Key? key, required this.woeid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailWeatherCityPageState();
}

class _DetailWeatherCityPageState extends State<DetailWeatherCityPage> {
  late int _woeid;
  late bool _isLoading = true;
  ConsolidatedWeather currentWeather = ConsolidatedWeather();
  WeeklyWeatherLocationResponse weekWeathetherLocation = WeeklyWeatherLocationResponse();
  DateTime now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    _woeid = widget.woeid;
    getWeeklyWeatherLocation(_woeid);
  }

  Future<void> getWeeklyWeatherLocation(int _woeid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await LocationService().getWeeklyWeatherLocation(_woeid).then((response) {
        var mapResponse = json.decode(response.body);
        weekWeathetherLocation = WeeklyWeatherLocationResponse.fromJson(mapResponse);
        currentWeather = weekWeathetherLocation.consolidatedWeather!.first;
      }).whenComplete(() {
        print("getWeeklyWeatherLocation service completed");
        setState(() => _isLoading = false);
      });
    } catch (e) {
      print(e);
      setState(() => _isLoading = false);
    }
  }

  List<Widget> getFiveDaysWeather() {
    List<Widget> lst = [];
    if (weekWeathetherLocation == null) {
      lst.add(
        Column(
          children: <Widget>[
            SizedBox(height: 30),
            Center(
              child: Text(
                "Kayıt bulunamadı.",
              ),
            ),
          ],
        ),
      );
    } else {
      final today = new DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day));

      weekWeathetherLocation.consolidatedWeather!.forEach((day) {
        lst.add(
          Container(
            height: 90,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${day.applicableDate}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        today != day.applicableDate.toString()
                            ? Text(
                                "${DateFormat('EEEE').format(DateTime.parse(day.applicableDate.toString()))}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            : Text(
                                "Today",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      child: SvgPicture.network(
                        Config.API_IMAGE_URL + "${day.weatherStateAbbr}.svg",
                        height: 30,
                        placeholderBuilder: (BuildContext context) => Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      "${day.minTemp!.toStringAsFixed(0)}°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "/",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${day.maxTemp!.toStringAsFixed(0)}°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Icon(
                      Icons.invert_colors,
                      color: Colors.white,
                    ),
                    Text(
                      "  %${day.humidity}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      });
    }
    return lst;
  }

  List<Widget> getSourcesWeather() {
    List<Widget> lst = [];
    if (weekWeathetherLocation == null) {
      lst.add(
        Column(
          children: <Widget>[
            SizedBox(height: 30),
            Center(
              child: Text(
                "Kayıt bulunamadı.",
              ),
            ),
          ],
        ),
      );
    } else {
      final today = new DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day));

      weekWeathetherLocation.consolidatedWeather!.forEach((day) {
        lst.add(
          Container(
            height: 90,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${day.applicableDate}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        today != day.applicableDate.toString()
                            ? Text(
                                "${DateFormat('EEEE').format(DateTime.parse(day.applicableDate.toString()))}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            : Text(
                                "Today",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      child: SvgPicture.network(
                        Config.API_IMAGE_URL + "${day.weatherStateAbbr}.svg",
                        height: 30,
                        placeholderBuilder: (BuildContext context) => Container(child: const CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      "${day.minTemp!.toStringAsFixed(0)}°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${day.maxTemp!.toStringAsFixed(0)}°",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Icon(
                      Icons.invert_colors,
                      color: Colors.white,
                    ),
                    Text(
                      "  %${day.humidity}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      });
    }
    return lst;
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
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
                                children: const [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Bringing the weekly weather forecast...",
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
                                SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${weekWeathetherLocation.title}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 35,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: SvgPicture.network(
                                                Config.API_IMAGE_URL + "${weekWeathetherLocation.consolidatedWeather![0].weatherStateAbbr}.svg",
                                                height: 40,
                                                placeholderBuilder: (BuildContext context) => Container(child: const CircularProgressIndicator()),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              "${currentWeather.theTemp!.toStringAsFixed(0)}°",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${currentWeather.weatherStateName}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "H: ${currentWeather.maxTemp!.toStringAsFixed(0)}°",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Text(
                                              "L: ${currentWeather.minTemp!.toStringAsFixed(0)}°",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${DateFormat("yyyy-MM-dd  hh:mm:ss").format(DateTime.parse(weekWeathetherLocation.time.toString()))}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 60,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24, right: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: const [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "5-day weather forecasts",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24, right: 10),
                                          child: Column(
                                            children: [...getFiveDaysWeather()],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24, right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(width: 1.0, color: Colors.white),
                                                    bottom: BorderSide(width: 1.0, color: Colors.white),
                                                  ),
                                                ),
                                                height: 80,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Sunrise",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${DateFormat("hh:mm").format(DateTime.parse(weekWeathetherLocation.sunRise.toString()))}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(width: 1.0, color: Colors.white),
                                                    bottom: BorderSide(width: 1.0, color: Colors.white),
                                                  ),
                                                ),
                                                height: 80,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Sunset",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${DateFormat("hh:mm").format(DateTime.parse(weekWeathetherLocation.sunSet.toString()))}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24, right: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: const [
                                              Icon(
                                                Icons.source,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Sources",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24, right: 10, bottom: 50),
                                          child: GridView.count(
                                            shrinkWrap: true,
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 15.0,
                                            mainAxisSpacing: 20.0,
                                            physics: BouncingScrollPhysics(),
                                            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), //change the number as you want
                                            children: weekWeathetherLocation.sources!.map((source) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white),
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${source.title}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Crawle Rate",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${source.crawlRate}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => setState(() {
                                                        _launchInBrowser(source.url.toString());
                                                      }),
                                                      child: Text(
                                                        "Visit Site",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
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
