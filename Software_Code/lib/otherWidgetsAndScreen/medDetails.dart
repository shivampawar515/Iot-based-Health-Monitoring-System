import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/otherWidgetsAndScreen/doctorAbout.dart';
import 'package:medkit/patient/Dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'backBtnAndImage.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medkit/doctor/addDisease.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final controllerUpdatedDesc = TextEditingController();
final controllerUpdatedMed = TextEditingController();
final controllerUpdatedDose = TextEditingController();

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class MedDetails extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String doctorName;
  // String final_result;
  MedDetails({@required this.snapshot, this.doctorName});

  @override
  _MedDetailsState createState() => _MedDetailsState();
}

class _MedDetailsState extends State<MedDetails> {
  var location = new Location();
  var currentLocation = LocationData;
  // String final_result_med = _DashboardState.final_result;

  final databaseReference = FirebaseDatabase.instance.reference();
  double temp, humidity, spO2, bodyTemp, bPM;
  bool validDesc = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    updatingDisease() {
      Firestore.instance
          .collection('Diseases')
          .document(widget.snapshot.data['patName'])
          .updateData({
        'medDesc': controllerUpdatedDesc.text,
        //'docEmail': widget.doctorEmail
      });
    }

    updatingMed() {
      Firestore.instance
          .collection('Diseases')
          .document(widget.snapshot.data['patName'])
          .updateData({
        'medName': controllerUpdatedMed.text,
        //'docEmail': widget.doctorEmail
      });
    }

    updatingDose() {
      Firestore.instance
          .collection('Diseases')
          .document(widget.snapshot.data['patName'])
          .updateData({
        'medTime': controllerUpdatedDose.text,
        //'docEmail': widget.doctorEmail
      });
    }

    databaseReference
        .child('Try2')
        .child("Manish")
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        temp = snapshot.value['temp'];
        humidity = snapshot.value['humidity'];
        spO2 = snapshot.value['spO2'];
        bPM = snapshot.value['bPM'];
        bodyTemp = snapshot.value['bodyTemp'];
        print("22222222222222222222222");
        print(temp);
        print(humidity);
        print(spO2);
        print(bPM);
        print(bodyTemp);
        print(snapshot.value['temp']);
      });
    });

    final updatedDose = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerUpdatedDose,
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
          labelText: widget.snapshot.data['medTime'],
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final updatedDesc = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerUpdatedDesc,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
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
          labelText: widget.snapshot.data['medDesc'],
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final updatedMed = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: controllerUpdatedMed,
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
          labelText: widget.snapshot.data['medName'],
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    return Scaffold(
      body: SafeArea(
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.02),
                  width: width * 0.75,
                  child: Opacity(
                      opacity: 0.3,
                      child: Row(
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/pill.png'),
                            height: height * 0.1,
                          ),
                          Image(
                            image: AssetImage('assets/syrup.png'),
                            height: height * 0.1,
                          ),
                          Image(
                            image: AssetImage('assets/tablets.png'),
                            height: height * 0.07,
                          ),
                          Image(
                            image: AssetImage('assets/injection.png'),
                            height: height * 0.07,
                          )
                        ],
                      )),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BackBtn(),
                  Container(
                      width: width,
                      margin: EdgeInsets.fromLTRB(
                          width * 0.025, 0, width * 0.025, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.snapshot.data['patName'],
                                style:
                                    GoogleFonts.abel(fontSize: height * 0.06),
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                shape: CircleBorder(),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DoctorAbout(
                                                docEmail: widget
                                                    .snapshot.data['docEmail'],
                                                docName: widget
                                                    .snapshot.data['post'],
                                              )));
                                },
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: height * 0.05,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Posted by: ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Dr. ' + widget.snapshot.data['post'],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'BodyTemp: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                              Text(
                                '${bodyTemp}',
                                style: GoogleFonts.averageSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.03),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Blood Oxygen: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                              WidgetAnimator(
                                Text(
                                  '${spO2}',
                                  style: GoogleFonts.averageSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'BPM: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                              WidgetAnimator(
                                Text(
                                  '${bPM}',
                                  style: GoogleFonts.averageSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Temperature: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                              WidgetAnimator(
                                Text(
                                  '${temp}',
                                  style: GoogleFonts.averageSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Humidity: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                              WidgetAnimator(
                                Text(
                                  '${humidity}',
                                  style: GoogleFonts.averageSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.03),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Medicine: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                            ],
                          ),
                          updatedMed,
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Dose: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                            ],
                          ),
                          updatedDose,
                          SizedBox(
                            height: height * 0.01,
                          ),
                          // Container(
                          //   width: width,
                          //   height: height * 0.2,
                          //   decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.black54),
                          //       borderRadius: BorderRadius.circular(4)),
                          //   child: ListView(
                          //     padding: EdgeInsets.symmetric(horizontal: 5),
                          //     children: <Widget>[
                          //       Text(
                          //         widget.snapshot.data['medDesc'],
                          //         style: TextStyle(height: 1.5, fontSize: 17),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Description: ',
                                style: TextStyle(fontSize: height * 0.03),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     Text(
                          //       final_result_med,
                          //       style: TextStyle(fontSize: height * 0.03),
                          //     ),
                          //   ],
                          // ),
                          updatedDesc,
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          // WidgetAnimator(
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Icon(
                          //         Icons.warning,
                          //         size: height * 0.02,
                          //         color: Colors.red,
                          //       ),
                          //       SizedBox(
                          //         width: width * 0.02,
                          //       ),
                          //       Text(
                          //         'See a Doctor if condition gets Worse!',
                          //         style: TextStyle(color: Colors.red),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                            child: SizedBox(
                              width: width,
                              height: height * 0.075,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: StadiumBorder(),
                                onPressed: () {
                                  updatingDisease();
                                  updatingMed();
                                  updatingDose();
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => MedDetails(
                                  //               snapshot: widget.snapshot,
                                  //             )));
                                  Toast.show(
                                      "Data Updated Successfully!!", context,
                                      backgroundRadius: 5,
                                      backgroundColor: Colors.blue,
                                      duration: 3);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        'Update',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.021),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                            child: SizedBox(
                              width: width,
                              height: height * 0.075,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: StadiumBorder(),
                                onPressed: () {
                                  MapUtils.openMap('Pharmacy near me');
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      WidgetAnimator(Image.asset(
                                        'assets/mapicon.png',
                                        height: height * 0.030,
                                      )),
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        'Search Nearest Pharmacy',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.021),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.07,
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
