import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../logic/caps.dart';
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
            (halfSize && orientation == Orientation.portrait ? 0.5 : 0.7),
        width: size.width * (orientation == Orientation.portrait ? 1 : 0.7),
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
                                myRoundCount == 6
                                    ? "Better luck next time :("
                                    : "Attempts taken: $myRoundCount / 5",
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
                              ' found this movie \n'
                              'https://cinemaguess-hapk.web.app/ \n'
                              //'For android: https://play.google.com/store/apps/details?id=inc.hapk.cinemaguess',
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
