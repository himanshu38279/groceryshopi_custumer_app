import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/offer.dart';

class OffersController extends ChangeNotifier {
  List<Offer> offers;
  // List<Offer> staticOffers;

  bool offersLoading;
  // bool staticOffersLoading;

  OffersController() {
    offers = [];
    // staticOffers = [];
    offersLoading = true;
    // staticOffersLoading = true;
    this.update();
  }

  Future<void> update() async {
    await Future.wait([
      this._updateOffers(),
      // this._updateStaticOffers(),
    ]);
  }

  Future<void> _updateOffers() async {
    offersLoading = true;
    notifyListeners();
    final temp = await Repository.getOffers();
    offers = temp?.offers ?? [];
    offersLoading = false;
    notifyListeners();
  }

  // Future<void> _updateStaticOffers() async {
  //   staticOffersLoading = true;
  //   notifyListeners();
  //   final temp = await Repository.getStaticOffers();
  //   staticOffers = temp?.offers ?? [];
  //   staticOffersLoading = false;
  //   notifyListeners();
  // }
}
