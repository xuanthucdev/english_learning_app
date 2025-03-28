enum OnboardingPagePosition { page1, page2, page3 }

extension OnBoardingPagePositionExtention on OnboardingPagePosition {
  String OnboardingPageImage() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "assets/images/onboarding/onboarding1.jpg";
      case OnboardingPagePosition.page2:
        return "assets/images/onboarding/onboarding2.jpg";
      case OnboardingPagePosition.page3:
        return "assets/images/onboarding/onboarding3.jpg";
    }
  }

  String OnboardingPageTitle() {
    switch (this) {
      case OnboardingPagePosition.page1:
        return "page 1";
      case OnboardingPagePosition.page2:
        return "page 2";
      case OnboardingPagePosition.page3:
        return "page 3";
    }
  }
}
