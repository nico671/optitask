import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';

import '../../models/assignment.dart';
import '../../providers/assignments_list_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../providers/theme_provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  //TODO: Report button on homescreen save json and headers of api request to random github repo file
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  ItemScrollController dateListController = ItemScrollController();
  final DateFormat weekDayFormatter = DateFormat('EEE');
  final DateFormat dayNumberFormatter = DateFormat('d');
  final DateFormat formatter = DateFormat('MMMM yyyy');
  int dateListIndex = 0;
  DateFormat dayFormatter = DateFormat("EEEE");
  DateFormat fullFormatter = DateFormat("MMMM d, y");
  final GlobalKey<_HomescreenState> _scaffoldKey =
      GlobalKey<_HomescreenState>();

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentsListProvider>(
        builder: (context, aListController, child) {
      return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: aListController.assignmentList.isEmpty
                ? FloatingActionButton.large(
                    elevation: 0,
                    enableFeedback: false,
                    backgroundColor: themeProvider.theme.accentColor,
                    // .withGreen(150),
                    shape: const CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                    onPressed: (() async {
                      aListController.calculate(aListController.selectedDate,
                          context, aListController.selectedDate);
                    }),
                    child: Icon(
                      Icons.add,
                      color: themeProvider.theme.primaryTextColor,
                    ))
                : const SizedBox.shrink(),
            key: _scaffoldKey,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              title: Text(
                "OptiTask",
                style: TextStyle(
                  color: themeProvider.theme.primaryTextColor,
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          "${aListController.percentageCompleted().toInt()}% Done",
                          style: TextStyle(
                            color: themeProvider.theme.primaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        "Completed Tasks",
                        style: TextStyle(
                          color: themeProvider.theme.secondaryTextColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: themeProvider.theme.backgroundColor,
            body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text(
                                dayFormatter
                                    .format(aListController.selectedDate),
                                style: TextStyle(
                                  color: themeProvider.theme.primaryTextColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Text(
                              fullFormatter
                                  .format(aListController.selectedDate),
                              style: TextStyle(
                                color: themeProvider.theme.secondaryTextColor,
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (() {
                            showModalBottomSheet(
                                context: context,
                                builder: ((context) {
                                  return Container(
                                    color: themeProvider.theme.backgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          const Text("Select Date"),
                                          Expanded(
                                            child: Theme(
                                              data: ThemeData(
                                                  primaryColor: themeProvider
                                                      .theme.accentColor,
                                                  textTheme: Theme.of(context)
                                                      .textTheme
                                                      .apply(
                                                          bodyColor: themeProvider
                                                              .theme
                                                              .primaryTextColor,
                                                          displayColor:
                                                              themeProvider
                                                                  .theme
                                                                  .primaryTextColor)),
                                              child: SfDateRangePicker(
                                                minDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 14)),
                                                maxDate: DateTime.now().add(
                                                    const Duration(days: 14)),
                                                showActionButtons: true,
                                                selectionMode:
                                                    DateRangePickerSelectionMode
                                                        .single,
                                                view: DateRangePickerView.month,
                                                onCancel: (() {
                                                  Navigator.of(context).pop();
                                                }),
                                                onSubmit: (Object? p0) {
                                                  if (p0 != null) {
                                                    DateTime selectedDate =
                                                        p0 as DateTime;
                                                    aListController
                                                        .setSelectedDate(
                                                            selectedDate);

                                                    dateListController.scrollTo(
                                                        index: selectedDate
                                                            .difference(DateTime
                                                                    .now()
                                                                .subtract(
                                                                    const Duration(
                                                                        days:
                                                                            14)))
                                                            .inDays,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        curve:
                                                            Curves.easeInOut);
                                                  }
                                                  Navigator.of(context).pop();
                                                  return p0;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                backgroundColor: Colors.white);
                          }),
                          child: Icon(Icons.calendar_month,
                              color: themeProvider.theme.primaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  Material(
                      color: themeProvider.theme.backgroundColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                            ),
                            child: SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.height,
                              child: ScrollablePositionedList.builder(
                                  itemScrollController: dateListController,
                                  initialScrollIndex: 14,
                                  itemCount: 28,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: (() {
                                          aListController.setSelectedDate(
                                              DateTime.now().add(
                                                  Duration(days: index - 14)));
                                          setState(() {
                                            dateListIndex = index;
                                          });
                                        }),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: aListController.selectedDate.day ==
                                                          DateTime.now()
                                                              .add(Duration(
                                                                  days: index -
                                                                      14))
                                                              .day &&
                                                      aListController.selectedDate.month ==
                                                          DateTime.now()
                                                              .add(Duration(
                                                                  days: index -
                                                                      14))
                                                              .month &&
                                                      aListController.selectedDate.year ==
                                                          DateTime.now()
                                                              .add(Duration(days: index - 14))
                                                              .year
                                                  ? themeProvider.theme.calendarSelectedColor
                                                  : themeProvider.theme.calendarDeselectedColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(16))),
                                          height: 40,
                                          width: 55,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                dayNumberFormatter.format(
                                                    DateTime.now().add(Duration(
                                                        days: index - 14))),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: themeProvider
                                                      .theme.primaryTextColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  weekDayFormatter.format(
                                                      DateTime.now().add(
                                                          Duration(
                                                              days:
                                                                  index - 14))),
                                                  style: TextStyle(
                                                    color: themeProvider.theme
                                                        .secondaryTextColor,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeProvider.theme.backgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Theme(
                              data: ThemeData(canvasColor: Colors.transparent),
                              child: ReorderableListView.builder(
                                reverse: true,
                                proxyDecorator: proxyDecorator,
                                clipBehavior: Clip.antiAlias,
                                shrinkWrap: true,
                                onReorder: (oldIndex, newIndex) {
                                  if (aListController.assignmentList[oldIndex]
                                              .completed ==
                                          true ||
                                      aListController.assignmentList[newIndex]
                                              .completed ==
                                          true) {
                                    return;
                                  }
                                  Assignment movedItem =
                                      aListController.assignmentList[oldIndex];
                                  if (oldIndex > newIndex) {
                                    aListController.assignmentList
                                        .removeAt(oldIndex);
                                    aListController.assignmentList
                                        .insert(newIndex, movedItem);
                                  } else {
                                    aListController.assignmentList
                                        .removeAt(oldIndex);
                                    aListController.assignmentList
                                        .insert(newIndex - 1, movedItem);
                                  }
                                },
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    aListController.assignmentList.length,
                                itemBuilder: ((context, i) {
                                  return Padding(
                                    key: Key(i.toString()),
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8, bottom: 10),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .075,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16)),
                                          color: themeProvider
                                              .theme.cardBackgroundColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: themeProvider
                                                  .theme.shadowColor,
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  width: 8.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      16.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      16.0)),
                                                      color: aListController
                                                                  .assignmentList[
                                                                      i]
                                                                  .completed ==
                                                              true
                                                          ? themeProvider.theme
                                                              .completedColor
                                                          : themeProvider.theme
                                                              .pendingCompletionColor)),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 4.0),
                                                        child: Text(
                                                          aListController
                                                              .assignmentList[i]
                                                              .assignmentName,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            decoration: aListController
                                                                    .assignmentList[
                                                                        i]
                                                                    .completed
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            fontSize: 20,
                                                            color: aListController
                                                                    .assignmentList[
                                                                        i]
                                                                    .completed
                                                                ? themeProvider
                                                                    .theme
                                                                    .secondaryTextColor
                                                                    .withOpacity(
                                                                        .76)
                                                                : themeProvider
                                                                    .theme
                                                                    .primaryTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                      if (aListController
                                                              .assignmentList[i]
                                                              .completed ==
                                                          false) ...[
                                                        Text(
                                                          aListController
                                                              .assignmentList[i]
                                                              .courseName,
                                                          textWidthBasis:
                                                              TextWidthBasis
                                                                  .parent,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: themeProvider
                                                                .theme
                                                                .secondaryTextColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                setUpCompletionTime(
                                                    aListController
                                                        .assignmentList[i]
                                                        .time!),
                                                textWidthBasis:
                                                    TextWidthBasis.parent,
                                                style: TextStyle(
                                                  color: themeProvider
                                                      .theme.secondaryTextColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: MaterialButton(
                                                      padding: EdgeInsets.zero,
                                                      elevation: 0,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      enableFeedback: false,
                                                      animationDuration:
                                                          const Duration(
                                                              milliseconds: 0),
                                                      onPressed: () {
                                                        aListController
                                                            .toggleCompleted(i);
                                                      },
                                                      child: Icon(
                                                        Icons.check,
                                                        color: aListController
                                                                .assignmentList[
                                                                    i]
                                                                .completed
                                                            ? themeProvider
                                                                .theme
                                                                .completedColor
                                                            : themeProvider
                                                                .theme
                                                                .disabledAccentColor,
                                                      )),
                                                ),
                                              ),
                                            ])),
                                  );
                                }),
                              ),
                            )),
                      ),
                    ),
                  ),
                ])));
      });
    });
  }

  String setUpCompletionTime(String input) {
    List<String> splitTime = input.split(":");
    input = "${splitTime[0][1]}h ${splitTime[1]}m";
    return input;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
