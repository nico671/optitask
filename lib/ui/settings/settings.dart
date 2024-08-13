import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optitask/providers/theme_provider.dart';
import 'package:optitask/ui/settings/json_page_view.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_colorpicker/flutter_native_colorpicker.dart';

import '../../providers/auth_provider.dart';
import '../loginscreen/loginscreen.dart';
import 'algorithm_values_page.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsViewState();
  }
}

TextEditingController controller = TextEditingController(
    text:
        '2873~tdZsbrNUkrdbHzBJKlSnkQUwHwaznrkH934zB2GufKShqlFMkwx9WuA0sDxTDfIa');

class _SettingsViewState extends State {
  GlobalKey key = GlobalKey();
  Color color = Colors.black;
  StreamSubscription? listener;
  Future<void> openColorpicker() async {
    final box = key.currentContext?.findRenderObject();

    if (box is! RenderBox) {
      throw StateError('Render object is not a render box');
    }

    final position = box.localToGlobal(Offset.zero);

    FlutterNativeColorpicker.open(position & box.size);

    listener = FlutterNativeColorpicker.startListener((col) {
      setState(() {
        color = col;
      });
    });
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
          title: Text('Settings',
              style: TextStyle(
                color: themeProvider.theme.primaryTextColor,
                fontSize: 40,
                fontWeight: FontWeight.w400,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SettingsList(
            lightTheme: SettingsThemeData(
                settingsListBackground: Colors.transparent,
                settingsSectionBackground:
                    themeProvider.theme.calendarDeselectedColor,
                dividerColor: themeProvider.theme.backgroundColor),
            sections: [
              SettingsSection(
                  tiles: [
                    SettingsTile.navigation(
                      title: Text(
                        'Algorithm Values Editor',
                        style: TextStyle(
                            color: themeProvider.theme.primaryTextColor),
                      ),
                      onPressed: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AlgorithmValuesPage()));
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text(
                        'See your data',
                        style: TextStyle(
                            color: themeProvider.theme.primaryTextColor),
                      ),
                      onPressed: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const JsonViewPage()));
                      },
                    )
                  ],
                  title: Text(
                    'Algorithm Values',
                    style:
                        TextStyle(color: themeProvider.theme.primaryTextColor),
                  )),
              SettingsSection(tiles: [
                SettingsTile(
                  title: Text(
                    'Log Out',
                    style:
                        TextStyle(color: themeProvider.theme.primaryTextColor),
                  ),
                  onPressed: (context) {
                    authProvider.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                ),
              ], title: const Text('Account')),
            ]));
  }
}
