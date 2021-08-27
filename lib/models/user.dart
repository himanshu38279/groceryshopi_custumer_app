import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';

class User extends ChangeNotifier {
  String id;
  String lastIpAddress;
  String ipAddress;
  String username;
  String password;
  String salt;
  String email;
  String activationCode;
  String forgottenPasswordCode;
  String forgottenPasswordTime;
  String rememberCode;
  String deviceToken;
  String createdOn;
  String lastLogin;
  String active;
  String firstName;
  String lastName;
  String company;
  String phone;
  String avatar;
  String gender;
  String groupId;
  String warehouseId;
  String billerId;
  String companyId;
  String showCost;
  String showPrice;
  String awardPoints;
  String viewRight;
  String editRight;
  String allowDiscount;

  bool get isLoggedIn => this.phone != null;

  Future<void> update() async {
    final _user = await this.getCurrentUser();
    this.updateUserInProvider(_user);
  }

  Future<bool> login({@required String phoneNumber}) async {
    final token = await Repository.loginUser(phoneNumber: phoneNumber);
    if (token == null)
      return false;
    else {
      await SharedPrefs.setString(SharedPrefs.accessTokenString, token);
      accessToken = token;
      print('ACCESS TOKEN $accessToken');
      await this.update();
      return true;
    }
  }

  Future<User> getCurrentUser() async {
    final token = SharedPrefs.getString(SharedPrefs.accessTokenString);
    User _user = User();
    accessToken = token;
    if (token == null)
      _user = User();
    else {
      _user = await Repository.getUserProfile();
      if (_user == null)
        await SharedPrefs.remove(SharedPrefs.accessTokenString);
    }
    print('ACCESS TOKEN $accessToken');
    return _user;
  }

  Future<void> logout() async {
    await SharedPrefs.remove(SharedPrefs.accessTokenString);
    this.clear();
    accessToken = null;
    //TODO: logout from api
  }

  void updateUserInProvider(User user) {
    if (user == null) return;
    this.id = user.id;
    this.lastIpAddress = user.lastIpAddress;
    this.ipAddress = user.ipAddress;
    this.username = user.username;
    this.password = user.password;
    this.salt = user.salt;
    this.email = user.email;
    this.activationCode = user.activationCode;
    this.forgottenPasswordCode = user.forgottenPasswordCode;
    this.forgottenPasswordTime = user.forgottenPasswordTime;
    this.rememberCode = user.rememberCode;
    this.deviceToken = user.deviceToken;
    this.createdOn = user.createdOn;
    this.lastLogin = user.lastLogin;
    this.active = user.active;
    this.firstName = user.firstName;
    this.lastName = user.lastName;
    this.company = user.company;
    this.phone = user.phone;
    this.avatar = user.avatar;
    this.gender = user.gender;
    this.groupId = user.groupId;
    this.warehouseId = user.warehouseId;
    this.billerId = user.billerId;
    this.companyId = user.companyId;
    this.showCost = user.showCost;
    this.showPrice = user.showPrice;
    this.awardPoints = user.awardPoints;
    this.viewRight = user.viewRight;
    this.editRight = user.editRight;
    this.allowDiscount = user.allowDiscount;
    notifyListeners();
  }

  void clear() {
    this.id = null;
    this.lastIpAddress = null;
    this.ipAddress = null;
    this.username = null;
    this.password = null;
    this.salt = null;
    this.email = null;
    this.activationCode = null;
    this.forgottenPasswordCode = null;
    this.forgottenPasswordTime = null;
    this.rememberCode = null;
    this.deviceToken = null;
    this.createdOn = null;
    this.lastLogin = null;
    this.active = null;
    this.firstName = null;
    this.lastName = null;
    this.company = null;
    this.phone = null;
    this.avatar = null;
    this.gender = null;
    this.groupId = null;
    this.warehouseId = null;
    this.billerId = null;
    this.companyId = null;
    this.showCost = null;
    this.showPrice = null;
    this.awardPoints = null;
    this.viewRight = null;
    this.editRight = null;
    this.allowDiscount = null;
    notifyListeners();
  }

  User({
    this.id,
    this.lastIpAddress,
    this.ipAddress,
    this.username,
    this.password,
    this.salt,
    this.email,
    this.activationCode,
    this.forgottenPasswordCode,
    this.forgottenPasswordTime,
    this.rememberCode,
    this.deviceToken,
    this.createdOn,
    this.lastLogin,
    this.active,
    this.firstName,
    this.lastName,
    this.company,
    this.phone,
    this.avatar,
    this.gender,
    this.groupId,
    this.warehouseId,
    this.billerId,
    this.companyId,
    this.showCost,
    this.showPrice,
    this.awardPoints,
    this.viewRight,
    this.editRight,
    this.allowDiscount,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastIpAddress = json['last_ip_address'];
    ipAddress = json['ip_address'];
    username = json['username'];
    password = json['password'];
    salt = json['salt'];
    email = json['email'];
    activationCode = json['activation_code'];
    forgottenPasswordCode = json['forgotten_password_code'];
    forgottenPasswordTime = json['forgotten_password_time'];
    rememberCode = json['remember_code'];
    deviceToken = json['device_token'];
    createdOn = json['created_on'];
    lastLogin = json['last_login'];
    active = json['active'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    phone = json['phone'];
    avatar = json['avatar'];
    gender = json['gender'];
    groupId = json['group_id'];
    warehouseId = json['warehouse_id'];
    billerId = json['biller_id'];
    companyId = json['company_id'];
    showCost = json['show_cost'];
    showPrice = json['show_price'];
    awardPoints = json['award_points'];
    viewRight = json['view_right'];
    editRight = json['edit_right'];
    allowDiscount = json['allow_discount'];
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['last_ip_address'] = this.lastIpAddress;
    data['ip_address'] = this.ipAddress;
    data['username'] = this.username;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['email'] = this.email;
    data['activation_code'] = this.activationCode;
    data['forgotten_password_code'] = this.forgottenPasswordCode;
    data['forgotten_password_time'] = this.forgottenPasswordTime;
    data['remember_code'] = this.rememberCode;
    data['device_token'] = this.deviceToken;
    data['created_on'] = this.createdOn;
    data['last_login'] = this.lastLogin;
    data['active'] = this.active;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['group_id'] = this.groupId;
    data['warehouse_id'] = this.warehouseId;
    data['biller_id'] = this.billerId;
    data['company_id'] = this.companyId;
    data['show_cost'] = this.showCost;
    data['show_price'] = this.showPrice;
    data['award_points'] = this.awardPoints;
    data['view_right'] = this.viewRight;
    data['edit_right'] = this.editRight;
    data['allow_discount'] = this.allowDiscount;
    return data;
  }
}
