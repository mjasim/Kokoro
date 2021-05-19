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

  Future<Map> getPersonalMapData(String uid) async {
    HttpsCallable callable = functions.httpsCallable('getPersonalMapData');

    dynamic startDate = DateTime.utc(2021, 4, 10);
    dynamic stopDate = DateTime.utc(2021, 4, 20);
    
    String dateToString(date) {
      return "${date.day}-${date.month}-${date.year}";
    }

    print('getPersonalMapData $uid');
    final results = await callable({'userUid': uid, 'startDate':  dateToString(startDate), 'stopDate': dateToString(stopDate)});
    print(results.data);
    return results.data;
  }

  Future<Map> getPersonalHistoryData(String senderUid, String receiverUid) async {
    HttpsCallable callable = functions.httpsCallable('getPersonalHistoryData');

    dynamic startDate = DateTime.utc(2021, 4, 10);
    dynamic stopDate = DateTime.utc(2021, 4, 20);

    String dateToString(date) {
      return "${date.day}-${date.month}-${date.year}";
    }

    print('getPersonalHistoryData $senderUid, $receiverUid');
    final results = await callable({'senderUid': senderUid, 'receiverUid': receiverUid, 'startDate':  dateToString(startDate), 'stopDate': dateToString(stopDate)});
    print(results.data);
    return results.data;
  }

  Future<void> makePlanetUsedImagesCollection() async {
    HttpsCallable callable = functions.httpsCallable('makePlanetUsedImagesCollection');
    final results = await callable();
  }
}
