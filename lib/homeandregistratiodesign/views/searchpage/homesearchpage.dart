import 'package:ansvel/homeandregistratiodesign/util/appthemedata.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _search() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('searchtable')
          .where('pagedescription', isGreaterThanOrEqualTo: query)
          .where('pagedescription', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        _searchResults = snapshot.docs
            .map((doc) => {
                  'pagedescription': doc['pagedescription'],
                  'PageLink': doc['PageLink']
                })
            .toList();
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppThemeData.primary50,
      appBar: AppBar(
        title: Text(
          'Search Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter text to search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _searchResults[index]['pagedescription'],
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => _launchURL(_searchResults[index]['PageLink']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
