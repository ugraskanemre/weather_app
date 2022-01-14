import 'package:weather_app/commons/config.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<http.Response> getNearLocations(String latitude, String longitude) async {
    var response = await http.get(Uri.parse(Config.API_URL + 'location/search/?lattlong=$latitude,$longitude'));

    return response;
  }

  Future<http.Response> getWeeklyWeatherLocation(int woeid) async {
    var response = await http.get(Uri.parse(Config.API_URL + 'location/$woeid/'));

    return response;
  }
}
