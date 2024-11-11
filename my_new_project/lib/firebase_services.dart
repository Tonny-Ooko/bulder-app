import 'dart:io'; // Importing dart:io for File class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Update phone number
  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        // Update phone number in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'phoneNumber': phoneNumber,
        });
      }
    } catch (e) {
      print('Error updating phone number: $e');
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await user.updatePassword(newPassword);
        await user.reload();
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  // Update phone number and password
  Future<void> updatePhoneAndPassword(String phone, String password, String verificationId, String smsCode) async {
    try {
      User? user = getCurrentUser();

      if (user != null) {
        // Update phone number
        await user.updatePhoneNumber(PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        ));

        // Update password
        await user.updatePassword(password);
      }
    } catch (e) {
      print('Error updating phone and password: $e');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        // Delete user document from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user from Firebase Auth
        await user.delete();
        print("Account deleted successfully.");
      } else {
        throw Exception("No user is currently logged in.");
      }
    } catch (e) {
      throw Exception("Failed to delete account: $e");
    }
  }

  // Get profile image URL from Firebase Storage
  Future<String?> getProfileImage(String userId) async {
    try {
      String downloadURL = await _storage
          .ref('users/$userId/profile_image.jpg')
          .getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error getting profile image: $e');
      return null;
    }
  }

  // Sync contacts or suggest account to others
  Future<void> suggestAccountToOthers(List<String> contacts) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'suggestedTo': contacts,
        });
      }
    } catch (e) {
      print('Error suggesting account: $e');
    }
  }

  // Block a user
  Future<void> blockUser(String blockedUserId) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
        });
      }
    } catch (e) {
      print('Error blocking user: $e');
    }
  }

  // Get profile views
  Future<List<String>> getProfileViews() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        List<String> profileViews =
            List.from(userDoc['profileViews'] ?? []);
        return profileViews;
      }
      return [];
    } catch (e) {
      print('Error fetching profile views: $e');
      return [];
    }
  }

  // Allow or deny comments visibility
  Future<void> updateCommentsVisibility(bool allowComments) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'allowComments': allowComments,
        });
      }
    } catch (e) {
      print('Error updating comments visibility: $e');
    }
  }

  // Report a problem
  Future<void> reportIssue(String issueDescription) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        await _firestore.collection('issues').add({
          'userId': user.uid,
          'description': issueDescription,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error reporting issue: $e');
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage(String filePath) async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        File file = File(filePath); // Create a File instance
        await _storage.ref('users/${user.uid}/profile_image.jpg').putFile(file);
        print("Profile image uploaded successfully.");
      }
    } catch (e) {
      print('Error uploading profile image: $e');
    }
  }

  // Method to get followers and following
  Future<List<String>> getFollowersFollowing() async {
    // Reference to the Firestore collection
    CollectionReference users = _firestore.collection('users');

    try {
      // Fetching all documents from the 'users' collection
      QuerySnapshot snapshot = await users.get();

      // Assuming each document has a 'name' field
      List<String> followersFollowing = snapshot.docs.map((doc) {
        return doc['name'].toString(); // Adjust according to your Firestore structure
      }).toList();

      return followersFollowing; // Return the list of names
    } catch (e) {
      // Handle any errors that may occur
      throw Exception("Failed to fetch followers or following: $e");
    }
  }
}
