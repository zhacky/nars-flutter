import 'dart:convert';
import 'package:nars/models/demo/doctor_demo.dart';
import 'package:http/http.dart' as http;

class DoctorApi {
  // static Future<List<Doctor>> getDoctor2() async {
  //   var uri = Uri.https(
  //     'us-doctors-and-medical-professionals.p.rapidapi.com',
  //     '/search_npi',
  //     {'npi': '1033112214'},
  //   );
  //   final response = await http.get(uri, headers: {
  //     'x-rapidapi-host': 'us-doctors-and-medical-professionals.p.rapidapi.com',
  //     'x-rapidapi-key': '1bc4d28367mshaccd1f28b5932e1p168279jsn2dc2377915c9'
  //   });

  //   Map data = jsonDecode(response.body);
  //   List _temp = [];

  //   for (var i in data['Data']) {
  //     _temp.add(i);
  //   }

  //   return Doctor.doctorsFromSnapshot(_temp);
  // }

  // static Future<List<Doctor>> getDoctor() async {
  //   var uri = Uri.https(
  //     '18.118.14.227',
  //     '/index.php/api/customer/get_doctors',
  //   );
  //   final response = await http.post(uri);

  //   Map data = jsonDecode(response.body);
  //   List _temp = [];

  //   for (var i in data['result']['doctors']) {
  //     _temp.add(i);
  //   }

  //   return Doctor.doctorsFromSnapshot(_temp);
  // }
}
