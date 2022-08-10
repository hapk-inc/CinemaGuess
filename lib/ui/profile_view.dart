import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/models/player.dart';
import '../logic/provider_list.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final User user = ref.watch(firebaseUserProvider);

    final Player? player = ref.watch(playerProvider(user.uid)).when(
          data: (data) => data,
          error: (e, s) => null,
          loading: () => null,
        );
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.shortestSide * 0.01),
          child: Column(
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(size.shortestSide * 0.01),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: AutoSizeText(
                          player?.name ?? "",
                          style: GoogleFonts.poppins(
                              fontSize: size.shortestSide * 0.1),
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                          child: SizedBox(
                        width: size.shortestSide * 0.025,
                      )),
                      Flexible(
                        flex: 2,
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText: "Your new name is.."),
                              ),
                              actions: ["UPDATE", "DISCARD"]
                                  .map((e) => e.contains("UPDATE")
                                      ? ElevatedButton(
                                          onPressed: () {}, child: Text(e))
                                      : TextButton(
                                          onPressed: () {}, child: Text(e)))
                                  .toList(),
                            ),
                          ),
                          child: AutoSizeText(
                            "Edit",
                            maxLines: 1,
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(flex: 4, child: Container())
            ],
          ),
        ),
      ),
    );
  }
}
