import 'dart:convert';
import 'package:nars/constants.dart';
import 'package:nars/models/payment/pay_param.dart';
import 'package:nars/models/payment/pay_response.dart';
import 'package:nars/models/payment/pay_subscription_param.dart';
import 'package:nars/models/payment/verify_payment_response.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class PaymentApi {
  static Future<dynamic> pay(PayParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Payment/Pay',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: payParamToJson(param),
    );
    print('Pay response.body');
    print(response.body);
    if (response.statusCode == 200) {
      return PayResponse.fromJson(jsonDecode(response.body));
    } else {
      return response.body;
    }
  }

  static Future<VerifyPaymentResponse> verifyPayment(String txnId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Payment/VerifyPaymentByTxnId/' + txnId,
      );
      final response = await http.get(uri,
        headers: {
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );

      return verifyPaymentResponseFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> paySubscription(PaySubscriptionParam param) async {
    var uri = Uri.https(
      omni_url,
      '/api/Payment/PaySubscription',
    );
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + TokenPreferences.getToken()!
      },
      body: paySubscriptionParamToJson(param),
    );
    print('Pay Subscription response.body');
    print(response.body);
    if (response.statusCode == 200) {
      return PayResponse.fromJson(jsonDecode(response.body));
    } else {
      return response.body;
    }
  }

  // static Future<dynamic> pay2C2P() async {
  //   var uri = Uri.https(
  //     'happyday.com.ph',
  //     '/api/Customer/Payment',
  //   );
  //   final response = await http.post(
  //     uri,
  //     body: {
  //       'merchantID': 'JT05',
  //       'invoiceNo':
  //           '00000' + DateFormat('MMddyyyyhhmmss').format(DateTime.now()),
  //       'description': 'item 1',
  //       'amount': '1420',
  //       'currencyCode': 'PHP',
  //       'backendReturnUrl':
  //           'https://happyday.com.ph/api/Customer/PaymentResponse',
  //     },
  //   );

  //   var data = jsonDecode(response.body);

  //   return data;
  // }
}
