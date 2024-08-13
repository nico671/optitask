import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class JsonViewPage extends StatefulWidget {
  const JsonViewPage({Key? key}) : super(key: key);

  @override
  State<JsonViewPage> createState() => _JsonViewPageState();
}

dynamic userJSON = {};

class _JsonViewPageState extends State<JsonViewPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder<DataSnapshot>(
        future: ref.child(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snap) {
          if (snap.hasData && !snap.hasError && snap.data!.value != null) {
            userJSON = snap.data!.value;
            return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      color: themeProvider.theme.primaryTextColor),
                ),
                title: Text(
                  'JSON Viewer',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.theme.primaryTextColor),
                ),
                elevation: 0,
                backgroundColor: themeProvider.theme.backgroundColor,
              ),
              body: Center(
                child: JsonView.string(
                  jsonEncode(userJSON),
                  theme: JsonViewTheme(
                      closeIcon: Icon(Icons.arrow_drop_up,
                          size: 18,
                          color: themeProvider.theme.primaryTextColor),
                      openIcon: Icon(Icons.arrow_drop_down,
                          size: 18,
                          color: themeProvider.theme.primaryTextColor),
                      backgroundColor: themeProvider.theme.backgroundColor,
                      keyStyle: TextStyle(
                          color: themeProvider.theme.primaryTextColor),
                      viewType: JsonViewType.collapsible),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('No data'),
              ),
            );
          }
        });
  }
}
