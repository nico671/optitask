import 'dart:developer';

import 'package:count_stepper/count_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../providers/algorithm_values_provider.dart';
import '../../../../providers/theme_provider.dart';

Future<void> showClassSelectionBottomSheet(
    BuildContext context,
    ThemeProvider themeProvider,
    AlgorithmValuesProvider onboardingProvider,
    List<int> classLikingRatings,
    List<int> classDifficultyRatings,
    Map<String, dynamic> dataAsMap) {
  return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: themeProvider.theme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Theme(
            data: ThemeData(
                primaryColor: themeProvider.theme.accentColor,
                textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: themeProvider.theme.primaryTextColor,
                    displayColor: themeProvider.theme.primaryTextColor)),
            child: Material(
              child: StatefulBuilder(builder: (context, setClassModalState) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 18.0),
                      child: Text(
                        "Classes",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                          itemCount: dataAsMap.length,
                          itemBuilder: (context, index) {
                            dataAsMap[dataAsMap.keys.elementAt(index)]
                                ['liking_rating'] = 5;
                            dataAsMap[dataAsMap.keys.elementAt(index)]
                                ['course_difficulty'] = 5;
                            return Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.fromSwatch().copyWith(
                                    primary: themeProvider.theme.accentColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          dataAsMap.keys.elementAt(index),
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8.0),
                                                      child: Text(
                                                        "How Much Do You Like This Class?",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FittedBox(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fit: BoxFit.fill,
                                                        child: CountStepper(
                                                          iconColor:
                                                              themeProvider
                                                                  .theme
                                                                  .accentColor,
                                                          defaultValue: 5,
                                                          max: 10,
                                                          min: 1,
                                                          splashRadius: 25,
                                                          onPressed: (value) {
                                                            dataAsMap[dataAsMap
                                                                    .keys
                                                                    .elementAt(
                                                                        index)][
                                                                'liking_rating'] = value;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 8.0),
                                                      child: Text(
                                                        "How Hard Is This Class?",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          // fontWeight:
                                                          //     FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FittedBox(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        fit: BoxFit.fill,
                                                        child: CountStepper(
                                                          iconColor:
                                                              themeProvider
                                                                  .theme
                                                                  .accentColor,
                                                          defaultValue: 5,
                                                          max: 10,
                                                          min: 1,
                                                          splashRadius: 25,
                                                          onPressed: (value) {
                                                            dataAsMap[dataAsMap
                                                                    .keys
                                                                    .elementAt(
                                                                        index)][
                                                                'course_difficulty'] = value;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: IconButton(
                                                    onPressed: () {
                                                      // showDialog(context: context, builder: builder)
                                                      print("tried to remove");
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons
                                                          .trash_circle_fill,
                                                      color: Colors.red,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    TextButton(
                        onPressed: () {
                          log(dataAsMap.toString());
                          onboardingProvider.setCoursesData(dataAsMap);
                          log(onboardingProvider.userJSON.toString());
                          Navigator.of(context).pop();
                        },
                        child: const Text("Done"))
                  ],
                );
              }),
            ),
          ),
        );
      });
}
