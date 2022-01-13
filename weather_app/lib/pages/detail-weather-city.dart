import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailWeatherCityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailWeatherCityPageState();
}

class _DetailWeatherCityPageState extends State<DetailWeatherCityPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [Text("DetailWeatherCityPage")],
      ),
    ));
  }
}
