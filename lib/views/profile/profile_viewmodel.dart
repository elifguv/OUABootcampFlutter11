import 'package:flutter/material.dart';
import 'profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileState _state = ProfileState();

  ProfileState get state => _state;

  //fetch only the username from Firestore
  Future<void> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic> ?? {};
      _state.userName = userData.containsKey('username')
          ? userData['username'] as String
          : '';
      notifyListeners();
    }
  }

  //update fields locally
  void updateBio(String bio) {
    _state.bio = bio;
    notifyListeners();
  }

  void updateWebsite(String website) {
    _state.website = website;
    notifyListeners();
  }

  void updatePhotoUrl(String photoUrl) {
    _state.photoUrl = photoUrl;
    notifyListeners();
  }

  void updateWorksCount(int worksCount) {
    _state.worksCount = worksCount;
    notifyListeners();
  }
}
