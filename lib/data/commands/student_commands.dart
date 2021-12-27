import 'package:sqflite/sql.dart';
import 'package:students/data/db_connection.dart';
import 'package:students/data/models/student.dart';

Future<void> insertStudent(Student student) async {
  final db = await dbConnect();

  await db.insert(
    'students',
    student.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Student>> getStudents() async {
  final db = await dbConnect();

  final List<Map<String, dynamic>> maps = await db.query('students');

  return List.generate(maps.length, (i) {
    return Student(
        id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']);
  });
}

Future<void> deleteStudent(int id) async {
  final db = await dbConnect();
  await db.delete('students', where: 'id=?', whereArgs: [id]);
}
