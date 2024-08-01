import 'package:flutter/material.dart';
import 'profile_edit_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditViewModel extends ChangeNotifier {
  ProfileEditState _state = ProfileEditState();
  ProfileEditState get state => _state;

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      _state.userName = userDoc.data()?['username'] ??
          ''; //ATTENTION: if 'username' was managed under 'firstName' field. if not, change this
      _state.email = userDoc.data()?['email'] ?? '';
      notifyListeners();
    }
  }

  Future<void> updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'username': _state
            .userName, //if 'username' was managed under 'firstName' field. if not, change this
        'email': _state.email,
      });
      if (!disposed) {
        //check if the ViewModel is still active
        notifyListeners();
      }
    }
  }

//track if ViewModel is disposed. if so, dınt'd dispose it to update the username
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void updateUsername(String userName) {
    _state.userName = userName;
    notifyListeners();
  }

  void updateEmail(String email) {
    _state.email = email;
    notifyListeners();
  }
}
