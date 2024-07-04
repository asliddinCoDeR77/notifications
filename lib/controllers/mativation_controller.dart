// import 'dart:convert';
// import 'package:notification/models/mativation_madel.dart';
// // ignore: depend_on_referenced_packages
// import 'package:http/http.dart' as http;

// class MativationController {
//   final List<MativationMadel> _list = [];

//   List<MativationMadel> get list {
//     return [..._list];
//   }

//   Future<void> getMativation() async {
//     Uri url = Uri.parse("https://zenquotes.io/api/random");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       List<dynamic> decodedData = jsonDecode(response.body);

//       List<Map<String, dynamic>> data =
//           decodedData.map((e) => e as Map<String, dynamic>).toList();

//       for (var user in data) {
//         MativationMadel newMotivation = MativationMadel.fromJson(user);
//         _list.add(newMotivation);
//       }
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notifications/models/mativation_madel.dart';

class MativationController {
  final List<MativationMadel> _list = [];

  List<MativationMadel> get list {
    return [..._list];
  }

  Future<void> getMativation() async {
    Uri url = Uri.parse("https://zenquotes.io/api/random");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic decodedData = jsonDecode(response.body);

      if (decodedData is List) {
        List<Map<String, dynamic>> data =
            decodedData.map((e) => e as Map<String, dynamic>).toList();
        for (var user in data) {
          MativationMadel newMotivation = MativationMadel.fromJson(user);
          _list.add(newMotivation);
        }
      } else if (decodedData is Map<String, dynamic>) {
        MativationMadel newMotivation = MativationMadel.fromJson(decodedData);
        _list.add(newMotivation);
      } else {
        // Handle unexpected response format
        print('Unexpected response format');
      }
    } else {
      print('Failed to load mativation: ${response.statusCode}');
    }
  }
}
