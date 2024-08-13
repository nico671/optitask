// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:optitask/ui/basescreen.dart';
// import 'package:provider/provider.dart';
// import 'package:toasta/toasta.dart';
// import 'package:weekday_selector/weekday_selector.dart';
// import 'package:intl/intl.dart';
// import '../../providers/stepper_provider.dart';
// import 'package:firebase_database/firebase_database.dart';

// import '../../providers/theme_provider.dart';
// import '../../services/api.dart';

// class OnboardingUI extends StatefulWidget {
//   const OnboardingUI({super.key});

//   @override
//   State<OnboardingUI> createState() => _OnboardingUIState();
// }

// class _OnboardingUIState extends State<OnboardingUI> {
//   TextEditingController tokenController = TextEditingController();
//   bool urlExplained = false;
//   final DateFormat currentDayFormatter = DateFormat("y-M-d");
//   // TODO: needs to be 24hr time
//   final DateFormat timesFormatter = DateFormat("HH:mm:ss");
//   static Map<String, dynamic> coursesMap = {};
//   static String mostProductiveTOD = "";
//   static String timeBeforeSchool = "00:00:00";
//   static Map<dynamic, dynamic> activitiesMap = {};
//   bool schoolSystemFound = false;
//   static String minSleepDuration = "00:00:00";
//   static String schoolDuration = "00:00:00";
//   static String weekendSleep = "00:00:00";
//   static String weekdaySleep = "00:00:00";
//   static String maxHomeworkTime = "00:00:00";
//   static String maxAssessmentTime = "00:00:00";
//   static String baseURL = "";

// //MARK: - UI
//   Map<String, dynamic> userJSON = {
//     "base_target": "/api/v1/",
//     "base_url": baseURL,
//     "headers": {"Authorization": "Bearer "},
//     "laziness": 5,
//     "today": "",
//     "user_data": {
//       "user_constants": {
//         "pre_scheduled_time": {
//           "activities": {},
//           "base_unscheduled_times": {},
//           "minimum_free_time": minFreeTime,
//           "weekday_required_sleep": weekdaySleep,
//           "weekend_required_sleep": weekendSleep,
//           "school_college_duration": schoolDuration,
//           "work_time_before_school": timeBeforeSchool,
//         }
//       },
//       "work_constants_preferences": {
//         "productivity_levels": {
//           "friday": 0.7,
//           "monday": 0.8,
//           "saturday": 0.6,
//           "sunday": 0.5,
//           "thursday": 0.9,
//           "tuesday": 0.7,
//           "wednesday": 0.7
//         },
//         "study_preferences": {
//           "max_assessment_study_time": maxAssessmentTime,
//           "max_homework_study_time": maxHomeworkTime,
//           "most_productive_time_of_day": mostProductiveTOD,
//         },
//         "weights": {
//           "fatigue_weights": fatigueWeightSliders,
//           "time_weights": timeWeightSliders,
//           "value_weights": valueWeightSliders,
//         },
//         "courses": coursesMap,
//       }
//     }
//   };
//   // TODO: FUCCKKKKKKKKKKKKKK FUCK FUCK FUCK have the users be able to get rid of classes they wont be recieving assignments/ grades in
//   // that needs get initial data
//   @override
//   Widget build(BuildContext context) {
//     // TODO: hook up to firebase
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     StepperProvider stepperViewModel = Provider.of<StepperProvider>(context);
//     return ToastaContainer(
//       child: Container(
//         color: themeProvider.theme.backgroundColor,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 16.0),
//           child: IntroductionScreen(
//             globalBackgroundColor: themeProvider.theme.backgroundColor,
//             showBackButton: false,
//             next: const Text('Next'),
//             pages: [
//               PageViewModel(
//                 decoration: PageDecoration(
//                     pageColor: themeProvider.theme.backgroundColor),
//                 titleWidget: const SizedBox.shrink(),
//                 bodyWidget: Column(
//                   children: [
//                     Text(
//                       "Welcome to OptiTask!",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: themeProvider.theme.primaryTextColor,
//                           fontSize: 50,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const Image(
//                       image: AssetImage('assets/optitask@2x-01.png'),
//                     ),
//                     Text(
//                       "OptiTask is a tool to help you manage your time and tasks more efficiently. This onboarding will help you tailor the app specifically to your needs.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: themeProvider.theme.primaryTextColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               PageViewModel(
//                 titleWidget: Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: Text(
//                     "Input Your Canvas Info!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: themeProvider.theme.primaryTextColor,
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 bodyWidget: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 12.0),
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height * .55,
//                         width: 500,
//                         child: const Center(
//                             child: Image(
//                                 image: AssetImage(
//                                     'assets/gifs/onboarding_canvas_token_directions.gif'))),
//                       ),
//                     ),
//                     TextField(
//                       style: TextStyle(
//                         color: themeProvider.theme.primaryTextColor,
//                       ),
//                       obscureText: false,
//                       decoration: InputDecoration(
//                           contentPadding:
//                               const EdgeInsetsDirectional.only(start: 12.5),
//                           filled: true,
//                           fillColor:
//                               themeProvider.theme.calendarDeselectedColor,
//                           focusColor:
//                               themeProvider.theme.calendarDeselectedColor,
//                           enabledBorder: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20.0)),
//                               borderSide:
//                                   BorderSide(color: Colors.transparent)),
//                           focusedBorder: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20.0)),
//                               borderSide:
//                                   BorderSide(color: Colors.transparent)),
//                           hintText: 'Enter your generated Canvas token',
//                           hintStyle: TextStyle(
//                               color: themeProvider.theme.primaryTextColor)),
//                       controller: tokenController,
//                       onSubmitted: (value) {
//                         _showTokenConmfirmationDialog(context, value);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               PageViewModel(
//                   titleWidget: Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Text(
//                         schoolSystemFound == false
//                             ? "Input Your School System!"
//                             : "Tune the Algorithm to your preferences \nEvery step must be completed for the algorithm to work",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: themeProvider.theme.primaryTextColor,
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                   bodyWidget:
//                       StatefulBuilder(builder: (context, setStepperState) {
//                     return Theme(
//                       data: ThemeData(
//                         colorScheme: ColorScheme.fromSwatch()
//                             .copyWith(primary: themeProvider.theme.accentColor),
//                       ),
//                       child: schoolSystemFound == false
//                           ? Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: TextField(
//                                 autocorrect: false,
//                                 onSubmitted: (value) async {
//                                   Api api = Api();
//                                   dynamic blah = await api.getBaseURL(value);
//                                   Map<String, dynamic> blah2 =
//                                       blah.data as Map<String, dynamic>;
//                                   if (context.mounted) {
//                                     showCupertinoModalPopup(
//                                         context: context,
//                                         builder: (context) {
//                                           return Material(
//                                             child: Theme(
//                                               data: ThemeData(
//                                                   primaryColor: themeProvider
//                                                       .theme.accentColor,
//                                                   textTheme: Theme.of(context)
//                                                       .textTheme
//                                                       .apply(
//                                                           bodyColor: themeProvider
//                                                               .theme
//                                                               .primaryTextColor,
//                                                           displayColor:
//                                                               themeProvider
//                                                                   .theme
//                                                                   .primaryTextColor)),
//                                               child: SizedBox(
//                                                 height: MediaQuery.of(context)
//                                                         .size
//                                                         .height /
//                                                     2,
//                                                 child: ListView.builder(
//                                                     itemCount: blah2.length,
//                                                     itemBuilder:
//                                                         ((context, index) {
//                                                       return ListTile(
//                                                         onTap: () async {
//                                                           setState(() {
//                                                             baseURL = blah2
//                                                                     .values
//                                                                     .toList()[
//                                                                 index];
//                                                             userJSON[
//                                                                     "base_url"] =
//                                                                 baseURL;
//                                                           });

//                                                           log(userJSON
//                                                               .toString());
//                                                           Navigator.pop(
//                                                               context);
//                                                           Api api = Api();
//                                                           dynamic blah = await api
//                                                               .getInitialData(
//                                                                   jsonEncode(
//                                                                       userJSON));
//                                                           if (blah.runtimeType ==
//                                                               int) {
//                                                             log('error');
//                                                           }
//                                                           var yerrrr =
//                                                               blah.data;
//                                                           Map<String, dynamic>
//                                                               dataAsMap = yerrrr
//                                                                   as Map<String,
//                                                                       dynamic>;
//                                                           log('yerr$yerrrr');
//                                                           List<int>
//                                                               classLikingRatings =
//                                                               List.filled(
//                                                                   dataAsMap
//                                                                       .length,
//                                                                   0);
//                                                           List<int>
//                                                               classDifficultyRatings =
//                                                               List.filled(
//                                                                   dataAsMap
//                                                                       .length,
//                                                                   0);
//                                                           if (context.mounted) {
//                                                             showModalBottomSheet(
//                                                                 isDismissible:
//                                                                     false,
//                                                                 isScrollControlled:
//                                                                     true,
//                                                                 context:
//                                                                     context,
//                                                                 builder:
//                                                                     (context) {
//                                                                   return Theme(
//                                                                     data: ThemeData(
//                                                                         primaryColor: themeProvider
//                                                                             .theme
//                                                                             .accentColor,
//                                                                         textTheme: Theme.of(context).textTheme.apply(
//                                                                             bodyColor:
//                                                                                 themeProvider.theme.primaryTextColor,
//                                                                             displayColor: themeProvider.theme.primaryTextColor)),
//                                                                     child:
//                                                                         Material(
//                                                                       child: StatefulBuilder(builder:
//                                                                           (context,
//                                                                               setClassModalState) {
//                                                                         return Container(
//                                                                             decoration:
//                                                                                 BoxDecoration(
//                                                                               color: themeProvider.theme.backgroundColor,
//                                                                               borderRadius: const BorderRadius.only(
//                                                                                 topLeft: Radius.circular(25.0),
//                                                                                 topRight: Radius.circular(25.0),
//                                                                               ),
//                                                                             ),
//                                                                             height: MediaQuery.of(context).size.height *
//                                                                                 0.75,
//                                                                             child:
//                                                                                 Column(
//                                                                               children: [
//                                                                                 const Padding(
//                                                                                   padding: EdgeInsets.only(top: 6, bottom: 18.0),
//                                                                                   child: Text(
//                                                                                     "Classes",
//                                                                                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                                                                                   ),
//                                                                                 ),
//                                                                                 SizedBox(
//                                                                                   height: MediaQuery.of(context).size.height * 0.6,
//                                                                                   child: Padding(
//                                                                                     padding: const EdgeInsets.only(left: 12.0),
//                                                                                     child: ListView.builder(
//                                                                                         itemCount: dataAsMap.length,
//                                                                                         itemBuilder: (context, index) {
//                                                                                           return Theme(
//                                                                                             data: ThemeData(
//                                                                                               colorScheme: ColorScheme.fromSwatch().copyWith(primary: themeProvider.theme.accentColor),
//                                                                                             ),
//                                                                                             child: SizedBox(
//                                                                                               height: MediaQuery.of(context).size.height * 0.21,
//                                                                                               child: Column(
//                                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                                 children: [
//                                                                                                   SizedBox(
//                                                                                                     width: MediaQuery.of(context).size.width * 0.8,
//                                                                                                     child: Text(
//                                                                                                       dataAsMap.keys.elementAt(index),
//                                                                                                       maxLines: 1,
//                                                                                                       style: const TextStyle(
//                                                                                                         fontSize: 20,
//                                                                                                         fontWeight: FontWeight.bold,
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   Text(
//                                                                                                     "Current Grade: ${dataAsMap.values.toList().elementAt(index)['current_grade']}",
//                                                                                                   ),
//                                                                                                   const Spacer(),
//                                                                                                   const Text(
//                                                                                                     "Input how much you like the class (1-10)",
//                                                                                                   ),
//                                                                                                   Slider(
//                                                                                                       min: 0,
//                                                                                                       max: 10,
//                                                                                                       divisions: 10,
//                                                                                                       value: classLikingRatings[index].toDouble(),
//                                                                                                       onChanged: ((value) {
//                                                                                                         setClassModalState(() {
//                                                                                                           classLikingRatings[index] = value.toInt();
//                                                                                                           dataAsMap[dataAsMap.keys.elementAt(index)]['liking_rating'] = (classLikingRatings[index] / 10).toStringAsFixed(1);
//                                                                                                         });
//                                                                                                       })),
//                                                                                                   const Spacer(),
//                                                                                                   const Text("Input Class Difficulty (1-10)", style: TextStyle()),
//                                                                                                   Slider(
//                                                                                                       min: 0,
//                                                                                                       max: 10,
//                                                                                                       divisions: 10,
//                                                                                                       value: classDifficultyRatings[index].toDouble(),
//                                                                                                       onChanged: ((value) {
//                                                                                                         setClassModalState(() {
//                                                                                                           classDifficultyRatings[index] = value.toInt();
//                                                                                                           dataAsMap[dataAsMap.keys.elementAt(index)]['course_difficulty'] = (classDifficultyRatings[index] / 10).toStringAsFixed(1);
//                                                                                                         });
//                                                                                                       })),
//                                                                                                 ],
//                                                                                               ),
//                                                                                             ),
//                                                                                           );
//                                                                                         }),
//                                                                                   ),
//                                                                                 ),
//                                                                                 TextButton(
//                                                                                     onPressed: () {
//                                                                                       setState(() {
//                                                                                         log(dataAsMap.toString());
//                                                                                         coursesMap = dataAsMap;
//                                                                                         userJSON['user_data']['work_constants_preferences']['courses'] = coursesMap;
//                                                                                         log(userJSON.toString());
//                                                                                       });

//                                                                                       Navigator.of(context).pop();
//                                                                                     },
//                                                                                     child: const Text("Done"))
//                                                                               ],
//                                                                             ));
//                                                                       }),
//                                                                     ),
//                                                                   );
//                                                                 });
//                                                           }
//                                                         },
//                                                         title: Text(blah2.keys
//                                                             .toList()[index]
//                                                             .toString()),
//                                                         subtitle: Text(blah2
//                                                             .values
//                                                             .toList()[index]
//                                                             .toString()),
//                                                       );
//                                                     })),
//                                               ),
//                                             ),
//                                           );
//                                         });
//                                   }
//                                 },
//                                 obscureText: false,
//                                 style: TextStyle(
//                                   color: themeProvider.theme.primaryTextColor,
//                                 ),
//                                 decoration: InputDecoration(
//                                     contentPadding:
//                                         const EdgeInsetsDirectional.only(
//                                             start: 12.5),
//                                     filled: true,
//                                     fillColor: themeProvider
//                                         .theme.calendarDeselectedColor,
//                                     focusColor: themeProvider
//                                         .theme.calendarDeselectedColor,
//                                     enabledBorder: const OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20.0)),
//                                         borderSide: BorderSide(
//                                             color: Colors.transparent)),
//                                     focusedBorder: const OutlineInputBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20.0)),
//                                         borderSide: BorderSide(
//                                             color: Colors.transparent)),
//                                     hintText:
//                                         'Search for your schools system here (by name)',
//                                     hintStyle: TextStyle(
//                                         color: themeProvider
//                                             .theme.primaryTextColor)),
//                               ),
//                             )
//                           : Stepper(
//                               controlsBuilder: (context, details) {
//                                 return Row(
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 8.0),
//                                       child: MaterialButton(
//                                           color:
//                                               themeProvider.theme.accentColor,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(20)),
//                                           onPressed: () {
//                                             setStepperState(() {
//                                               stepperViewModel
//                                                   .decrementCounter();
//                                             });
//                                           },
//                                           child: const Text("Back")),
//                                     ),
//                                     MaterialButton(
//                                         color: themeProvider.theme.accentColor,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(20)),
//                                         onPressed: () {
//                                           setStepperState(() {
//                                             stepperViewModel.incrementCounter();
//                                           });
//                                         },
//                                         child: const Text("Next"))
//                                   ],
//                                 );
//                               },
//                               physics: const PageScrollPhysics(),
//                               onStepTapped: (stepperIndex) {
//                                 stepperViewModel.setCounter(stepperIndex);
//                               },
//                               onStepContinue: () {
//                                 if (stepperViewModel.counter < 11) {
//                                   stepperViewModel.incrementCounter();
//                                 }
//                               },
//                               onStepCancel: () {
//                                 if (stepperViewModel.counter > 0) {
//                                   stepperViewModel.decrementCounter();
//                                 } else {}
//                               },
//                               currentStep: stepperViewModel.counter,
//                               type: StepperType.vertical,
//                               steps: [
//                                   // Step(
//                                   //     title: Text(
//                                   //       'Values',
//                                   //       style: TextStyle(
//                                   //         color: themeProvider
//                                   //             .theme.primaryTextColor,
//                                   //       ),
//                                   //     ),
//                                   //     subtitle: Text(
//                                   //         'Adjust how important each of these values are to you',
//                                   //         style: TextStyle(
//                                   //           color: themeProvider
//                                   //               .theme.primaryTextColor,
//                                   //         )),
//                                   //     content: Column(
//                                   //       children: [
//                                   //         Text(
//                                   //             'How much do you want to prioritize the amount of time left until submission?',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: valueWeightSliders[0]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       valueWeightSliders[0] =
//                                   //                           value;
//                                   //                       _updateWeight(
//                                   //                           valueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 valueWeightSliders[0]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //         Text(
//                                   //             'How important is your current grade in the class?',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: valueWeightSliders[1]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       valueWeightSliders[1] =
//                                   //                           value;
//                                   //                       _updateWeight(
//                                   //                           valueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 valueWeightSliders[1]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //         Text(
//                                   //             'How much do you want to prioritize assignments by how much you like the class (max of 20)?',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: valueWeightSliders[2]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       valueWeightSliders[2] =
//                                   //                           value;
//                                   //                       _updateWeight(
//                                   //                           valueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 valueWeightSliders[2]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //     isActive: stepperViewModel.counter >= 0),
//                                   // Step(
//                                   //     title: Text('Fatigue',
//                                   //         style: TextStyle(
//                                   //           color: themeProvider
//                                   //               .theme.primaryTextColor,
//                                   //         )),
//                                   //     subtitle: Text(
//                                   //         'Adjust how important each of these values are to you',
//                                   //         style: TextStyle(
//                                   //           color: themeProvider
//                                   //               .theme.primaryTextColor,
//                                   //         )),
//                                   //     content: Column(
//                                   //       children: [
//                                   //         Text(
//                                   //             'How important is the difficulty of the class to your homework fatigue?',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: fatigueWeightSliders[0]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       fatigueWeightSliders[
//                                   //                           0] = value;
//                                   //                       _updateWeight(
//                                   //                           fatigueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 fatigueWeightSliders[0]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //         Text(
//                                   //             'How does the type of assignment (All Tasks vs. Practice/Prep) affect your fatigue?',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: fatigueWeightSliders[2]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       fatigueWeightSliders[
//                                   //                           2] = value;
//                                   //                       _updateWeight(
//                                   //                           fatigueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 fatigueWeightSliders[2]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //         Text(
//                                   //             'How much does liking the class reduce fatigue from doing the assignments',
//                                   //             style: TextStyle(
//                                   //                 color: themeProvider
//                                   //                     .theme.primaryTextColor,
//                                   //                 fontWeight: FontWeight.bold)),
//                                   //         Row(
//                                   //           children: [
//                                   //             Expanded(
//                                   //               child: Slider(
//                                   //                 value: fatigueWeightSliders[1]
//                                   //                     .toDouble(),
//                                   //                 onChanged: (value) {
//                                   //                   setStepperState(
//                                   //                     () {
//                                   //                       fatigueWeightSliders[
//                                   //                           1] = value;
//                                   //                       _updateWeight(
//                                   //                           fatigueWeightSliders);
//                                   //                     },
//                                   //                   );
//                                   //                 },
//                                   //                 max: 100.0,
//                                   //                 min: 0.0,
//                                   //               ),
//                                   //             ),
//                                   //             Text(
//                                   //                 fatigueWeightSliders[1]
//                                   //                     .toInt()
//                                   //                     .toString(),
//                                   //                 style: TextStyle(
//                                   //                     color: themeProvider.theme
//                                   //                         .primaryTextColor))
//                                   //           ],
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //     isActive: stepperViewModel.counter >= 1),
//                                   // Step(
//                                   //     title: Text('Time',
//                                   //         style: TextStyle(
//                                   //           color: themeProvider
//                                   //               .theme.primaryTextColor,
//                                   //         )),
//                                   //     subtitle: Text(
//                                   //         'Adjust how important each of these values are to you',
//                                   //         style: TextStyle(
//                                   //           color: themeProvider
//                                   //               .theme.primaryTextColor,
//                                   //         )),
//                                   //     content: Container(
//                                   //       decoration: BoxDecoration(
//                                   //         boxShadow: [
//                                   //           BoxShadow(
//                                   //             color: Colors.black
//                                   //                 .withOpacity(0.04),
//                                   //             spreadRadius: 3,
//                                   //             blurRadius: 5,
//                                   //             offset: const Offset(0,
//                                   //                 3), // changes position of shadow
//                                   //           ),
//                                   //         ],
//                                   //       ),
//                                   //       child: Column(
//                                   //         children: [
//                                   //           Text(
//                                   //               'How important is the difficulty of the class to how much time you will spend on an assignment?',
//                                   //               style: TextStyle(
//                                   //                   color: themeProvider
//                                   //                       .theme.primaryTextColor,
//                                   //                   fontWeight:
//                                   //                       FontWeight.bold)),
//                                   //           Row(
//                                   //             children: [
//                                   //               Expanded(
//                                   //                 child: Slider(
//                                   //                   value: timeWeightSliders[0],
//                                   //                   onChanged: (value) {
//                                   //                     setStepperState(
//                                   //                       () {
//                                   //                         timeWeightSliders[0] =
//                                   //                             value;
//                                   //                         _updateWeight(
//                                   //                             timeWeightSliders);
//                                   //                       },
//                                   //                     );
//                                   //                   },
//                                   //                   max: 100.0,
//                                   //                   min: 0.0,
//                                   //                 ),
//                                   //               ),
//                                   //               Text(
//                                   //                   timeWeightSliders[0]
//                                   //                       .toInt()
//                                   //                       .toString(),
//                                   //                   style: TextStyle(
//                                   //                       color: themeProvider
//                                   //                           .theme
//                                   //                           .primaryTextColor))
//                                   //             ],
//                                   //           ),
//                                   //           Text(
//                                   //               'How does the type of assignment (All Tasks vs. Practice/Prep) affect the time you will spend on an assignment?',
//                                   //               style: TextStyle(
//                                   //                   color: themeProvider
//                                   //                       .theme.primaryTextColor,
//                                   //                   fontWeight:
//                                   //                       FontWeight.bold)),
//                                   //           Row(
//                                   //             mainAxisAlignment:
//                                   //                 MainAxisAlignment
//                                   //                     .spaceBetween,
//                                   //             children: [
//                                   //               Expanded(
//                                   //                 child: Slider(
//                                   //                   value: timeWeightSliders[2]
//                                   //                       .toDouble(),
//                                   //                   onChanged: (value) {
//                                   //                     setStepperState(
//                                   //                       () {
//                                   //                         timeWeightSliders[2] =
//                                   //                             value;
//                                   //                         _updateWeight(
//                                   //                             timeWeightSliders);
//                                   //                       },
//                                   //                     );
//                                   //                   },
//                                   //                   max: 100.0,
//                                   //                   min: 0.0,
//                                   //                 ),
//                                   //               ),
//                                   //               Text(
//                                   //                   timeWeightSliders[2]
//                                   //                       .toInt()
//                                   //                       .toString(),
//                                   //                   style: TextStyle(
//                                   //                       color: themeProvider
//                                   //                           .theme
//                                   //                           .primaryTextColor))
//                                   //             ],
//                                   //           ),
//                                   //           Text(
//                                   //               'How important is how much you like the class to how much time you will spend on an assignment',
//                                   //               style: TextStyle(
//                                   //                   color: themeProvider
//                                   //                       .theme.primaryTextColor,
//                                   //                   fontWeight:
//                                   //                       FontWeight.bold)),
//                                   //           Row(
//                                   //             children: [
//                                   //               Expanded(
//                                   //                 child: Slider(
//                                   //                   value: timeWeightSliders[1],
//                                   //                   onChanged: (value) {
//                                   //                     setStepperState(
//                                   //                       () {
//                                   //                         if (value < 20) {
//                                   //                           timeWeightSliders[
//                                   //                               1] = value;
//                                   //                           _updateWeight(
//                                   //                               timeWeightSliders);
//                                   //                         } else {
//                                   //                           timeWeightSliders[
//                                   //                               1] = 20;
//                                   //                           _updateWeight(
//                                   //                               timeWeightSliders);
//                                   //                         }
//                                   //                       },
//                                   //                     );
//                                   //                   },
//                                   //                   max: 100.0,
//                                   //                   min: 0.0,
//                                   //                 ),
//                                   //               ),
//                                   //               Text(
//                                   //                   timeWeightSliders[1]
//                                   //                       .toInt()
//                                   //                       .toString(),
//                                   //                   style: TextStyle(
//                                   //                       color: themeProvider
//                                   //                           .theme
//                                   //                           .primaryTextColor)),
//                                   //             ],
//                                   //           ),
//                                   //         ],
//                                   //       ),
//                                   //     ),
//                                   //     isActive: stepperViewModel.counter >= 2),
//                                   Step(
//                                       title: Text("School Hours",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input how long you are at school",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                       primaryColor:
//                                                           themeProvider.theme
//                                                               .accentColor,
//                                                       textTheme: Theme.of(
//                                                               context)
//                                                           .textTheme
//                                                           .apply(
//                                                               bodyColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor,
//                                                               displayColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor)),
//                                                   child: Container(
//                                                     height: 216,
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 6.0),
//                                                     // The Bottom margin is provided to align the popup above the system
//                                                     // navigation bar.
//                                                     margin: EdgeInsets.only(
//                                                       bottom:
//                                                           MediaQuery.of(context)
//                                                               .viewInsets
//                                                               .bottom,
//                                                     ),
//                                                     // Provide a background color for the popup.
//                                                     color: themeProvider
//                                                         .theme.backgroundColor,
//                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                     child: SafeArea(
//                                                       top: false,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: SizedBox(
//                                                           height: 200,
//                                                           child: Row(
//                                                             children: [
//                                                               CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,
//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       schoolDuration =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               schoolDuration == ""
//                                                   ? "0h 0m"
//                                                   : schoolDuration,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 3),
//                                   Step(
//                                       title: Text("Weekday Sleep",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input how much sleep you want to get on weekdays",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                       primaryColor:
//                                                           themeProvider.theme
//                                                               .accentColor,
//                                                       textTheme: Theme.of(
//                                                               context)
//                                                           .textTheme
//                                                           .apply(
//                                                               bodyColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor,
//                                                               displayColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor)),
//                                                   child: Container(
//                                                     height: 216,
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 6.0),
//                                                     // The Bottom margin is provided to align the popup above the system
//                                                     // navigation bar.
//                                                     margin: EdgeInsets.only(
//                                                       bottom:
//                                                           MediaQuery.of(context)
//                                                               .viewInsets
//                                                               .bottom,
//                                                     ),
//                                                     // Provide a background color for the popup.
//                                                     color: themeProvider
//                                                         .theme.backgroundColor,
//                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                     child: SafeArea(
//                                                       top: false,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: SizedBox(
//                                                           height: 200,
//                                                           child: Row(
//                                                             children: [
//                                                               CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,
//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       weekdaySleep =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               weekdaySleep == ""
//                                                   ? "0h 0m"
//                                                   : weekdaySleep,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 4),
//                                   Step(
//                                       title: Text("Weekend Sleep",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input how much sleep you want to get on weekends",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                       primaryColor:
//                                                           themeProvider.theme
//                                                               .accentColor,
//                                                       textTheme: Theme.of(
//                                                               context)
//                                                           .textTheme
//                                                           .apply(
//                                                               bodyColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor,
//                                                               displayColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor)),
//                                                   child: Container(
//                                                     height: 216,
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 6.0),
//                                                     // The Bottom margin is provided to align the popup above the system
//                                                     // navigation bar.
//                                                     margin: EdgeInsets.only(
//                                                       bottom:
//                                                           MediaQuery.of(context)
//                                                               .viewInsets
//                                                               .bottom,
//                                                     ),
//                                                     // Provide a background color for the popup.
//                                                     color: themeProvider
//                                                         .theme.backgroundColor,
//                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                     child: SafeArea(
//                                                       top: false,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: SizedBox(
//                                                           height: 200,
//                                                           child: Row(
//                                                             children: [
//                                                               CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,
//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       weekendSleep =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               weekendSleep == ""
//                                                   ? "0h 0m"
//                                                   : weekendSleep,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 5),
//                                   Step(
//                                       title: Text("Free Time",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input the minimum amount of free time you want to account for per day",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                       primaryColor:
//                                                           themeProvider.theme
//                                                               .accentColor,
//                                                       textTheme: Theme.of(
//                                                               context)
//                                                           .textTheme
//                                                           .apply(
//                                                               bodyColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor,
//                                                               displayColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor)),
//                                                   child: Container(
//                                                     height: 216,
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 6.0),
//                                                     // The Bottom margin is provided to align the popup above the system
//                                                     // navigation bar.
//                                                     margin: EdgeInsets.only(
//                                                       bottom:
//                                                           MediaQuery.of(context)
//                                                               .viewInsets
//                                                               .bottom,
//                                                     ),
//                                                     // Provide a background color for the popup.
//                                                     color: themeProvider
//                                                         .theme.backgroundColor,
//                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                     child: SafeArea(
//                                                       top: false,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: SizedBox(
//                                                           height: 200,
//                                                           child: Row(
//                                                             children: [
//                                                               CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,
//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       minFreeTime =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               minFreeTime == ""
//                                                   ? "0h 0m"
//                                                   : minFreeTime,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 6),
//                                   Step(
//                                       title: Text("Productivity",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Choose which time of day you are most productive",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: CupertinoButton(
//                                         onPressed: () {
//                                           _showDialog(
//                                               CupertinoPicker(
//                                                 itemExtent: 40,
//                                                 // This is called when selected item is changed.
//                                                 onSelectedItemChanged:
//                                                     (int selectedItem) {
//                                                   if (selectedItem == 0) {
//                                                     setState(() {
//                                                       mostProductiveTOD = 'day';
//                                                     });
//                                                   } else {
//                                                     setState(() {
//                                                       mostProductiveTOD =
//                                                           'night';
//                                                     });
//                                                   }
//                                                 },
//                                                 children: [
//                                                   Center(
//                                                     child: Text(
//                                                       "Day",
//                                                       style: TextStyle(
//                                                         color: themeProvider
//                                                             .theme
//                                                             .primaryTextColor,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Center(
//                                                       child: Text(
//                                                     "Night",
//                                                     style: TextStyle(
//                                                       color: themeProvider.theme
//                                                           .primaryTextColor,
//                                                     ),
//                                                   ))
//                                                 ],
//                                               ),
//                                               themeProvider);
//                                         },
//                                         child: mostProductiveTOD.isEmpty
//                                             ? const Text("Choose Time of Day")
//                                             : Text(mostProductiveTOD
//                                                 .toCapitalized()),
//                                       ),
//                                       isActive: stepperViewModel.counter >= 7),
//                                   Step(
//                                       title: Text("Before School Work Time",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input how much time you have to work before school",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Container(
//                                                   height: 216,
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 6.0),
//                                                   // The Bottom margin is provided to align the popup above the system
//                                                   // navigation bar.
//                                                   margin: EdgeInsets.only(
//                                                     bottom:
//                                                         MediaQuery.of(context)
//                                                             .viewInsets
//                                                             .bottom,
//                                                   ),
//                                                   // Provide a background color for the popup.
//                                                   color: themeProvider
//                                                       .theme.backgroundColor,
//                                                   // Use a SafeArea widget to avoid system overlaps.
//                                                   child: SafeArea(
//                                                     top: false,
//                                                     child:
//                                                         SingleChildScrollView(
//                                                       child: SizedBox(
//                                                         height: 200,
//                                                         child: Row(
//                                                           children: [
//                                                             CupertinoTheme(
//                                                               data:
//                                                                   CupertinoThemeData(
//                                                                       textTheme:
//                                                                           CupertinoTextThemeData(
//                                                                 dateTimePickerTextStyle:
//                                                                     TextStyle(
//                                                                         color: themeProvider
//                                                                             .theme
//                                                                             .primaryTextColor),
//                                                               )),
//                                                               child:
//                                                                   CupertinoTimerPicker(
//                                                                 backgroundColor:
//                                                                     themeProvider
//                                                                         .theme
//                                                                         .backgroundColor,

//                                                                 mode:
//                                                                     CupertinoTimerPickerMode
//                                                                         .hm,
//                                                                 // This is called when the user changes the time.
//                                                                 onTimerDurationChanged:
//                                                                     (Duration
//                                                                         newTime) {
//                                                                   setState(() {
//                                                                     timeBeforeSchool =
//                                                                         formDurat(
//                                                                             newTime);
//                                                                   });
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               timeBeforeSchool == ""
//                                                   ? "0h 0m"
//                                                   : timeBeforeSchool,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 8),
//                                   Step(
//                                       title: Text("Home Work Time",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input the maximum amount of time you want to spend on a homework assignment",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Container(
//                                                   height: 216,
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 6.0),
//                                                   // The Bottom margin is provided to align the popup above the system
//                                                   // navigation bar.
//                                                   margin: EdgeInsets.only(
//                                                     bottom:
//                                                         MediaQuery.of(context)
//                                                             .viewInsets
//                                                             .bottom,
//                                                   ),
//                                                   // Provide a background color for the popup.
//                                                   color: themeProvider
//                                                       .theme.backgroundColor,
//                                                   // Use a SafeArea widget to avoid system overlaps.
//                                                   child: SafeArea(
//                                                     top: false,
//                                                     child:
//                                                         SingleChildScrollView(
//                                                       child: SizedBox(
//                                                         height: 200,
//                                                         child: Row(
//                                                           children: [
//                                                             CupertinoTheme(
//                                                               data:
//                                                                   CupertinoThemeData(
//                                                                       textTheme:
//                                                                           CupertinoTextThemeData(
//                                                                 dateTimePickerTextStyle:
//                                                                     TextStyle(
//                                                                         color: themeProvider
//                                                                             .theme
//                                                                             .primaryTextColor),
//                                                               )),
//                                                               child:
//                                                                   CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,

//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       maxHomeworkTime =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               maxHomeworkTime == ""
//                                                   ? "0h 0m"
//                                                   : maxHomeworkTime,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 9),
//                                   Step(
//                                       title: Text("Assessment Time",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Input the maximum amount of time you want to spend on an assessment",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text("Hours:",
//                                               style: TextStyle(
//                                                 color: themeProvider
//                                                     .theme.primaryTextColor,
//                                               )),
//                                           CupertinoButton(
//                                             // Display a CupertinoDatePicker in time picker mode.
//                                             onPressed: () =>
//                                                 showCupertinoModalPopup(
//                                               context: context,
//                                               builder: (context) {
//                                                 return Theme(
//                                                   data: ThemeData(
//                                                       primaryColor:
//                                                           themeProvider.theme
//                                                               .accentColor,
//                                                       textTheme: Theme.of(
//                                                               context)
//                                                           .textTheme
//                                                           .apply(
//                                                               bodyColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor,
//                                                               displayColor:
//                                                                   themeProvider
//                                                                       .theme
//                                                                       .primaryTextColor)),
//                                                   child: Container(
//                                                     height: 216,
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 6.0),
//                                                     // The Bottom margin is provided to align the popup above the system
//                                                     // navigation bar.
//                                                     margin: EdgeInsets.only(
//                                                       bottom:
//                                                           MediaQuery.of(context)
//                                                               .viewInsets
//                                                               .bottom,
//                                                     ),
//                                                     // Provide a background color for the popup.
//                                                     color: themeProvider
//                                                         .theme.backgroundColor,
//                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                     child: SafeArea(
//                                                       top: false,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: SizedBox(
//                                                           height: 200,
//                                                           child: Row(
//                                                             children: [
//                                                               CupertinoTheme(
//                                                                 data:
//                                                                     CupertinoThemeData(
//                                                                         textTheme:
//                                                                             CupertinoTextThemeData(
//                                                                   dateTimePickerTextStyle: TextStyle(
//                                                                       color: themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor),
//                                                                 )),
//                                                                 child:
//                                                                     CupertinoTimerPicker(
//                                                                   backgroundColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .backgroundColor,

//                                                                   mode:
//                                                                       CupertinoTimerPickerMode
//                                                                           .hm,
//                                                                   // This is called when the user changes the time.
//                                                                   onTimerDurationChanged:
//                                                                       (Duration
//                                                                           newTime) {
//                                                                     setState(
//                                                                         () {
//                                                                       maxAssessmentTime =
//                                                                           formDurat(
//                                                                               newTime);
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                             // In this example, the time value is formatted manually.
//                                             // You can use the intl package to format the value based on
//                                             // the user's locale settings.
//                                             child: Text(
//                                               maxAssessmentTime == ""
//                                                   ? "0h 0m"
//                                                   : maxAssessmentTime,
//                                               style: const TextStyle(
//                                                 fontSize: 20.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       isActive: stepperViewModel.counter >= 10),
//                                   Step(
//                                       isActive: stepperViewModel.counter >= 11,
//                                       title: Text("Activities",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       subtitle: Text(
//                                           "Add in any recurring activities here",
//                                           style: TextStyle(
//                                             color: themeProvider
//                                                 .theme.primaryTextColor,
//                                           )),
//                                       content: Column(
//                                         children: [
//                                           MaterialButton(
//                                             onPressed: () {
//                                               final values =
//                                                   List.filled(7, false);
//                                               int activityStepIndex = 0;
//                                               DateTime activityStartTime =
//                                                   DateTime.now();
//                                               DateTime activityEndTime =
//                                                   DateTime.now();
//                                               TextEditingController
//                                                   activityNameTextController =
//                                                   TextEditingController();
//                                               showModalBottomSheet(
//                                                   context: context,
//                                                   builder: (context) {
//                                                     return Theme(
//                                                       data: ThemeData(
//                                                           primaryColor:
//                                                               themeProvider
//                                                                   .theme
//                                                                   .accentColor,
//                                                           textTheme: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .apply(
//                                                                   bodyColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor,
//                                                                   displayColor:
//                                                                       themeProvider
//                                                                           .theme
//                                                                           .primaryTextColor)),
//                                                       child: Container(
//                                                         color: themeProvider
//                                                             .theme
//                                                             .backgroundColor,
//                                                         child: Padding(
//                                                           padding: EdgeInsets.only(
//                                                               bottom: MediaQuery
//                                                                       .of(context)
//                                                                   .viewInsets
//                                                                   .bottom),
//                                                           child: StatefulBuilder(
//                                                               builder: (context,
//                                                                   setActivityModalState) {
//                                                             return Stepper(
//                                                                 physics:
//                                                                     const PageScrollPhysics(),
//                                                                 onStepTapped:
//                                                                     (stepperIndex) {
//                                                                   setActivityModalState(
//                                                                       () {
//                                                                     activityStepIndex =
//                                                                         stepperIndex;
//                                                                   });
//                                                                 },
//                                                                 onStepContinue:
//                                                                     () {
//                                                                   if (activityStepIndex !=
//                                                                       2) {
//                                                                     setActivityModalState(
//                                                                         () {
//                                                                       activityStepIndex++;
//                                                                     });
//                                                                   } else {
//                                                                     List<int>
//                                                                         dayValuesAsInt =
//                                                                         [];
//                                                                     for (int i =
//                                                                             0;
//                                                                         i <
//                                                                             values.length -
//                                                                                 1;
//                                                                         i++) {
//                                                                       if (values[0] ==
//                                                                               true &&
//                                                                           i ==
//                                                                               0) {
//                                                                         dayValuesAsInt
//                                                                             .add(7);
//                                                                       } else if (i !=
//                                                                               0 &&
//                                                                           values[i] ==
//                                                                               true) {
//                                                                         dayValuesAsInt
//                                                                             .add(i -
//                                                                                 1);
//                                                                       }
//                                                                     }

//                                                                     setState(
//                                                                         () {
//                                                                       activitiesMap[
//                                                                           activityNameTextController
//                                                                               .text] = {};
//                                                                       activitiesMap[
//                                                                           activityNameTextController
//                                                                               .text]['start_time'] = timesFormatter
//                                                                           .format(
//                                                                               activityStartTime);
//                                                                       activitiesMap[activityNameTextController.text]
//                                                                               [
//                                                                               'days_participating'] =
//                                                                           dayValuesAsInt;
//                                                                       activitiesMap[
//                                                                           activityNameTextController
//                                                                               .text]['end_time'] = timesFormatter
//                                                                           .format(
//                                                                               activityEndTime);

//                                                                       activityNameTextController
//                                                                           .clear();
//                                                                       Navigator.of(
//                                                                               context)
//                                                                           .pop();
//                                                                     });
//                                                                   }
//                                                                 },
//                                                                 onStepCancel:
//                                                                     () {
//                                                                   if (activityStepIndex >
//                                                                       0) {
//                                                                     setActivityModalState(
//                                                                         () {
//                                                                       activityStepIndex--;
//                                                                     });
//                                                                   } else {}
//                                                                 },
//                                                                 currentStep:
//                                                                     activityStepIndex,
//                                                                 steps: [
//                                                                   Step(
//                                                                       title: const Text(
//                                                                           "Activity Name"),
//                                                                       content:
//                                                                           TextField(
//                                                                         style:
//                                                                             TextStyle(
//                                                                           color: themeProvider
//                                                                               .theme
//                                                                               .primaryTextColor,
//                                                                         ),
//                                                                         obscureText:
//                                                                             false,
//                                                                         decoration: InputDecoration(
//                                                                             contentPadding:
//                                                                                 const EdgeInsetsDirectional.only(start: 12.5),
//                                                                             filled: true,
//                                                                             fillColor: themeProvider.theme.calendarDeselectedColor,
//                                                                             focusColor: themeProvider.theme.calendarDeselectedColor,
//                                                                             enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(color: Colors.transparent)),
//                                                                             focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)), borderSide: BorderSide(color: Colors.transparent)),
//                                                                             hintText: 'Enter your generated Canvas token',
//                                                                             hintStyle: TextStyle(color: themeProvider.theme.primaryTextColor)),
//                                                                         controller:
//                                                                             activityNameTextController,
//                                                                       ),
//                                                                       isActive:
//                                                                           activityStepIndex >=
//                                                                               0),
//                                                                   Step(
//                                                                       title: const Text(
//                                                                           "Days Participating"),
//                                                                       subtitle:
//                                                                           const Text(
//                                                                               'Selected the days you will be participating in this activity'),
//                                                                       content:
//                                                                           WeekdaySelector(
//                                                                         onChanged:
//                                                                             (int
//                                                                                 day) {
//                                                                           setActivityModalState(
//                                                                               () {
//                                                                             final index =
//                                                                                 day % 7;

//                                                                             values[index] =
//                                                                                 !values[index];
//                                                                           });
//                                                                         },
//                                                                         values:
//                                                                             values,
//                                                                       ),
//                                                                       isActive:
//                                                                           activityStepIndex >=
//                                                                               1),
//                                                                   Step(
//                                                                       title: const Text(
//                                                                           "Activity Timing"),
//                                                                       subtitle:
//                                                                           const Text(
//                                                                               "Input when the activity starts and ends"),
//                                                                       content:
//                                                                           Column(
//                                                                         mainAxisAlignment:
//                                                                             MainAxisAlignment.center,
//                                                                         children: [
//                                                                           const Text(
//                                                                               "Start Time: ",
//                                                                               style: TextStyle(fontSize: 16)),
//                                                                           CupertinoButton(
//                                                                             // Display a CupertinoDatePicker in time picker mode.
//                                                                             onPressed: () =>
//                                                                                 showCupertinoModalPopup(
//                                                                               context: context,
//                                                                               builder: (context) {
//                                                                                 return Theme(
//                                                                                   data: ThemeData(primaryColor: themeProvider.theme.accentColor, textTheme: Theme.of(context).textTheme.apply(bodyColor: themeProvider.theme.primaryTextColor, displayColor: themeProvider.theme.primaryTextColor)),
//                                                                                   child: Container(
//                                                                                     height: 216,
//                                                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                                                     // The Bottom margin is provided to align the popup above the system
//                                                                                     // navigation bar.
//                                                                                     margin: EdgeInsets.only(
//                                                                                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                                                                                     ),
//                                                                                     // Provide a background color for the popup.
//                                                                                     color: themeProvider.theme.backgroundColor,
//                                                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                                                     child: SafeArea(
//                                                                                       top: false,
//                                                                                       child: SingleChildScrollView(
//                                                                                         child: SizedBox(
//                                                                                           height: 200,
//                                                                                           child: CupertinoDatePicker(
//                                                                                             backgroundColor: Colors.white,
//                                                                                             initialDateTime: DateTime.now(),
//                                                                                             mode: CupertinoDatePickerMode.time,
//                                                                                             use24hFormat: false,
//                                                                                             // This is called when the user changes the time.
//                                                                                             onDateTimeChanged: (DateTime newTime) {
//                                                                                               setActivityModalState(() {
//                                                                                                 activityStartTime = newTime;
//                                                                                               });
//                                                                                             },
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                 );
//                                                                               },
//                                                                             ),
//                                                                             // In this example, the time value is formatted manually.
//                                                                             // You can use the intl package to format the value based on
//                                                                             // the user's locale settings.
//                                                                             child:
//                                                                                 Text(
//                                                                               timesFormatter.format(activityStartTime),
//                                                                               style: const TextStyle(
//                                                                                 fontSize: 20.0,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           const Text(
//                                                                               "End Time: "),
//                                                                           CupertinoButton(
//                                                                             // Display a CupertinoDatePicker in time picker mode.
//                                                                             onPressed: () =>
//                                                                                 showCupertinoModalPopup(
//                                                                               context: context,
//                                                                               builder: (context) {
//                                                                                 return Theme(
//                                                                                   data: ThemeData(primaryColor: themeProvider.theme.accentColor, textTheme: Theme.of(context).textTheme.apply(bodyColor: themeProvider.theme.primaryTextColor, displayColor: themeProvider.theme.primaryTextColor)),
//                                                                                   child: Container(
//                                                                                     height: 216,
//                                                                                     padding: const EdgeInsets.only(top: 6.0),
//                                                                                     // The Bottom margin is provided to align the popup above the system
//                                                                                     // navigation bar.
//                                                                                     margin: EdgeInsets.only(
//                                                                                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                                                                                     ),
//                                                                                     // Provide a background color for the popup.
//                                                                                     color: themeProvider.theme.backgroundColor,
//                                                                                     // Use a SafeArea widget to avoid system overlaps.
//                                                                                     child: SafeArea(
//                                                                                       top: false,
//                                                                                       child: SizedBox(
//                                                                                         height: 200,
//                                                                                         child: CupertinoDatePicker(
//                                                                                           backgroundColor: themeProvider.theme.backgroundColor,
//                                                                                           initialDateTime: DateTime.now(),
//                                                                                           mode: CupertinoDatePickerMode.time,
//                                                                                           use24hFormat: false,
//                                                                                           // This is called when the user changes the time.
//                                                                                           onDateTimeChanged: (DateTime newTime) {
//                                                                                             setActivityModalState(() {
//                                                                                               activityEndTime = newTime;
//                                                                                             });
//                                                                                           },
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                 );
//                                                                               },
//                                                                             ),
//                                                                             // In this example, the time value is formatted manually.
//                                                                             // You can use the intl package to format the value based on
//                                                                             // the user's locale settings.
//                                                                             child:
//                                                                                 Text(
//                                                                               timesFormatter.format(activityEndTime),
//                                                                               style: const TextStyle(
//                                                                                 fontSize: 20.0,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       isActive:
//                                                                           activityStepIndex >=
//                                                                               2),
//                                                                 ]);
//                                                           }),
//                                                         ),
//                                                       ),
//                                                     );
//                                                   });
//                                             },
//                                             child: Text("Add new activity",
//                                                 style: TextStyle(
//                                                   color: themeProvider
//                                                       .theme.primaryTextColor,
//                                                 )),
//                                           ),
//                                           SizedBox(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 .15,
//                                             child: ListView.builder(
//                                                 itemCount: activitiesMap.isEmpty
//                                                     ? 0
//                                                     : activitiesMap.length,
//                                                 itemBuilder: (context, index) {
//                                                   if (index >=
//                                                       activitiesMap.length) {
//                                                     return const SizedBox();
//                                                   }
//                                                   return ListTile(
//                                                     title: Text(
//                                                         "${activitiesMap.keys.elementAt(index)}"),
//                                                     subtitle: Text(
//                                                         "${activitiesMap.values.elementAt(index)['start_time']} - ${activitiesMap.values.elementAt(index)['end_time']}"),
//                                                   );
//                                                 }),
//                                           ),
//                                         ],
//                                       )),
//                                 ]),
//                     );
//                   })),
//             ],
//             done: Text("Done",
//                 style: TextStyle(
//                     color: themeProvider.theme.primaryTextColor,
//                     fontWeight: FontWeight.w600)),
//             onDone: () async {
//               DatabaseReference ref = FirebaseDatabase.instance
//                   .ref('users/${FirebaseAuth.instance.currentUser!.uid}');

//               Api api = Api();
//               dynamic blah =
//                   await api.getUnscheduledTimes(jsonEncode(userJSON));
//               if (blah.runtimeType == int) {
//                 if (context.mounted) {
//                   Toasta(context).toast(Toast(
//                       title: "Error: $blah",
//                       subtitle:
//                           "Sorry for the inconvenience but please report this!",
//                       duration: const Duration(seconds: 3)));
//                 }
//               } else {
//                 var yerrrr = blah.data;

//                 userJSON['user_data']['user_constants']['pre_scheduled_time']
//                         ['base_unscheduled_times'] =
//                     yerrrr['base_unscheduled_times'];
//                 log(userJSON.toString());
//                 ref.set(userJSON);
//                 if (context.mounted) {
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const Basescreen()));
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDialog(Widget child, ThemeProvider themeProvider) {
//     showCupertinoModalPopup<void>(
//         context: context,
//         builder: (BuildContext context) => Container(
//               height: MediaQuery.of(context).size.height * .33,
//               padding: const EdgeInsets.only(top: 6.0),
//               // The Bottom margin is provided to align the popup above the system navigation bar.
//               margin: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               // Provide a background color for the popup.
//               color: themeProvider.theme.backgroundColor,
//               // Use a SafeArea widget to avoid system overlaps.
//               child: SafeArea(
//                 top: false,
//                 child: child,
//               ),
//             ));
//   }

//   String formDurat(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   void _updateWeight(List<double> sliders) {
//     double sumOfSliderValues = 0;
//     for (var i = 0; i < sliders.length; i++) {
//       sumOfSliderValues = sumOfSliderValues + sliders[i];
//     }
//     if (sliders[2] >= 20) {
//       for (var j = 0; j < sliders.length; j++) {
//         if (sliders[j] != sumOfSliderValues) {
//           sliders[j] = (sliders[j] / sumOfSliderValues) * 100;
//         }
//       }
//     } else {
//       for (var j = 0; j < sliders.length - 1; j++) {
//         if (sliders[j] != sumOfSliderValues) {
//           sliders[j] = (sliders[j] / sumOfSliderValues) * 100;
//         }
//       }
//     }
//   }

//   Future<void> _showTokenConmfirmationDialog(
//       BuildContext context, String token) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm This token is Right'),
//           content: Text(
//               '$token \nPlease confirm that the token you have entered is correct before you continue, the token must be correct to complete onboarding. If it is wrong press cancel and reenter the token. If it is correct and you are ready to complete the onboarding process press confirm.'),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Confirm'),
//               onPressed: () {
//                 userJSON["headers"]["Authorization"] = "Bearer $token";
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// extension StringCasingExtension on String {
//   String toCapitalized() =>
//       length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
//   String toTitleCase() => replaceAll(RegExp(' +'), ' ')
//       .split(' ')
//       .map((str) => str.toCapitalized())
//       .join(' ');
// }
