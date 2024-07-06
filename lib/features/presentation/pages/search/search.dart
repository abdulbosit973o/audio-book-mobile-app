import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController emailController = TextEditingController();
  List<Map<String, dynamic>> categoryItems = [];

  _runFilter(String entered) async {
    if (entered.isEmpty) {
      setState(() {
        categoryItems = [];
      });
      return;
    }

    final collection = FirebaseFirestore.instance.collection('audio');
    final querySnapshot = await collection
        .where('audioName', isEqualTo: entered)
        .get();

    final querySnapshotAuthor = await collection
        .where('audioAuthor', isEqualTo: entered)
        .get();

    setState(() {
      categoryItems = [
        ...querySnapshot.docs.map((doc) => doc.data()).toList(),
        ...querySnapshotAuthor.docs.map((doc) => doc.data()).toList(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 16,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              onChanged: _runFilter,
              decoration: const InputDecoration(
                labelText: 'Search books',
                border: OutlineInputBorder(),
              ),
              keyboardAppearance: Brightness.dark,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryItems.length,
                itemBuilder: (context, index) {
                  final item = categoryItems[index];
                  return ListTile(
                    leading: Icon(Iconsax.play_circle),
                    title: Text(
                      item['audioName'] ?? 'Unknown',
                      style: const TextStyle(
                          fontFamily: 'PaynetB',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item['audioAuthor'] ?? 'Unknown'}\n${item['audioDuration'] ?? 'Duration not available'}',
                      style: const TextStyle(
                          fontFamily: 'PaynetB',
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.more_vert),
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
