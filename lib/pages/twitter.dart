import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final twitterApi = TwitterApi(
  client: TwitterClient(
    consumerKey: 'a25EPPBbD0ZEXrT5xG21mgcWp',
    consumerSecret: 'E0aBQW9BOoJho8uUBel8e1oEDiSnq4pptlBommet1rjaHdfPIH',
    //token: 'AAAAAAAAAAAAAAAAAAAAAK3VbgEAAAAAPDYL2RKnYr2vfVmZ2GlZdIse%2F2U%3DduUH8urI7YPscR1MHkdPjVJ5rc8xxCfLSc2sIQxpBqqyjraWMd',
    token: '775312816408440832-IpSiJe6CTEPYIRWBdNpUcJHx1OZTvdc',
    secret: 'eWq9RW0oB6K5VFoVhFFuMjXtPUnlzYpSdGltGXzzKhjwf',
  ),
);

  Future<List<String>> twitterAPI() async {
    List<String> tweets = [];
  debugPrint("Twitter APIIIIII");
  for(int i=0;i<10;i++){
    debugPrint(i.toString());
  }
  try {
    // Get the last 200 tweets from your home timeline
    final homeTimeline = await twitterApi.timelineService.homeTimeline(
      count: 10,
    );

    // // Print the text of each Tweet
    for (var tweet in homeTimeline) {
      debugPrint(tweet.fullText);
      tweets.add(tweet.fullText!);
    }
    debugPrint("hello");

    return tweets;
    // Update your status (tweet)
    // await twitterApi.tweetService.update(
    //  status: 'Hello world!',
    //);
    
  } catch (error) {
    // Requests made by the client can throw the following errors:
    //
    // * `TimeoutException` when a request hasn't returned a response for some
    //   time (defaults to 10s, can be changed in the TwitterClient).
    //
    // * `Response` when the received response does not have a 2xx status code.
    //   Most responses include additional error information that can be parsed
    //   manually from the response's body.
    //
    // * Other unexpected errors in unlikely events (for example when parsing
    //   the response).
    debugPrint('error while requesting home timeline: $error');
    return ["No tweet found"];
  }
}



class TwitterAPI extends StatefulWidget {
  List<String> tweets;
  TwitterAPI({ Key? key, required this.tweets }) : super(key: key);

  @override
  State<TwitterAPI> createState() => _TwitterAPIState();
}

class _TwitterAPIState extends State<TwitterAPI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tweets"),
      ),
      body: Center(
        child: ListView.builder(
        itemCount: widget.tweets.length,
        itemBuilder: (BuildContext context,int index){
          return Column(
            children: [
              ListTile(
            title: Text(widget.tweets[index],
                           style: const TextStyle(
                             color: Colors.white,fontSize: 15),),

            tileColor: Colors.blueAccent,
            contentPadding: const EdgeInsets.all(10.0),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
            )
            ],
          );
        }
        ),
      ),
    );
  }
}
