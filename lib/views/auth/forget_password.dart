// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/data/models/user.dart';
// import '/data/providers/auth_provider.dart';
// import '/data/utils/utils.dart';
// import '/views/auth/login_screen.dart';
// import '/views/auth/verify_otp.dart';
// import '/views/shared/button_widget.dart';
// import '/views/shared/shared_components.dart';
// import '/views/shared/shared_values.dart';
// import '/views/shared/text_field_widget.dart';
//
// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({Key? key}) : super(key: key);
//
//   @override
//   State<ForgetPassword> createState() => _ForgetPasswordState();
// }
//
// class _ForgetPasswordState extends State<ForgetPassword> {
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController confirmPasswordController;
//   final _formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     confirmPasswordController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             SharedComponents.appBar(title: "forget-password".tr()),
//             Expanded(
//                 flex: 2,
//                 child: Form(
//                   key: _formKey,
//                   child: ListView(
//                     padding: const EdgeInsets.all(SharedValues.padding),
//                     children: [
//                       SizedBox(
//                         height: 200,
//                         child: Center(
//                             child: Text("forget-password".tr(),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .headline1
//                                     ?.copyWith(
//                                         color:
//                                             Theme.of(context).primaryColor))),
//                       ),
//                       const SizedBox(height: SharedValues.padding),
//                       TextFieldWidget(
//                           validator: (value) {
//                             if (value == null) {
//                               return "field-required".tr();
//                             } else if (!Utils.validateEmail(value)) {
//                               return "invalid-email".tr();
//                             }
//                             return null;
//                           },
//                           controller: emailController,
//                           hintText: "email".tr()),
//                       const SizedBox(height: SharedValues.padding),
//                       TextFieldWidget(
//                         controller: passwordController,
//                         hintText: "password".tr(),
//                         validator: (value) {
//                           if (value != null && value.isNotEmpty) {
//                             return null;
//                           }
//                           return "field-required".tr();
//                         },
//                       ),
//                       const SizedBox(height: SharedValues.padding),
//                       TextFieldWidget(
//                         controller: confirmPasswordController,
//                         hintText: "confirm-password".tr(),
//                         textInputAction: TextInputAction.none,
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "field-required".tr();
//                           } else if (confirmPasswordController.text ==
//                               passwordController.text) {
//                             return null;
//                           }
//                           return "password-not-match".tr();
//                         },
//                       ),
//                       const SizedBox(height: SharedValues.padding * 3),
//                       ButtonWidget(
//                         minWidth: double.infinity,
//                         withBorder: false,
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             final provider = Provider.of<AuthProvider>(context,
//                                 listen: false);
//                             final user = User(
//                                 email: emailController.text,
//                                 password: passwordController.text);
//                             Result result = await provider.sendCode(user, true);
//                             if (result is Success) {
//                               // ignore: use_build_context_synchronously
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const VerifyOTP(isSignUp: false)));
//                             } else {
//                               // ignore: use_build_context_synchronously
//                               SharedComponents.showSnackBar(
//                                   context, "error-occurred".tr());
//                             }
//                           }
//                         },
//                         child: Text("reset".tr(),
//                             style: Theme.of(context).textTheme.button),
//                       ),
//                       const SizedBox(height: SharedValues.padding),
//                       Padding(
//                         padding: const EdgeInsets.all(SharedValues.padding),
//                         child: Row(
//                           children: [
//                             Text("remember-password".tr(),
//                                 style: Theme.of(context).textTheme.bodyText2),
//                             TextButton(
//                               onPressed: () async {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             const SignInScreen()));
//                               },
//                               child: Text("${"sign-in".tr()}?",
//                                   style: Theme.of(context).textTheme.headline5),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
