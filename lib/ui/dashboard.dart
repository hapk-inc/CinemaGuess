import 'package:auto_route/auto_route.dart';
import 'package:cinema_guess/logic/caps.dart';
import 'package:cinema_guess/logic/provider_list.dart';
import 'package:cinema_guess/routes/my_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/models/language.dart';
import '../logic/models/movie.dart';
import '../logic/models/player.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) =>
                constraints.maxHeight > constraints.maxWidth
                    ? const DashboardPortrait()
                    : const DashboardLandscape(),
          ),
        ),
      );
}

final movie = Movie(
    lang: Lang.tamil, name: "aa", releasedOn: 2004, postedOn: "Jun 22,2022");

class DashboardPortrait extends StatelessWidget {
  const DashboardPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return Column(
      children: [
        Flexible(
          flex: 3,
          child: Container(
            color: Colors.red,
            constraints: const BoxConstraints.expand(),
            padding: EdgeInsets.all(highest * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Flexible(child: TodayMovieText()),
                Flexible(
                  flex: 4,
                  child: TodayMovieList(isPortrait: true),
                )
              ],
            ),
          ),
        ),
        const Flexible(
          flex: 6,
          child: DashboardPrevMovies(),
        ),
        Flexible(
          child: Container(
            color: Colors.blue.shade200,
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: "HAPK ",
                  children: [
                    TextSpan(
                      text: "presents",
                      style: TextStyle(
                        fontSize: highest * 0.015,
                        color: Colors.black38,
                      ),
                    )
                  ],
                  style: GoogleFonts.poppins(
                    fontSize: highest * 0.02,
                    color: Colors.black54,
                  ),
                ),
              ),
              subtitle: Text(
                "CinemaGuess",
                style: GoogleFonts.poppins(
                  fontSize: highest * 0.03,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardPrevMovies extends ConsumerWidget {
  const DashboardPrevMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return DefaultTabController(
      length: Lang.values.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: TabBar(
              tabs: Lang.values
                  .map(
                    (e) => Tab(
                      text: e.name.capitalize,
                    ),
                  )
                  .toList(),
            ),
          ),
          Flexible(
            flex: 4,
            child: TabBarView(
              children: Lang.values
                  .map<Widget>(
                    (e) => ref.watch(langMoviesProvider(e)).when(
                          data: (map) {
                            // print("langMovies Size ${list.length}");
                            return map.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No movies yet",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  )
                                : ListView(
                                    padding: EdgeInsets.all(highest * 0.01),
                                    scrollDirection: Axis.horizontal,
                                    children: map.entries.map(
                                      (e) {
                                        final String id = e.key;
                                        Map m = e.value as Map;
                                        Map<String, dynamic> json =
                                            Map<String, dynamic>.from(m);
                                        Movie movie = Movie.fromJson(json);
                                        return PrevMovieTile(id, movie);
                                      },
                                    ).toList(),
                                  );
                          },
                          error: (e, s) => Container(),
                          loading: () => Container(),
                        ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodayMovieTile extends ConsumerWidget {
  final String id;
  final Movie movie;
  const TodayMovieTile(this.id, {Key? key, required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String user = ref.watch(firebaseUserProvider).uid;

    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    final Player? player = ref.watch(playerProvider(user)).when(
        data: (data) => data,
        error: (e, s) {
          print(e);
          print(s);
          return null;
        },
        loading: () => null);
    final playerRounds = player?.rounds ?? {};

    final bool userFoundCheck =
        movie.usersFound.contains(user) || (playerRounds[id] == 6);
    return SizedBox(
      width: highest * 0.4,
      height: highest * 0.2,
      child: Card(
        elevation: 4,
        color: userFoundCheck ? null : Colors.brown,
        child: userFoundCheck
            ? GridTile(
                footer: Container(
                  color: Colors.black45,
                  height: highest * 0.05,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: FittedBox(
                                child: Text(
                                  "${movie.name} (${movie.releasedOn})"
                                      .capitalize,
                                  style: GoogleFonts.poppins(
                                      fontSize: highest * 0.02,
                                      color: Colors.white70),
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: AnimatedSwitcher(
                                  key: ValueKey(movie),
                                  duration: const Duration(milliseconds: 500),
                                  child: Text(
                                    "${movie.usersFound.length} found",
                                    style: GoogleFonts.poppins(
                                      fontSize: highest * 0.015,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      /* Flexible(
              child: Text(
                "${movie.usersFound.length} users found this..",
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: size.width * 0.03,
                ),
              ),
            )*/
                    ],
                  ),
                ),
                child: ref.watch(moviePosterLandscapeProvider(id)).when(
                    data: (data) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(data),
                              fit: BoxFit.fill,
                              //opacity: 0.5,
                            ),
                          ),
                        ),
                    error: (error, s) => Container(),
                    loading: () => Container()),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  title: Text(
                    "Guess the ${movie.lang.name} movie",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  subtitle: Text(
                    "${movie.usersPlayed.length} playing this round",
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
              ),
      ),
    );
  }
}

class PrevMovieTile extends ConsumerWidget {
  final String movieId;
  final Movie movie;
  const PrevMovieTile(this.movieId, this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String user = ref.watch(firebaseUserProvider).uid;
    //final user = "a";

    final Player? player = ref.watch(playerProvider(user)).when(
        data: (data) => data,
        error: (e, s) {
          print(e);
          print(s);
          return null;
        },
        loading: () => null);
    final playerRounds = player?.rounds ?? {};
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;
    final userFoundCheck =
        movie.usersFound.contains(user) || (playerRounds[movieId] == 6);
    return SizedBox(
      width: highest * 0.275,
      //height: 50,
      child: InkWell(
        onTap: userFoundCheck
            ? null
            : () {
                ref.read(movieIdProvider.notifier).state = movieId;
                context.router.push(GameRoute(movie: movie));
              },
        child: Card(
          elevation: 4,
          color: userFoundCheck ? null : Colors.brown,
          child: userFoundCheck
              ? ref.watch(moviePosterProvider(movieId)).maybeWhen(
                    orElse: () => Container(),
                    data: (url) => GridTile(
                      footer: Container(
                        color: Colors.black45,
                        height: highest * 0.05,
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: highest * 0.01),
                        child: Text(
                          "${movie.name} (${movie.releasedOn})".capitalize,
                          style: GoogleFonts.poppins(
                              fontSize: highest * 0.015, color: Colors.white70),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                        //child: Text("ll"),
                      ),
                    ),
                  )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    title: Text(
                      "Guess the ${movie.lang.name} movie",
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    subtitle: Text(
                      "${movie.usersPlayed.length} playing this round",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class DashboardLandscape extends ConsumerWidget {
  const DashboardLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.all(highest * 0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Flexible(child: TodayMovieText()),
                Flexible(
                  flex: 4,
                  child: TodayMovieList(),
                )
              ],
            ),
          ),
        ),
        const Flexible(
          flex: 6,
          child: DashboardPrevMovies(),
        ),
      ],
    );
  }
}

class TodayMovieList extends ConsumerWidget {
  final bool isPortrait;
  const TodayMovieList({Key? key, this.isPortrait = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String user = ref.watch(firebaseUserProvider).uid;
    return FirebaseAnimatedList(
      query: ref.watch(todayMoviesProvider),
      scrollDirection: isPortrait ? Axis.horizontal : Axis.vertical,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map map = snapshot.value as Map;
        final String id = snapshot.key ?? "";
        Map<String, dynamic> json = Map<String, dynamic>.from(map);
        Movie m = Movie.fromJson(json);

        return InkWell(
          onTap: m.usersFound.contains(user)
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Already Found",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  )
              : () {
                  ref.read(movieIdProvider.notifier).state = id;
                  context.router.push(GameRoute(movie: m));
                },
          child: TodayMovieTile(id, movie: m),
        );
      },
    );
  }
}

class TodayMovieText extends StatelessWidget {
  const TodayMovieText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return Text(
      "Today's movies",
      style: GoogleFonts.poppins(
        fontSize: highest * 0.02,
        color: Colors.white70,
      ),
    );
  }
}
