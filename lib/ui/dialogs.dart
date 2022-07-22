import 'package:cinema_guess/logic/provider_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

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
        /*    TextButton(
          onPressed: () {
            ref.refresh(langMoviesProvider(movie.lang));
            context.router.pop();
          },
          child: Text(
            "To Dashboard",
            style: GoogleFonts.poppins(),
          ),
        ),*/
        TextButton(
          onPressed: () {
            Share.share(
                'Check out my website https://cinemaguess-hapk.web.app/');
          },
          child: Text(
            "Share",
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }
}
