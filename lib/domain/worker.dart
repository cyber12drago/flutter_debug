import 'package:flutteragenda/util/capitalize.dart';
import 'package:flutteragenda/domain/domain.dart';
import 'package:flutteragenda/util/enums.dart';

class Student extends Domain {
  static const alarms = ['tk', 'sd', 'smp', 'sma'];

  String taskName;
  String waktu;
  String lokasi;
  String deskripsi;
  String notulensi;
  String alarm;

  @override
  Map<String, dynamic> toMap([Purpose purpose = Purpose.created]) {
    var map = <String, dynamic>{
      'task_name': taskName,
      'waktu': waktu,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'notulensi': notulensi,
      'alarm':alarm,
    };
    if (id != null) {
      map['id_worker'] = id;
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
    taskName = value['taskName'];
    waktu = value['waktu'];
    lokasi= value['lokasi'];
    deskripsi= value['deskripsi'];
    notulensi= value['notulensi'];
    alarm = value['alarm'];
    id = value['id'];
    createdAt = value['createdAt'] is String
        ? DateTime.parse(value['createdAt'])
        : null;
    updatedAt = value['updatedAt'] is String
        ? DateTime.parse(value['updatedAt'])
        : null;
  }
}