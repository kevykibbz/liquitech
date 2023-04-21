import 'package:flutter/material.dart';
import 'package:liquitech/components/customIcon.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class BuildTextInputField extends StatefulWidget {
  final String label;
  final String validatorName;
  final String confirmPasswordValue;
  final TextEditingController controller;
  final IconData icon;
  final bool isLogin;
  final bool isPasswordType;
  final double numberValidator;
  final bool isNumber;
  final bool isPhoneType;
  final bool isConfirmPasswordType;
  const BuildTextInputField({
    Key? key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.validatorName,
    this.isLogin = false,
    this.isPasswordType = false,
    this.isPhoneType = false,
    this.isConfirmPasswordType = false,
    this.isNumber = false,
    this.numberValidator = 0.0,
    this.confirmPasswordValue = '',
  }) : super(key: key);

  @override
  State<BuildTextInputField> createState() => _BuildTextInputFieldState();
}

class _BuildTextInputFieldState extends State<BuildTextInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.isPhoneType
            ? IntlPhoneField(
                obscureText: false,
                cursorColor: Colors.blue,
                controller: widget.controller,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: 'Enter your ${widget.label}',
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: CustomSuffixIcon(icon: widget.icon),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 42),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28.0),
                      gapPadding: 10),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(28.0),
                      gapPadding: 10),
                ),
              )
            : TextFormField(
                obscureText: widget.isPasswordType,
                enableSuggestions: !widget.isPasswordType,
                autocorrect: !widget.isPasswordType,
                cursorColor: Colors.blue,
                controller: widget.controller,
                keyboardType: widget.isPasswordType
                    ? TextInputType.visiblePassword
                    : (widget.isNumber
                        ? TextInputType.number
                        : TextInputType.emailAddress),
                validator: (value) {
                  switch (widget.validatorName) {
                    case "amount":
                      if (value == null || value.isEmpty) {
                        return "Please enter amount.";
                      } else if (double.parse(value) < widget.numberValidator) {
                        var label = widget.label;
                        var amountString = widget.numberValidator.toString();
                        return "$label cant be less than ksh $amountString";
                      }
                      break;
                    case "displayName":
                      if (value == null || value.isEmpty) {
                        return "Please enter your full name";
                      }
                      break;
                    case "username":
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      } else if (value.length < 4) {
                        return "Username too short";
                      }
                      break;
                    case 'email':
                      if (value == null || value.isEmpty) {
                        return "Please enter your email address";
                      } else if (!value.contains('@') || !value.contains('.')) {
                        return "Enter a valid email address";
                      }
                      break;
                    case 'password':
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      } else if (!widget.isLogin && value.length < 6) {
                        return "password too short.Max of 6 chars or long";
                      }
                      break;
                    case 'oldpassword':
                      if (value == null || value.isEmpty) {
                        return "Please enter your old password";
                      } 
                      break;
                    case 'confirm password':
                      if (value == null || value.isEmpty) {
                        return "Please enter confirm password";
                      }
                      break;
                    default:
                      return null;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: 'Enter your ${widget.label}',
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: CustomSuffixIcon(icon: widget.icon),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 42),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 10),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 10),
                ),
              ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
