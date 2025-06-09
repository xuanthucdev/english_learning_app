// import 'package:flutter/material.dart';

// class UploadProgressIndicator extends StatelessWidget {
//   final double progress;

//   const UploadProgressIndicator({Key? key, required this.progress})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         LinearProgressIndicator(
//           value: progress,
//           minHeight: 10,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//         ),
//         const SizedBox(height: 8),
//         Text('${(progress * 100).toStringAsFixed(1)}%'),
//       ],
//     );
//   }
// }
