import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';

class AppSettingsController extends ChangeNotifier {
  Map<String, String> _settingsMap;
  Map<String, String> _faqsMap;
  String razorpayToken;

  bool settingsLoading;
  bool contactDetailsLoading;
  bool faqsLoading;
  bool razorpayLoading;

  AppSettingsController() {
    settingsLoading = true;
    contactDetailsLoading = true;
    faqsLoading = true;
    razorpayLoading = true;
    this.update();
  }

  void update() async {
    await Future.wait([
      this._updateRazorpayToken(),
      this._updateSettings(),
    ]);
  }

  double get withdrawalRequestAmount =>
      double.tryParse(_settingsMap['withdrawal_request_amount'] ?? '0');

  double get orderWalletPercent =>
      double.tryParse(_settingsMap['order_wallet_percent'] ?? '0');

  Map<String, String> get getSettings {
    this._updateSettings();
    return {
      'About Us': _settingsMap['about_us'],
      'Privacy Policy': _settingsMap['privacy_policy'],
      'Terms & Conditions': _settingsMap['terms_condition'],
      'Refund Policy': _settingsMap['return_and_refund'],
    };
  }

  Map<String, String> get getContactDetails {
    this._updateSettings();
    return {
      'support_mobile': _settingsMap['support_mobile'],
      'support_email': _settingsMap['support_email'],
      'whats_number': _settingsMap['whats_number'],
    };
  }

  Map<String, String> get getFAQs {
    this._updateFAQs();
    return _faqsMap;
  }

  Future<void> _updateRazorpayToken() async {
    if (razorpayToken == null) {
      final res = await Repository.getRazorpayCredentials();
      razorpayToken = res.razorpayKeyId;
      razorpayLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateFAQs() async {
    if (_faqsMap == null) {
      _faqsMap = {};
      final res = await Repository.getFAQs();
      if (res != null)
        for (Map<String, dynamic> data in res)
          _faqsMap[data['faq_question']] = data['faq_ans'];
      faqsLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateSettings() async {
    if (_settingsMap == null) {
      _settingsMap = {};
      final res = await Repository.getSettings();
      if (res != null)
        for (Map<String, dynamic> data in res)
          _settingsMap[data['key_name']] = data['value'];
      settingsLoading = false;
      contactDetailsLoading = false;
      notifyListeners();
    }
  }
}
