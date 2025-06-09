// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class AudioPlayerWidget extends StatefulWidget {
//   final String url;

//   const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _setupAudioPlayer();
//   }

//   void _setupAudioPlayer() {
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         _isPlaying = state == PlayerState.playing;
//       });
//     });

//     _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() {
//         _duration = duration;
//       });
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       setState(() {
//         _position = position;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _togglePlay() async {
//     if (_isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play(UrlSource(widget.url));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Slider(
//           min: 0,
//           max: _duration.inSeconds.toDouble(),
//           value: _position.inSeconds.toDouble(),
//           onChanged: (value) async {
//             await _audioPlayer.seek(Duration(seconds: value.toInt()));
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(_formatDuration(_position)),
//               IconButton(
//                 icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                 onPressed: _togglePlay,
//                 iconSize: 36,
//               ),
//               Text(_formatDuration(_duration)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));

//     return "$minutes:$seconds";
//   }
// }