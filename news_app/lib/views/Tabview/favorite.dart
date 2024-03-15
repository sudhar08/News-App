import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _dataStream;

  @override
  void initState() {
    super.initState();
    // Get a stream of all documents in the 'data' collection
    _dataStream = _firestore.collection('favorites').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust for desired number of columns
                crossAxisSpacing: 10.0, // Adjust spacing between items
                mainAxisSpacing: 10.0, // Adjust spacing between rows
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data();
                final String imageUrl =
                    data['imageUrl']; // Assuming key for image URL
                final String title = data['title']; // Assuming key for title

                return _buildFeedItem(imageUrl, title);
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFeedItem(String Imageurl, String title) {
    return SizedBox(
        height: 200,
        child: Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SizedBox(
                width: 190,
                height: 120,
                child: Image.network(
                  Imageurl,
                  fit: BoxFit.cover,
                )),
          ), // Assuming imageUrl property in FeedItem
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Text(title,
                maxLines: 2, // Allow wrapping for long titles
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.0, // Adjust font size
                  fontWeight: FontWeight.w500, // Add some boldness
                  color: Colors.black87, // Set text color
                )),
          )
        ])));
  }
}
