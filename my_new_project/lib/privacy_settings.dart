import 'package:flutter/material.dart';

class PrivacySettings extends StatefulWidget {
  @override
  _PrivacySettingsState createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool _profileVisibility = true;
  bool _commentsVisibility = true;
  bool _blockPeople = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Allow others to view profile'),
            value: _profileVisibility,
            onChanged: (bool value) {
              setState(() {
                _profileVisibility = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Allow comments on posts'),
            value: _commentsVisibility,
            onChanged: (bool value) {
              setState(() {
                _commentsVisibility = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Block other users'),
            value: _blockPeople,
            onChanged: (bool value) {
              setState(() {
                _blockPeople = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
