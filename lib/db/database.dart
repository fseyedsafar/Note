import 'package:note/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDataBase {
  NoteDataBase._();

  static final NoteDataBase db = NoteDataBase._();
  late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "note.db"),
        version: 1, onCreate: (db, version) async {
      await db.execute("create table tbl_note("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title varchar(50),"
          "description Text,"
          "timeNote varchar(50),"
          "dateNote varchar(50) )");
    });
  }

  /*
      rawInsert vs insert
          rawInsert return rawId
          insert return void
  */
  Future<int> insertNote(Note note) async {
    final db = await database;
    int result = await db.rawInsert(
        "insert into tbl_note(title, description, timeNote, dateNote) values(?, ?, ?, ?)",
        [note.title, note.description, note.time, note.date]);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final db = await database;
    var response = await db.rawQuery("select * from tbl_note");
    List<Note> noteList = [];
    for (var element in response) {
      Map item = element;
      int id = item['id'];
      String title = item['title'];
      String description = item['description'];
      String time = item['timeNote'];
      String date = item['dateNote'];
      var note = Note(id, title, description, date, time);
      noteList.add(note);
    }
    return noteList;
  }

  deleteNote(int noteId) async {
    final db = await database;
    var count =
        await db.rawDelete('DELETE FROM tbl_note WHERE id = ?', [noteId]);
    return count;
  }

  updateNote(Note note) async {
    final db = await database;
    print('before: ${note.id}');
    int count = await db.rawUpdate(
        'UPDATE tbl_note SET title = ?, description = ? WHERE id = ?',
        [note.title, note.description, note.id]);
    print('updated: $count');
  }
}
