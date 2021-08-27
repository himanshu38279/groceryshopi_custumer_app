import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/address.dart';

class AddressController extends ChangeNotifier {
  Map<String, Address> _addressesMap;
  bool addressesLoading;

  AddressController() {
    _addressesMap = {};
    addressesLoading = true;
  }

  void clear() {
    _addressesMap = {};
    addressesLoading = true;
    notifyListeners();
  }

  List<Address> get addresses => _addressesMap.values?.toList() ?? [];

  Future<void> update() async {
    final getAddress = await Repository.getAddresses();
    final res = getAddress?.addresses ?? [];
    if (res.isNotEmpty)
      for (Address address in res) _addressesMap[address.addressId] = address;
    this.addressesLoading = false;
    notifyListeners();
  }

  void addAddress(Address newAddress) {
    _addressesMap[newAddress.addressId] = newAddress;
    notifyListeners();
  }

  void updateAddress({
    @required String addressId,
    @required Address address,
  }) {
    _addressesMap[addressId] = address;
    notifyListeners();
  }

  void deleteAddress(String addressId) {
    _addressesMap.remove(addressId);
    notifyListeners();
  }

  String getMapAddress(String addressId) {
    // FIXME: what if address used in order details but deleted by user??
    return _addressesMap[addressId]?.mapAddress;
  }
}
