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
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
import 'package:traffic_congestion/views/shared/shared_values.dart';
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
                    hintText: 'Enter your name',
                    controller: _name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'Enter your last ID',
                    controller: _idNumber,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'ID number is required';
                      }
                      if (value?.length != 10) {
                        return 'ID number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'Enter your phone',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'Enter your email',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'Email is required';
                      }
                      if (!EmailValidator.validate(value!)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  TextFieldWidget(
                    hintText: 'Enter your password',
                    controller: _password,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isNotEmpty != true) {
                        return 'Password is required';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
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
                          'Forget Password',
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
                                context, 'Success Register');
                          } else if (result is Error){
                            SharedComponents.showSnackBar(
                                context,result.message??'An error occurred');
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: SharedValues.padding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
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
                          'Register',
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
