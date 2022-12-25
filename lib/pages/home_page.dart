/*
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FlickManager? flickManager;
  List videosList = [
    "assets/videos/windows.mp4",
    "assets/videos/joker.mp4",
  ];
  List videosImages = [];

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset("assets/videos/joker.mp4"),
      autoPlay: false,
    );
    videoInfo(videosList);
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Video
            SizedBox(
              height: 300,
              child: ClipRRect(
                child: FlickVideoPlayer(
                  flickManager: flickManager!,
                ),
              ),
            ),
            /// Playlist
            (isLoading) ?
            const CircularProgressIndicator() :
            Expanded(
              child: ListView.builder(
                itemCount: videosList.length,
                itemBuilder: (context, index) {
                  return itemOfVideo(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemOfVideo(int index) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade100,
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 5),
          ]
      ),
      child: MaterialButton(
        onPressed: (){},
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image(
                image: FileImage(File(videosImages[index])),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(videosImages[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = true;
  Future<void> videoInfo(List videosList) async {
    for (var item in videosList) {
      final byteData = await rootBundle.load(item);
      Directory? tempDir = await getTemporaryDirectory();

      File tempVideo = File("${tempDir.path}/$item")
        ..createSync(recursive: true)
        ..writeAsBytesSync(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final caption1 = await VideoThumbnail.thumbnailFile(
        video: tempVideo.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        quality: 100,
      );
      print(caption1);

      videosImages.add(caption1);

    }

    setState(() {
      isLoading = false;
    });

  }

}






