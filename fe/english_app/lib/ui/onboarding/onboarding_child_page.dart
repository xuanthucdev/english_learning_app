import 'package:english_app/ultils.enums/onboarding_page_position.dart';
import 'package:flutter/material.dart';

class OnboardingChildPage extends StatelessWidget {
  const OnboardingChildPage(
      {super.key,
      required this.onboardingPagePosition,
      required this.nextOnPressed});
  final OnboardingPagePosition onboardingPagePosition;
  final VoidCallback nextOnPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildOnBoardingImage(),
          _buildPageControl(),
          _buildTitle(),
          _buildNextButton()
        ],
      ),
    );
  }

  Widget _buildOnBoardingImage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100),
      child: Image.asset(onboardingPagePosition.OnboardingPageImage(),
          width: 300, height: 300, fit: BoxFit.contain),
    );
  }

  Widget _buildPageControl() {
    return Container();
  }

  Widget _buildTitle() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              onboardingPagePosition.OnboardingPageTitle(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  Widget _buildNextButton() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          SizedBox(
            width: 320,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                nextOnPressed.call();
              },
              child: Text("Next",
                  style: TextStyle(color: Colors.white, fontSize: 17)),
            ),
          ),
        ],
      ),
    );
  }
}
