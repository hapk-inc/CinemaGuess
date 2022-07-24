import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth.dart';
import 'models/language.dart';
import 'models/movie.dart';
import 'models/player.dart';
import 'movie_database.dart';

final firebaseAppProvider = Provider<FirebaseApp>(
  (_) => throw UnimplementedError(),
);

final storageProvider = Provider<FirebaseStorage>(
  (ref) {
    final app = ref.read(firebaseAppProvider);
    return FirebaseStorage.instanceFor(app: app);
  },
);

final Provider<FirebaseDatabase> databaseProvider = Provider<FirebaseDatabase>(
  (ref) {
    final app = ref.read(firebaseAppProvider);
    print("27-->");
    print(app.options.databaseURL);
    return FirebaseDatabase.instanceFor(
        app: app,
        databaseURL: 'https://cinemaguess-hapk-default-rtdb.firebaseio.com');
  },
);

//////////////////////////////////////////////

final Provider<User> firebaseUserProvider = Provider<User>(
  (ref) {
    final Auth auth = ref.watch(authProvider);
    return auth.currentUser!;
  },
);

final Provider<Auth> authProvider = Provider<Auth>(
  (ref) => Auth(ref.read),
);

final AutoDisposeFutureProviderFamily<Player, String> playerProvider =
    FutureProvider.autoDispose.family<Player, String>(
  (ref, id) {
    final auth = ref.read(authProvider);
    return auth.player(id);
  },
);

final AutoDisposeFutureProviderFamily anonymousProvider =
    FutureProvider.autoDispose.family<void, String>(
  (ref, name) async {
    final auth = ref.read(authProvider);
    return auth.signInAnonymous(name: name);
  },
);

final StreamProvider<bool> userCheckProvider = StreamProvider<bool>(
  (ref) {
    final auth = ref.watch(authProvider);
    return auth.userCheck;
  },
);

final AutoDisposeStreamProviderFamily<int, String> myRoundCountProvider =
    StreamProvider.autoDispose.family<int, String>(
  (ref, id) {
    final auth = ref.read(authProvider);
    return auth.myRoundCount(id);
  },
);

///////////////////////

final AutoDisposeProvider<MovieDatabase> movieDatabaseProvider =
    Provider.autoDispose<MovieDatabase>(
  (ref) => MovieDatabase(ref.read),
);

final Provider<Query> todayMoviesProvider = Provider<Query>(
  (ref) {
    final movieDatabase = ref.read(movieDatabaseProvider);
    return movieDatabase.todayMovies;
  },
);

final FutureProviderFamily<Map, Lang> langMoviesProvider =
    FutureProvider.family<Map, Lang>(
  (ref, lang) {
    final movieDatabase = ref.read(movieDatabaseProvider);
    return movieDatabase.prevLangMovies(lang);
  },
);

final FutureProvider<Map<String, Movie>> allMoviesProvider = FutureProvider(
  (ref) async {
    print("AllMoviesProvider--103");
    final movieDatabase = ref.read(movieDatabaseProvider);
    return movieDatabase.allMovies;
  },
);

final StreamProviderFamily<Movie, String> movieProvider =
    StreamProvider.family<Movie, String>(
  (ref, id) {
    final movieDatabase = ref.read(movieDatabaseProvider);
    return movieDatabase.movie(id);
  },
);

final FutureProviderFamily<List<String>, String> allCluesProvider =
    FutureProvider.family<List<String>, String>(
  (ref, id) async {
    final movieDatabase = ref.read(movieDatabaseProvider);
    final List<Reference> refs = await movieDatabase.imageClues(id);
    final List<String> urls =
        await Future.wait(refs.map((e) => e.getDownloadURL()));
    return urls;
  },
);

final AutoDisposeFutureProvider<void> updateFoundProvider =
    FutureProvider.autoDispose<void>(
  (ref) {
    final String id = ref.watch(movieIdProvider.notifier).state;
    final movieDatabase = ref.watch(movieDatabaseProvider);
    return movieDatabase.updateNewFound(id);
  },
);

final FutureProviderFamily<String, String> moviePosterProvider =
    FutureProvider.family<String, String>(
  (ref, movie) {
    final gameDatabase = ref.read(movieDatabaseProvider);
    return gameDatabase.moviePoster(movie);
  },
);

final FutureProviderFamily<String, String> moviePosterLandscapeProvider =
    FutureProvider.family<String, String>(
  (ref, movie) {
    final gameDatabase = ref.read(movieDatabaseProvider);
    return gameDatabase.moviePosterLandscape(movie);
  },
);

final AutoDisposeFutureProviderFamily<void, String> updateRoundProvider =
    FutureProvider.autoDispose.family<void, String>(
  (ref, id) {
    final auth = ref.watch(authProvider);
    return auth.setRound(id);
  },
);

final movieIdProvider = StateNotifierProvider<MovieId, String>(
  (ref) => MovieId(),
);

class MovieId extends StateNotifier<String> {
  MovieId() : super("");
}
