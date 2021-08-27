import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class MyTextField extends StatefulWidget {
  final Key key;
  final String labelText;
  final void Function(String) onChanged;
  final VoidCallback trailingFunction;
  final String defaultValue;
  final bool showTrailingWidget;
  final Widget trailing;
  final bool autofocus;
  final TextEditingController controller;
  final Function(String) validator;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final double borderRadius;
  final String hintText;
  final bool overrideHintText;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets contentPadding;
  final int maxLines;
  final bool readOnly;
  final int maxLength;
  final VoidCallback onTap;

  MyTextField({
    @required this.labelText,
    @required this.onChanged,
    this.key,
    this.onTap,
    this.hintText,
    this.trailingFunction,
    this.defaultValue,
    this.keyboardType,
    this.controller,
    this.validator,
    this.trailing,
    this.width,
    this.margin,
    this.maxLength,
    this.readOnly = false,
    this.maxLines = 1,
    this.overrideHintText = false,
    this.showTrailingWidget = true,
    this.autofocus = false,
    this.isPasswordField = false,
    this.borderColor = kAccentColor,
    this.focusedBorderColor = kAccentColor,
    this.borderWidth = 1,
    this.focusedBorderWidth = 2,
    this.borderRadius = 20,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    ),
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _showPassword;

  @override
  void initState() {
    _showPassword = !widget.isPasswordField;
    super.initState();
  }

  void toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.width,
      margin: this.widget.margin,
      child: TextFormField(
        onTap: this.widget.onTap,
        controller: this.widget.controller,
        validator: this.widget.validator,
        initialValue: this.widget.defaultValue,
        readOnly: this.widget.readOnly,
        textAlignVertical: TextAlignVertical.center,
        autofocus: this.widget.autofocus,
        keyboardType: this.widget.keyboardType,
        maxLength: this.widget.maxLength,
        onChanged: this.widget.onChanged,
        maxLines: this.widget.maxLines,
        obscureText: this.widget.isPasswordField ? !this._showPassword : false,
        decoration: InputDecoration(
          hintText: 'Enter Value',
          contentPadding: this.widget.contentPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(this.widget.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: this.widget.borderColor,
              width: this.widget.borderWidth,
            ),
            borderRadius: BorderRadius.circular(this.widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: this.widget.focusedBorderColor,
              width: this.widget.focusedBorderWidth,
            ),
            borderRadius: BorderRadius.circular(this.widget.borderRadius),
          ),
        ).copyWith(
          hintText: this.widget.overrideHintText
              ? this.widget.hintText
              : "Enter ${this.widget.labelText}",
          labelText: this.widget.labelText,
          suffixIcon: this.widget.showTrailingWidget
              ? this.widget.trailing == null
              ? this.widget.isPasswordField
              ? IconButton(
            padding: const EdgeInsets.only(right: 5.0),
            splashRadius: 1,
            color: Theme.of(context).accentColor,
            icon: _showPassword
                ? Icon(Icons.visibility, size: 25.0)
                : Icon(Icons.visibility_off, size: 25.0),
            onPressed: toggleShowPassword,
          )
              : null
              : this.widget.trailing
              : null,
        ),
      ),
    );
  }
}
