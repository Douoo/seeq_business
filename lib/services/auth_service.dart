import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:hive/hive.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
// import 'package:seeq_business/models/user.dart';

class Authentication extends Model {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  final String _url = 'https://warm-island-26970.herokuapp.com/event_organizer';
  // final userBox = Hive.openBox('user');
  // UserProfile _user = Hive.box('loggedInUser').get('user');

  // UserProfile get user {
  //   return _user;
  // }

  // set user(UserProfile user) {
  //   _user = user;
  // }

  bool get isLoading {
    return _isLoading;
  }

  bool isAuthenticated() {
    final user = _auth.currentUser;
    bool userAuthenticated = false;
    notifyListeners();

    if (user != null) {
      userAuthenticated = true;
      notifyListeners();
    }

    return userAuthenticated;
  }

  Future<void> logout() async {
    _auth.signOut();
  }

  String? username() {
    return _auth.currentUser!.displayName;
  }

  String? profilePicture() {
    return _auth.currentUser!.photoURL;
  }

  Future<bool> isUserRegistered() async {
    // _isLoading = true;
    // notifyListeners();
    await Hive.openBox('user');
    final userBox = Hive.box('user');
    http.Response response =
        await http.get(Uri.parse('$_url/${_auth.currentUser!.uid}'));

    Map<String, dynamic> user = json.decode(response.body);

    if (user.isEmpty) {
      // _isLoading = false;
      // notifyListeners();
      return false;
    } else {
      // _isLoading = false;
      // notifyListeners();
      final loggedInUser = UserProfile(
          id: user['_id'],
          name: user['displayName'],
          phoneNumber: user['phoneNumber'],
          description: user['about'],
          profilePicture: user['photoUrl'] ?? _auth.currentUser!.photoURL,
          coverPic: user['coverPhoto'] ?? '');
      userBox.put('loggedInUser', loggedInUser);
      return true;
    }
  }

  Future<bool> registerUser(Map<String, dynamic> user) async {
    _isLoading = true;
    notifyListeners();
    await Hive.openBox('user');
    final userBox = Hive.box('user');
    http.Response response =
        await http.post(Uri.parse('$_url/signup'), body: user);

    Map<String, dynamic> userData = json.decode(response.body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      _isLoading = false;
      notifyListeners();
      final loggedInUser = UserProfile(
        id: userData['_id'],
        name: userData['displayName'],
        phoneNumber: userData['phoneNumber'],
        description: userData['about'],
      );
      userBox.put('loggedInUser', loggedInUser);
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      print('user registration error');
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updateData) async {
    _isLoading = true;
    notifyListeners();

    await Hive.openBox('user');
    final user = Hive.box('user');
    try {
      http.Response response = await http.patch(
          Uri.parse('$_url/update/${_auth.currentUser!.uid}'),
          body: updateData);
      final Map<String, dynamic> updatedData = json.decode(response.body);
      if (response.statusCode == 200) {
        UserProfile updateUserInfo = UserProfile(
          id: updatedData['_id'],
          name: updatedData['displayName'],
          phoneNumber: updatedData['phoneNumber'],
          description: updatedData['about'],
          profilePicture:
              updatedData['photoUrl'] ?? _auth.currentUser!.photoURL,
          coverPic: updatedData['coverPhoto'] ?? '',
        );
        user.put('loggedInUser', updateUserInfo);
        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  // Future<void> getUserData([Map<String, dynamic>? newData]) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   final data =
  //       await _db.child('event_organizers/${_auth.currentUser!.uid}').once();
  //   final userData = data.snapshot.value as LinkedHashMap<dynamic, dynamic>;
  //   print('user : ${newData?['cover_picture']}');
  //   _user = UserProfile(
  //     id: _auth.currentUser!.uid,
  //     name: '${_auth.currentUser!.displayName}',
  //     coverPic:
  //         newData?['cover_picture'] == '' || newData?['cover_picture'] == null
  //             ? userData['cover_picture']
  //             : newData?['cover_picture'],
  //     profilePicture: '${_auth.currentUser!.photoURL}',
  //     phoneNumber: '${_auth.currentUser!.phoneNumber}',
  //     email: userData['email'] ?? '',
  //     website: userData['link'] ?? '',
  //   );
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // updateProfile(Map<String, dynamic> data) {
  //   _user = UserProfile(
  //     id: _auth.currentUser!.uid,
  //     name: '${_auth.currentUser!.displayName}',
  //     coverPic: data['cover_picture'],
  //     profilePicture: data['profile_picture'] ?? _auth.currentUser!.photoURL,
  //     phoneNumber: '${_auth.currentUser!.phoneNumber}',
  //     email: data['email'] ?? '',
  //     website: data['link'] ?? '',
  //   );
  //   notifyListeners();
  // }
// }
// notifyListeners();
  // }
}
