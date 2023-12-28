// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// class Monitoringcctv extends StatefulWidget {
//   const Monitoringcctv({Key? key}) : super(key: key);

//   @override
//   _MonitoringcctvState createState() => _MonitoringcctvState();
// }

// class _MonitoringcctvState extends State<Monitoringcctv> {
//   final VlcPlayerController _videoPlayerController = VlcPlayerController.network('https://media.w3.org/2010/05/sintel/trailer.mp4'),
//   hwAcc: HwAcc.FULL,
//       autoPlay: false,
//       options: VlcPlayerOptions(),



//   @override
//   void initState() {
//     super.initState();

   
//       ,
//     );
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     await _videoPlayerController.stopRendererScanning();
//     await _videoViewController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Center(
//           child: VlcPlayer(
//             controller: _videoPlayerController,
//             aspectRatio: 16 / 9,
//             placeholder: Center(child: CircularProgressIndicator()),
//           ),
//         ));
//   }
// }
