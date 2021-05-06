import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert';

class FirebaseFunctionsService {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<List<Map>> locationAutoFill(String query) async {
    HttpsCallable callable = functions.httpsCallable('googleLocationAutoFill');
    final results = await callable({'queryText': query});
    final data = json.decode(results.data);
    print('predictions ${data['predictions']}');
    return data['predictions']
        .map<Map>((e) => {
      'placeId': e['place_id'],
      'fullName': e['description'],
      'cityName': e['terms'].first['value'],
      'country': e['terms'].last['value'],
    }).toList();
  }

  Future<Map> latLngFromPlaceId(String placeId) async {
    HttpsCallable callable = functions.httpsCallable('latLngFromPlaceId');
    final placeIdResults = await callable({'placeId': placeId});
    return json.decode(placeIdResults.data);
  }

  Future<Map> latLngFromName(String name) async {
    HttpsCallable callable = functions.httpsCallable('latLngFromName');
    final results = await callable({'name': name});
    print('latLngFromName ${results.data}');
    return json.decode(results.data);
  }
}
