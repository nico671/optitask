import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:weekday_selector/weekday_selector.dart';
import '../../providers/algorithm_values_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/api.dart';

class AlgorithmValuesPage extends StatefulWidget {
  const AlgorithmValuesPage({super.key});

  @override
  State<AlgorithmValuesPage> createState() => _AlgorithmValuesPageState();
}

class _AlgorithmValuesPageState extends State<AlgorithmValuesPage> {
  Map<String, dynamic> coursesMap = {};
  Map<dynamic, dynamic> activitiesMap = {};
  dynamic userJSON = {};
  final DateFormat timesFormatter = DateFormat("HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');

    return Consumer<AlgorithmValuesProvider>(
        builder: (context, aValuesProvider, child) {
      return StatefulBuilder(builder: (context, setSettingsState) {
        return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: Text('Algorithm Values',
                  style:
                      TextStyle(color: themeProvider.theme.primaryTextColor)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios,
                    color: themeProvider.theme.primaryTextColor),
              ),
            ),
            backgroundColor: themeProvider.theme.backgroundColor,
            body: SafeArea(
                child: FutureBuilder<DataSnapshot>(
                    future:
                        ref.child(FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data!.value != null) {
                        userJSON = snap.data!.value;
                        log(userJSON.runtimeType.toString());
                        activitiesMap = userJSON['user_data']['user_constants']
                                ['pre_scheduled_time']['activities'] ??
                            {};
                        TextEditingController tokenController =
                            TextEditingController(
                                text: userJSON['headers']['Authorization']
                                    .toString()
                                    .substring(7));
                        TextEditingController hostTextController =
                            TextEditingController(text: userJSON['base_url']);
                        List<dynamic> valueWeightSliders = userJSON['user_data']
                                ['work_constants_preferences']['weights']
                            ['value_weights'];
                        List<dynamic> fatigueWeightSliders =
                            userJSON['user_data']['work_constants_preferences']
                                ['weights']['fatigue_weights'];
                        List<dynamic> timeWeightSliders = userJSON['user_data']
                                ['work_constants_preferences']['weights']
                            ['time_weights'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(children: [
                            Text(
                              'Canvas Token',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: TextField(
                                style: TextStyle(
                                    color:
                                        themeProvider.theme.primaryTextColor),
                                controller: tokenController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsetsDirectional.only(
                                            start: 12.5),
                                    filled: true,
                                    fillColor: themeProvider
                                        .theme.calendarDeselectedColor,
                                    focusColor: themeProvider
                                        .theme.calendarDeselectedColor,
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintText: 'Paste The Generated Token Here',
                                    hintStyle: const TextStyle()),
                                onChanged: (value) {
                                  userJSON['headers']['Authorization'] =
                                      'Bearer $value';
                                  aValuesProvider.updateFirebase(userJSON);
                                },
                              ),
                            ),
                            Text(
                              'Canvas URL',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: TextField(
                                style: TextStyle(
                                    color:
                                        themeProvider.theme.primaryTextColor),
                                autocorrect: false,
                                onSubmitted: (value) async {
                                  Api api = Api();
                                  dynamic blah = await api.getBaseURL(value);
                                  Map<String, dynamic> blah2 =
                                      blah.data as Map<String, dynamic>;
                                  if (context.mounted) {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Material(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              child: ListView.builder(
                                                  itemCount: blah2.length,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return ListTile(
                                                      onTap: () async {
                                                        userJSON['base_url'] =
                                                            blah2.values
                                                                    .toList()[
                                                                index];
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                        Navigator.pop(context);
                                                        Api api = Api();
                                                        dynamic blah = await api
                                                            .getInitialData(
                                                                jsonEncode(
                                                                    userJSON));
                                                        if (blah.runtimeType ==
                                                            int) {
                                                          if (context
                                                              .mounted) {}
                                                        }
                                                        var yerrrr = blah.data;
                                                        Map<String, dynamic>
                                                            dataAsMap = yerrrr
                                                                as Map<String,
                                                                    dynamic>;

                                                        List<int>
                                                            classLikingRatings =
                                                            List.filled(
                                                                dataAsMap
                                                                    .length,
                                                                0);
                                                        List<int>
                                                            classDifficultyRatings =
                                                            List.filled(
                                                                dataAsMap
                                                                    .length,
                                                                0);
                                                        if (context.mounted) {
                                                          showModalBottomSheet(
                                                              isDismissible:
                                                                  false,
                                                              isScrollControlled:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            setClassModalState) {
                                                                  return Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: themeProvider
                                                                            .theme
                                                                            .backgroundColor,
                                                                        borderRadius:
                                                                            const BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(25.0),
                                                                          topRight:
                                                                              Radius.circular(25.0),
                                                                        ),
                                                                      ),
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.75,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 6, bottom: 18.0),
                                                                            child:
                                                                                Text(
                                                                              "Classes",
                                                                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.6,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 12.0),
                                                                              child: ListView.builder(
                                                                                  itemCount: dataAsMap.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Theme(
                                                                                      data: ThemeData(
                                                                                        colorScheme: ColorScheme.fromSwatch().copyWith(primary: themeProvider.theme.accentColor),
                                                                                      ),
                                                                                      child: SizedBox(
                                                                                        height: MediaQuery.of(context).size.height * 0.21,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: MediaQuery.of(context).size.width * 0.8,
                                                                                              child: Text(
                                                                                                dataAsMap.keys.elementAt(index),
                                                                                                maxLines: 1,
                                                                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                            Text("Current Grade: ${dataAsMap.values.toList().elementAt(index)['current_grade']}"),
                                                                                            const Spacer(),
                                                                                            const Text("Input how much you like the class (1-10)"),
                                                                                            Slider(
                                                                                                min: 0,
                                                                                                max: 10,
                                                                                                divisions: 10,
                                                                                                value: classLikingRatings[index].toDouble(),
                                                                                                onChanged: ((value) {
                                                                                                  setClassModalState(() {
                                                                                                    classLikingRatings[index] = value.toInt();
                                                                                                    dataAsMap[dataAsMap.keys.elementAt(index)]['liking_rating'] = (classLikingRatings[index] / 10).toStringAsFixed(1);
                                                                                                  });
                                                                                                })),
                                                                                            const Spacer(),
                                                                                            const Text("Input Class Difficulty (1-10)"),
                                                                                            Slider(
                                                                                                min: 0,
                                                                                                max: 10,
                                                                                                divisions: 10,
                                                                                                value: classDifficultyRatings[index].toDouble(),
                                                                                                onChanged: ((value) {
                                                                                                  setClassModalState(() {
                                                                                                    classDifficultyRatings[index] = value.toInt();
                                                                                                    dataAsMap[dataAsMap.keys.elementAt(index)]['course_difficulty'] = (classDifficultyRatings[index] / 10).toStringAsFixed(1);
                                                                                                  });
                                                                                                })),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                setSettingsState(() {
                                                                                  userJSON['user_data']['work_constants_preferences']['courses'] = dataAsMap;
                                                                                  aValuesProvider.updateFirebase(userJSON);
                                                                                });

                                                                                log(userJSON.toString());
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text("Done"))
                                                                        ],
                                                                      ));
                                                                });
                                                              });
                                                        }
                                                      },
                                                      title: Text(blah2.keys
                                                          .toList()[index]
                                                          .toString()),
                                                      subtitle: Text(blah2
                                                          .values
                                                          .toList()[index]
                                                          .toString()),
                                                    );
                                                  })),
                                            ),
                                          );
                                        });
                                  }

                                  log('blah $blah');
                                },
                                // onChanged: (value) {
                                //   final uri = Uri.parse(value);
                                //   setSettingsState(() {
                                //     userJSON['base_url'] =
                                //         "https://${uri.host}";
                                //     aValuesProvider.updateFirebase(userJSON);
                                //   });
                                // },
                                obscureText: false,
                                controller: hostTextController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsetsDirectional.only(
                                            start: 12.5),
                                    filled: true,
                                    fillColor: themeProvider
                                        .theme.calendarDeselectedColor,
                                    focusColor: themeProvider
                                        .theme.calendarDeselectedColor,
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    hintText:
                                        'Paste Your Canvas Homepage Link Here',
                                    hintStyle: const TextStyle()),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Value Weights',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Column(
                              children: [
                                Text(
                                  'How much do you want to prioritize the amount of time left until submission?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: valueWeightSliders[0].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(() {
                                            valueWeightSliders[0] = value;
                                            _updateWeight(valueWeightSliders);
                                            userJSON['user_data'][
                                                        'work_constants_preferences']
                                                    [
                                                    'weights']['value_weights'] =
                                                valueWeightSliders;
                                            aValuesProvider
                                                .updateFirebase(userJSON);
                                          });
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      valueWeightSliders[0].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How important is your current grade in the class?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: valueWeightSliders[1].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              valueWeightSliders[1] = value;
                                              _updateWeight(valueWeightSliders);
                                              userJSON['user_data'][
                                                          'work_constants_preferences']
                                                      [
                                                      'weights']['value_weights'] =
                                                  valueWeightSliders;
                                              aValuesProvider
                                                  .updateFirebase(userJSON);
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      valueWeightSliders[1].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How much do you want to prioritize assignments by how much you like the class (max of 20)?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: valueWeightSliders[2].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(() {
                                            valueWeightSliders[2] = value;
                                            _updateWeight(valueWeightSliders);
                                            userJSON['user_data'][
                                                        'work_constants_preferences']
                                                    [
                                                    'weights']['value_weights'] =
                                                valueWeightSliders;
                                            aValuesProvider
                                                .updateFirebase(userJSON);
                                          });
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      valueWeightSliders[2].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Fatigue Weights',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Column(
                              children: [
                                Text(
                                  'How important is the difficulty of the class to your homework fatigue?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value:
                                            fatigueWeightSliders[0].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              fatigueWeightSliders[0] = value;
                                              _updateWeight(
                                                  fatigueWeightSliders);
                                              userJSON['user_data'][
                                                              'work_constants_preferences']
                                                          ['weights']
                                                      ['fatigue_weights'] =
                                                  fatigueWeightSliders;
                                              aValuesProvider
                                                  .updateFirebase(userJSON);
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      fatigueWeightSliders[0]
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How does the type of assignment (All Tasks vs. Practice/Prep) affect your fatigue?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value:
                                            fatigueWeightSliders[2].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              fatigueWeightSliders[2] = value;
                                              _updateWeight(
                                                  fatigueWeightSliders);
                                              userJSON['user_data'][
                                                              'work_constants_preferences']
                                                          ['weights']
                                                      ['fatigue_weights'] =
                                                  fatigueWeightSliders;
                                              aValuesProvider
                                                  .updateFirebase(userJSON);
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      fatigueWeightSliders[2]
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How much does liking the class reduce fatigue from doing the assignments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value:
                                            fatigueWeightSliders[1].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              fatigueWeightSliders[1] = value;

                                              _updateWeight(
                                                  fatigueWeightSliders);
                                              userJSON['user_data'][
                                                              'work_constants_preferences']
                                                          ['weights']
                                                      ['fatigue_weights'] =
                                                  fatigueWeightSliders;
                                              aValuesProvider
                                                  .updateFirebase(userJSON);
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      fatigueWeightSliders[1]
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Time Weights',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Column(
                              children: [
                                Text(
                                  'How much does the amount of time spent working in one day impact your homework fatigue?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: timeWeightSliders[0].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              timeWeightSliders[0] = value;
                                              _updateWeight(timeWeightSliders);
                                              setState(() {
                                                userJSON['user_data'][
                                                                'work_constants_preferences']
                                                            ['weights']
                                                        ['time_weights'] =
                                                    timeWeightSliders;
                                                aValuesProvider
                                                    .updateFirebase(userJSON);
                                              });
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      timeWeightSliders[0].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How does time spent on one assignment affect your fatigue?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: timeWeightSliders[2].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              timeWeightSliders[2] = value;
                                              _updateWeight(timeWeightSliders);
                                              setState(() {
                                                userJSON['user_data'][
                                                                'work_constants_preferences']
                                                            ['weights']
                                                        ['time_weights'] =
                                                    timeWeightSliders;
                                                aValuesProvider
                                                    .updateFirebase(userJSON);
                                              });
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      timeWeightSliders[2].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    )
                                  ],
                                ),
                                Text(
                                  'How much does time left on assignments reduce fatigue from doing assignments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: timeWeightSliders[1].toDouble(),
                                        onChanged: (value) {
                                          setSettingsState(
                                            () {
                                              if (value < 20) {
                                                timeWeightSliders[1] = value;
                                                _updateWeight(
                                                    timeWeightSliders);
                                                setState(() {
                                                  userJSON['user_data'][
                                                                  'work_constants_preferences']
                                                              ['weights']
                                                          ['time_weights'] =
                                                      timeWeightSliders;
                                                  aValuesProvider
                                                      .updateFirebase(userJSON);
                                                });
                                              } else {
                                                timeWeightSliders[1] = 20;
                                                _updateWeight(
                                                    timeWeightSliders);
                                                timeWeightSliders;
                                              }
                                            },
                                          );
                                        },
                                        max: 100.0,
                                        min: 0.0,
                                      ),
                                    ),
                                    Text(
                                      timeWeightSliders[1].toInt().toString(),
                                      style: TextStyle(
                                          color: themeProvider
                                              .theme.primaryTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'School Duration',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'school_college_duration'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['school_college_duration'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['school_college_duration'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Weekday Sleep Duration',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'weekday_required_sleep'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['weekday_required_sleep'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['weekday_required_sleep'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Weekend Sleep Duration',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'weekend_required_sleep'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['weekend_required_sleep'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['weekend_required_sleep'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Hours of Sleep',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'weekday_required_sleep'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['weekday_required_sleep'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['weekday_required_sleep'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Minimum Free Time',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'minimum_free_time'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['minimum_free_time'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['minimum_free_time'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Most Productive Time of Day',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                _showDialog(
                                    CupertinoPicker(
                                      itemExtent: 40,
                                      // This is called when selected item is changed.
                                      onSelectedItemChanged:
                                          (int selectedItem) {
                                        if (selectedItem == 0) {
                                          setSettingsState(() {
                                            userJSON['user_data'][
                                                        'work_constants_preferences']
                                                    ['study_preferences'][
                                                'most_productive_time_of_day'] = 'day';
                                            aValuesProvider
                                                .updateFirebase(userJSON);
                                          });
                                        } else {
                                          setSettingsState(() {
                                            userJSON['user_data'][
                                                            'work_constants_preferences']
                                                        ['study_preferences'][
                                                    'most_productive_time_of_day'] =
                                                'night';
                                            aValuesProvider
                                                .updateFirebase(userJSON);
                                          });
                                        }
                                      },
                                      children: const [
                                        Center(
                                          child: Text(
                                            "Day",
                                          ),
                                        ),
                                        Center(child: Text("Night"))
                                      ],
                                    ),
                                    themeProvider);
                              },
                              child: userJSON['user_data']
                                                  ['work_constants_preferences']
                                              ['study_preferences']
                                          ['most_productive_time_of_day']
                                      .isEmpty
                                  ? const Text("Choose Time of Day")
                                  : Text(userJSON['user_data']
                                              ['work_constants_preferences']
                                          ['study_preferences']
                                      ['most_productive_time_of_day']),
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Time Before School',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hours:",
                                  style: TextStyle(
                                      color: themeProvider
                                          .theme.secondaryTextColor),
                                ),
                                CupertinoButton(
                                  // Display a CupertinoDatePicker in time picker mode.
                                  onPressed: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 216,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        // The Bottom margin is provided to align the popup above the system
                                        // navigation bar.
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        // Provide a background color for the popup.
                                        color:
                                            themeProvider.theme.backgroundColor,
                                        // Use a SafeArea widget to avoid system overlaps.
                                        child: SafeArea(
                                          top: false,
                                          child: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 200,
                                              child: Row(
                                                children: [
                                                  CupertinoTimerPicker(
                                                    backgroundColor:
                                                        Colors.white,
                                                    mode:
                                                        CupertinoTimerPickerMode
                                                            .hm,
                                                    // This is called when the user changes the time.
                                                    onTimerDurationChanged:
                                                        (Duration newTime) {
                                                      setSettingsState(() {
                                                        userJSON['user_data'][
                                                                        'user_constants']
                                                                    [
                                                                    'pre_scheduled_time']
                                                                [
                                                                'work_time_before_school'] =
                                                            formDurat(newTime);
                                                        aValuesProvider
                                                            .updateFirebase(
                                                                userJSON);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // In this example, the time value is formatted manually.
                                  // You can use the intl package to format the value based on
                                  // the user's locale settings.
                                  child: Text(
                                    userJSON['user_data']['user_constants']
                                                    ['pre_scheduled_time']
                                                ['work_time_before_school'] ==
                                            ""
                                        ? "0h 0m"
                                        : userJSON['user_data']
                                                    ['user_constants']
                                                ['pre_scheduled_time']
                                            ['work_time_before_school'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Text(
                              'Activities',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.theme.primaryTextColor),
                            ),
                            Column(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    final values = List.filled(7, false);
                                    int activityStepIndex = 0;
                                    DateTime activityStartTime = DateTime.now();
                                    DateTime activityEndTime = DateTime.now();
                                    TextEditingController
                                        activityNameTextController =
                                        TextEditingController();
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: StatefulBuilder(builder:
                                                (context,
                                                    setActivityModalState) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: themeProvider
                                                      .theme.backgroundColor,
                                                ),
                                                child: Stepper(
                                                    physics:
                                                        const PageScrollPhysics(),
                                                    onStepTapped:
                                                        (stepperIndex) {
                                                      setActivityModalState(() {
                                                        activityStepIndex =
                                                            stepperIndex;
                                                      });
                                                    },
                                                    onStepContinue: () async {
                                                      if (activityStepIndex !=
                                                          2) {
                                                        setActivityModalState(
                                                            () {
                                                          activityStepIndex++;
                                                        });
                                                      } else {
                                                        List<int>
                                                            dayValuesAsInt = [];
                                                        for (int i = 0;
                                                            i <
                                                                values.length -
                                                                    1;
                                                            i++) {
                                                          if (values[0] ==
                                                                  true &&
                                                              i == 0) {
                                                            dayValuesAsInt
                                                                .add(7);
                                                          } else if (i != 0 &&
                                                              values[i] ==
                                                                  true) {
                                                            dayValuesAsInt
                                                                .add(i - 1);
                                                          }
                                                        }

                                                        setSettingsState(() {
                                                          activitiesMap[
                                                              activityNameTextController
                                                                  .text] = {};
                                                          activitiesMap[
                                                                      activityNameTextController
                                                                          .text]
                                                                  [
                                                                  'start_time'] =
                                                              timesFormatter.format(
                                                                  activityStartTime);
                                                          activitiesMap[
                                                                      activityNameTextController
                                                                          .text]
                                                                  [
                                                                  'days_participating'] =
                                                              dayValuesAsInt;
                                                          activitiesMap[
                                                                      activityNameTextController
                                                                          .text]
                                                                  ['end_time'] =
                                                              timesFormatter.format(
                                                                  activityEndTime);
                                                          userJSON['user_data'][
                                                                          'user_constants']
                                                                      [
                                                                      'pre_scheduled_time']
                                                                  [
                                                                  'activities'] =
                                                              activitiesMap;
                                                          aValuesProvider
                                                              .updateFirebase(
                                                                  userJSON);

                                                          activityNameTextController
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                        Api api = Api();
                                                        log(jsonEncode(
                                                            userJSON));
                                                        dynamic blah = await api
                                                            .getUnscheduledTimes(
                                                                jsonEncode(
                                                                    userJSON));
                                                        if (blah.runtimeType ==
                                                            int) {
                                                          if (context
                                                              .mounted) {}
                                                        } else {
                                                          var yerrrr =
                                                              blah.data;
                                                          log(yerrrr
                                                              .toString());
                                                          userJSON['user_data'][
                                                                          'user_constants']
                                                                      [
                                                                      'pre_scheduled_time']
                                                                  [
                                                                  'base_unscheduled_times'] =
                                                              yerrrr[
                                                                  'base_unscheduled_times'];
                                                          aValuesProvider
                                                              .updateFirebase(
                                                                  userJSON);
                                                        }
                                                      }
                                                    },
                                                    onStepCancel: () {
                                                      if (activityStepIndex >
                                                          0) {
                                                        setActivityModalState(
                                                            () {
                                                          activityStepIndex--;
                                                        });
                                                      } else {}
                                                    },
                                                    currentStep:
                                                        activityStepIndex,
                                                    steps: [
                                                      Step(
                                                          title: const Text(
                                                              "Activity Name"),
                                                          content: TextField(
                                                            controller:
                                                                activityNameTextController,
                                                          ),
                                                          isActive:
                                                              activityStepIndex >=
                                                                  0),
                                                      Step(
                                                          title: const Text(
                                                              "Days Participating"),
                                                          subtitle: const Text(
                                                              'Selected the days you will be participating in this activity'),
                                                          content: const Text(
                                                              "data"),
                                                          isActive:
                                                              activityStepIndex >=
                                                                  1),
                                                      Step(
                                                          title: const Text(
                                                              "Activity Timing"),
                                                          subtitle: const Text(
                                                              "Input when the activity starts and ends"),
                                                          content: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                  "Start Time: ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                              CupertinoButton(
                                                                // Display a CupertinoDatePicker in time picker mode.
                                                                onPressed: () =>
                                                                    showCupertinoModalPopup(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      height:
                                                                          216,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6.0),
                                                                      // The Bottom margin is provided to align the popup above the system
                                                                      // navigation bar.
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom,
                                                                      ),
                                                                      // Provide a background color for the popup.
                                                                      color: themeProvider
                                                                          .theme
                                                                          .backgroundColor,
                                                                      // Use a SafeArea widget to avoid system overlaps.
                                                                      child:
                                                                          SafeArea(
                                                                        top:
                                                                            false,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                200,
                                                                            child:
                                                                                CupertinoDatePicker(
                                                                              backgroundColor: Colors.white,
                                                                              initialDateTime: DateTime.now(),
                                                                              mode: CupertinoDatePickerMode.time,
                                                                              use24hFormat: false,
                                                                              // This is called when the user changes the time.
                                                                              onDateTimeChanged: (DateTime newTime) {
                                                                                setActivityModalState(() {
                                                                                  activityStartTime = newTime;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                // In this example, the time value is formatted manually.
                                                                // You can use the intl package to format the value based on
                                                                // the user's locale settings.
                                                                child: Text(
                                                                  timesFormatter
                                                                      .format(
                                                                          activityStartTime),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Text(
                                                                  "End Time: "),
                                                              CupertinoButton(
                                                                // Display a CupertinoDatePicker in time picker mode.
                                                                onPressed: () =>
                                                                    showCupertinoModalPopup(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      height:
                                                                          216,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              6.0),
                                                                      // The Bottom margin is provided to align the popup above the system
                                                                      // navigation bar.
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom,
                                                                      ),
                                                                      // Provide a background color for the popup.
                                                                      color: themeProvider
                                                                          .theme
                                                                          .backgroundColor,
                                                                      // Use a SafeArea widget to avoid system overlaps.
                                                                      child:
                                                                          SafeArea(
                                                                        top:
                                                                            false,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              CupertinoDatePicker(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            initialDateTime:
                                                                                DateTime.now(),
                                                                            mode:
                                                                                CupertinoDatePickerMode.time,
                                                                            use24hFormat:
                                                                                false,
                                                                            // This is called when the user changes the time.
                                                                            onDateTimeChanged:
                                                                                (DateTime newTime) {
                                                                              setActivityModalState(() {
                                                                                activityEndTime = newTime;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                // In this example, the time value is formatted manually.
                                                                // You can use the intl package to format the value based on
                                                                // the user's locale settings.
                                                                child: Text(
                                                                  timesFormatter
                                                                      .format(
                                                                          activityEndTime),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          isActive:
                                                              activityStepIndex >=
                                                                  2),
                                                    ]),
                                              );
                                            }),
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Add new activity",
                                    style: TextStyle(
                                        color: themeProvider
                                            .theme.secondaryTextColor),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  child: ListView.builder(
                                      itemCount: activitiesMap.isEmpty
                                          ? 0
                                          : activitiesMap.length,
                                      itemBuilder: (context, index) {
                                        if (index > activitiesMap.length) {
                                          return const SizedBox();
                                        }
                                        return ListTile(
                                          title: Text(
                                              "${activitiesMap.keys.elementAt(index)}"),
                                          subtitle: Text(
                                              "${activitiesMap.values.elementAt(index)['start_time']} - ${activitiesMap.values.elementAt(index)['end_time']}"),
                                        );
                                      }),
                                ),
                              ],
                            )
                          ]),
                        );
                      } else {
                        return const Center(
                          child: Text("loading"),
                        );
                      }
                    })));
      });
    });
  }

  void _updateWeight(List<dynamic> sliders) {
    double sumOfSliderValues = 0;
    for (var i = 0; i < sliders.length; i++) {
      sumOfSliderValues = sumOfSliderValues + sliders[i];
    }
    if (sliders[2] >= 20) {
      for (var j = 0; j < sliders.length; j++) {
        if (sliders[j] != sumOfSliderValues) {
          sliders[j] = (sliders[j] / sumOfSliderValues) * 100;
        }
      }
    } else {
      for (var j = 0; j < sliders.length - 1; j++) {
        if (sliders[j] != sumOfSliderValues) {
          sliders[j] = (sliders[j] / sumOfSliderValues) * 100;
        }
      }
    }
  }

  String formDurat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showDialog(Widget child, ThemeProvider themeProvider) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: MediaQuery.of(context).size.height * .33,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: themeProvider.theme.backgroundColor,
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}

extension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
