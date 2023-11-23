import 'package:nars/constants.dart';
import 'package:nars/models/payment_channel/payment_channel.dart';
import 'package:nars/models/processors/processors.dart';
import 'package:nars/models/wallet/wallet.dart';
import 'package:nars/models/wallet/withdrawal_param.dart';
import 'package:nars/preferences/token_pref.dart';
import 'package:http/http.dart' as http;

class WalletApi {
  static Future<Wallet> getBalance(int userId) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Wallet/GetUserBalanceById/$userId',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return walletFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> withdraw(
      UserRequestForWithdrawalParam param) async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Wallet/UserRequestForWithdrawal',
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
        body: userRequestForWithdrawalParamToJson(
          param,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<PaymentChannel>> getPaymentChannels() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Wallet/GetPaymentChannels',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return paymentChannelsFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Processor>> getProcessors() async {
    try {
      var uri = Uri.https(
        omni_url,
        '/api/Wallet/GetProcessors',
      );
      final response = await http.get(
        uri,
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + TokenPreferences.getToken()!
        },
      );
      return processorsFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
