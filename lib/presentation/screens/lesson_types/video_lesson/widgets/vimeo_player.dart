import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VimeoPlayerWidget extends StatelessWidget {
  const VimeoPlayerWidget({Key? key, required this.videoLink}) : super(key: key);

  final String videoLink;

  @override
  Widget build(BuildContext context) {
    return VimeoPlayer(
      videoId: videoLink,
    );
  }
}
