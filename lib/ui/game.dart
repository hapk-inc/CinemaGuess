import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/caps.dart';
import '../logic/images_index.dart';
import '../logic/models/language.dart';
import '../logic/models/movie.dart';
import '../logic/provider_list.dart';
import 'dialogs.dart';
import 'utils/game_loader.dart';
import 'utils/row_indicator.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      resizeToAvoidBottomInset: orientation == Orientation.portrait,
      body: SafeArea(
        child: orientation == Orientation.portrait
            ? const GamePagePortrait()
            : const GamePageLandScape(),
      ),
    );
  }
}

class GamePagePortrait extends ConsumerWidget {
  const GamePagePortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId = ref.watch(movieIdProvider..notifier);

    final size = MediaQuery.of(context).size;
    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    final Movie? movie = ref
        .watch(movieProvider(movieId))
        .maybeWhen(orElse: () => null, data: (m) => m);

    final portraitImageUrl = ref
        .watch(moviePosterProvider(movieId))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final landScapeImageUrl = ref
        .watch(moviePosterLandscapeProvider(movieId))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    ref.listen<int>(
      myRoundCountProvider(movieId).select((value) => value.value ?? 0),
      (prev, next) {
        switch (next) {
          case 6:
            {
              //context.router.pop();
              showDialog(
                context: context,
                builder: (context) => MovieInfoDialog(
                  id: movieId,
                  iMovie: movie!,
                  portraitImageUrl: portraitImageUrl,
                  landScapeImageUrl: landScapeImageUrl,
                  halfSize: true,
                ),
              );
            }
        }
      },
    );

    final textController = TextEditingController();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: movie == null
          ? const GamePageLoader()
          : Column(
              children: [
                Flexible(
                  flex: 19,
                  child: ref.watch(allCluesProvider(movieId)).when(
                        data: (urls) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: RowIndicator(),
                              ),
                            ),
                            Flexible(
                              flex: 4,
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                heightFactor: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: selectedRound == 5
                                        ? Container()
                                        : CachedNetworkImage(
                                            imageUrl: urls[selectedRound],
                                            key: ValueKey(selectedRound),
                                            fit: BoxFit.contain,
                                            placeholder: (ctx, __) =>
                                                DefaultTextStyle(
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              child: AnimatedTextKit(
                                                animatedTexts: [
                                                  FadeAnimatedText(
                                                      'Loading image')
                                                ],
                                                isRepeatingAnimation: true,
                                              ),
                                            ),
                                            errorWidget: (_, __, ___) =>
                                                const Center(
                                              child: Text("Error :("),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: myRoundCount == 6
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: AutoSizeText(
                                              "${movie.name.capitalize} (${movie.releasedOn})",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: size.width * 0.7),
                                              maxLines: 1,
                                            ),
                                          ),
                                          Flexible(
                                            child: AutoSizeText(
                                              "${movie.usersFound.length} found this movie",
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: size.width * 0.05),
                                            ),
                                          )
                                        ],
                                      )
                                    : TextField(
                                        autofocus: true,
                                        controller: textController,
                                        autocorrect: movie.lang == Lang.english,
                                        cursorHeight: size.shortestSide * 0.07,
                                        onChanged: (name) {
                                          if (movie.suggestions
                                              .contains(name.toLowerCase())) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  SnackBar(
                                                    elevation: 4,
                                                    content: Text(
                                                      "You mean ${movie.name.capitalize}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    action: SnackBarAction(
                                                      label: "Search",
                                                      onPressed: () {
                                                        ref.watch(
                                                            updateFoundProvider);
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                MovieInfoDialog(
                                                                  id: movieId,
                                                                  iMovie: movie,
                                                                  portraitImageUrl:
                                                                      portraitImageUrl,
                                                                  landScapeImageUrl:
                                                                      landScapeImageUrl,
                                                                  halfSize:
                                                                      true,
                                                                )).then(
                                                            (value) => context
                                                                .router
                                                                .popTop());
                                                      },
                                                    ),
                                                  ),
                                                )
                                                .closed
                                                .then((value) =>
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .clearSnackBars());
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              "It's a ${movie.lang.name.capitalize} movie",
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: size.shortestSide * 0.04,
                                            color: Colors.black38,
                                          ),
                                          suffixIcon: TextButton(
                                            child: const Text(
                                              'Skip',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            onPressed: () {
                                              ref.watch(
                                                  updateRoundProvider(movieId));
                                              ref
                                                  .watch(
                                                      selectedImageIndexProvider(
                                                              movieId)
                                                          .notifier)
                                                  .state = myRoundCount;
                                            },
                                          ),
                                          suffix: InkWell(
                                            onTap: () {
                                              if (textController.text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Enter something",
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                if (movie.suggestions.contains(
                                                        textController.text) ||
                                                    movie.name.toLowerCase() ==
                                                        textController.text
                                                            .toLowerCase()) {
                                                  ref.watch(
                                                      updateFoundProvider);
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          MovieInfoDialog(
                                                            id: movieId,
                                                            iMovie: movie,
                                                            portraitImageUrl:
                                                                portraitImageUrl,
                                                            landScapeImageUrl:
                                                                landScapeImageUrl,
                                                            halfSize: true,
                                                          )).then((value) =>
                                                      context.router.popTop());
                                                } else {
                                                  ref.watch(updateRoundProvider(
                                                      movieId));
                                                  ref
                                                      .watch(
                                                          selectedImageIndexProvider(
                                                                  movieId)
                                                              .notifier)
                                                      .state = myRoundCount;
                                                }
                                              }
                                            },
                                            child: const Text(
                                              "Search",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        error: (e, s) => Container(),
                        loading: () => const GamePageLoader(),
                      ),
                ),
                Flexible(
                    child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    child: Text(
                      movie.postedOn,
                      style: GoogleFonts.poppins(color: Colors.grey.shade400),
                    ),
                  ),
                ))
              ],
            ),
    );
  }
}

class GamePageLandScape extends ConsumerWidget {
  const GamePageLandScape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String movieId = ref.watch(movieIdProvider..notifier);
    final Movie? movie = ref
        .watch(movieProvider(movieId))
        .maybeWhen(orElse: () => null, data: (m) => m);
    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    final portraitImageUrl = ref
        .watch(moviePosterProvider(movieId))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final landScapeImageUrl = ref
        .watch(moviePosterLandscapeProvider(movieId))
        .maybeWhen(orElse: () => "", data: (url) => url);

    final size = MediaQuery.of(context).size;

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    final textController = TextEditingController();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: movie == null
          ? const GamePageLoader()
          : ref.watch(allCluesProvider(movieId)).maybeWhen(
                orElse: () => const GamePageLoader(),
                data: (urls) => Container(
                  padding: EdgeInsets.all(size.longestSide * 0.01),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: TextField(
                                autofocus: true,
                                controller: textController,
                                autocorrect: movie.lang == Lang.english,
                                cursorHeight: size.shortestSide * 0.07,
                                onChanged: (name) {
                                  if (movie.suggestions
                                      .contains(name.toLowerCase())) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                          SnackBar(
                                            elevation: 4,
                                            content: Text(
                                              "You mean ${movie.name.capitalize}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey),
                                            ),
                                            action: SnackBarAction(
                                              label: "Search",
                                              onPressed: () {
                                                ref.watch(updateFoundProvider);
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        MovieInfoDialog(
                                                          id: movieId,
                                                          iMovie: movie,
                                                          portraitImageUrl:
                                                              portraitImageUrl,
                                                          landScapeImageUrl:
                                                              landScapeImageUrl,
                                                          halfSize: true,
                                                        )).then((value) =>
                                                    context.router.popTop());
                                              },
                                            ),
                                          ),
                                        )
                                        .closed
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .clearSnackBars());
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      "It's a ${movie.lang.name.capitalize} movie",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: size.shortestSide * 0.04,
                                    color: Colors.black38,
                                  ),
                                  suffixIcon: TextButton(
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      ref.watch(updateRoundProvider(movieId));
                                      ref
                                          .watch(selectedImageIndexProvider(
                                                  movieId)
                                              .notifier)
                                          .state = myRoundCount;
                                    },
                                  ),
                                  suffix: InkWell(
                                    onTap: () {
                                      if (textController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Enter something",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (movie.suggestions.contains(
                                                textController.text) ||
                                            movie.name.toLowerCase() ==
                                                textController.text
                                                    .toLowerCase()) {
                                          ref.watch(updateFoundProvider);
                                          showDialog(
                                              context: context,
                                              builder: (_) => MovieInfoDialog(
                                                    id: movieId,
                                                    iMovie: movie,
                                                    portraitImageUrl:
                                                        portraitImageUrl,
                                                    landScapeImageUrl:
                                                        landScapeImageUrl,
                                                    halfSize: true,
                                                  )).then((value) =>
                                              context.router.popTop());
                                        } else {
                                          ref.watch(
                                              updateRoundProvider(movieId));
                                          ref
                                              .watch(selectedImageIndexProvider(
                                                      movieId)
                                                  .notifier)
                                              .state = myRoundCount;
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Search",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Flexible(
                              flex: 2,
                              child: RowIndicator(),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: CachedNetworkImage(
                              imageUrl: urls[selectedRound],
                              key: ValueKey(selectedRound),
                              fit: BoxFit.cover,
                              placeholder: (ctx, __) => DefaultTextStyle(
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText('Loading image')
                                  ],
                                  isRepeatingAnimation: true,
                                ),
                              ),
                              errorWidget: (_, __, ___) =>
                                  const Center(child: Text("Error :(")),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "You think you are a movie buff?"
                                  " Guess the cini using 5 snips",
                                  style: GoogleFonts.prompt(),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  movie.postedOn,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
