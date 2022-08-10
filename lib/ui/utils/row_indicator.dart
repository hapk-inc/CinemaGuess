import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../logic/images_index.dart';
import '../../logic/provider_list.dart';

class RowIndicator extends ConsumerWidget {
  const RowIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieId = ref.watch(movieIdProvider..notifier);

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
      selectedColor: Colors.black54,
      unselectedColor: Colors.grey,
      customStep: (index, color, _) => InkWell(
        /* onTap: () {
          print("371--$index");
          if (myRoundCount > index) {
            ref.watch(selectedImageIndexProvider(movieId).notifier).state =
                index;
          }
        },*/

        onTap: myRoundCount > index
            ? () => ref
                .watch(selectedImageIndexProvider(movieId).notifier)
                .state = index
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: selectedRound == index ? Colors.blue : color,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: color == Colors.black54
                ? const Icon(Icons.check, color: Colors.white)
                : const Icon(Icons.remove),
          ),
        ),
      ),
    );
  }
}
