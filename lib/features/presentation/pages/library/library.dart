import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audiobook/core/data/audio_player_data.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/data/local/shared_pref.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<DocumentSnapshot> categories = [];
  String? selectedCategoryId;
  bool isLoading = true;
  List<Map<String, dynamic>> categoryItems = [];
  final SharedPreferencesHelper _pref = SharedPreferencesHelper();
  List<AudioPlayerData> contacts = [];

  void _loadContacts() async {
    contacts = await _pref.loadContacts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _loadContacts();
  }

  Future<void> fetchCategories() async {
    CollectionReference categoryCollection =
    FirebaseFirestore.instance.collection('category');
    QuerySnapshot querySnapshot =
    await categoryCollection.where('type', isEqualTo: 'AUDIO').get();

    categories = querySnapshot.docs;
    if (categories.isNotEmpty) {
      selectedCategoryId = categories.first.id;
      fetchCategoryItems();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchCategoryItems() async {
    if (selectedCategoryId != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('audio')
          .where('audioCategory', isEqualTo: selectedCategoryId)
          .get();

      categoryItems = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Center(
            child: Text(
              'Library',
              style: TextStyle(
                  fontFamily: 'PaynetB',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF26B6C)),
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more button press
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Releases Section
              const Text(
                'Recently played',
                style: TextStyle(
                    fontFamily: 'PaynetB',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchNewReleases(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        categoryItems.isEmpty) {
                      return const Center(
                          child: Text('No new releases found'));
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 176,
                                  width: 108,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(categoryItems
                                          .reversed
                                          .toList()[index]['audioImage']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // Category Section
              // Category Items Section
              const Text(
                'Playlists',
                style: TextStyle(
                    fontFamily: 'PaynetB',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const Center(
                  child: Text('There is no saved playlists yet')),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Bookmarks',
                style: TextStyle(
                    fontFamily: 'PaynetB',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              contacts.isEmpty
                  ? const Center(child: Text('No bookmarks found'))
                  : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true, // Use shrinkWrap to fit the content
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Iconsax.play_circle),
                      title: Text(
                        contacts[index].audioName,
                        style: const TextStyle(
                            fontFamily: 'PaynetB',
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        contacts[index].audioAuthor,
                        style: const TextStyle(
                            fontFamily: 'PaynetB',
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 2,
                    color: Color(0xffdcd9dc),
                  ),
                  itemCount: contacts.length),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Most played',
                style: TextStyle(
                    fontFamily: 'PaynetB',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              const ListTile(
                leading: Icon(Iconsax.play_circle),
                title: Text(
                  'Chapter ',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '10:00 - 12:09 minutes',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                height: 2,
                color: Color(0xffdcd9dc),
              ),
              const ListTile(
                leading: Icon(Iconsax.play_circle),
                title: Text(
                  'Chapter ',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '10:00 - 12:09 minutes',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                height: 2,
                color: Color(0xffdcd9dc),
              ),
              const ListTile(
                leading: Icon(Iconsax.play_circle),
                title: Text(
                  'Chapter ',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '10:00 - 12:09 minutes',
                  style: TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                height: 2,
                color: Color(0xffdcd9dc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchNewReleases() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('newReleases').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
