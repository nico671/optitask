import 'package:flutter/material.dart';

import '../../../../providers/algorithm_values_provider.dart';
import '../../../../providers/theme_provider.dart';
import 'onboardingschoolsysteminfoview.dart';

Widget CanvasTokenBaseURLCollectionView(ThemeProvider themeProvider,
    BuildContext context, AlgorithmValuesProvider onboardingProvider) {
  bool canvasTokenDone;

  if (onboardingProvider.userJSON['headers']['Authorization'] != "Bearer ") {
    canvasTokenDone = true;
  } else {
    canvasTokenDone = false;
  }

  bool schoolSystemSelected = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "App Setup",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.theme.primaryTextColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Before we get started we need access to your Canvas account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeProvider.theme.primaryTextColor, fontSize: 20),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 24),
                child: GestureDetector(
                  onTap: () {
                    showTokenBottomSheet(
                        context, themeProvider, onboardingProvider);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: canvasTokenDone == false
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
                              flex: canvasTokenDone == false ? 10 : 5,
                              child: Text(
                                canvasTokenDone == false
                                    ? "Set up Canvas Token"
                                    : "Canvas Token",
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: canvasTokenDone == false
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32),
                child: GestureDetector(
                  onTap: () {
                    //TODO: reeenable this when done testing

                    if (canvasTokenDone == false) {
                      return;
                    }
                    showSchoolSystemBottomSheet(
                        context, themeProvider, onboardingProvider);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 1,
                          color: Colors.grey.shade300,
                          offset: const Offset(2.0, 4.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      color: schoolSystemSelected == false
                          ? themeProvider.theme.backgroundColor
                          : themeProvider.theme.accentColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: schoolSystemSelected == false ? 10 : 5,
                              child: Text(
                                schoolSystemSelected == false
                                    ? "Select School System"
                                    : "School System",
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: schoolSystemSelected == false
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
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showTokenBottomSheet(BuildContext context,
    ThemeProvider themeProvider, AlgorithmValuesProvider onboardingProvider) {
  TextEditingController tokenController = TextEditingController();
  return showModalBottomSheet<void>(
    backgroundColor: themeProvider.theme.backgroundColor,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Material(
          color: Colors.transparent,
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 36,
                  left: 24,
                  right: 24),
              child: Column(
                children: [
                  const Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Follow These Steps To Get Your Canvas Token",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(16.0),
                    )),
                  ),
                  TextField(
                    style: TextStyle(
                      color: themeProvider.theme.primaryTextColor,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsetsDirectional.only(start: 12.5),
                        filled: true,
                        fillColor: themeProvider.theme.calendarDeselectedColor,
                        focusColor: themeProvider.theme.calendarDeselectedColor,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        hintText: 'Enter your generated Canvas token',
                        hintStyle: TextStyle(
                            color: themeProvider.theme.primaryTextColor)),
                    controller: tokenController,
                    onSubmitted: (value) {
                      print(value);
                      if (value.isEmpty) {
                        return;
                      }

                      _showTokenConmfirmationDialog(
                              context, value, onboardingProvider)
                          .then((value) => Future.delayed(
                                  const Duration(milliseconds: 500), () {
                                Navigator.of(context).pop();
                              }));
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      );
    },
  );
}

Future<void> _showTokenConmfirmationDialog(BuildContext context, String token,
    AlgorithmValuesProvider onboardingProvider) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Confirm This Token Is Right',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                token,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 126, 135, 218),
                ),
              ),
            ),
            const Text(
                'Please confirm that the token you have entered is correct before you continue, the token must be correct to complete onboarding. If it is wrong press cancel and reenter the token. If it is correct and you are ready to complete the onboarding process press confirm.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color.fromARGB(25, 126, 135, 218),
              ),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              )),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromARGB(255, 126, 135, 218),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color.fromARGB(25, 126, 135, 218),
              ),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              )),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Color.fromARGB(255, 126, 135, 218),
              ),
            ),
            onPressed: () {
              onboardingProvider.updateToken(token);

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
