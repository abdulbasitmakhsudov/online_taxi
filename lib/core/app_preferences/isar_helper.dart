import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/weather/domain/entity/history_entity.dart';

class IsarHelper {
  late Future<Isar> db;
  static Isar? _isarInstance;

  IsarHelper() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    if (_isarInstance != null) {
      return _isarInstance!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isarInstance = await Isar.open(
      [
        HistoryEntitySchema,
      ],
      directory: dir.path,
    );

    return _isarInstance!;
  }

  Future<int> addHistory(HistoryEntity history) async {
    final isar = await db;
    return await isar.writeTxn<int>(() async {
      return await isar.historyEntitys.put(history);
    });
  }

  Future<List<HistoryEntity>> getAllHistories() async {
    final isar = await db;
    return await isar.historyEntitys.where().findAll();
  }

  Future<void> deleteHistory(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.historyEntitys.delete(id);
    });
  }

  Future<void> deleteAllHistory(List<int> ids) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.historyEntitys.deleteAll(ids);
    });
  }

  // Close DB
  Future<void> closeDb() async {
    final isar = await db;
    await isar.close();
  }
}
