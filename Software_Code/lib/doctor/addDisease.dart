import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:toast/toast.dart';
import 'dart:developer' as developer;

final controllerPatName = TextEditingController();
final controllerDisName = TextEditingController();
final controllerMedName = TextEditingController();
final controllerMedDose = TextEditingController();
final controllerDesc = TextEditingController();

class AddDisease extends StatefulWidget {
  final String doctorName;
  final String doctorEmail;
  AddDisease({this.doctorName, this.doctorEmail});

  @override
  _AddDiseaseState createState() => _AddDiseaseState();
}

class _AddDiseaseState extends State<AddDisease> {
  bool validPatName = false;
  bool validDisName = false;
  bool validMedName = false;
  bool validMedDose = false;
  bool validDesc = false;
  final DbRef = FirebaseDatabase.instance.reference();
  //final db = FirebaseDatabase.instance.reference().child("Patient_Name");
  final databaseReference = FirebaseDatabase.instance.reference();

  // final ref = DbRef.reference().child("Patient_Name");
  // var query =
  //     DbRef.child("Patient_Name").orderByChild("Name").limitToFirst(pageSize);
  var reterData = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final patNameTF = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerPatName,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: WidgetAnimator(
              Image(
                  image: AssetImage('assets/PName.png'), height: height * 0.04),
            ),
          ),
          labelText: 'Patients Full Name',
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final disNameTF = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerDisName,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: WidgetAnimator(
              Image(
                  image: AssetImage('assets/injection.png'),
                  height: height * 0.04),
            ),
          ),
          labelText: 'Disease Name',
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final medNameTF = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerMedName,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: WidgetAnimator(
              Image(
                image: AssetImage('assets/tablets.png'),
                height: height * 0.04,
              ),
            ),
          ),
          labelText: 'Medicine Name',
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final medTimeTF = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerMedDose,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: WidgetAnimator(
              Image(
                image: AssetImage('assets/pill.png'),
                height: height * 0.04,
              ),
            ),
          ),
          labelText: 'Medicine Dose',
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final medDescTF = TextField(
      keyboardType: TextInputType.multiline,
      autofocus: false,
      controller: controllerDesc,
      maxLines: null,
      decoration: InputDecoration(
          prefixIcon: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: WidgetAnimator(
              Image(
                image: AssetImage('assets/steth.png'),
                height: height * 0.04,
              ),
            ),
          ),
          labelText: 'Description & Prediction',
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    controllerClear() {
      controllerPatName.clear();
      controllerDisName.clear();
      controllerMedName.clear();
      controllerMedDose.clear();
      controllerDesc.clear();
    }

    addingDisease() {
      Firestore.instance
          .collection('Diseases')
          .document(controllerPatName.text)
          .setData({
        'patName': controllerPatName.text,
        'disName': "Not Yet Added",
        'medName': "Not Yet Added",
        'medTime': "Not Yet Added",
        'medDesc': "Not Yet Added",
        'post': widget.doctorName,
        'docEmail': widget.doctorEmail
      });
      DbRef.child("Patient_Name")
          .push()
          .set({controllerPatName.text: controllerPatName.text});

      controllerClear();

      Toast.show('Added Successfully In Both Databases!', context,
          backgroundRadius: 5, backgroundColor: Colors.blue, duration: 3);
      Navigator.pop(context);

      // DbRef.once().then((DataSnapshot dataSnapShot) {
      //   print(dataSnapShot.value);
      //   dataSnapShot.value.forEach((key, values) {
      //     print(values["Name"]);
      //   });
      // });
    }

    retData() {
      databaseReference.child('Try').once().then((DataSnapshot snapshot) {
        double temp = snapshot.value['temp'];
        print(
            "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Fetched Value !!!!!!!!!!!!!!!!! ");
        print(temp);
        print(
            "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Successfull !!!!!!!!!!!!!!!!! ");
      });
      //query.onChildAdded.forEach((event) => {print(event.snapshot.value)});
      // DbRef.child('Patient_Name')
      //     .orderByChild('Name')
      //     .equalTo('Pratik')
      //     .once()
      //     .then((DataSnapshot dataSnapShot) {
      //   print(dataSnapShot.value);
      // });
      DbRef.once().then((DataSnapshot dataSnapShot) {
        print(dataSnapShot.value);
        dataSnapShot.value.forEach((key, values) {
          print(values["Name"]);
        });
      });
      // db.once().then((DataSnapshot snapshot) {
      //   Map<dynamic, dynamic> value = snapshot.value;
      //   value.forEach((key, values) {
      //     setState(() {
      //       reterData = value["Name"];
      //       print(value["Name"]);
      //       print(snapshot.value);
      //       developer.log(snapshot.value);
      //       developer.log(value["Name"]);
      //     });
      //   });
      // });
      Toast.show("Fetched Data Successfully!!", context,
          backgroundRadius: 5, backgroundColor: Colors.blue, duration: 20);
    }

    final addBtn = Container(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              controllerPatName.text.isEmpty
                  ? validPatName = true
                  : validPatName = false;
              // controllerDisName.text.isEmpty
              //     ? validDisName = true
              //     : validDisName = false;
              // controllerMedName.text.isEmpty
              //     ? validMedName = true
              //     : validMedName = false;
              // controllerMedDose.text.isEmpty
              //     ? validMedDose = true
              //     : validMedDose = false;
              // controllerDesc.text.isEmpty
              //     ? validDesc = true
              //     : validDesc = false;
            });
            !validPatName & !validDisName
                // !validMedName &
                // !validMedDose &
                // !validDesc
                ? addingDisease()
                : Toast.show("Empty Field(s) Found!", context,
                    backgroundColor: Colors.red,
                    backgroundRadius: 5,
                    duration: 2);
            retData();
            print("Hello Shivammmmm.....");
            developer.log("Helloooooo Vishall");
            Text("Helloooo Siddhi");
            Text(reterData);
          },
          color: Colors.white,
          shape: StadiumBorder(),
          child: Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ));

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: width,
              margin: EdgeInsets.fromLTRB(width * 0.025, 0, width * 0.025, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BackBtn(),
                  SizedBox(height: height * 0.05),
                  Row(
                    children: <Widget>[
                      Text(
                        'Adding',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.04),
                      ),
                      SizedBox(width: height * 0.015),
                      Text('Disease',
                          style: GoogleFonts.abel(fontSize: height * 0.04))
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Enter the Following Information',
                    style: GoogleFonts.abel(fontSize: height * 0.025),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  patNameTF,
                  SizedBox(
                    height: height * 0.015,
                  ),
                  // disNameTF,
                  // SizedBox(
                  //   height: height * 0.015,
                  // ),
                  // medNameTF,
                  // SizedBox(
                  //   height: height * 0.015,
                  // ),
                  // medTimeTF,
                  // SizedBox(
                  //   height: height * 0.015,
                  // ),
                  // medDescTF,
                  // SizedBox(
                  //   height: height * 0.02,
                  // ),
                  addBtn,
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
