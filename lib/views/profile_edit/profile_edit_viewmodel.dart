import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/image.dart';
import 'profile_edit_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final ProfileEditState _state = ProfileEditState();
  ProfileEditState get state => _state;
  
  //UYARI: yanlış class'ı kullanmış olabilirim
  final defaultImage = ImageM(
      url: '',
      storagePath: '',
      imageUrl: '',
      storageId: '');

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      _state.userName = userDoc.data()?['username'] ?? '';
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
        'username': _state.userName,
        'email': _state.email,
      });
      if (!disposed) {
        //check if the ViewModel is still active
        notifyListeners();
      }
    }
  }

//track if ViewModel is disposed. if so, don't dispose it to update the username
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

  //UYARI: istenen fotoğrafı çekmeyebilir, deneyemedim
  void updatePhotoUrl(String filePath) async {
    User? user = FirebaseAuth.instance.currentUser;
    File file = File(filePath);
    try {
      var snapshot = await FirebaseStorage.instance
          .ref('profile_images/${user!.uid}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      _state.photoUrl = downloadUrl;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'photoUrl': downloadUrl});
      notifyListeners();
    } catch (e) {
      print(e); //log error
    }
  }
}
