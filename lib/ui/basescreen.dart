import 'package:optitask/providers/tab_bar_provider.dart';
import 'package:optitask/ui/homescreen/homescreen.dart';
import 'package:optitask/ui/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

import '../providers/theme_provider.dart';

class Basescreen extends StatefulWidget {
  const Basescreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BasescreenState();
  }
}

class _BasescreenState extends State with SingleTickerProviderStateMixin {
  ThemeProvider themeChangeProvider = ThemeProvider();

  late TabController tabController;
  ItemScrollController dateListController = ItemScrollController();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  final DateFormat formatter = DateFormat('MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Consumer<TabBarViewModel>(
        builder: (context, tabViewModel, child) {
          return Scaffold(
              backgroundColor: themeProvider.theme.backgroundColor,
              bottomNavigationBar: Material(
                color: Colors.transparent,
                child: SalomonBottomBar(
                  currentIndex: tabViewModel.getTabIndex(),
                  onTap: (i) {
                    tabController.animateTo(i);
                    tabViewModel.setTabIndex(i);
                  },
                  items: [
                    /// Profile
                    SalomonBottomBarItem(
                      icon: Icon(
                        Icons.library_books,
                        color: themeProvider.theme.accentColor,
                      ),
                      title: const Text("Gradebook"),
                      selectedColor: themeProvider.theme.accentColor,
                    ),

                    /// Home
                    SalomonBottomBarItem(
                      icon: Icon(
                        Icons.home,
                        color: themeProvider.theme.accentColor,
                      ),
                      title: const Text("Scheduler"),
                      selectedColor: themeProvider.theme.accentColor,
                    ),

                    SalomonBottomBarItem(
                      icon: Icon(
                        Icons.settings,
                        color: themeProvider.theme.accentColor,
                      ),
                      title: const Text("Settings"),
                      selectedColor: themeProvider.theme.accentColor,
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                  child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  Center(
                    child: Text("This page is under construction 🔨"),
                  ),
                  Homescreen(),
                  SettingsView()
                ],
              )));
        },
      );
    });
  }
}
