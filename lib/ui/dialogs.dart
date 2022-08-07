/*import 'package:cinema_guess/logic/provider_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:share_plus/share_plus.dart';

import '../logic/caps.dart';
import '../logic/models/movie.dart';

const imageUrl =
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg";

class InfoDialogPage extends ConsumerWidget {
  final String id;
  final Movie movie;
  final bool movieFound;
  const InfoDialogPage(this.id, this.movie, {Key? key, this.movieFound = true})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return AlertDialog(
      title: Text(
        movieFound
            ? "Great!. You found the movie"
            : "Sorry! Better Luck next time",
        style: GoogleFonts.poppins(
          fontSize: highest * 0.02,
        ),
      ),
      content: Container(
        color: Colors.grey,
        width: highest * 0.5,
        height: highest * 0.3,
        // width: size.width,
        child: GridTile(
          header: Container(
            height: highest * 0.05,
            color: Colors.black.withOpacity(0.2),
            padding: EdgeInsets.all(highest * 0.01),
            alignment: Alignment.centerLeft,
            child: Text(
              "${movie.name.capitalize} (${movie.releasedOn})",
              style: GoogleFonts.poppins(
                color: Colors.white70,
              ),
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ref.watch(moviePosterLandscapeProvider(id)).maybeWhen(
                    orElse: () => Container(),
                    data: (url) => Image.network(
                      url,
                      fit: BoxFit.fill,
                      width: highest * 0.5,
                      height: highest * 0.3,
                    ),
                  ),
            ),
          ),
        ),
      ),
      actions: [
        */ /*    TextButton(
          onPressed: () {
            ref.refresh(langMoviesProvider(movie.lang));
            context.router.pop();
          },
          child: Text(
            "To Dashboard",
            style: GoogleFonts.poppins(),
          ),
        ),*/ /*
        TextButton(
          onPressed: () {
            */
import 'package:PicoFilm/logic/caps.dart';
/*  Share.share(
                'Check out my website https://cinemaguess-hapk.web.app/');*/ /*
          },
          child: Text(
            "Share",
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }
}*/

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../logic/models/movie.dart';
import '../logic/models/player.dart';
import '../logic/provider_list.dart';

class MovieInfoDialog extends ConsumerWidget {
  const MovieInfoDialog(
      {Key? key,
      required this.id,
      required this.iMovie,
      required this.portraitImageUrl,
      required this.landScapeImageUrl,
      this.halfSize = false})
      : super(key: key);

  final String id;
  final bool halfSize;
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
        height: size.height *
            (halfSize && orientation == Orientation.portrait ? 0.5 : 1),
        width: size.width,
        child: GridTile(
          footer: FadeInUp(
            child: Container(
              height: orientation == Orientation.portrait
                  ? size.height * 0.15
                  : size.height * 0.25,
              color: Colors.transparent.withOpacity(0.75),
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
                      child: InkWell(
                        onTap: () async {
                          String str = myRoundCount == 6
                              ? "❌❌❌❌❌"
                              : List.generate(
                                  myRoundCount,
                                  (index) => index == (myRoundCount - 1)
                                      ? "✅"
                                      : "❌").join();
                          await Share.share(
                            'On ${iMovie.postedOn} / ${iMovie.lang.name.capitalize}'
                            ' \n\n$str\n${iMovie.usersFound.length}'
                            ' found this movie \n '
                            'https://cinemaguess-hapk.web.app/ \n'
                            'For android: https://play.google.com/store/apps/details?id=inc.hapk.cinemaguess',
                          );
                        },
                        child: const AutoSizeText(
                          "SHARE",
                          maxLines: 1,
                          style: TextStyle(color: Colors.blue),
                        ),
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
