import './bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBloc extends BlocBase {
  FireBloc();
  FirebaseAuth faInstance = FirebaseAuth.instance;
  FirebaseDatabase databaseReference = FirebaseDatabase.instance;

  deleteSuggestion(suggestionUid) async {
    databaseReference.reference().child('Suggestions').child(suggestionUid).remove();
  }

  getSuggestionsStream(type) {
    var values =  databaseReference
        .reference()
        .child('Suggestions');
    // TODO: сделать с orderByChild('time')
    return type >= 0 
      ? values
        .orderByChild('type')
        .equalTo(type)
        .limitToLast(100)
        .onValue
      : values
        .limitToLast(100)
        .orderByChild('time')
        .onValue;        
  }

  void createGame(map) async {
    var item = databaseReference.reference().child("Suggestions").push();
    await item.set(map);
  }

  getChatStream() {
    return databaseReference.reference().child('Chat').limitToLast(10).onValue;
  }

  void sendMessage(map) {
    databaseReference.reference().child("Chat").push().set(map);
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
    if (newPass.length >= 6) {
      await user.updatePassword(newPass);
    }
  }

  @override
  void dispose() {}
}
