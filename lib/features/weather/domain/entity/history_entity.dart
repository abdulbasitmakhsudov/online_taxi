import 'package:isar/isar.dart';

part 'history_entity.g.dart';

@Collection()
class HistoryEntity {
  Id? id; // ID required emas
  late String from;
  late String to;
  late String time; // DateTime string ko'rinishida saqlanadi
}

// Model class
class HistoryModel {
  final int? id;
  final String from;
  final String to;
  final DateTime time;

  HistoryModel({
    this.id,
    required this.from,
    required this.to,
    required this.time,
  });
}

// Extensions
extension HistoryEntityExtensions on HistoryEntity {
  // Entity to Model
  HistoryModel toModel() {
    return HistoryModel(
      id: id,
      from: from,
      to: to,
      time: DateTime.parse(time),
    );
  }
}

extension HistoryModelExtensions on HistoryModel {
  // Model to Entity
  HistoryEntity toEntity() {
    final entity = HistoryEntity()
      ..id = id
      ..from = from
      ..to = to
      ..time = time.toIso8601String();
    return entity;
  }
}
