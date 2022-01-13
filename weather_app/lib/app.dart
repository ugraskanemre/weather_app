import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/detail-weather-city.dart';
import 'package:weather_app/pages/no-internet.dart';
import 'package:weather_app/pages/redirect.dart';
import 'package:weather_app/pages/select-city.dart';
import 'dart:async';

import 'package:weather_app/utils/connectivity_provider.dart';

class WeatherApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherAppState();
  }
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: RedirectPage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hava Durumu',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: {
          '/': (context) => RedirectPage(),
          '/select-city': (context) => SelectCityPage(pushLocationData: RedirectPage.pushLocationData,),
          '/detail-weather-city': (context) => DetailWeatherCityPage(),
          '/no-internet': (context) => NoInternetPage(),
        },
        initialRoute: "/",
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text("Üzgünüz!"),
              centerTitle: true,
            ),
            body: Center(
              child: Text('Hay aksi, bir hata oluştu.'),
            ),
          ),
        ),
      ),
    );
  }
}
