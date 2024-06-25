import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String videoDescription;
  final String uploaderName;
  final String views;

  const VideoPlayerPage({
    Key? key,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoDescription,
    required this.uploaderName,
    required this.views,
  }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      if (_controller.value.hasError) {
        // Handle error
        print(_controller.value.errorDescription);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlayPause,
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Video Player
            Stack(
              children: [
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        height: 200,
                        color: Colors.black,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ],
            ),
            // Video Progress
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black26,
              ),
            ),
            // Video Metadata
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.videoTitle
                            .replaceAll("_", " ")
                            .replaceAll(".mp4", ""),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.account_circle,
                              size: 30,
                            ),
                            radius: 24,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.uploaderName,
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.thumb_up_outlined),
                          SizedBox(width: 10),
                          Icon(Icons.thumb_down_outlined),
                          SizedBox(width: 10),
                          Icon(Icons.share),
                          SizedBox(width: 10),
                          Icon(Icons.download),
                        ],
                      ),
                      Divider(),
                      Text(
                        widget.videoDescription,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Divider(),

                      // Here you would integrate your comments section
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
