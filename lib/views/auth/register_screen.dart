import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/models/user.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/data/providers/auth_provider.dart';
import 'package:traffic_congestion/views/shared/assets_variables.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/dropdown_field_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _idNumber = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    hintText: 'enter-name'.tr(),
                    controller: _name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'name-is-required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'enter-ID'.tr(),
                    controller: _idNumber,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'number-required'.tr();
                      }
                      if (value?.length != 10) {
                        return 'number-digits'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'enter-phone'.tr(),
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'Phone-required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'enter-your-email'.tr(),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'email-required'.tr();
                      }
                      if (!EmailValidator.validate(value!)) {
                        return 'email-invalid-email'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'enter-password'.tr(),
                    controller: _password,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'password-required'.tr();
                      }
                      if (value!.length < 6) {
                        return 'password-must-characters'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  DropdownFieldWidget(
                    items: [
                      DropdownMenuItemModel(text: 'ذكر', id: 1),
                      DropdownMenuItemModel(text: 'انثى', id: 2),
                    ],
                    onChanged: (value) {
                      gender = value?.text;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Gender is required';
                      }
                      return null;
                    },
                    hintText: 'Enter your gender',
                    keyDropDown: GlobalKey(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {},
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent,
                          ),
                        ),
                        child: Text(
                          'forget-password'.tr(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ButtonWidget(
                      isCircle: true,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final User user = User(
                              email: _email.text,
                              name: _name.text,
                              idNumber: _idNumber.text,
                              phone: _phone.text,
                              password: _password.text);
                          Result result = await Provider.of<AuthProvider>(
                                  context,
                                  listen: false)
                              .register(user);
                          if (!mounted) return;
                          if (result is Success) {
                            SharedComponents.showSnackBar(
                                context, 'success-register'.tr());
                          } else if (result is Error){
                            SharedComponents.showSnackBar(
                                context,result.message??'error-occurred'.tr());
                          }
                        }
                      },
                      child: Text(
                        'login'.tr(),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "do-not-have-account".tr(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent,
                          ),
                        ),
                        child: Text(
                          'register'.tr(),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
