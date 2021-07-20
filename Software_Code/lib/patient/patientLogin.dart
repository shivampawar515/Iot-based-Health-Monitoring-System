import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medkit/animations/bottomAnimation.dart';
import 'package:medkit/doctor/doctorLogin.dart';
import 'package:medkit/otherWidgetsAndScreen/backBtnAndImage.dart';
import 'package:medkit/patient/patientPanel.dart';
import 'package:medkit/patient/Dashboard.dart';

import 'package:toast/toast.dart';

final _controllerPatientName = TextEditingController();

class PatientLogin extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  bool validatePatientName = false;
  static String PatientNameVar;
  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);
    ProviderDoctorDetails providerInfo =
        new ProviderDoctorDetails(userDetails.providerId);

    List<ProviderDoctorDetails> providerData =
        new List<ProviderDoctorDetails>();
    providerData.add(providerInfo);

    PatientDetails details = new PatientDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Dashboard(PatientNameVar: PatientNameVar)));

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final PatientNameTextField = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLength: 30,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      controller: _controllerPatientName,
      decoration: InputDecoration(
          fillColor: Colors.black.withOpacity(0.07),
          filled: true,
          labelText: 'Enter Name',
          prefixIcon: WidgetAnimator(Icon(Icons.person)),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(20)))),
    );

    getNamePatient() {
      PatientNameVar = _controllerPatientName.text;
      _signIn(context)
          .then((FirebaseUser user) => print('Gmail Logged In'))
          .catchError((e) => print(e));
    }

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            BackBtn(),
            ImageAvatar(
              assetImage: 'assets/patient.png',
            ),
            Container(
              width: width,
              height: height,
              margin: EdgeInsets.fromLTRB(
                  width * 0.04, height * 0.1, width * 0.04, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: GoogleFonts.abel(
                        fontSize: height * 0.045, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  // Text(
                  //   'Features',
                  //   style: TextStyle(
                  //       color: Colors.black.withOpacity(0.5),
                  //       fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   '1. Details about different Diseases'
                  //   '\n2. Details about different Medicine'
                  //   '\n3. Check Dr Specification'
                  //   '\n4. Search for Nearest Pharmacy',
                  //   style: TextStyle(
                  //       color: Colors.black.withOpacity(0.5),
                  //       height: height * 0.002),
                  // ),
                  PatientNameTextField,
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.white,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        _controllerPatientName.text.isEmpty
                            ? validatePatientName = true
                            : validatePatientName = false;

                        !validatePatientName
                            ? getNamePatient()
                            : Toast.show("Empty Field Found!", context,
                                backgroundColor: Colors.red,
                                backgroundRadius: 5,
                                duration: Toast.LENGTH_LONG);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          WidgetAnimator(
                            Image(
                              image: AssetImage('assets/google.png'),
                              height: height * 0.038,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            'Login Using Gmail',
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                                fontSize: height * 0.021),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDoctorDetails> providerData;

  PatientDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderPatientDetails {
  ProviderPatientDetails(this.providerDetails);

  final String providerDetails;
}
