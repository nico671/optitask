import 'package:flutter/material.dart';
import 'package:optitask/models/weightslidertypes.dart';

import '../../../providers/algorithm_values_provider.dart';
import '../../../providers/theme_provider.dart';

Widget OnboardingSlidersView(ThemeProvider themeProvider,
    AlgorithmValuesProvider onboardingProvider, SliderTypes sliderType) {
  List<double> weightSliders = [];

  String title = "";
  String prompt1 = "";
  String prompt2 = "";
  String prompt3 = "";
  switch (sliderType) {
    case SliderTypes.value:
      {
        weightSliders = onboardingProvider.userJSON["user_data"]
            ["work_constants_preferences"]["weights"]["value_weights"];
        title = "Personal Values";
        prompt1 =
            'How much do you want to prioritize the amount of time left until submission?';
        prompt2 = 'How important is your current grade in the class?';
        prompt3 =
            'How much do you want to prioritize assignments by how much you like the class (max of 20)?';
      }
      break;
    case SliderTypes.time:
      {
        // TODO: Handle this case.
        weightSliders = onboardingProvider.userJSON["user_data"]
            ["work_constants_preferences"]["weights"]["time_weights"];
        title = "Time Values";
        prompt1 =
            'How important is the difficulty of the class to how much time you will spend on an assignment?';
        prompt2 =
            'How does the type of assignment (weight on final grade) affect the time you will spend on an assignment?';
        prompt3 =
            'How important is how much you like the class to how much time you will spend on an assignment';
      }

      break;
    case SliderTypes.fatigue:
      {
        // TODO: Handle this case.
        weightSliders = onboardingProvider.userJSON["user_data"]
            ["work_constants_preferences"]["weights"]["fatigue_weights"];
        title = "Fatigue Values";
        prompt1 =
            'How important is the difficulty of the class to your homework fatigue?';
        prompt2 =
            'How does the type of assignment (weight on final grade) affect your fatigue?';
        prompt3 =
            'How much does liking the class reduce fatigue from doing the assignments';
      }

      break;
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: themeProvider.theme.primaryTextColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 16.0),
                //   child: Text(
                //     "Adjust how important each of these values are to you. This will help OptiTask tailor it's suggestions specifically to your preferences.",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         color: themeProvider.theme.primaryTextColor,
                //         fontSize: 20),
                //   ),
                // ),
                Column(
                  children: [
                    Text(prompt1,
                        style: TextStyle(
                            color: themeProvider.theme.primaryTextColor,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            inactiveColor: themeProvider.theme.accentColor
                                .withOpacity(0.5),
                            thumbColor: themeProvider.theme.accentColor,
                            activeColor: themeProvider.theme.accentColor,
                            secondaryActiveColor: themeProvider
                                .theme.accentColor
                                .withOpacity(0.5),
                            value: weightSliders[0].toDouble(),
                            onChanged: (value) {
                              setState(
                                () {
                                  weightSliders[0] = value;
                                  _updateWeight(weightSliders, sliderType);
                                },
                              );
                            },
                            max: 100.0,
                            min: 0.0,
                          ),
                        ),
                        Text(weightSliders[0].toInt().toString(),
                            style: TextStyle(
                                color: themeProvider.theme.primaryTextColor))
                      ],
                    ),
                    Text(prompt2,
                        style: TextStyle(
                            color: themeProvider.theme.primaryTextColor,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            inactiveColor: themeProvider.theme.accentColor
                                .withOpacity(0.5),
                            thumbColor: themeProvider.theme.accentColor,
                            activeColor: themeProvider.theme.accentColor,
                            secondaryActiveColor: themeProvider
                                .theme.accentColor
                                .withOpacity(0.5),
                            value: weightSliders[1].toDouble(),
                            onChanged: (value) {
                              setState(
                                () {
                                  weightSliders[1] = value;
                                  _updateWeight(weightSliders, sliderType);
                                },
                              );
                            },
                            max: 100.0,
                            min: 0.0,
                          ),
                        ),
                        Text(weightSliders[1].toInt().toString(),
                            style: TextStyle(
                                color: themeProvider.theme.primaryTextColor))
                      ],
                    ),
                    Text(prompt3,
                        style: TextStyle(
                            color: themeProvider.theme.primaryTextColor,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            inactiveColor: themeProvider.theme.accentColor
                                .withOpacity(0.5),
                            thumbColor: themeProvider.theme.accentColor,
                            activeColor: themeProvider.theme.accentColor,
                            secondaryActiveColor: themeProvider
                                .theme.accentColor
                                .withOpacity(0.5),
                            value: weightSliders[2].toDouble(),
                            onChanged: (value) {
                              if (sliderType == SliderTypes.value) {
                                if (value > 20) {
                                  value = 20;
                                  double leftover = 80 -
                                      (weightSliders[0] + weightSliders[1]);
                                  weightSliders[0] =
                                      weightSliders[0] + leftover / 2;
                                  weightSliders[1] =
                                      weightSliders[1] + leftover / 2;
                                  return;
                                }
                              }

                              setState(
                                () {
                                  weightSliders[2] = value;
                                  _updateWeight(weightSliders, sliderType);
                                },
                              );
                            },
                            max: 100.0,
                            min: 0.0,
                          ),
                        ),
                        Text(weightSliders[2].toInt().toString(),
                            style: TextStyle(
                                color: themeProvider.theme.primaryTextColor))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void updateJson(SliderTypes sliderTypes, List<double> weightSliders,
    AlgorithmValuesProvider onboardingProvider) {
  switch (sliderTypes) {
    case SliderTypes.time:
      {
        onboardingProvider.userJSON["user_data"]["work_constants_preferences"]
            ["weights"]["time_weights"] = weightSliders;
      }
      break;
    case SliderTypes.value:
      {
        onboardingProvider.userJSON["user_data"]["work_constants_preferences"]
            ["weights"]["value_weights"] = weightSliders;
      }
      break;
    case SliderTypes.fatigue:
      {
        onboardingProvider.userJSON["user_data"]["work_constants_preferences"]
            ["weights"]["fatigue_weights"] = weightSliders;
      }
      break;
  }
}

void _updateWeight(List<double> sliders, SliderTypes sliderType) {
  double sumOfSliderValues = 0;
  for (var i = 0; i < sliders.length; i++) {
    sumOfSliderValues = sumOfSliderValues + sliders[i];
  }

  for (var j = 0; j < sliders.length; j++) {
    if (sliders[j] != sumOfSliderValues) {
      sliders[j] = ((sliders[j] / sumOfSliderValues) * 100);
    }
  }
  if (sliderType == SliderTypes.value) {
    if (sliders[2] > 20) {
      double leftover = 80 - (sliders[0] + sliders[1]);
      sliders[0] = sliders[0] + leftover / 2;
      sliders[1] = sliders[1] + leftover / 2;
      sliders[2] = 20;
    }
  }
}
