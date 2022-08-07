import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/provider_list.dart';

final controller = TextEditingController();

class WelcomePage extends ConsumerWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxHeight > constraints.maxWidth
                  ? const WelcomePortrait()
                  : const WelcomeLandScape(),
        ),
      ),
    );
  }
}

class WelcomeLandScape extends StatelessWidget {
  const WelcomeLandScape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        const Flexible(
          flex: 4,
          child: Center(
            child: AppLogoName(),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: const WelcomeNameTextField(),
          ),
        )
      ],
    );
  }
}

class WelcomePortrait extends ConsumerWidget {
  const WelcomePortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.075),
      child: Stack(
        children: const [
          Center(child: AppLogoName()),
          Positioned(
            child: WelcomeNameTextField(),
          )
        ],
      ),
    );
  }
}

class WelcomeNameTextField extends ConsumerWidget {
  const WelcomeNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Your name",
        hintStyle: GoogleFonts.poppins(
          fontSize: highest * 0.025,
          color: Colors.white24,
        ),
        suffix: InkWell(
          onTap: () {
            if (controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text("Enter something", style: GoogleFonts.poppins()),
                ),
              );
            } else {
              ref.watch(anonymousProvider(controller.text));
            }
          },
          child: Text(
            "Submit",
            style: GoogleFonts.poppins(fontSize: highest * 0.02),
          ),
        ),
      ),
      style: GoogleFonts.poppins(fontSize: highest * 0.03),
      onSubmitted: (str) {
        if (str.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Enter something", style: GoogleFonts.poppins()),
            ),
          );
        } else {
          ref.watch(anonymousProvider(str));
        }
      },
    );
  }
}

class AppLogoName extends StatelessWidget {
  const AppLogoName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double highest = size.width > size.height ? size.width : size.height;
    return ListTile(
      subtitle: Icon(
        Icons.movie,
        size: highest * 0.2,
      ),
      title: Text(
        "PICOFILM",
        style: TextStyle(
          fontSize: highest * 0.07,
          fontFamily: 'LuckiestGuy',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
