class NearCityResponse {
  String title;
  String location_type;
  String latt_long;
  int distance;
  int woeid;

  NearCityResponse(
    this.title,
    this.location_type,
    this.latt_long,
    this.distance,
    this.woeid,
  );

  factory NearCityResponse.fromJson(dynamic json) {
    return NearCityResponse(
      json['title'] as String,
      json['location_type'] as String,
      json['latt_long'] as String,
      json['distance'] as int,
      json['woeid'] as int,
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
