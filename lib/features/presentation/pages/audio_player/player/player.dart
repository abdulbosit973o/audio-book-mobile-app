import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audiobook/core/data/local/shared_pref.dart';

import '../../../../../core/data/audio_player_data.dart';

class AudioPlayerScreen extends StatefulWidget {
  final AudioPlayerData audioPlayerData;

  const AudioPlayerScreen({super.key, required this.audioPlayerData});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;
  final SharedPreferencesHelper shared = SharedPreferencesHelper();
  var _isAdded = false;
  List<AudioPlayerData> contacts = [];

  void _loadContacts() async {
    contacts = await shared.loadContacts();
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadContacts();
    _isAdded = findAudioIndex(contacts, widget.audioPlayerData) != -1;

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _playAudio();
  }

  void _addToBookmark() async {
    await shared.addContact(widget.audioPlayerData);
  }

  void _deleteFromBookmark() async {
    int index = findAudioIndex(contacts, widget.audioPlayerData);
    await shared.deleteContactAtIndex(index);
  }
  int findAudioIndex(List<AudioPlayerData> audioList, AudioPlayerData audio) {
    return audioList.indexWhere((element) => element == audio);
  }

  void _playAudio() async {
    String audioUriString = widget.audioPlayerData.audioPath;
    Uri audioUri = Uri.parse(audioUriString);
    try {
      await _audioPlayer.play(UrlSource(audioUriString));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      // Handle potential errors during playback (optional)
    }
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
      _audioPlayer.resume();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26B6C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
            child: Text(
          'Now Playing',
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
      body: Column(
        children: [
          Image.asset('assets/images/up.jpg'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(widget.audioPlayerData.audioImage,
                      height: 200),
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
                const SizedBox(height: 16.0),
                Slider(
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  value: _position.inSeconds.toDouble(),
                  min: 0.0,
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _seekToSecond(value.toInt());
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_position.toString().split('.').first),
                    Text(_duration.toString().split('.').first),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      iconSize: 36.0,
                      onPressed: () {
                        _seekToSecond(_position.inSeconds - 10);
                      },
                    ),
                    IconButton(
                      icon: Icon(isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled),
                      iconSize: 64.0,
                      onPressed: _playPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      iconSize: 36.0,
                      onPressed: () {
                        _seekToSecond(_position.inSeconds + 10);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.dark_mode_outlined,
                        color: Colors.grey,
                      ),
                      iconSize: 24.0,
                      onPressed: () {
                        _seekToSecond(_position.inSeconds + 10);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.grey,
                      ),
                      iconSize: 24.0,
                      onPressed: () {
                        _seekToSecond(_position.inSeconds + 10);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isAdded ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.grey,
                      ),
                      iconSize: 24.0,
                      onPressed: () {
                        _isAdded ? _deleteFromBookmark() : _addToBookmark();
                        _isAdded = !_isAdded;
                        setState(() {});
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
