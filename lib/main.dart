import 'package:flutter/material.dart';
import 'pages/MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// import 'package:dart_twitter_api/twitter_api.dart';
// import 'package:flutter/cupertino.dart';

// final twitterApi = TwitterApi(
//   client: TwitterClient(
//     consumerKey: 'a25EPPBbD0ZEXrT5xG21mgcWp',
//     consumerSecret: 'E0aBQW9BOoJho8uUBel8e1oEDiSnq4pptlBommet1rjaHdfPIH',
//     //token: 'AAAAAAAAAAAAAAAAAAAAAK3VbgEAAAAAPDYL2RKnYr2vfVmZ2GlZdIse%2F2U%3DduUH8urI7YPscR1MHkdPjVJ5rc8xxCfLSc2sIQxpBqqyjraWMd',
//     token: '775312816408440832-IpSiJe6CTEPYIRWBdNpUcJHx1OZTvdc',
//     secret: 'eWq9RW0oB6K5VFoVhFFuMjXtPUnlzYpSdGltGXzzKhjwf',
//   ),
// );

// Future<void> main() async {
//   try {
//     // Get the last 200 tweets from your home timeline
//     final homeTimeline = await twitterApi.timelineService.homeTimeline(
//       count: 200,
//     );

//     // Print the text of each Tweet
//     homeTimeline.forEach((tweet) => debugPrint(tweet.fullText));

//     // Update your status (tweet)
//   } catch (error) {
//     // Requests made by the client can throw the following errors:
//     //
//     // * `TimeoutException` when a request hasn't returned a response for some
//     //   time (defaults to 10s, can be changed in the TwitterClient).
//     //
//     // * `Response` when the received response does not have a 2xx status code.
//     //   Most responses include additional error information that can be parsed
//     //   manually from the response's body.
//     //
//     // * Other unexpected errors in unlikely events (for example when parsing
//     //   the response).
//     debugPrint('error while requesting home timeline: $error');
//   }
// }

