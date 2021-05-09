import 'package:flutter/material.dart';
import 'package:meteo/services/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Перенаправление трафика'),
              value: DatabaseService.isTrafficRedirection,
              onChanged: (value) {
                setState(() {
                  //switchValue = value;
                  DatabaseService.isTrafficRedirection = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
