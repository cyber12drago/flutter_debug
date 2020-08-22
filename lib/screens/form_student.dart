import 'package:flutter/material.dart';
import 'package:flutteragenda/domain/student.dart';
import 'package:flutteragenda/service/app_service.dart';
import 'package:flutteragenda/util/capitalize.dart';
import 'package:flutteragenda/widgets/check_box.dart';
import 'package:flutteragenda/widgets/form_label.dart';
import 'package:flutteragenda/widgets/radio_button.dart';
import 'package:toast/toast.dart';

import 'home.dart';

class FormStudent extends StatefulWidget {
  final String title;
  final bool isEdit;
  final Student data;
  final int id;

  const FormStudent(
      {Key key,
        @required this.title,
        @required this.isEdit,

        this.data
        ,

        this.id
      })
      : super(key: key);


  @override
  _FormStudentState createState() => _FormStudentState();
}

class _FormStudentState extends State<FormStudent> {
  static const genders = Student.genders;
  static const grades = Student.grades;
  static const hobbies = Student.hobbiesList;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  double _gap = 16.0;
  FocusNode _firstNameFocus, _mobilePhoneFocus, _lastNameFocus;
  TextEditingController _firstNameCtrl,
      _mobilePhoneCtrl,
      _lastNameCtrl,
      _addressCtrl;
  String _firstName, _lastName, _mobilePhone, _address, _gender, _grade;
  List<String> _hobbies = [];
  final List<DropdownMenuItem<String>> _gradeItems = grades
      .map((String val) => DropdownMenuItem<String>(
    value: val,
    child: Text(val.toUpperCase()),
  ))
      .toList();

  @override
  void initState() {
    super.initState();



    _gender = 'pria';
    _firstNameFocus = FocusNode();
    _mobilePhoneFocus = FocusNode();
    _lastNameFocus = FocusNode();

    _firstNameCtrl = TextEditingController();
    _mobilePhoneCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _addressCtrl = TextEditingController();

    if (
    widget.data
        != null &&
        widget.data
        is Student && widget.isEdit) {
      setState(() {

        _firstName = widget.data.firstName;
        _lastName = widget.data.lastName;
        _mobilePhone = widget.data.mobilePhone;
        _address = widget.data.address;
        _gender = widget.data.gender;
        _grade = widget.data.grade;
        _hobbies = widget.data.hobbies;


        _firstNameCtrl.value = TextEditingValue(
            text: widget.data.firstName,
            selection:
            TextSelection.collapsed(offset: widget.data.firstName.length));
        _lastNameCtrl.value = TextEditingValue(
            text: widget.data.lastName,
            selection:
            TextSelection.collapsed(offset: widget.data.lastName.length));
        _mobilePhoneCtrl.value = TextEditingValue(
            text: widget.data.mobilePhone,
            selection:
            TextSelection.collapsed(offset: widget.data.mobilePhone.length));
        _addressCtrl.value = TextEditingValue(
            text: widget.data.address,
            selection:
            TextSelection.collapsed(offset: widget.data.address.length));

      });
    }




  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _firstNameFocus.dispose();
    _mobilePhoneFocus.dispose();
    _lastNameFocus.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  handleError(e) {

    _showSnackBar('Error: ${e.toString()}');

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
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            focusNode: _firstNameFocus,
                            controller: _firstNameCtrl,
                            textInputAction:
                            TextInputAction.next
                            ,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama Depan',
                            ),
                            onSaved: (String value) {
                              // will trigger when saved
                              print('onsaved firstName: $value');
                              _firstName = value;
                            },
                            onFieldSubmitted: (term) {
                              // process
                              _firstNameFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_lastNameFocus);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            focusNode: _lastNameFocus,
                            controller:_lastNameCtrl,
                            textInputAction:
                            TextInputAction.next
                            ,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama Belakang',
                            ),
                            onSaved: (String value) {
                              // will trigger when saved
                              print('onsaved _lastName $value');
                              _lastName = value;
                            },
                            onFieldSubmitted: (term) {
                              // process
                              _lastNameFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_mobilePhoneFocus);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    focusNode: _mobilePhoneFocus,
                    controller: _mobilePhoneCtrl,
                    textInputAction:
                    TextInputAction.next
                    ,
                    keyboardType:
                    TextInputType.phone
                    ,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No. Hp',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _mobilePhone $value');
                      _mobilePhone = value;
                    },
                    onFieldSubmitted: (term) {
                      // process
                    },
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  FormLabel('Jenis Kelamin'),
                  Row(
                    children: genders
                        .map((String val) => RadioButton<String>(
                        value: val,
                        groupValue: _gender,
                        label: Text(capitalize(val)),
                        onChanged: (String value) {
                          setState(() => _gender = value);
                        }))
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: DropdownButton(
                      value: _grade,
                      hint: Text('Pilih jenjang'),
                      items: _gradeItems,
                      isExpanded: true,
                      onChanged: (String value) {
                        setState(() {
                          _grade = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  FormLabel('Hobi'),
                  Column(
                    children: hobbies
                        .map((String val) => CheckBox(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 1.0),
                      value: _hobbies.contains(val),
                      onChanged: (bool value) {
                        setState(() {
                          if (_hobbies.contains(val)) {
                            _hobbies.remove(val);
                          } else {
                            _hobbies.add(val);
                          }
                        });
                      },
                      label: capitalize(val),
                    ))
                        .toList(),
                  ),
                  SizedBox(
                    height: _gap,
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: _addressCtrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat',
                    ),
                    onSaved: (String value) {
                      // will trigger when saved
                      print('onsaved _address $value');
                      _address = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(

            Icons.save
            ,
            color: Colors.white,
          ),
          onPressed: () {


            final form = _formKey.currentState;
            if (form.validate()) {
              // Process data.
              if (_grade == null) {
                _showSnackBar('Jenjang wajib diisi!');
              } else if (_gender == null) {
                _showSnackBar('Jenis kelamin wajib diisi!');
              } else if (_hobbies.length == 0) {
                _showSnackBar('Hobi wajib diisi!');
              } else {

                form.save
                  (); // required to trigger onSaved props
                Student _student = Student();
                _student.firstName = _firstName;
                _student.lastName = _lastName ==null?"":_lastName;
                _student.mobilePhone = _mobilePhone;
                _student.grade = _grade;
                _student.gender = _gender;
                _student.hobbies = _hobbies;
                _student.address = _address;
//                                print(_student);

                if (widget.isEdit){

                  AppService.studentService.updateStudentBy(id:widget.data.id,domain:_student).then((val) {

                    Toast.show
                      ("Updated sukses", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
                  }).catchError((onError) {
                    handleError(onError);
                  });

                }else {
                  AppService.studentService.createStudent(_student).then((val) {

                    Toast.show
                      ("Sukses tersimpan", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
                  }).catchError((onError) {
                    handleError(onError);
                  });
                }
//                                AppService.studentService.createStudent(_student).then((int idx) =>

//                                        .catchError(handleError)
//                                );



              }


            }else {
              setState(() {
                _autoValidate = true;
              });
            }
          }),
    );
  }
}