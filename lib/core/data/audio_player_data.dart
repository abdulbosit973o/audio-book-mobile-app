class AudioPlayerData {
  final String audioPath;
  final String audioName;
  final String audioImage;
  final String audioDescription;
  final String audioAuthor;

  AudioPlayerData(
      {required this.audioPath,
      required this.audioName,
      required this.audioImage,
      required this.audioDescription,
      required this.audioAuthor});

  factory AudioPlayerData.fromJson(Map<String, dynamic> json) {
    return AudioPlayerData(
      audioPath: json['audioPath'],
      audioName: json['audioName'],
      audioImage: json['audioImage'],
      audioDescription: json['audioDescription'],
      audioAuthor: json['audioAuthor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioPath': audioPath,
      'audioName': audioName,
      'audioImage': audioImage,
      'audioDescription': audioDescription,
      'audioAuthor': audioAuthor,
    };
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioPlayerData &&
        other.audioPath == audioPath &&
        other.audioName == audioName &&
        other.audioImage == audioImage &&
        other.audioDescription == audioDescription &&
        other.audioAuthor == audioAuthor;
  }

  @override
  int get hashCode {
    return audioPath.hashCode ^
    audioName.hashCode ^
    audioImage.hashCode ^
    audioDescription.hashCode ^
    audioAuthor.hashCode;
  }
}
