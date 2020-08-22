// lib/repository/student_repository.dart
import 'dart:core';
import 'dart:async';
import 'package:flutteragenda/domain/student.dart';
import 'package:flutteragenda/model/model_provider.dart';
import 'package:flutteragenda/util/enums.dart';

class StudentRepository {
  static const String tableName = 'Siswa';
  final ModelProvider modelProvider;

  StudentRepository(this.modelProvider);

  Future<int> create(Student domain) {
    final siswa = domain.toMap();
    print('[db] is creating $siswa');
    return modelProvider
        .getDatabase()
        .then((database) => database.insert(tableName, siswa));
  }

  Future<List<Student>> findAll([String searchCriteria]) {
    var sql = '''
    SELECT
        id_siswa AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        grade,
        hobbies,
        address,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
    ''';

    if (searchCriteria.isNotEmpty) {
      final pattern = '%$searchCriteria%';
      sql += '''
      WHERE
        first_name LIKE '$pattern' OR
        last_name LIKE '$pattern' OR
        mobile_phone LIKE '$pattern' OR
        gender LIKE '$pattern' OR
        grade LIKE '$pattern'
      ''';
    }
    sql += 'ORDER BY created_at DESC;';
    print('[db] raw sql: $sql');
    return modelProvider
        .getDatabase()
        .then((database) => database.rawQuery(sql))
        .then((data) {
      print('[db] success retrieve $data');
      if (data.length == 0) {
        return [];
      }
      final List<Student> students = [];
      for (var i = 0; i < data.length; i++) {
        Student student = Student();
        student.fromMap(data[i]);
        students.add(student);
      }

      return students;
    });
  }

  Future<Student> findOne(int id) {
    final sql = '''
      SELECT
        id_siswa AS id,
        first_name AS firstName,
        last_name AS lastName,
        mobile_phone AS mobilePhone,
        gender,
        grade,
        hobbies,
        address,
        created_at AS createdAt,
        updated_at AS updatedAt
      FROM
        $tableName
      WHERE id_siswa = $id;
    ''';
    return modelProvider
        .getDatabase()
        .then((database) => database.rawQuery(sql))
        .then((data) {
      print('[db] success retrieve $data by id = $id');
      if (data.length == 1) {
        final Student student = Student();
        student.fromMap(data[0]);

        return student;
      }

      return null;
    });
  }

  Future<int> delete(int id) {
    return modelProvider.getDatabase().then((database) =>
        database.delete(tableName, where: 'id_siswa = ?', whereArgs: [id]));
  }

  Future<int> rawdelete(int id) {
    const sql = 'DELETE FROM $tableName WHERE id_siswa = ?';
    return modelProvider
        .getDatabase()
        .then((database) => database.rawDelete(sql, [id]));
  }

  Future<int> update(int id, Student domain) {
    print('[db] Updating data by id from the db...');
    return modelProvider.getDatabase().then((database) => database.update(
        tableName, domain.toMap(Purpose.updated),
        where: 'id_siswa = $id'));
  }
}