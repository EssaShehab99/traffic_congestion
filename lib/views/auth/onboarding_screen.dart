import 'package:flutter/material.dart';
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
              const Text("We help you reach your destination with the least possible traffic and the least time to wait for available parking.",
                style: TextStyle(
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

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Login",style: Theme.of(context).textTheme.button,),
                      Icon(Icons.arrow_forward,color: Theme.of(context).colorScheme.onPrimary,),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text('Don\'t have an account?',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  TextButton(
                    onPressed: () {

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
    );
  }
}
