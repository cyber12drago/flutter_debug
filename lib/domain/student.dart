import 'package:flutteragenda/util/capitalize.dart';
import 'package:flutteragenda/domain/domain.dart';
import 'package:flutteragenda/util/enums.dart';

class Student extends Domain {
  static const genders = ['pria', 'wanita'];
  static const grades = ['tk', 'sd', 'smp', 'sma'];
  static const hobbiesList = ['membaca', 'menulis', 'menggambar'];

  String firstName;
  String lastName;
  String mobilePhone;
  String gender;
  String grade;
  List<String> hobbies = [];
  String address;

  String get fullName => '${capitalize(firstName)} ${capitalize(lastName)}';

  @override
  Map<String, dynamic> toMap([Purpose purpose = Purpose.created]) {
    var map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'mobile_phone': mobilePhone,
      'gender': gender,
      'grade': grade,
      'hobbies': hobbies.join(', '),
      'address': address,
    };
    if (id != null) {
      map['id_siswa'] = id;
    }
    if (purpose == Purpose.created && createdAt == null) {
      map['created_at'] = DateTime.now().toIso8601String();
    }
    if (purpose == Purpose.updated && updatedAt == null) {
      map['updated_at'] = DateTime.now().toIso8601String();
    }

    return map;
  }

  @override
  void fromMap(Map<String, dynamic> value) {
    firstName = value['firstName'];
    lastName = value['lastName'];
    mobilePhone = value['mobilePhone'];
    gender = value['gender'];
    grade = value['grade'];
    address = value['address'];
    hobbies = value['hobbies'] is String ? value['hobbies'].split(', ') : [];
    id = value['id'];
    createdAt = value['createdAt'] is String
        ? DateTime.parse(value['createdAt'])
        : null;
    updatedAt = value['updatedAt'] is String
        ? DateTime.parse(value['updatedAt'])
        : null;
  }
}