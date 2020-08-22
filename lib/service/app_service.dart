import 'package:flutteragenda/repository/student_repository.dart';
import 'package:flutteragenda/service/student_service.dart';
import 'package:flutteragenda/model/model_provider.dart';
import 'package:sqflite/sqflite.dart';

StudentRepository _studentRepository=StudentRepository(ModelProvider.getInstance());
StudentService _studentService=StudentService(_studentRepository);

class AppService{

  static StudentService get studentService => _studentService;
  static Future<Database> open(){
    return ModelProvider.getInstance().open();
  }

  static Future<void>close(){
    return ModelProvider.getInstance().close();
  }
}
