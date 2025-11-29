import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class _InsideClipCard extends StatefulWidget {
  final String title, subtitle, thumbnail;
  const _InsideClipCard({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
  });

  @override
  State<_InsideClipCard> createState() => _InsideClipCardState();
}

class _InsideClipCardState extends State<_InsideClipCard> {
  // late VideoPlayerController _controller;
  final bool _initialized = false;
  final bool _playing = false;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset(widget.thumbnail)
    //   ..initialize().then((_) {
    //     setState(() => _initialized = true);
    //   });
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      // if (_playing) {
      //   _controller.pause();
      // } else {
      //   _controller.play();
      // }
      // _playing = !_playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            // AspectRatio(
            //   aspectRatio: _initialized
            //       ? _controller.value.aspectRatio
            //       : 16 / 9,
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       if (_initialized)
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(14),
            //           child: VideoPlayer(_controller),
            //         )
            //       else
            //         const Center(child: CircularProgressIndicator()),
            //       Positioned.fill(
            //         child: GestureDetector(
            //           onTap: _togglePlay,
            //           child: Container(
            //             color: Colors.black26,
            //             child: Center(
            //               child: Icon(
            //                 _playing
            //                     ? Icons.pause_circle_filled
            //                     : Icons.play_circle_fill,
            //                 color: Colors.white,
            //                 size: 64,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
