import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_guess/ui/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../logic/caps.dart';
import '../logic/images_index.dart';
import '../logic/models/language.dart';
import '../logic/models/movie.dart';
import '../logic/provider_list.dart';

class GamePage extends ConsumerWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final textController = TextEditingController();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: movie == null
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Do you watch Movies \nframe by frame,\nremember "
                "the scenes still now?",
                style: TextStyle(
                  fontSize: size.shortestSide * 0.05,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ref.watch(allCluesProvider(movieId)).when(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: CachedNetworkImage(
                              imageUrl: urls[selectedRound],
                              key: ValueKey(selectedRound),
                              fit: BoxFit.contain,
                              placeholder: (ctx, __) => DefaultTextStyle(
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.blue.shade800,
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
                    ),
                    Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                            label: "Search", onPressed: () {}),
                                      ),
                                    )
                                    .closed
                                    .then((value) =>
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars());
                                ;
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                                  "It's a ${movie.lang.name.capitalize} movie",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: size.shortestSide * 0.04,
                                color: Colors.black38,
                              ),
                              suffix: TextButton(
                                onPressed: () {
                                  if (movie.suggestions
                                          .contains(textController.text) ||
                                      movie.name.toLowerCase().trim() ==
                                          textController.text
                                              .toLowerCase()
                                              .trim()) {
                                    final portraitImageUrl = ref
                                        .watch(moviePosterProvider(movieId))
                                        .maybeWhen(
                                            orElse: () => "",
                                            data: (url) => url);

                                    final landScapeImageUrl = ref
                                        .watch(moviePosterLandscapeProvider(
                                            movieId))
                                        .maybeWhen(
                                            orElse: () => "",
                                            data: (url) => url);
                                    ref.watch(updateFoundProvider);
                                    showDialog(
                                        context: context,
                                        builder: (_) => MovieInfoDialog(
                                            id: movieId,
                                            iMovie: movie,
                                            portraitImageUrl: portraitImageUrl,
                                            landScapeImageUrl:
                                                landScapeImageUrl)).then(
                                        (value) => context.router.popTop());
                                  } else {
                                    ref.watch(updateRoundProvider(movieId));
                                  }
                                },
                                child: const Text("Search"),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                error: (e, s) => Container(),
                loading: () => Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "Do u watch movies frame by frame and remember the scenes still now?"),
                ),
              ),
    );
  }
}

class GamePageLandScape extends ConsumerWidget {
  const GamePageLandScape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId = ref.watch(movieIdProvider.notifier).state;
    final Movie? movie = ref
        .watch(movieProvider(movieId))
        .maybeWhen(orElse: () => null, data: (m) => m);
    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    final size = MediaQuery.of(context).size;

    final textController = TextEditingController();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: movie == null
          ? Container()
          : ref.watch(allCluesProvider(movieId)).maybeWhen(
                orElse: () => Container(),
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
                                cursorHeight: size.shortestSide * 0.05,
                                onSubmitted: (str) {
                                  print(str);
                                  if (movie.suggestions
                                      .contains(textController.text)) {
                                    final portraitImageUrl = ref
                                        .watch(moviePosterProvider(movieId))
                                        .maybeWhen(
                                            orElse: () => "",
                                            data: (url) => url);

                                    final landScapeImageUrl = ref
                                        .watch(moviePosterLandscapeProvider(
                                            movieId))
                                        .maybeWhen(
                                            orElse: () => "",
                                            data: (url) => url);
                                    ref.watch(updateFoundProvider);
                                    showDialog(
                                        context: context,
                                        builder: (_) => MovieInfoDialog(
                                            id: movieId,
                                            iMovie: movie,
                                            portraitImageUrl: portraitImageUrl,
                                            landScapeImageUrl:
                                                landScapeImageUrl));
                                  } else {
                                    ref.watch(updateRoundProvider(movieId));
                                  }
                                },
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
                                                onPressed: () {}),
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
                                    onPressed: () {
                                      if (movie.suggestions
                                          .contains(textController.text)) {
                                        final portraitImageUrl = ref
                                            .watch(moviePosterProvider(movieId))
                                            .maybeWhen(
                                                orElse: () => "",
                                                data: (url) => url);

                                        final landScapeImageUrl = ref
                                            .watch(moviePosterLandscapeProvider(
                                                movieId))
                                            .maybeWhen(
                                                orElse: () => "",
                                                data: (url) => url);
                                        ref.watch(updateFoundProvider);
                                        showDialog(
                                            context: context,
                                            builder: (_) => MovieInfoDialog(
                                                id: movieId,
                                                iMovie: movie,
                                                portraitImageUrl:
                                                    portraitImageUrl,
                                                landScapeImageUrl:
                                                    landScapeImageUrl));
                                      } else {
                                        ref.watch(updateRoundProvider(movieId));
                                      }
                                    },
                                    child: const Text("Search"),
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

class RowIndicator extends ConsumerWidget {
  const RowIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User user = ref.watch(firebaseUserProvider);

    final movieId = ref.watch(movieIdProvider..notifier);
    final Movie? movie = ref
        .watch(movieProvider(movieId))
        .maybeWhen(orElse: () => null, data: (m) => m);

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    return StepProgressIndicator(
      totalSteps: 5,
      currentStep: myRoundCount,
      size: 36,
      selectedColor: Colors.black,
      unselectedColor: Colors.grey,
      customStep: (index, color, _) => InkWell(
        onTap: () {
          print("371--$index");
          if (myRoundCount > index)
            ref.watch(selectedImageIndexProvider(movieId).notifier).state =
                index;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: color,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: color == Colors.black
                ? const Icon(Icons.check, color: Colors.white)
                : const Icon(Icons.remove),
          ),
        ),
      ),
    );
  }
}
