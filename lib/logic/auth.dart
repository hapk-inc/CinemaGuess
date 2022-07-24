import 'package:cinema_guess/logic/movie_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/player.dart';
import 'provider_list.dart';

class Auth {
  final Reader read;
  late FirebaseAuth _auth;
  late DatabaseReference usersRef;

  Auth(this.read) {
    _auth = FirebaseAuth.instanceFor(app: read(firebaseAppProvider));
    if (kIsWeb) {
      _auth.setPersistence(Persistence.SESSION);
    }
    usersRef = read(databaseProvider).ref().child('users');
  }

  Stream<bool> get userCheck =>
      _auth.authStateChanges().map((event) => event != null);

  User? get currentUser => _auth.currentUser;

  Future signInAnonymous({String name = ""}) async {
    String uid = await _auth.signInAnonymously().then(
        (UserCredential userCredential) => userCredential.user?.uid ?? "");
    return usersRef.child(uid).child('name').set(name);
  }

  Future<Player> player(String id) async => usersRef.child(id).once().then(
        (DatabaseEvent databaseEvent) {
          final map = databaseEvent.snapshot.value as Map;
          Map<String, dynamic> json = Map<String, dynamic>.from(map);
          Player player = Player.fromJson(json);
          return player;
        },
      );

  Stream<int> myRoundCount(String movieId) {
    final String user = _auth.currentUser?.uid ?? "";

    return usersRef.child(user).child('rounds').child(movieId).onValue.map(
      (DatabaseEvent event) {
        if (!event.snapshot.exists) return 1;
        final int a = event.snapshot.value as int;
        return a;
      },
    );
  }

  Future setRound(String movieId) async {
    final String user = _auth.currentUser?.uid ?? "";

    return await usersRef
        .child(user)
        .child('rounds')
        .child(movieId)
        .runTransaction(
      (mutableData) {
        print("mutableData $mutableData");
        if (mutableData == null) {
          MovieDatabase(read).updatePlayed(user, movieId);
        }
        return Transaction.success((mutableData as int? ?? 1) + 1);
      },
    );
  }
}
