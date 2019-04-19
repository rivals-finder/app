import './bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBloc extends BlocBase {
  FireBloc();
  FirebaseAuth faInstance = FirebaseAuth.instance;
  FirebaseDatabase databaseReference = FirebaseDatabase.instance;

  getSuggestionsStream() {
    return databaseReference
        .reference()
        .child('Suggestions')
        .orderByChild('time')
        .limitToLast(100)
        .onValue;
  }

  void createGame(map) async {
    var item = databaseReference.reference().child("Suggestions").push();
    await item.set(map);
  }

  getTestList() async {
    return new List(5);
  }

  logOut() async {
    await faInstance.signOut();
  }

  logIn(email, pass) async {
    await faInstance.signInWithEmailAndPassword(email: email, password: pass);
  }

  getCurrentUser() async {
    return await faInstance.currentUser();
  }

  changeCurrentUserInfo(String newName, String newPass) async {
    var user = await faInstance.currentUser();
    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = newName;
    await user.updateProfile(info);
    await user.updatePassword(newPass);
  }

  @override
  void dispose() {}
}
