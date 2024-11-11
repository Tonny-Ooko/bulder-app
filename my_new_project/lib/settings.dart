import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isProfilePublic = true;
  bool isDataSaverOn = false;
  bool isProfileViewAllowed = true;
  double volumeLevel = 50;
  String selectedLanguage = 'English';
  List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];

  void _clearCache() {
    // Logic for clearing cache
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Cache Cleared!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Public Profile'),
              subtitle: Text('Allow everyone to see your profile'),
              value: isProfilePublic,
              onChanged: (bool value) {
                setState(() {
                  isProfilePublic = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Data Saver'),
              subtitle: Text('Turn on data saver to limit data usage'),
              value: isDataSaverOn,
              onChanged: (bool value) {
                setState(() {
                  isDataSaverOn = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Allow Profile Views'),
              subtitle: Text('See who viewed your profile'),
              value: isProfileViewAllowed,
              onChanged: (bool value) {
                setState(() {
                  isProfileViewAllowed = value;
                });
              },
            ),
            ListTile(
              title: Text('Volume'),
              subtitle: Slider(
                value: volumeLevel,
                min: 0,
                max: 100,
                divisions: 10,
                label: volumeLevel.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    volumeLevel = value;
                  });
                },
              ),
            ),
            DropdownButtonFormField(
              value: selectedLanguage,
              decoration: InputDecoration(labelText: 'Select Language'),
              items: languages.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
                // Logic to switch app language
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _clearCache,
              child: Text('Clear Cache'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
          ],
        ),
      ),
    );
  }
}
