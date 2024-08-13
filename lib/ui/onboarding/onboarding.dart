import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:optitask/models/weightslidertypes.dart';
import 'package:optitask/ui/onboarding/onboardingsteppages/onboardingtimepickerpage.dart';

import 'package:provider/provider.dart';

import '../../providers/algorithm_values_provider.dart';
import '../../providers/theme_provider.dart';
import 'onboardingsteppages/canvastokenbaseurl/onboardingcanvastokenbaseurlview.dart';
import 'onboardingsteppages/onboardingintropage.dart';
import 'onboardingsteppages/onboardingslidersview.dart';

class OnboardingUI extends StatefulWidget {
  const OnboardingUI({super.key});

  @override
  State<OnboardingUI> createState() => _OnboardingUIState();
}

class _OnboardingUIState extends State<OnboardingUI> {
  PageController onboardingPageViewController = PageController();
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<AlgorithmValuesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    double progress = currentPage /
        onboardingPages(themeProvider, onboardingProvider, context).length;
    return Scaffold(
        backgroundColor: themeProvider.theme.backgroundColor,
        body: Stack(children: [
          Positioned(
              top: 0,
              left: -50,
              child: Container(
                width: 500,
                height: MediaQuery.of(context).size.height * .5,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(500),
                        bottomLeft: Radius.circular(500)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(200, 128, 103, 216),
                          Colors.white,
                        ])),
              )),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 200.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: SafeArea(
                child: Column(
                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   // child: Image.asset("assets/optitask@2x-01.png"),
                    // ),
                    Expanded(
                      flex: 5,
                      child: PageView(
                        children: onboardingPages(
                            themeProvider, onboardingProvider, context),
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value + 1;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24, bottom: 16),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: progress,
                        ),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          color:
                              themeProvider.theme.accentColor.withOpacity(0.7),
                          backgroundColor: Colors.grey[350],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}

Widget finishTest(AlgorithmValuesProvider onboardingProvider) {
  return Center(
      child: ElevatedButton(
          child: const Text("Finish"),
          onPressed: () {
            print(onboardingProvider.userJSON);
          }));
}

List<Widget> onboardingPages(ThemeProvider themeProvider,
    AlgorithmValuesProvider onboardingProvider, BuildContext context) {
  return [
    OnboardingIntro(themeProvider),
    OnboardingTimePickerPage(themeProvider, onboardingProvider),
    CanvasTokenBaseURLCollectionView(
        themeProvider, context, onboardingProvider),
    OnboardingSlidersView(themeProvider, onboardingProvider, SliderTypes.value),
    OnboardingSlidersView(themeProvider, onboardingProvider, SliderTypes.time),
    OnboardingSlidersView(
        themeProvider, onboardingProvider, SliderTypes.fatigue),
    OnboardingTimePickerPage(themeProvider, onboardingProvider),
    finishTest(onboardingProvider)
  ];
}
