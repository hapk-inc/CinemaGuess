import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'models/language.dart';
import 'models/movie.dart';
import 'provider_list.dart';

class MovieDatabase {
  final Reader read;
  late DatabaseReference movieRef;
  late Reference storageRef;

  MovieDatabase(this.read) {
    movieRef = read(databaseProvider).ref().child('movies');

    storageRef = read(storageProvider).ref();
  }

  Query get todayMovies {
    final now = DateTime.now();
    String formatterNow = DateFormat('yMMMMd').format(now);
    return movieRef.orderByChild("posted_on").equalTo(formatterNow);
  }

  Future<Map> prevLangMovies(Lang lang) =>
      movieRef.orderByChild("lang").equalTo(lang.name).once().then(
        (DatabaseEvent databaseEvent) {
          if (!databaseEvent.snapshot.exists) return {};

          return databaseEvent.snapshot.value as Map;
        },
      );

  Stream<Movie> movie(String id) => movieRef.child(id).onValue.map(
        (DatabaseEvent event) {
          final map = event.snapshot.value as Map;
          Map<String, dynamic> json = Map<String, dynamic>.from(map);
          Movie movie = Movie.fromJson(json);
          return movie;
        },
      );

  Stream<String> onNewUserFound(String movieId) => movieRef
      .child(movieId)
      .child("users_found")
      .onChildAdded
      .map((event) => event.snapshot.value as String);

  Future updateNewFound(String id) async {
    final String user = read(firebaseUserProvider).uid;

    final userPlayedTransaction =
        movieRef.child(id).child("users_played").runTransaction(
      (mutableData) {
        final list = mutableData as List<dynamic>? ?? [];

        return Transaction.success([...list, if (!list.contains(user)) user]);
      },
    );

    final userFoundTransaction =
        movieRef.child(id).child("users_found").runTransaction(
      (mutableData) {
        final list = mutableData as List<dynamic>? ?? [];

        return Transaction.success([...list, if (!list.contains(user)) user]);
      },
    );
    return Future.wait([userFoundTransaction, userPlayedTransaction]);
  }

  Future<List<Reference>> imageClues(String id) async =>
      storageRef.child(id).list().then(
        (ListResult result) async {
          final List<Reference> files = result.items;
          return files;
        },
      );

  Future<String> moviePoster(String id) =>
      storageRef.child(id).child('main').child("portrait.jpg").getDownloadURL();

  Future<String> moviePosterLandscape(String id) => storageRef
      .child(id)
      .child('main')
      .child("landscape.jpg")
      .getDownloadURL();

  Future updatePlayed(String user, String id) async {
    //final String user = read(firebaseUserProvider).uid;
    final transactionResult =
        await movieRef.child(id).child("users_played").runTransaction(
      (mutableData) {
        final list = mutableData as List<dynamic>? ?? [];

        return Transaction.success([...list, if (!list.contains(user)) user]);
      },
    );
    return transactionResult.committed;
  }

  Future<Map<String, Movie>> get allMovies async => await movieRef.once().then(
        (DatabaseEvent event) {
          final snapshot = event.snapshot;

          Map movies = snapshot.value as Map;
          movies.updateAll(
            (key, value) {
              Map m = value;
              Map<String, dynamic> json = Map<String, dynamic>.from(m);
              Movie movie = Movie.fromJson(json);
              return movie;
            },
          );
          return movies.cast<String, Movie>();
        },
      );
}
