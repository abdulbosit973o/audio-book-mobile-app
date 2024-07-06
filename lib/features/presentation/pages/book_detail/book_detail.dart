import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audiobook/features/presentation/pages/audio_player/player/player.dart';
import 'package:flutter_audiobook/features/presentation/pages/pdf_reader/pdf_reader.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/data/audio_player_data.dart';

class BookDetailScreen extends StatefulWidget {
  final AudioPlayerData audioPlayerData;

  const BookDetailScreen({super.key, required this.audioPlayerData});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  final Duration _position = const Duration();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    // _audioPlayer.onAudioPositionChanged.listen((Duration p) {
    //   setState(() {
    //     _position = p;
    //   });
    // });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      // _audioPlayer.play(widget.audioPlayerData.audioPath);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    var index = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26B6C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
            // Handle more button press
          },
        ),
        title: const Center(
            child: Text(
          'AudioBook Detail',
          style: TextStyle(
              fontFamily: 'PaynetB',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF)),
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFFFFF)),
            onPressed: () {
              // Handle more button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(widget.audioPlayerData.audioImage,
                      height: 256),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(widget.audioPlayerData.audioName,
                  style: const TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Text(
                widget.audioPlayerData.audioAuthor,
                style: const TextStyle(
                    fontFamily: 'PaynetB',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24.0),
              const Row(
                children: [
                  Icon(
                    Iconsax.star5,
                    color: Colors.orange,
                  ),
                  Icon(
                    Iconsax.star5,
                    color: Colors.orange,
                  ),
                  Icon(
                    Iconsax.star5,
                    color: Colors.orange,
                  ),
                  Icon(
                    Iconsax.star5,
                    color: Colors.orange,
                  ),
                  Icon(
                    Iconsax.star_1,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '4',
                    style: TextStyle(
                        fontFamily: 'PaynetB',
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    width: 132,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: (index % 3 == 0
                            ? const Color(0xFFF26B6C)
                            : index % 3 == 1
                                ? const Color(0xFF6FCF97)
                                : const Color(0xFFF2C94C)),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Fantasy',
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
                  const SizedBox(width: 16),
                  Container(
                    width: 132,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFF2C94C),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'Drama',
                          style: TextStyle(
                              fontFamily: 'PaynetB', color: Color(0xFFF2C94C)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(
                                  audioPlayerData: widget.audioPlayerData)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF26B6C),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Iconsax.play_circle, color: Color(0xFFFFFFFF)),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Play Audio',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'PaynetB',
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(
                                url:
                                    'https://firebasestorage.googleapis.com/v0/b/asaxiybooks-4e1aa.appspot.com/o/books%2FAndroidNotesForProfessionals.pdf?alt=media&token=f36433bb-af8d-4a8f-be9e-3dec81a42bda')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF2C94C),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Iconsax.document, color: Color(0xFFFFFFFF)),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Read book',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'PaynetB',
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('Summary',
                  style: const TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Text(widget.audioPlayerData.audioDescription,
                  style: const TextStyle(
                      fontFamily: 'PaynetB',
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
