
//https://github.com/Kadermiyanyedi/IOT-Project-Esp8266-MAX30100/blob/main/iot_project_max30100_esp8266/iot_project_max30100_esp8266.ino
#include <MAX30100_PulseOximeter.h>

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include "FirebaseESP8266.h"
#include "ESP8266WebServer.h"
#include <Wire.h>
#define REPORTING_PERIOD_MS 10000

//#define FIREBASE_HOST "mp2project-7a5a3-default-rtdb.firebaseio.com"         // the project name address from firebase id
//#define FIREBASE_AUTH "xiZ2m7jTH6gp8qalENbevAbbeLs5sez2OlAv2zgi"

#define FIREBASE_HOST "iot-based-health-monitor-206a6-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "xiZ2m7jTH6gp8qalENbevAbbeLs5sez2OlAv2zgi"
FirebaseData firebaseDataone;
FirebaseJson json;

#define WIFI_SSID       "AndroidSP21"
#define WIFI_PASSWORD   "11223344"
String patient_name = "Manish";
PulseOximeter pox;

uint32_t tsLastReport = 0;

void onBeatDetected()
{
    Serial.println("Beat!");
}

void setup()
{
    Serial.begin(115200);
    Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
    Serial.print("Initializing Pulse Oximeter..");
    if (!pox.begin())
    {
      Serial.println("FAILED");
      for(;;);
    }
    else
    {
      Serial.println("SUCCESS");
    }
    // Connect to wifi.
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting");
    while (WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(500);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());

//     if (Firebase.getString(firebaseDataone, "/Patient_Name/Manish")){
//        Serial.println("Fetched Data successfully");
//        patient_name = firebaseDataone.stringData();
//        //Serial.println(firebaseDataone.stringData());
//      }
//      else
//      {
//          Serial.println("Failed to fetch data");
//      }
      Serial.print("Data Received: ");
      Serial.print(patient_name);
      Serial.println(""); 


    pox.begin();
    pox.setOnBeatDetectedCallback(onBeatDetected);
    pox.setIRLedCurrent(MAX30100_LED_CURR_24MA);

}

void loop()
{
    pox.update();
    if (millis() - tsLastReport > REPORTING_PERIOD_MS) {

        float bpm = pox.getHeartRate();
        float spO2 = pox.getSpO2();
        
        
        Serial.print("Heart rate:");
        Serial.print(bpm);
        Serial.print("bpm / SpO2:");
        Serial.print(spO2);
        Serial.println("%");
                                                   

        tsLastReport = millis();

            //Firebase.pushFloat(firebaseDataone,"/Patient/Manish/SpO2", bpm);
            //Firebase.pushInt(firebaseDataone,"/Patient/Manish/bpm", spO2);
//            Firebase.setFloat(firebaseDataone, "/Try2/"+patient_name+"/bPM", bpm);
//            Firebase.setFloat(firebaseDataone, "/Try2/"+patient_name+"/spO2", spO2);
//            Firebase.setFloat(firebaseDataone, "/Patient_Name/Shivam1/BPM", bpm);
//            Firebase.setFloat(firebaseDataone, "/Patient_Name/Shivam1/SPO2",spO2);
        
    }
}
