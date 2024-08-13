import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:optitask/ui/onboarding/onboardingsteppages/canvastokenbaseurl/onboardingclassinfoview.dart';

import '../../../../providers/algorithm_values_provider.dart';
import '../../../../providers/theme_provider.dart';
import '../../../../services/api.dart';

Future<void> showSchoolSystemBottomSheet(BuildContext context,
    ThemeProvider themeProvider, AlgorithmValuesProvider onboardingProvider) {
  Map<String, dynamic> searchResults = {};
  Future<void> createSearchResults(String query) async {
    print(query);

    Api api = Api();
    dynamic initResults = await api.getBaseURL(query);
    searchResults = initResults.data as Map<String, dynamic>;
    print(searchResults);
  }

  bool searching = false;
  TextEditingController schoolSystemInputController = TextEditingController();
  onboardingProvider.updateToken(
      "2873~4UtcqzyPBoNK6AsEEr8kKsQ2ZqrGRxKM3RIogrn7gX9tkqpCaCheLxRvIOluN5Ze");
  //TODO: PLS DONT FORGET TO REMOVE THIS
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: themeProvider.theme.backgroundColor,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    "Search For Your School System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextField(
                autocorrect: false,
                autofocus: true,
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
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    hintText: 'Enter The Full Name Of Your School System',
                    hintStyle:
                        TextStyle(color: themeProvider.theme.primaryTextColor)),
                controller: schoolSystemInputController,
                onSubmitted: (query) {
                  setState(() {
                    searching = true;
                  });

                  createSearchResults(query).then((value) => setState(() {
                        searching = false;
                      }));
                },
              ),
              Expanded(
                child: Builder(builder: (context) {
                  if (searchResults.isEmpty) {
                    if (searching == false) {
                      return const SizedBox.shrink();
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: themeProvider.theme.accentColor,
                        ),
                      );
                    }
                  }
                  return ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(searchResults.keys.toList()[index].toString()),
                        subtitle: Text(
                            searchResults.values.toList()[index].toString()),
                        onTap: () async {
                          onboardingProvider.updateURL(
                              searchResults.values.toList()[index].toString());
                          Api api = Api();
                          dynamic initialResponse = await api.getInitialData(
                              jsonEncode(onboardingProvider.userJSON));

                          if (initialResponse.runtimeType == int) {
                            //TODO: TOASTA FOR THIS
                            log('error');
                            return;
                          }

                          var responseData = initialResponse.data;
                          Map<String, dynamic> dataAsMap =
                              responseData as Map<String, dynamic>;

                          List<int> classLikingRatings =
                              List.filled(dataAsMap.length, 0);
                          List<int> classDifficultyRatings =
                              List.filled(dataAsMap.length, 0);
                          if (context.mounted) {
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).pop();
                              showClassSelectionBottomSheet(
                                  context,
                                  themeProvider,
                                  onboardingProvider,
                                  classLikingRatings,
                                  classDifficultyRatings,
                                  dataAsMap);
                            });
                          }
                        },
                      );
                    },
                  );
                }),
              )
            ]),
          );
        }),
      );
    },
  );
}
