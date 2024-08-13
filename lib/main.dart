import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:optitask/providers/algorithm_values_provider.dart';
import 'package:optitask/providers/assignments_list_provider.dart';
import 'package:optitask/providers/auth_provider.dart';
import 'package:optitask/providers/stepper_provider.dart';
import 'package:optitask/providers/tab_bar_provider.dart';
import 'package:optitask/providers/theme_provider.dart';
import 'package:optitask/ui/basescreen.dart';
import 'package:optitask/ui/homescreen/homescreen.dart';

import 'package:optitask/ui/onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State with WidgetsBindingObserver {
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});

    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
              create: (context) => AuthProvider()),
          ChangeNotifierProvider<TabBarViewModel>(
              create: (context) => TabBarViewModel()),
          ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider()),
          ChangeNotifierProvider<AssignmentsListProvider>(
              create: (context) => AssignmentsListProvider()),
          ChangeNotifierProvider<StepperProvider>(
              create: (context) => StepperProvider()),
          ChangeNotifierProvider<AlgorithmValuesProvider>(
              create: (context) => AlgorithmValuesProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              theme: ThemeData(fontFamily: 'DMSans'),
              home: const Basescreen(),
            );
          },
        ));
  }
}
