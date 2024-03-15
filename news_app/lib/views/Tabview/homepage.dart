import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Replace with your actual API URL
 String apiUrl = 'https://newsapi.org/v2/everything?q=google&apiKey=feac98a968d942aea9a83bfc1c23ed15';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<List<FeedItem>> _feedStream;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
bool Favorites = false;
  @override
  void initState() {
    super.initState();
    _feedStream = _fetchFeed().asBroadcastStream();
    
  }
Stream<List<FeedItem>> _fetchFeed() async* {
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // Assuming a top-level key "data" containing a list of items
      final dataMap = jsonDecode(response.body) as Map<String, dynamic>;
      final feedItemsList = dataMap['articles'] as List<dynamic>;
     // print(feedItemsList);
      yield feedItemsList.map((item) => FeedItem.fromJson(item)).toList();
    } else {
      // Handle error scenario
      throw Exception('Failed to load feed');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load feed: $e');
  }
}




Future<void> refersh () async{
await _fetchFeed();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: _buildAppBar(),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<List<FeedItem>>(
              stream: _feedStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
            
                if (snapshot.hasData) {
                  final feedItems = snapshot.data!;
                  return Column(
                 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            
                       Padding(
              padding: const EdgeInsets.all(8.0),
             
              child: _Richtext("NEWS"),
            ),
            
            
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2, // Adjust as needed
                          children: feedItems.map((item) => SizedBox(
                            height: 200 ,
                            child: _buildFeedItem(item))).toList(),
                        ),
                      ),
                    ],
                  );
                }
            
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
      
          
          
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('News Feed'),
       // Customize color
      elevation: 5.0, // Remove shadow for a cooler look
      centerTitle: true,
      
      
    );
  }


Widget _Richtext(String text){
  return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          colors: <Color>[Colors.red, Colors.orange]),
       
        borderRadius: BorderRadius.circular(5.0),  // Add rounded corners
      ),
      child: Text(
    text,
    style: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w600,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: <Color>[Colors.white, Colors.white],  // Set gradient colors
        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 20.0)),  // Adjust rect for gradient size
    ),

    
  ),
    );
}




  Widget _buildFeedItem(FeedItem feedItem) {
    
    return SizedBox(
      height: 200,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                
                width: 190,
                height: 100,
                
                child: Image.network(feedItem.imageUrl,fit: BoxFit.cover,)),
            ), // Assuming imageUrl property in FeedItem
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2   ),
              child: Text(
                feedItem.title,
                maxLines: 2,  // Allow wrapping for long titles
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.0,  // Adjust font size
                  fontWeight: FontWeight.w500,  // Add some boldness
                  color: Colors.black87,  // Set text color
                )),
            ),
            IconButton(
  onPressed: () async {

    try {
      await _firestore.collection('favorites').add({
        'imageUrl': feedItem.imageUrl,
        'title': feedItem.title,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites')),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to favorites')),
      );
    }
  },
  icon: Icon(Icons.favorite_rounded,color: Colors.pink,),
              isSelected: true,

),

          ],
        ),
      ),
    );
  }


  



}

class FeedItem {
  final String imageUrl;
  final String title;

  FeedItem.fromJson(Map<String, dynamic> json)
      : imageUrl = json['urlToImage']??"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk8RLjeIEybu1xwZigumVersvGJXzhmG8-0Q&usqp=CAU",
        title = json['title']??"";
}


