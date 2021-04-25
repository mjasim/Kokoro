import 'package:http/http.dart' as http;

class GoogleLocationService {
  String apiKey = 'AIzaSyB4vwPM5fwg6M-LUoo6mqbflDtDNXodOKs';

  void getSuggestedLocations(String queryText) async {
    String urlBase = 'cors-anywhere.herokuapp.com';
    String restOfUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$queryText&key=$apiKey';
    http.Response response = await http.get(Uri.http(urlBase, restOfUrl));
    print(response.body);
  }

}