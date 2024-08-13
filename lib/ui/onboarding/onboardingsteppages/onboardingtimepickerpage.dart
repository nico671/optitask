import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optitask/providers/algorithm_values_provider.dart';
import 'package:optitask/providers/theme_provider.dart';

Widget OnboardingTimePickerPage(
    ThemeProvider themeProvider, AlgorithmValuesProvider onboardingProvider) {
  return StatefulBuilder(builder: ((context, setState) {
    return Column(
      children: [
        Text(
          "Routine Setup",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeProvider.theme.primaryTextColor,
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Learning your daily routines helps OptiTask make better decisions.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: themeProvider.theme.primaryTextColor, fontSize: 20),
        ),
        requiredSleep(context, themeProvider, onboardingProvider),
      ],
    );
  }));
}

Widget requiredSleep(BuildContext context, ThemeProvider themeProvider,
    AlgorithmValuesProvider onboardingProvider) {
  bool requiredSleepDone = false;
  Duration weekdayRequiredSleep = Duration.zero;
  Duration weekendRequiredSleep = Duration.zero;
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 24),
      child: GestureDetector(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: themeProvider.theme.backgroundColor,
              ),
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Material(
                          color: Colors.transparent,
                          child: Text(
                            "Required Sleep",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 36),
                          ),
                        ),
                        const Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Enter how much sleep you want to get on weekdays.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            onTimerDurationChanged: (Duration newDate) {
                              weekdayRequiredSleep = newDate;
                            },
                          ),
                        ),
                        const Material(
                          color: Colors.transparent,
                          child: Text(
                            "Enter how much sleep you want to get on weekends.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          child: CupertinoTimerPicker(
                            mode: CupertinoTimerPickerMode.hm,
                            onTimerDurationChanged: (Duration newDate) {
                              weekendRequiredSleep = newDate;
                            },
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                elevation: const WidgetStatePropertyAll(0),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    themeProvider.theme.accentColor
                                        .withOpacity(0.2))),
                            onPressed: () {
                              if (weekdayRequiredSleep == Duration.zero ||
                                  weekendRequiredSleep == Duration.zero) {}
                              onboardingProvider.setRequiredSleep(
                                  weekdayRequiredSleep, weekendRequiredSleep);

                              requiredSleepDone = true;

                              Navigator.of(context).pop();
                            },
                            child: const Text("Done"))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: requiredSleepDone == false
                ? themeProvider.theme.backgroundColor
                : themeProvider.theme.accentColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: Colors.grey.shade300,
                offset: const Offset(2.0, 4.0), //(x,y)
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: requiredSleepDone == false ? 10 : 5,
                    child: const Text(
                      "Required Sleep",
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        Icons.check_circle_outline,
                        color: requiredSleepDone == false
                            ? Colors.transparent
                            : Colors.black,
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    ),
  );
}
