class NearCityResponse {
  int distance;
  String title;
  String location_type;
  int woeid;
  String latt_long;

  NearCityResponse(
    this.distance,
    this.title,
    this.location_type,
    this.woeid,
    this.latt_long,
  );

  factory NearCityResponse.fromJson(dynamic json) {
    return NearCityResponse(
      json['distance'] as int,
      json['title'] as String,
      json['location_type'] as String,
      json['woeid'] as int,
      json['latt_long'] as String,
    );
  }

  @override
  String toString() {
    return '{ '
        'title: ${this.title},'
        'distance: ${this.distance},'
        'location_type: ${this.location_type},'
        'woeid:${this.woeid},'
        'latt_long: ${this.latt_long} }';
  }
}
