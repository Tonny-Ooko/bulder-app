import 'package:flutter/material.dart';
import 'update_profile_image.dart';
import 'update_phone_password.dart';
import 'privacy_settings.dart';
import 'account_deletion.dart';
import 'profile_views.dart';
import 'followers_following.dart';
import 'social_connections.dart';
import 'mentions.dart';
import 'settings.dart';
import 'support.dart';
import 'subscription.dart';


class ManageAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Account'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Update Profile Image"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileImage())),
          ),
          ListTile(
            title: Text("Update Phone Number & Password"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePhonePassword())),
          ),
          ListTile(
            title: Text("Privacy Settings"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettings())),
          ),
          ListTile(
            title: Text("View Profile Views"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileViews())),
          ),
          ListTile(
            title: Text("Followers & Following"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FollowersFollowing())),
          ),
          ListTile(
            title: Text("Mentions"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MentionsPage())),
          ),
          ListTile(
            title: Text("Social Connections"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SocialConnections())),
          ),
          ListTile(
            title: Text("General Settings"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
          ),
          ListTile(
            title: Text("Subscription Settings"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage())),
          ),
          ListTile(
            title: Text("Support"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SupportPage())),
          ),
          ListTile(
            title: Text("Delete Account"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountDeletionPage())),
          ),
        ],
      ),
    );
  }
}
