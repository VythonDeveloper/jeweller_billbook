import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeweller_stockbook/Models/gold_price_model.dart';
import 'package:jeweller_stockbook/Models/silver_price_model.dart';
import 'package:jeweller_stockbook/utils/api_config.dart';

// final goldPrice = StateProvider<GoldModel?>((ref) => null);

final goldPriceProvider = FutureProvider<GoldModel?>(
  (ref) async {
    final res = await apiCallback(
      method: 'GET',
      url: 'https://gold-rates-india.p.rapidapi.com/api/state-gold-rates',
      header: {
        'X-RapidAPI-Key': 'a18010f01cmshaea7be3e2bb831ep146244jsnd20f6687f9aa',
        'X-RapidAPI-Host': 'gold-rates-india.p.rapidapi.com',
        "Content-Type": "application/json",
      },
    );
    if (res != null) {
      GoldModel? data;
      (res['GoldRate'] as List).forEach((e) {
        if (e['state'] == "West-Bengal") {
          data = GoldModel.fromMap(e)
              .copyWith(timeStamp: DateTime.now().millisecondsSinceEpoch);
        }
      });
      return data;
    }
    return null;
  },
);

final silverPriceProvider = FutureProvider<SilverModel?>(
  (ref) async {
    final res = await apiCallback(
      method: 'GET',
      url: 'https://gold-rates-india.p.rapidapi.com/api/state-silver-rates',
      header: {
        'X-RapidAPI-Key': 'a18010f01cmshaea7be3e2bb831ep146244jsnd20f6687f9aa',
        'X-RapidAPI-Host': 'gold-rates-india.p.rapidapi.com',
        "Content-Type": "application/json",
      },
    );
    if (res != null) {
      SilverModel? data;
      (res['SilverRates'] as List).forEach((e) {
        if (e['state'] == "West-Bengal") {
          data = SilverModel.fromMap(e)
              .copyWith(timeStamp: DateTime.now().millisecondsSinceEpoch);
        }
      });
      return data;
    }
    return null;
  },
);
