import 'dart:convert';

import 'package:nars/constants.dart';
import 'package:nars/models/banner/banner_photo.dart';
import 'package:nars/models/banner/banner_response.dart';
import 'package:nars/models/pagination/pagination_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class BannerApi {
  static Future<List<BannerPhoto>> getBanners() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Banner/GetBanners',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: paginationParamToJson(
          PaginationParam(
            pageCommon: PageCommon(
              page: 1,
              pageSize: 10,
            ),
          ),
        ),
      );
      return BannerResponse.fromJson(jsonDecode(response.body)).results;
    } catch (e) {
      rethrow;
    }
  }
}
