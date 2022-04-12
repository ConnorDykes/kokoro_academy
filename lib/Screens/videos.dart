import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../main.dart';

class Videos extends StatefulWidget {
  Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  TextEditingController searchBar = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String apiKey = 'AIzaSyDVvvkH_KVLirv7-dOK7Mr6po0ez3I-s1I';
  List results = [];
  String query = '';
  YoutubeAPI yt = YoutubeAPI('AIzaSyDVvvkH_KVLirv7-dOK7Mr6po0ez3I-s1I',
      type: "channel", maxResults: 500);
  bool isLoaded = false;

  callApi() async {
    try {
      var videos = await yt.channel("UC2RD0h8FkuWqZsM6ZBmwcHg", order: "date");

      for (YouTubeVideo video in videos) {
        print(video.title + " " + video.id.toString());
      }
      setState(() {
        results = videos;
        isLoaded = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => _key.currentState!.openDrawer(),
          child: Icon(Icons.menu)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: isLoaded
          ? Container(
              color: Theme.of(context).backgroundColor,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 8, 8),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                query = searchBar.text;
                              });
                            },
                            icon: Icon(Icons.search),
                          ),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: searchBar,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          YouTubeVideo video = results[index];
                          YoutubePlayerController _controller =
                              YoutubePlayerController(
                            initialVideoId: video.id.toString(),
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                              mute: true,
                            ),
                          );
                          if (video.kind != "video") {
                            return SizedBox.shrink();
                          } else {
                            if (searchBar.text == "") {
                              return (Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: Offset(0, 10),
                                                  blurRadius: 40,
                                                  color: index == 0
                                                      ? (Colors.red[50])!
                                                      : Color.fromRGBO(
                                                          0, 0, 0, 0.09))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: YoutubePlayerBuilder(
                                                  player: YoutubePlayer(
                                                    controller: _controller,
                                                    thumbnail: Image.network(
                                                            "https://img.youtube.com/vi/${video.id}/hqdefault.jpg") ??
                                                        Image.asset(
                                                            'assests/hqdefault.jpg'),
                                                    showVideoProgressIndicator:
                                                        true,
                                                    progressIndicatorColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    progressColors:
                                                        ProgressBarColors(
                                                      playedColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      handleColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                  builder: (context, player) {
                                                    return Column(
                                                      children: [
                                                        // some widgets
                                                        player,
                                                        //some other widgets
                                                      ],
                                                    );
                                                  }),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      results[index].title,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: Text(
                                                results[index].duration ?? "",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Poppins"),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ));
                            } else {
                              if (video.title.contains(searchBar.text))
                                return (Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 10),
                                                    blurRadius: 40,
                                                    color: index == 0
                                                        ? (Colors.red[50])!
                                                        : Color.fromRGBO(
                                                            0, 0, 0, 0.09))
                                              ]),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                child: YoutubePlayerBuilder(
                                                    player: YoutubePlayer(
                                                      controller: _controller,
                                                      thumbnail: Image.network(
                                                              "https://img.youtube.com/vi/${video.id}/hqdefault.jpg") ??
                                                          Image.asset(
                                                              'assests/hqdefault.jpg'),
                                                      showVideoProgressIndicator:
                                                          true,
                                                      progressIndicatorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      progressColors:
                                                          ProgressBarColors(
                                                        playedColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        handleColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                    ),
                                                    builder: (context, player) {
                                                      return Column(
                                                        children: [
                                                          // some widgets
                                                          player,
                                                          //some other widgets
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        results[index].title,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Poppins"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  results[index].duration ?? "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "Poppins"),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ));
                              else {
                                return SizedBox.shrink();
                              }
                            }
                          }
                        },
                        itemCount: results.length,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
