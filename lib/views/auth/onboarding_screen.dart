import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/auth/login_screen.dart';
import 'package:traffic_congestion/views/auth/register_screen.dart';
import 'package:traffic_congestion/views/shared/button_widget.dart';

class OnboardingScreeb extends StatefulWidget {
  const OnboardingScreeb({super.key});

  @override
  State<OnboardingScreeb> createState() => OonboardingScreebState();
}

class OonboardingScreebState extends State<OnboardingScreeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ksa_map.png',
                width: 500,
                height: 300,
              ),
              const SizedBox(height: 25),
               Text(
                "we-help-you-reach".tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "login".tr(),
                        style: Theme.of(context).textTheme.button,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
    );
  }
}
