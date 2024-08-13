import 'package:flutter/material.dart';

import '../../../providers/theme_provider.dart';

Widget OnboardingIntro(ThemeProvider themeProvider) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Welcome to OptiTask!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.theme.primaryTextColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Optitask seamlessly integrates with your Canvas account, utilizing machine learning and a genetic scheduling algorithm to optimize your schedule. Take control, boost productivity, and tailor the algorithm to your needs through Optitask's personalized onboarding process.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: themeProvider.theme.primaryTextColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
