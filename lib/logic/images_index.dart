import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedImageIndexProvider =
    StateNotifierProvider.autoDispose.family<ImageIndex, int, String>(
  (_, __) => ImageIndex(),
);

class ImageIndex extends StateNotifier<int> {
  ImageIndex() : super(0);

  increment() => state++;
}
