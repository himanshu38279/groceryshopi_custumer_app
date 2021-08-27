import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/primary_banner.dart';
import 'package:tbo_the_best_one/models/secondary_banner.dart';

class BannersController extends ChangeNotifier {
  List<PrimaryBanner> primaryBanners;
  List<SecondaryBanner> secondaryBanners;

  bool primaryBannersLoading;
  bool secondaryBannersLoading;

  BannersController() {
    primaryBanners = [];
    secondaryBanners = [];
    primaryBannersLoading = true;
    secondaryBannersLoading = true;
    this.update();
  }

  Future<void> update() async {
    await Future.wait([
      this._updatePrimaryBanners(),
      this._updateSecondaryBanners(),
    ]);
  }

  Future<void> _updatePrimaryBanners() async {
    primaryBannersLoading = true;
    notifyListeners();
    final temp = await Repository.getPrimaryBanners();
    primaryBanners = temp?.primaryBanners ?? [];
    primaryBannersLoading = false;
    notifyListeners();
  }

  Future<void> _updateSecondaryBanners() async {
    secondaryBannersLoading = true;
    notifyListeners();
    final temp = await Repository.getSecondaryBanners();
    secondaryBanners = temp?.secondaryBanners ?? [];
    secondaryBannersLoading = false;
    notifyListeners();
  }
}
