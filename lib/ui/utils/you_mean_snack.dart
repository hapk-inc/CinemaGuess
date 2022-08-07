import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/caps.dart';
import '../../logic/models/movie.dart';

SnackBar youMeanSnackBar(Movie movie, BuildContext context) {
  return SnackBar(
    elevation: 4,
    content: Text(
      "You mean ${movie.name.capitalize}",
      style: GoogleFonts.poppins(color: Colors.grey),
    ),
    action: SnackBarAction(label: "Search", onPressed: () {}),
  );
}
