import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/wallet.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class WalletController extends ChangeNotifier {
  Wallet walletPlusDetails;
  List<WalletStatement> _walletPlusStatements;

  bool walletPlusLoading;
  bool walletPlusStatementsLoading;

  Wallet walletDetails;
  List<WalletStatement> _walletStatements;

  bool walletLoading;
  bool walletStatementsLoading;

  bool get loading => walletPlusLoading && walletLoading;

  String get totalAmountAsString =>
      "$kRupeeSymbol ${(walletPlusDetails.wallet + walletDetails.wallet).toStringAsFixed(1)}";

  String get walletPlusAmountAsString =>
      "$kRupeeSymbol ${walletPlusDetails.wallet.toStringAsFixed(1)}";

  String get walletAmountAsString =>
      "$kRupeeSymbol ${walletDetails.wallet.toStringAsFixed(1)}";

  WalletController() {
    walletPlusLoading = true;
    walletPlusStatementsLoading = true;
    walletLoading = true;
    walletStatementsLoading = true;
  }

  void clear() {
    walletPlusLoading = true;
    walletPlusStatementsLoading = true;
    walletPlusDetails = null;
    _walletPlusStatements = null;
    walletLoading = true;
    walletStatementsLoading = true;
    walletDetails = null;
    _walletStatements = null;
    notifyListeners();
  }

  Future<void> update() async {
    await Future.wait([
      this._updateWalletPlus(),
      this._updateWallet(),
    ]);
  }

  List<WalletStatement> get walletStatements {
    this._updateWalletStatements();
    return _walletStatements ?? [];
  }

  List<WalletStatement> get walletPlusStatements {
    this._updateWalletPlusStatements();
    return _walletPlusStatements ?? [];
  }

  void setWalletPlus(Wallet newWalletPlus) {
    walletPlusDetails = newWalletPlus;
    // clear statements when resetting wallet to allow fetching statements when my wallet screen pushed
    _walletPlusStatements = null;
    walletPlusStatementsLoading = true;
    notifyListeners();
  }

  void setWallet(Wallet newWallet) {
    walletDetails = newWallet;
    // clear statements when resetting wallet to allow fetching statements when my wallet screen pushed
    _walletStatements = null;
    walletStatementsLoading = true;
    notifyListeners();
  }

  Future<void> _updateWalletPlusStatements() async {
    if (_walletPlusStatements == null) {
      final res = await Repository.getWalletPlusStatements();
      _walletPlusStatements = res ?? [];
      this.walletPlusStatementsLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateWalletPlus() async {
    if (walletPlusDetails == null) {
      final res = await Repository.getWalletPlusDetails();
      walletPlusDetails = res.wallet;
      this.walletPlusLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateWalletStatements() async {
    if (_walletStatements == null) {
      final res = await Repository.getWalletStatements();
      _walletStatements = res ?? [];
      this.walletStatementsLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateWallet() async {
    if (walletDetails == null) {
      final res = await Repository.getWalletDetails();
      walletDetails = res.wallet;
      this.walletLoading = false;
      notifyListeners();
    }
  }
}

