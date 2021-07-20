import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'CircleProgress.dart';
import 'package:toast/toast.dart';
import 'package:medkit/otherWidgetsAndScreen/medDetails.dart';
import 'package:medkit/doctor/addDisease.dart';
//import 'package:medkit/otherWidgetsAndScreen/customListTiles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'patientLogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'API.dart';

class Dashboard extends StatefulWidget {
  //final DocumentSnapshot snapshot;
  String PatientNameVar;
  //final DocumentSnapshot snapshot;

  Dashboard({this.PatientNameVar});

  @override
  _DashboardState createState() => _DashboardState(PatientNameVar);
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  // _deleteDisease(BuildContext context) {
  //   Firestore.instance
  //       .collection('Diseases')
  //       .document(widget.snapshot.data['patName']);
  // }
  //String dataLe;
  String PatientNameVar;
  String tryingText;
  String final_result = "Click on 'Check Prediction' button";
  String dataLe = PatientLogin.PatientNameVar;
  // var url;
  // var Data;
  // String QueryText = "Query";
  double temp, humidity, spO2, bodyTemp, bPM;
  _DashboardState(this.PatientNameVar);
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final databaseReference = FirebaseDatabase.instance.reference();

  AnimationController progressController;
  Animation<double> tempAnimation;
  Animation<double> humidityAnimation;
  Animation<double> spO2Animation;
  Animation<double> bodyTempAnimation;
  Animation<double> bPMAnimation;

  @override
  void initState() {
    super.initState();

    databaseReference.child('Try2').once().then((DataSnapshot snapshot) {
      setState(() {
        temp = snapshot.value[dataLe]['temp'];
        humidity = snapshot.value['Manish']['humidity'];
        spO2 = snapshot.value['Manish']['spO2'];
        bPM = snapshot.value['Manish']['bPM'];
        bodyTemp = snapshot.value['Manish']['bodyTemp'];
        print("!!!!!!!!!!!");
        print(temp);
        print(humidity);
        print(spO2);
        print(bPM);
        print(bodyTemp);
      });
      isLoading = true;
      _DashboardInit(temp, humidity, spO2, bPM, bodyTemp);
    });
  }

  DdataLe() {
    print("Ddata inside");
    print(PatientNameVar);
    print(dataLe);
    Firestore.instance
        .collection('Diseases')
        .document(dataLe)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data}');
      } else {
        print('Document data does not exists.');
      }
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => MedDetails(
                    snapshot: documentSnapshot,
                  )));
    });
  }

  _DashboardInit(
      double temp, double humid, double spO2, double bPM, double bodyTemp) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000)); //5s

    tempAnimation =
        Tween<double>(begin: -50, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    humidityAnimation =
        Tween<double>(begin: 0, end: humid).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    spO2Animation =
        Tween<double>(begin: -50, end: spO2).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    bPMAnimation =
        Tween<double>(begin: -50, end: bPM).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    bodyTempAnimation =
        Tween<double>(begin: -50, end: bodyTemp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Info'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
            icon: Icon(Icons.reorder), onPressed: handleLoginOutPopup),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CustomPaint(
                            foregroundPainter:
                                CircleProgress(tempAnimation.value, true),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Temperature'),
                                    Text(
                                      //'${tempAnimation.value.toInt()}',
                                      '${temp}',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '°C',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CustomPaint(
                            foregroundPainter:
                                CircleProgress(humidityAnimation.value, false),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Humidity'),
                                    Text(
                                      '${humidityAnimation.value.toInt()}',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '%',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CustomPaint(
                            foregroundPainter:
                                CircleProgress(spO2Animation.value, true),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('SpO2'),
                                    Text(
                                      '${spO2Animation.value.toInt()}',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '°C',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CustomPaint(
                            foregroundPainter:
                                CircleProgress(bPMAnimation.value, true),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('BPM'),
                                    Text(
                                      '${bPMAnimation.value.toInt()}',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '%',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CustomPaint(
                            foregroundPainter:
                                CircleProgress(bodyTempAnimation.value, true),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('BodyTemp'),
                                    Text(
                                      '${bodyTempAnimation.value.toInt()}',
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '%C',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        child: Text(
                          "Your Predicted Condition: $final_result",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: height * 0.03),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                            child: SizedBox(
                              width: width,
                              height: height * 0.075,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: StadiumBorder(),
                                onPressed: () async {
                                  // print("HELLO Artiel");
                                  // http.Response tryText =
                                  //     await http.get('http://10.0.2.2:5000/');
                                  // print("Hello Idea");

                                  // final dec = json.decode((tryText.body))
                                  //     as Map<String, dynamic>;
                                  // // final Map temp = json.decode(tryText.body);
                                  // // print(temp);
                                  // final_result = dec['greetings'];

                                  // print("HELLO Jio");
                                  DocumentSnapshot variable = await Firestore
                                      .instance
                                      .collection('Diseases')
                                      .document(PatientNameVar)
                                      .get();
                                  //var url = Uri.parse('https://10.0.2.2:5000/');

                                  // var value = "April MAy June July";
                                  // url = 'http://127.0.0.1:5000/api?Query=' +
                                  //     value.toString();

                                  // Data = await Getdata(url);
                                  // var DataDecoded = jsonDecode(Data);
                                  // QueryText = DataDecoded['Query'];

                                  print("##################");
                                  //print(QueryText);
                                  // print(dec['greetings']);
                                  //setState(({tryingText = dec['greetings']}));

                                  //print(variable['medName']);
                                  print(PatientNameVar);
                                  print(dataLe);
                                  DdataLe();
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => Dashboard()));

                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => MedDetails(
                                  //               snapshot: widget.snapshot,
                                  //             )));

                                  Toast.show("Check the Report", context,
                                      backgroundRadius: 5,
                                      backgroundColor: Colors.blue,
                                      duration: 3);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        'Report',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.021),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                            child: SizedBox(
                              width: width,
                              height: height * 0.075,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: StadiumBorder(),
                                onPressed: () async {
                                  print("HELLO Artiel");
                                  http.Response tryText =
                                      await http.get('http://10.0.2.2:5000/');
                                  print("Hello Idea");

                                  final dec = json.decode((tryText.body))
                                      as Map<String, dynamic>;
                                  // final Map temp = json.decode(tryText.body);
                                  // print(temp);
                                  setState(() {
                                    final_result = dec['greetings'];
                                  });

                                  print("HELLO Jio");
                                  // DocumentSnapshot variable = await Firestore
                                  //     .instance
                                  //     .collection('Diseases')
                                  //     .document(PatientNameVar)
                                  //     .get();
                                  //var url = Uri.parse('https://10.0.2.2:5000/');

                                  // var value = "April MAy June July";
                                  // url = 'http://127.0.0.1:5000/api?Query=' +
                                  //     value.toString();

                                  // Data = await Getdata(url);
                                  // var DataDecoded = jsonDecode(Data);
                                  // QueryText = DataDecoded['Query'];

                                  // print("##################");
                                  // //print(QueryText);
                                  // // print(dec['greetings']);
                                  // //setState(({tryingText = dec['greetings']}));

                                  // //print(variable['medName']);
                                  // print(PatientNameVar);
                                  // print(dataLe);
                                  // DdataLe();
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => Dashboard()));

                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) => MedDetails(
                                  //               snapshot: widget.snapshot,
                                  //             )));

                                  Toast.show(
                                      "Check Doctors Prescription", context,
                                      backgroundRadius: 5,
                                      backgroundColor: Colors.blue,
                                      duration: 3);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        'Check Prediction',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: height * 0.021),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                    ],
                  )
                : Text(
                    'Loading your data...',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
      ),
    );
  }

  handleLoginOutPopup() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Login Out",
      desc: "Do you want to login out now?",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: handleSignOut,
          color: Colors.blue,
        )
      ],
    ).show();
  }

  Future<Null> handleSignOut() async {
    googleSignIn.signOut();
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }
}
