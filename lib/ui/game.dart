import 'package:auto_route/auto_route.dart';
import 'package:cinema_guess/logic/caps.dart';
import 'package:cinema_guess/logic/images_index.dart';
import 'package:cinema_guess/logic/provider_list.dart';
import 'package:cinema_guess/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/models/movie.dart';

class GamePage extends ConsumerWidget {
  final Movie movie;
  const GamePage(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider).uid;
    return WillPopScope(
      onWillPop: () async {
        ref.refresh(playerProvider(user));
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: constraints.maxHeight < constraints.maxWidth
                ? const GameLandScape()
                : const GamePortrait(),
          ),
        ),
      ),
    );
  }
}

class GamePortrait extends ConsumerWidget {
  const GamePortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId = ref.watch(movieIdProvider.notifier).state;

    final List<String> imageUrls =
        ref.watch(allCluesProvider(movieId)).maybeWhen(
              orElse: () => [],
              data: (urls) => urls,
            );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 12,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: imageUrls.isEmpty
                    ? Container()
                    : Image.network(
                        imageUrls[selectedRound],
                        key: ValueKey(selectedRound),
                        fit: BoxFit.fitHeight,
                      ),
              ),
            ),
          ),
          const Flexible(flex: 2, child: RowIndicator()),
          const Spacer(),
          const Flexible(flex: 4, child: GameTextField()),
          const Spacer(),
          const Flexible(
            flex: 3,
            child: GameButtons(),
          )
        ],
      ),
    );
  }
}

class RowIndicator extends ConsumerWidget {
  const RowIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final highestSize = size.width > size.height ? size.width : size.height;
    final indicatorSizeMax = highestSize * 0.02;
    final indicatorSizeMin = highestSize * 0.01;

    final movieId = ref.watch(movieIdProvider.notifier).state;

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    return Container(
      padding: EdgeInsets.all(size.width * 0.01),
      alignment: Alignment.bottomLeft,
      height: size.height * 0.1,
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          myRoundCount,
          (index) => Flexible(
            child: InkWell(
              onTap: myRoundCount == 5
                  ? null
                  : () => ref
                      .watch(selectedImageIndexProvider(movieId).notifier)
                      .state = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: index == selectedRound
                    ? indicatorSizeMax
                    : indicatorSizeMin,
                height: index == selectedRound
                    ? indicatorSizeMax
                    : indicatorSizeMin,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const imageUrl =
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg";

class GameLandScape extends ConsumerWidget {
  const GameLandScape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final movieId = ref.watch(movieIdProvider.notifier).state;

    final List<String> imageUrls =
        ref.watch(allCluesProvider(movieId)).maybeWhen(
              orElse: () => [],
              data: (urls) => urls,
            );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));
    return Row(
      children: [
        Flexible(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: imageUrls.isEmpty
                  ? Container()
                  : Image.network(
                      imageUrls[selectedRound],
                      key: ValueKey(selectedRound),
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridTile(
              header: const RowIndicator(),
              footer: const GameButtons(),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(size.width * 0.02),
                child: const GameTextField(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final gameTextController = TextEditingController();

class GameTextField extends ConsumerWidget {
  const GameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final String movieId = ref.watch(movieIdProvider.notifier).state;

    final String user = ref.watch(firebaseUserProvider).uid;
    final Movie? movie = ref
        .watch(movieProvider(movieId))
        .maybeWhen(orElse: () => null, data: (movie) => movie);

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    final int remainingChances = 5 - myRoundCount;

    final smallSize = size.width > size.height ? size.height : size.width;
    return movie == null
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: smallSize * 0.02),
            child: TextField(
              autofocus: true,
              autocorrect: true,
              controller: gameTextController,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.search,
              enabled: remainingChances == -1
                  ? false
                  : !(movie.usersFound.contains(user)),
              onSubmitted: (str) {
                if (movie.name.toLowerCase() == str.toLowerCase()) {
                  ref.watch(updateFoundProvider);
                  gameTextController.text = "";
                  showDialog(
                    context: context,
                    //useRootNavigator: true,
                    builder: (_) => InfoDialogPage(movieId, movie),
                  ).then(
                    (value) {
                      ref.refresh(langMoviesProvider(movie.lang));
                      context.router.pop();
                    },
                  );
                } else {
                  ref.watch(updateRoundProvider(movieId));
                  gameTextController.text = "";
                  ref
                      .watch(selectedImageIndexProvider(movieId).notifier)
                      .state = myRoundCount - 1;
                }
                //if(movie.name==str)
              },
              decoration: InputDecoration(
                hintText: movie.usersFound.contains(user)
                    ? "${movie.name.capitalize} (${movie.releasedOn})"
                    : remainingChances == -1
                        ? "Better luck next time. It's ${movie.name.capitalize}"
                        : remainingChances == 4
                            ? "Guess the movie.."
                            : remainingChances == 0
                                ? "You have last chance"
                                : "$remainingChances more chances to go",
                hintStyle: GoogleFonts.poppins(
                    fontSize: smallSize * 0.04, color: Colors.black38),
                suffix: InkWell(
                  onTap: () {
                    if (movie.name.toLowerCase() ==
                        gameTextController.text.toLowerCase()) {
                      ref.watch(updateFoundProvider);
                      gameTextController.text = "";
                      showDialog(
                        context: context,
                        //useRootNavigator: true,
                        builder: (_) => InfoDialogPage(movieId, movie),
                      ).then(
                        (value) {
                          ref.refresh(langMoviesProvider(movie.lang));
                          context.router.pop();
                        },
                      );
                    } else {
                      ref.watch(updateRoundProvider(movieId));
                      gameTextController.text = "";
                      ref
                          .watch(selectedImageIndexProvider(movieId).notifier)
                          .state = myRoundCount - 1;
                    }
                  },
                  child: Icon(
                    Icons.check,
                    size: smallSize * 0.075,
                  ),
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: smallSize * 0.05,
                color: Colors.black54,
              ),
            ),
          );
  }
}

class GameButtons extends ConsumerWidget {
  const GameButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId = ref.watch(movieIdProvider.notifier).state;

    final int myRoundCount = ref.watch(myRoundCountProvider(movieId)).when(
          loading: () => 0,
          data: (value) => value,
          error: (e, s) => 0,
        );

    final int selectedRound = ref.watch(selectedImageIndexProvider(movieId));

    return ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: selectedRound == 0
              ? null
              : () {
                  ref
                      .watch(selectedImageIndexProvider(movieId).notifier)
                      .state--;
                },
          child: Text("Previous", style: GoogleFonts.poppins()),
        ),
        TextButton(
          onPressed: selectedRound == 4
              ? null
              : () {
                  print(
                      "myRoundCount $myRoundCount selectedRound $selectedRound");
                  if (myRoundCount == (selectedRound + 1)) {
                    ref.watch(updateRoundProvider(movieId));
                  }
                  ref
                      .watch(selectedImageIndexProvider(movieId).notifier)
                      .state++;
                },
          child: Text(
            "Next One",
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }
}
