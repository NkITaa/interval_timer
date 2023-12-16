class LockscreenDataModel {
  final int elapsedSeconds;

  LockscreenDataModel({
    required this.elapsedSeconds,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'elapsedSeconds': elapsedSeconds,
    };
  }
}
