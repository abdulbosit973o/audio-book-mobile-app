import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audiobook/features/presentation/pages/book_detail/book_detail.dart';

import '../../../../core/data/audio_player_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> categories = [];
  String? selectedCategoryId;
  bool isLoading = true;
  List<Map<String, dynamic>> categoryItems = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
          'Explore',
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
                      'New Releases Book',
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
                    const Text(
                      'Category',
                      style: TextStyle(
                          fontFamily: 'PaynetB',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategoryId =
                                            categories[index].id;
                                        fetchCategoryItems();
                                      });
                                    },
                                    child: Container(
                                      width: 132,
                                      decoration: BoxDecoration(
                                        color: index % 3 == 0
                                            ? const Color(0x1AF26B6C)
                                            : index % 3 == 1
                                                ? const Color(0x1A6FCF97)
                                                : const Color(0x1AF2C94C),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedCategoryId ==
                                                  categories[index].id
                                              ? (index % 3 == 0
                                                  ? const Color(0xFFF26B6C)
                                                  : index % 3 == 1
                                                      ? const Color(0xFF6FCF97)
                                                      : const Color(0xFFF2C94C))
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          categories[index]['categoryName'],
                                          style: TextStyle(
                                            fontFamily: 'PaynetB',
                                            color: index % 3 == 0
                                                ? const Color(0xFFF26B6C)
                                                : index % 3 == 1
                                                    ? const Color(0xFF6FCF97)
                                                    : const Color(0xFFF2C94C),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    // Category Items Section
                    const Text(
                      'Category Items',
                      style: TextStyle(
                          fontFamily: 'PaynetB',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    categoryItems.isEmpty
                        ? const Center(
                            child: Text('No items found for this category'))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                            ),
                            itemCount: categoryItems.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> item = categoryItems[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(
                                                audioPlayerData:
                                                    AudioPlayerData(
                                              audioAuthor: item['audioAuthor'],
                                              audioDescription:
                                                  item['audioDescription'],
                                              audioName: item['audioName'],
                                              audioImage: item['audioImage'],
                                              audioPath: item['audioPath'],
                                            ))),
                                  );
                                  // Handle item tap
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(item['audioImage']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Spacer(),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          item['audioName'],
                                          style: const TextStyle(
                                            fontFamily: 'PaynetB',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
