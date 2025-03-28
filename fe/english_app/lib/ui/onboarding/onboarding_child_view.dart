import 'package:english_app/ui/onboarding/onboarding_child_page.dart';
import 'package:english_app/ultils.enums/onboarding_page_position.dart';
import 'package:flutter/material.dart';

class OnboardingChildView extends StatefulWidget {
  const OnboardingChildView({super.key});

  @override
  State<OnboardingChildView> createState() => _OnboardingChildViewState();
}

class _OnboardingChildViewState extends State<OnboardingChildView> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          OnboardingChildPage(
              onboardingPagePosition: OnboardingPagePosition.page1,
              nextOnPressed: () {
                _pageController.jumpToPage(1);
              }),
          OnboardingChildPage(
              onboardingPagePosition: OnboardingPagePosition.page2,
              nextOnPressed: () {
                _pageController.jumpToPage(2);
              }),
          OnboardingChildPage(
              onboardingPagePosition: OnboardingPagePosition.page3,
              nextOnPressed: () {
                _pageController.jumpToPage(1);
              })
        ],
      ),
    );
  }
}
