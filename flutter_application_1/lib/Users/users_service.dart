import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManagement {
  storeNewUser(user, context, password, name) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser!.uid).set({
      'email': user.email,
      'name': name,
      'uid': user.uid,
      'photoUrl':
          'https://firebasestorage.googleapis.com/v0/b/signinsearchat.appspot.com/o/UsersImages%2Fdefoltimegeforeveryone.jpeg?alt=media&token=3781473e-efb3-4610-9e30-c3c72559f120',
      'about_yourself': '',
      'password': password,
      'emailVerified': false,
      'status': 'online',
      'currentChatId': ''
    }).catchError((e) {
      print(e);
    });
  }

  updateUserCurrentChat(String email, String chatId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'currentChatId': chatId,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  clearUserCurrentChat(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'currentChatId': '',
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getUserNameByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['name'];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class UserData {
  static String? photoURLPath;
  static String? aboutYourself;
  static String? name;
  static String? email;
}
