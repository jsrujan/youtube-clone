import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone/pages/video_player.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<FileObject> videos = []; // List to store video file objects
  Map<String, String> signedVideoUrls = {};
  Map<String, String> signedThumbnailUrls = {};

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    try {
      final response =
          await Supabase.instance.client.storage.from('videos').list();

      setState(() {
        videos = response ?? []; // Ensure to access response.data
      });

      await generateSignedUrls();
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

  Future<void> generateSignedUrls() async {
    for (var video in videos) {
      try {
        // Generate signed URL for video
        final signedVideoUrlResponse = await Supabase.instance.client.storage
            .from('videos')
            .createSignedUrl(video.name, 60000);

        // Generate signed URL for thumbnail
        final thumbnailName = video.name.replaceAll('.mp4', '.png');
        final signedThumbnailUrlResponse = await Supabase
            .instance.client.storage
            .from('thumbnails')
            .createSignedUrl(thumbnailName, 60000);

        setState(() {
          signedVideoUrls[video.name] = signedVideoUrlResponse;
          signedThumbnailUrls[video.name] = signedThumbnailUrlResponse;
        });
      } catch (e) {
        print('Error generating signed URL for ${video.name}: $e');
      }
    }
  }

  String formatName(String name) {
    return name.replaceAll("_", " ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                var video = videos[index];
                var thumbnailUrl = signedThumbnailUrls[video.name];
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: GestureDetector(
                    onTap: () {
                      if (signedVideoUrls[video.name] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(
                              videoUrl: signedVideoUrls[video.name]!,
                              uploaderName: "Srujan Jadhav"
                                  .replaceAll("_", " ")
                                  .replaceAll(".mp4", ""),
                              videoDescription:
                                  "This is the video with playback functionailty",
                              videoTitle: video.name,
                              views: "1M",
                            ),
                          ),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: thumbnailUrl != null
                                    ? Image.network(
                                        thumbnailUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.broken_image),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.play_circle_filled,
                                      size: 50, color: Colors.white),
                                  onPressed: () {
                                    if (signedVideoUrls[video.name] != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayerPage(
                                            videoUrl:
                                                signedVideoUrls[video.name]!,
                                            uploaderName: "Srujan Jadhav"
                                                .replaceAll("_", " ")
                                                .replaceAll(".mp4", ""),
                                            videoDescription:
                                                "This is the video with playback functionailty",
                                            videoTitle: video.name,
                                            views: "1M",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.account_circle),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    formatName(video.name)
                                        .replaceAll(".mp4", ""),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Srujan Jadhav",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black26),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
