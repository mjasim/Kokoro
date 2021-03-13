
class GlobalMapService {

  List<Map> getData(zoomLevel) {
    return [
      {
        'lat':  51.507359,
        'lon': -0.136439,
        'activity': 40,
        'location': 'london',
      },
      {
        'lat':  40.730610,
        'lon': -73.935242,
        'activity': 100,
        'location': 'new york',
      },
      {
        'lat':  32.779167,
        'lon': -96.808891,
        'activity': 5,
        'location': 'dallas',
      },
    ];
  }
}