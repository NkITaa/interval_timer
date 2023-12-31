import 'package:hive/hive.dart';
part 'workout.g.dart';

@HiveType(typeId: 1)
class Workout {
  Workout({
    required this.secondsTraining,
    required this.secondsPause,
    required this.sets,
    required this.name,
  });

  @HiveField(0)
  int secondsTraining;

  @HiveField(1)
  int secondsPause;

  @HiveField(2)
  int sets;

  @HiveField(3)
  String name;
}
