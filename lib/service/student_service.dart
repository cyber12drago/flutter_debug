// lib/service/student_service.dart
import 'package:flutteragenda/domain/student.dart';
import 'package:flutteragenda/repository/student_repository.dart';

class StudentService {
  final StudentRepository repository;

  const StudentService(this.repository);

  Future<int> createStudent(Student domain) {
    return repository.create(domain);
  }

  Future<List<Student>> findAllStudents(String searchCriteria) {
    return repository.findAll(searchCriteria);
  }

  Future<Student> findStudentBy({int id}) {
    return repository.findOne(id);
  }

  Future<int> deleteStudentBy({ int id}) {
    return repository.delete(id);
  }
  Future<int> updateStudentBy({int id, Student domain}){
    return repository.update(id, domain);
  }

}