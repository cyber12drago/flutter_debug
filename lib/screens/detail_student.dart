import 'package:flutter/material.dart';
import 'package:flutteragenda/service/app_service.dart';
import 'package:flutteragenda/domain/student.dart';
import 'package:flutteragenda/util/capitalize.dart';
import 'package:toast/toast.dart';

import 'form_student.dart';
import 'home.dart';
class DetailStudent extends StatefulWidget {
  final int id;

  const DetailStudent({Key key,
    this.id
  }) : super(key: key);

  //final int index;
  //const DetailStudent({Key key,   this.index})😒uper(key:key);
  @override
  _DetailStudentState createState() => _DetailStudentState();
}

class _DetailStudentState extends State<DetailStudent> {
  Student student;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    //  _student = AppService.studentService.findStudentBy(index: 1);
  }
  handleError(e) {

    _showSnackBar('Error: ${e.toString()}');

  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detail Siswa'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormStudent(title: 'Siswa Baru',
                  isEdit:true, data: student, id: student.id

              )));


            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

//AppService.studentService.deleteStudentBy
              //(id:widget.id).then((value) => Navigator.pop(context));

              AppService.studentService.deleteStudentBy(id:widget.id).then((val){

                Toast.show
                  ("Data berhasil di hapus", context);

                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => Home()));

              }).catchError((onError){
                handleError(onError);
              });



            },
          ),
        ],
      ),

      body:
      Center(
          child: FutureBuilder<Student>(
              future: AppService.studentService.findStudentBy(id:
              widget.id
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&             snapshot.hasData == null) {
                  return LinearProgressIndicator();
                }
                if (!snapshot.hasData){
                  return Center(child:CircularProgressIndicator());
                }else {
                  student =
                      snapshot.data
                  ;
                  return ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child:
                        student.gender == null ? Text("Tidak ada gambar") :
                        Image.asset(
                          'assets/images/${student.gender}.png',
                          width: 150.0,
                          height: 150.0,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text(student.fullName),
                        subtitle: const Text('Nama'),
                      ),
                      ListTile(
                        leading: Icon(
                            Icons.phone
                        ),
                        title: Text(student.mobilePhone),
                        subtitle: const Text('No.Hp'),
                      ),
                      ListTile(
                        leading: Icon(Icons.label),
                        title: Text(capitalize(student.gender)),
                        subtitle: const Text('Jenis Kelamin'),
                      ),
                      ListTile(
                        leading: Icon(
                            Icons.school
                        ),
                        title: Text(student.grade != null
                            ? student.grade.toUpperCase()
                            : "NO GRADE"),
                        subtitle: const Text('Jenjang'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(student.address),
                        subtitle: const Text('Alamat'),
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text(student.hobbies
                            .map((val) => capitalize(val))
                            .join(', ')),
                        subtitle: const Text('Hobi'),
                      ),
                    ],
                  );
                }
              })),

    );
  }
}