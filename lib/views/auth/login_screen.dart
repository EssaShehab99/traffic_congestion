import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_congestion/data/network/data_response.dart';
import 'package:traffic_congestion/views/auth/register_screen.dart';
import 'package:traffic_congestion/views/home/home_screen.dart';
import 'package:traffic_congestion/views/shared/assets_variables.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';
import 'package:traffic_congestion/views/shared/shared_components.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

import '../../data/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
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
                  Stack(
                    children: [
                      const Opacity(
                        opacity: 0.4,
                        child: Image(
                          image: AssetImage(AssetsVariable.standardKsaMap),
                        ),
                      ),
                      Positioned.fill(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 50, left: 40),
                          child: Text(
                            'welcome'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(fontSize: 25),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'login-continue'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    hintText: 'enter-username'.tr(),
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
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    hintText: 'enter-password'.tr(),
                    controller: _password,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isNotEmpty!=true) {
                        return 'please-enter-password'.tr();
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
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
                          Result result = await Provider.of<AuthProvider>(
                                  context,
                                  listen: false)
                              .login(_email.text, _password.text);
                          if (!mounted) return;
                          if (result is Success) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'do-not-have-account'.tr(),
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
