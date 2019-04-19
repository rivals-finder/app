import './bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBloc extends BlocBase {
  FireBloc();
  FirebaseAuth faInstance = FirebaseAuth.instance;
  FirebaseDatabase databaseReference = FirebaseDatabase.instance;

  getSuggestionsStream() {
    return databaseReference.reference().child('Suggestions').limitToFirst(10).onValue;
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

  getCurrentUser() {
    return faInstance.currentUser();
  }

  @override
  void dispose() {}
}
