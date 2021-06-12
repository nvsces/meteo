import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meteo/models/arduino_simulyator.dart';
import 'package:meteo/pages/arduino_sennings_page.dart';
import 'package:meteo/services/auth.dart';
import 'package:meteo/services/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _deleteRealTimeDataBase() => DatabaseService.deleteRealTimeDatabase();

  void _deleteCloudFirestore() => DatabaseService.deleteCloudFirestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                AuthService().logOut();
              },
              icon: Icon(Icons.exit_to_app)),
        ],
        centerTitle: true,
        title: Text('Настройки'),
      ),
      body: Container(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Перенаправление трафика'),
              value: DatabaseService.isTrafficRedirection,
              onChanged: (value) {
                setState(() {
                  DatabaseService.isTrafficRedirection = value;
                });
              },
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArduinoSettingPage()),
                );
              },
              title: const Text('Симулятор Ардуино'),
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: ArduinoSimulyator.isActive,
                  onChanged: (value) {
                    setState(() {
                      ArduinoSimulyator.isActive = value;
                      if (value)
                        ArduinoSimulyator.startTimer();
                      else
                        ArduinoSimulyator.stopTimer();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _deleteRealTimeDataBase,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text('Очистить RealTimeDatabase'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _deleteCloudFirestore,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text('Очистить CloudFirestore'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
