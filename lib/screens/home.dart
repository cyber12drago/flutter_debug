import 'package:flutter/material.dart';
import 'package:flutteragenda/domain/student.dart';
import 'package:flutteragenda/screens/form_student.dart';
import 'package:flutteragenda/screens/detail_student.dart';
import 'package:flutteragenda/service/app_service.dart';
import 'package:flutteragenda/util/capitalize.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _searchCriteria = '';
  bool _showTextField = false;
  List<Student> _students = [];
  bool _shouldWidgetUpdate = true;

  _fetchData() {
    if (!_shouldWidgetUpdate) {
      return Future.value(_students);
    }

    return AppService.studentService.findAllStudents(_searchCriteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _showTextField
            ? TextField(
          // expands: true,
          decoration: InputDecoration(
            hintText: 'Cari Siswa',
            fillColor: Colors.white,
            filled: true,
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              _searchCriteria = value;
              _shouldWidgetUpdate = true;
            });
          },
        )
            : Text('SekolahKu'),
        actions: <Widget>[
          IconButton(
              icon: _showTextField ? Icon(Icons.close) : Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _showTextField = !_showTextField;
                  _shouldWidgetUpdate = false;
                });
              }),
        ],
      ),
      body: FutureBuilder<List<Student>>(
          future: _fetchData(),
          initialData: <Student>[],
          builder: (context, snapshot) {
            if (_shouldWidgetUpdate) {
              if ((snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) ||
                  snapshot.connectionState == ConnectionState.waiting) {
                // print('project snapshot data is: ${snapshot.data}');
                return LinearProgressIndicator();
              } else if (snapshot.hasData && snapshot.data.length == 0) {
                _students = snapshot.data;
                return Container();
              }
            }
            //  print('snapshot.data.length ${snapshot.data.length}');

            return ListView.separated(
              itemCount: snapshot.hasData ? snapshot.data.length : 0,
              separatorBuilder: (BuildContext context, int i) => Divider(
                color: Colors.grey[400],
              ),
              itemBuilder: (BuildContext context, int i) {
                _students = snapshot.data;
                final Student student = _students[i];
                return ListTile(
                  key: ValueKey(student.id),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailStudent(
                              id: student.id,
                              key: ValueKey(student.id),
                            )));
                  },
                  leading: Image.asset(
                    'assets/images/${student.gender}.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                  title: Text(student.fullName),
                  subtitle: Text(capitalize(student.gender)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(student.grade.toUpperCase()),
                      Text(student.mobilePhone)
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          _shouldWidgetUpdate = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FormStudent(
                  title: 'Buat Siswa',
                  isEdit: false,
                )),
          ) ??
              true;
        },
      ),
    );
  }
}
