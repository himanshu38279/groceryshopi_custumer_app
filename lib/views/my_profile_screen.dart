import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/components/text_container.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';

// ignore: must_be_immutable
class MyProfileScreen extends StatelessWidget {
  static const id = 'my_profile_screen';

  User user;
  final profileData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (user.isLoggedIn)
              await user.update();
            else
              Fluttertoast.showToast(msg: "Please login");
          },
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              _buildInfoCard(
                context,
                title: "Username",
                subTitle: user.username,
              ),
              SizedBox(height: 10),
              _buildInfoCard(
                context,
                title: "Email",
                subTitle: user.email,
              ),
              SizedBox(height: 10),
              _buildInfoCard(
                context,
                title: "First Name",
                subTitle: user.firstName,
              ),
              SizedBox(height: 10),
              _buildInfoCard(
                context,
                title: "Last Name",
                subTitle: user.lastName,
              ),
              SizedBox(height: 10),
              _buildInfoCard(
                context,
                title: "Gender",
                subTitle: user.gender,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.edit),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => _EditProfileDialog(user),
          ),
        ),
      ),
    );
  }

  Card _buildInfoCard(
    BuildContext context, {
    @required String title,
    @required String subTitle,
  }) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle ?? ""),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final User user;

  const _EditProfileDialog(this.user);

  @override
  __EditProfileDialogState createState() => __EditProfileDialogState();
}

class __EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final profileMap = <String, String>{};

  @override
  void initState() {
    profileMap['username'] = widget.user.username;
    profileMap['email'] = widget.user.email;
    profileMap['first_name'] = widget.user.firstName;
    profileMap['last_name'] = widget.user.lastName;
    profileMap['gender'] = widget.user.gender;
    super.initState();
  }

  static final _genders = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    return CustomLoadingScreen(
      child: Dialog(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              MyTextField(
                labelText: "Username",
                defaultValue: profileMap['username'],
                onChanged: (String v) => profileMap['username'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please enter username";
                },
              ),
              SizedBox(height: 10),
              MyTextField(
                labelText: "Email",
                defaultValue: profileMap['email'],
                onChanged: (String v) => profileMap['email'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please enter your email address";
                  else if (!(v.contains("@") && v.contains(".")))
                    return "Please enter a valid email address";
                },
              ),
              SizedBox(height: 10),
              MyTextField(
                labelText: "First Name",
                defaultValue: profileMap['first_name'],
                onChanged: (String v) => profileMap['first_name'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please enter your first name";
                },
              ),
              SizedBox(height: 10),
              MyTextField(
                labelText: "Last Name",
                defaultValue: profileMap['last_name'],
                onChanged: (String v) => profileMap['last_name'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please enter your last name";
                },
              ),
              SizedBox(height: 10),
              Text(
                "Gender",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  for (String gender in _genders) ...[
                    Expanded(
                      child: TextContainer(
                        gender,
                        selected: profileMap['gender'] == gender.toLowerCase(),
                        onTap: () {
                          profileMap['gender'] = gender.toLowerCase();
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ],
              ),
              SizedBox(height: 20),
              MyButton(
                text: "Update Profile",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    if (profileMap['gender'] == null) {
                      Fluttertoast.showToast(msg: "Please select your gender");
                      return;
                    }
                    loadingController.startLoading();
                    final newUser = await Repository.updateProfile(
                      profileMap: profileMap,
                    );
                    loadingController.stopLoading();
                    if (newUser == null)
                      Fluttertoast.showToast(
                        msg:
                            "An error occurred while updating profile. Please try again later",
                      );
                    else
                      Fluttertoast.showToast(
                        msg: "Profile updated successfully",
                      );
                    widget.user.updateUserInProvider(newUser);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
