import 'dart:collection';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinema_guess/logic/provider_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../logic/caps.dart';
import '../logic/models/language.dart';
import '../logic/models/movie.dart';
import '../logic/models/player.dart';
import '../routes/my_route.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: ref.watch(allMoviesProvider).when(
              error: (e, s) {
                print("37-->Error");
                print(e);
                print(s);
                return const Center(
                    child: Text("Error while loading all movies"));
              },
              loading: () => Center(
                    child: DefaultTextStyle(
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [WavyAnimatedText('Loading all movies')],
                        isRepeatingAnimation: true,
                      ),
                    ),
                  ),
              data: (map) => map.isEmpty
                  ? Container()
                  : orientation == Orientation.portrait
                      ? const DashboardPortrait()
                      : const DashboardLandscape()),
        ),
      ),
    );
  }
}

const List<String> noOnePlayedTamil = [
  "துவக்கம் சரியா இருக்கணும்",
  "ஆரம்பிக்களாங்களா??"
];

const List<String> noOnePlayedEng = [
  "Be the first to guess",
  "Take the lead",
  "Wanna know the movie before everyone else?"
];

class DashboardPortrait extends ConsumerWidget {
  const DashboardPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, Movie> allMovies = ref.watch(allMoviesProvider).value!;

    final now = DateTime.now();
    String formatterNow = DateFormat('yMMMMd').format(now);

    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Flexible(child: DashboardHeader()),
              Flexible(
                flex: 2,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: FadeIn(
                    child: CarouselSlider(
                      items: allMovies.entries
                          .where((element) =>
                              element.value.postedOn == formatterNow)
                          .map((e) => CarouselTodayMovieTile(e))
                          .toList(),
                      options: CarouselOptions(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Flexible(
          flex: 6,
          child: LangMovies(),
        )
      ],
    );
  }
}

class LangMovies extends StatelessWidget {
  const LangMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FadeInUp(
      child: Container(
        constraints: const BoxConstraints.expand(),
        padding: EdgeInsets.all(size.shortestSide * 0.01),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.shortestSide * 0.075),
            topRight: Radius.circular(size.shortestSide * 0.075),
          ),
        ),
        child: DefaultTabController(
          length: Lang.values.length,
          child: Column(
            children: [
              Flexible(
                child: TabBar(
                  tabs: Lang.values
                      .map((e) => Tab(text: e.name.capitalize))
                      .toList(),
                ),
              ),
              const Expanded(flex: 4, child: LangMoviesPortrait())
            ],
          ),
        ),
      ),
    );
  }
}

class AllMovieTileLandscape extends ConsumerWidget {
  const AllMovieTileLandscape(this.id, this.movie, {Key? key})
      : super(key: key);

  final String id;
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String uid = ref.watch(firebaseUserProvider).uid;
    final iMovie = ref
        .watch(movieProvider(id))
        .maybeWhen(orElse: () => movie, data: (a) => a);
    final size = MediaQuery.of(context).size;

    final portraitImageUrl = ref
        .watch(moviePosterProvider(id))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final landScapeImageUrl = ref
        .watch(moviePosterLandscapeProvider(id))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final bool alreadyFound = iMovie.usersFound.contains(uid);
    return SizedBox(
      width: size.width * 0.275,
      child: Card(
        color: Colors.lightBlue.shade900,
        elevation: 4,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: alreadyFound
              ? portraitImageUrl.isEmpty
                  ? Container()
                  : GridTile(
                      footer: Container(
                        height: size.height * 0.12,
                        color: Colors.transparent.withOpacity(0.5),
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: AutoSizeText(
                                iMovie.name.capitalize,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: size.width * 0.025),
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  builder: (_) => MovieInfoDialog(
                                    landScapeImageUrl: landScapeImageUrl,
                                    iMovie: iMovie,
                                    id: id,
                                    portraitImageUrl: portraitImageUrl,
                                  ),
                                ),
                                child: const Text("VIEW"),
                              ),
                            )
                          ],
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(size.shortestSide * 0.01),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(portraitImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
              : InkWell(
                  onTap: () {
                    ref.read(movieIdProvider.notifier).state = id;
                    context.router.push(const GameRoute());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(size.shortestSide * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            movie.postedOn,
                            minFontSize: 24,
                            maxFontSize: 36,
                            style: const TextStyle(color: Colors.white60),
                            maxLines: 2,
                          ),
                        ),
                        // const Spacer(),
                        Flexible(
                          child: Center(
                            child: AutoSizeText(
                              "Click here",
                              style: TextStyle(
                                fontSize: size.shortestSide * 0.07,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: DefaultTextStyle(
                              style: GoogleFonts.poppins(color: Colors.white38),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  FadeAnimatedText(
                                      '${iMovie.usersPlayed.length} played this quiz'),
                                  FadeAnimatedText(
                                      '${iMovie.usersFound.length} found this quiz'),
                                ],
                                pause: Duration(seconds: Random().nextInt(5)),
                                onTap: () {
                                  print("Tap Event");
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class LangMoviesPortrait extends ConsumerWidget {
  const LangMoviesPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final Map<String, Movie> allMovies = Map<String, Movie>.from(
      ref.watch(allMoviesProvider).maybeWhen(
            orElse: () => {},
            data: (v) => v,
          ),
    );

    final User user = ref.watch(firebaseUserProvider);

    final orientation = MediaQuery.of(context).orientation;

    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: Lang.values.map(
        (lang) {
          final Map<String, Movie> langMovies = {};
          allMovies.forEach((key, value) {
            final checkDate = DateTime.now().subtract(
                Duration(days: orientation == Orientation.portrait ? 1 : 0));
            DateTime date = DateFormat("yMMMMd").parse(value.postedOn);

            if (checkDate.compareTo(date) == 1 && value.lang == lang) {
              langMovies[key] = value;
            }
          });

          print(langMovies);

          final sorted = SplayTreeMap<String, Movie>.from(
            langMovies,
            (m1, m2) {
              Movie a = langMovies[m1]!;
              Movie b = langMovies[m2]!;

              DateTime aDate = DateFormat("yMMMMd").parse(a.postedOn);
              DateTime bDate = DateFormat("yMMMMd").parse(b.postedOn);

              return aDate.compareTo(bDate);
            },
          );

          return ListView(
            reverse: true,
            padding: EdgeInsets.all(size.shortestSide * 0.02),
            scrollDirection: Axis.horizontal,
            children: sorted.entries
                // .where((element) => element.value.lang == lang)
                .map((eMap) {
              final portraitImageUrl = ref
                  .watch(moviePosterProvider(eMap.key))
                  .maybeWhen(orElse: () => "", data: (url) => url);

              final landScapeImageUrl =
                  ref.watch(moviePosterLandscapeProvider(eMap.key)).maybeWhen(
                        orElse: () => "",
                        data: (url) => url,
                      );

              final iMovie = ref
                  .watch(movieProvider(eMap.key))
                  .maybeWhen(orElse: () => eMap.value, data: (i) => i);

              return orientation == Orientation.landscape
                  ? AllMovieTileLandscape(eMap.key, eMap.value)
                  : SizedBox(
                      width: size.width * 0.5,
                      child: Card(
                        color: Colors.lightBlue.shade900,
                        elevation: 4,
                        child: iMovie.usersFound.contains(user.uid)
                            ? GridTile(
                                footer: Container(
                                  height: size.height * 0.07,
                                  color: Colors.transparent.withOpacity(0.5),
                                  //color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: AutoSizeText(
                                          eMap.value.name.capitalize,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: size.width * 0.04),
                                          maxLines: 1,
                                        ),
                                      ),
                                      Flexible(
                                        child: TextButton(
                                          onPressed: () => showDialog(
                                            context: context,
                                            useSafeArea: true,
                                            builder: (_) => MovieInfoDialog(
                                              id: eMap.key,
                                              iMovie: iMovie,
                                              portraitImageUrl:
                                                  portraitImageUrl,
                                              landScapeImageUrl:
                                                  landScapeImageUrl,
                                            ),
                                          ),
                                          child: const Text("VIEW"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: portraitImageUrl.isEmpty
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.all(
                                              size.shortestSide * 0.01),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  portraitImageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  ref.read(movieIdProvider.notifier).state =
                                      eMap.key;
                                  context.router.push(GameRoute());
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(size.shortestSide * 0.01),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          eMap.value.postedOn,
                                          minFontSize: 24,
                                          maxFontSize: 36,
                                          style: const TextStyle(
                                            color: Colors.white60,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: AutoSizeText(
                                            "Click this!",
                                            style: TextStyle(
                                                fontSize:
                                                    size.shortestSide * 0.07),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: AnimatedTextKit(
                                          animatedTexts: [
                                            RotateAnimatedText(eMap.value
                                                    .usersPlayed.isNotEmpty
                                                ? "${eMap.value.usersPlayed.length} played this game"
                                                : eMap.value.lang == Lang.tamil
                                                    ? noOnePlayedTamil[
                                                        Random().nextInt(2)]
                                                    : noOnePlayedEng[
                                                        Random().nextInt(2)]),
                                            RotateAnimatedText(
                                                '${eMap.value.usersFound.length} found this game'),
                                          ],
                                          isRepeatingAnimation: false,
                                          repeatForever: false,
                                          pause: Duration(
                                              milliseconds: Random().nextBool()
                                                  ? 200
                                                  : 500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    );
            }).toList(),
          );
        },
      ).toList(),
    );
  }
}

class CarouselTodayMovieTile extends ConsumerWidget {
  final MapEntry<String, Movie> mEntry;
  const CarouselTodayMovieTile(this.mEntry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final User user = ref.watch(firebaseUserProvider);

    final Movie iMovie = ref
        .watch(movieProvider(mEntry.key))
        .maybeWhen(orElse: () => mEntry.value, data: (m) => m);

    final bool alreadyFound = iMovie.usersFound.contains(user.uid);

    final landScapeImageUrl =
        ref.watch(moviePosterLandscapeProvider(mEntry.key)).maybeWhen(
              orElse: () => "",
              data: (url) => url,
            );

    final portraitImageUrl =
        ref.watch(moviePosterProvider(mEntry.key)).maybeWhen(
              orElse: () => "",
              data: (url) => url,
            );

    return Card(
      color: Colors.grey.shade600,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: alreadyFound
            ? landScapeImageUrl.isEmpty
                ? Container()
                : GridTile(
                    footer: Container(
                      height: size.height * 0.075,
                      color: Colors.transparent.withOpacity(0.5),
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: AutoSizeText(
                              "${iMovie.name.capitalize} (${iMovie.releasedOn})",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () => showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => MovieInfoDialog(
                                  id: mEntry.key,
                                  iMovie: iMovie,
                                  portraitImageUrl: portraitImageUrl,
                                  landScapeImageUrl: landScapeImageUrl,
                                ),
                              ),
                              child: const Text("view"),
                            ),
                          )
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(landScapeImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
            : InkWell(
                onTap: () {
                  ref.read(movieIdProvider.notifier).state = mEntry.key;
                  context.router.push(GameRoute());
                },
                child: Center(
                  child: ListTile(
                    title: Text(
                      mEntry.value.lang.name.capitalize,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: size.shortestSide * 0.1),
                    ),
                    subtitle: SizedBox(
                      height: size.height * 0.07,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          RotateAnimatedText(iMovie.usersPlayed.isNotEmpty
                              ? "${iMovie.usersPlayed.length} played this game"
                              : mEntry.value.lang == Lang.tamil
                                  ? noOnePlayedTamil[Random().nextInt(2)]
                                  : noOnePlayedEng[Random().nextInt(2)]),
                          RotateAnimatedText(
                              '${iMovie.usersFound.length} found this game'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class MovieInfoDialog extends ConsumerWidget {
  const MovieInfoDialog({
    Key? key,
    required this.id,
    required this.iMovie,
    required this.portraitImageUrl,
    required this.landScapeImageUrl,
  }) : super(key: key);

  final String id;
  final Movie iMovie;
  final String portraitImageUrl;
  final String landScapeImageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    final orientation = MediaQuery.of(context).orientation;

    final user = ref.watch(firebaseUserProvider);

    final Player? player = ref.watch(playerProvider(user.uid)).when(
          data: (data) => data,
          error: (e, s) => null,
          loading: () => null,
        );

    final int myRoundCount = ref.watch(myRoundCountProvider(id)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: size.height,
        width: size.width,
        child: GridTile(
          footer: FadeInUp(
            child: Container(
              height: orientation == Orientation.portrait
                  ? size.height * 0.15
                  : size.height * 0.25,
              color: Colors.transparent.withOpacity(0.5),
              padding: orientation == Orientation.portrait
                  ? EdgeInsets.all(size.width * 0.04)
                  : EdgeInsets.all(size.height * 0.02),
              //alignment: Alignment.centerLeft,
              child: FadeInRight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 2,
                            child: AutoSizeText(
                              "${iMovie.name.capitalize} (${iMovie.releasedOn})",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          if (player != null)
                            Flexible(
                              flex: 2,
                              child: AutoSizeText(
                                "Your score: $myRoundCount/ 5",
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ),
                          Flexible(
                            child: AutoSizeText(
                              "${iMovie.usersFound.length} found this movie",
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: size.width * 0.02),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: TextButton(
                        onPressed: () async {
                          String str = myRoundCount == 6
                              ? "❌❌❌❌❌"
                              : List.generate(
                                  myRoundCount ?? 1,
                                  (index) => index == (myRoundCount - 1)
                                      ? "✅"
                                      : "❌").join();
                          await Share.share(
                            'On ${iMovie.postedOn} / ${iMovie.lang.name.capitalize} \n\n$str\n${iMovie.usersFound.length} found this movie \n '
                            'https://cinemaguess-hapk.web.app/',
                            //title: 'CinemaGuess',
                            //linkUrl: 'https://flutter.dev/',
                            //linkUrl: 'https://cinemaguess-hapk.web.app/',
                            //chooserTitle: 'Example Chooser Title',
                          );
                        },
                        child: const AutoSizeText("SHARE", maxLines: 1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    orientation == Orientation.portrait
                        ? portraitImageUrl
                        : landScapeImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final User user = ref.watch(firebaseUserProvider);

    final Player? player = ref.watch(playerProvider(user.uid)).when(
          data: (data) => data,
          error: (e, s) => null,
          loading: () => null,
        );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: player == null
          ? Container()
          : FadeInDown(
              child: ListTile(
                title: Row(
                  children: [
                    Flexible(
                        flex: 2,
                        child: Text(
                          "Hi ${player.name}",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: size.shortestSide * 0.05,
                          ),
                        )),
                    Flexible(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "EDIT",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  "Start guessing today's movies",
                  style: TextStyle(
                    fontSize: size.shortestSide * 0.025,
                    color: Colors.white54,
                  ),
                ),
                trailing: Text(
                  "PICOFILM",
                  style: GoogleFonts.luckiestGuy(
                    fontSize: size.shortestSide * 0.07,
                    fontWeight: FontWeight.w900,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
    );
  }
}

class DashboardLandscape extends StatelessWidget {
  const DashboardLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Flexible(
          fit: FlexFit.tight,
          child: DashboardHeader(),
        ),
        Flexible(
          flex: 4,
          child: LangMovies(),
        ),
      ],
    );
  }
}
