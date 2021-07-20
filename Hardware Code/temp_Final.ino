
#include <Wire.h>
//#include "MAX30100_PulseOximeter.h"
//#include <OneWire.h>
//#include <DallasTemperature.h>
#include <DHT.h>
#include <ESP8266WiFi.h> 
#include "Adafruit_GFX.h"

#define DHTPIN 0         //pin where the dht11 is connected (D3)
#include "FirebaseESP8266.h"
#include "ESP8266HTTPClient.h" 
uint32_t tsLastReport = 0;

//#define FIREBASE_HOST "tempfinal-b868a-default-rtdb.firebaseio.com"         // the project name address from firebase id
//#define FIREBASE_AUTH "G6T2KTCGALI88kCE1f5lGFZQ9TYD7qvua31gOFae"            // the secret key generated from firebase        // the secret key generated from firebase

//#define FIREBASE_HOSTO "mp2project-7a5a3-default-rtdb.firebaseio.com"         // the project name address from firebase id
//#define FIREBASE_AUTHO "tzBlR5vSttW5OjnoiW52DStmmTnTJLkuUSJSxTiL" 

#define FIREBASE_HOSTO "iot-based-health-monitor-206a6-default-rtdb.firebaseio.com"
#define FIREBASE_AUTHO "xiZ2m7jTH6gp8qalENbevAbbeLs5sez2OlAv2zgi"

//FirebaseData firebaseData;
FirebaseData firebaseDataone;
FirebaseJson json;
DHT dht(DHTPIN, DHT11);

//#define DS18B20 D5
#define REPORTING_PERIOD_MS 10000
String patient_name = "zhakir";
float vref = 3.3;
float resolution = vref/1023;
float temperature, humidity, BPM, SpO2, bodytemperature;

/*Put your SSID & Password*/
const char *ssid =  "AndroidSP21";     // replace with your wifi ssid and wpa2 key
const char *pass =  "11223344";
WiFiServer server(80);
 

//PulseOximeter pox;
//uint32_t tsLastReport = 0;
//OneWire oneWire(DS18B20);
//DallasTemperature sensors(&oneWire);
 

       
 
void onBeatDetected()
{
  Serial.println("Beat!");
}
 
void setup() {
  Serial.begin(115200);
  //pinMode(D0, OUTPUT);
//  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
//  Firebase.reconnectWiFi(true);
  Firebase.begin(FIREBASE_HOSTO, FIREBASE_AUTHO);
  delay(10);
  dht.begin();
  delay(100);   
 
  Serial.println("Connecting to ");
  Serial.println(ssid);
 
  //connect to your local wi-fi network
  WiFi.begin(ssid, pass);
 
  //check wi-fi is connected to wi-fi network
  while (WiFi.status() != WL_CONNECTED) {
  delay(1000);
  Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected..!");
  Serial.print("Got IP: ");  Serial.println(WiFi.localIP());
 


  server.begin();
  Serial.println("HTTP server started");
 
//  Serial.print("Initializing pulse oximeter..");
// 
//    if (!pox.begin())
//    {
//         Serial.println("FAILED");
//        
//    }
//    else
//    {
//         Serial.println("SUCCESS");
//         pox.setOnBeatDetectedCallback(onBeatDetected);
//    }
    //patient_name = Firebase.getString(firebaseDataone, "/MP2_Project/Vishal");
//    if (Firebase.getString(firebaseDataone, "/Patient_Name/Manish")){
//      
//      patient_name = firebaseDataone.stringData();
//      Serial.println(firebaseDataone.stringData());
//    }
//    else
//    {
//        Serial.println("Failed to fetch data");
//    }
    Serial.print("Data Received: ");
    Serial.print(patient_name);
    Serial.println(""); 
  // Register a callback for the beat detection
 
}

void loop() {
  //pox.update();
  //heartSensor();
  //pox.shutdown();
  
  
//  if (isnan(h) || isnan(t)) 
//  {
//    Serial.println("Failed to read from DHT sensor!");
//    return;
//  }
//  
  
  

    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/temperature", t); 
    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/humidity", h);
    //Firebase.setFloat(firebaseDataone, "/Try/temp/", t);      
//    Firebase.pushFloat(firebaseDataone, "/Patient_Name/Shivam1/Temp", t); 
//    Firebase.pushFloat(firebaseDataone, "/Patient_Name/Shivam1/Humidity", h);
//    Firebase.pushFloat(firebaseDataone, "/Patient_Name/Shivam1/BodyTemperature", bodytemp);
    //Firebase.pushFloat(firebaseDataone, "/Patient_Name/Name".equals('Manish')"/BodyTemp"), bodytemp);
 
    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/bpm", BPM);
    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/SpO2", SpO2);
    //Firebase.pushFloat(firebaseDataone, "/Patient_Name/Name").equals('Manish')), bodytemp);
    //delay(10000);
  if (millis() - tsLastReport > REPORTING_PERIOD_MS) 
  {
//    Serial.print("Room Temperature: ");
//    Serial.print(t);
//    Serial.println("°C");
//    
//    Serial.print("Room Humidity: ");
//    Serial.print(h);
//    Serial.println("%");
    
//    Serial.print("BPM: ");
//    Serial.println(BPM);
//    
//    Serial.print("SpO2: ");
//    Serial.print(SpO2);
//    Serial.println("%");
 
//    Serial.print("Body Temperature: ");
//    Serial.print(bodytemp);
//    Serial.println("°C");
//    
//    Serial.println("*********************************");
//    Serial.println();
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    float bodytemp = ((analogRead(A0) * resolution) * 100)+33.89;
  Serial.print("Room Temperature: ");
  Serial.print(t);
  Serial.println("°C");
    
  Serial.print("Room Humidity: ");
  Serial.print(h);
  Serial.println("%");
  
  Serial.print("Body Temperature: ");
  Serial.print(bodytemp);
  Serial.println("°C");
    
  Serial.println("*********************************");
  Serial.println();
    tsLastReport = millis();
    
    Firebase.setFloat(firebaseDataone, "/Try2/"+patient_name+"/temp", t); 
    Firebase.setFloat(firebaseDataone, "/Try2/"+patient_name+"/humidity", h); 
    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/bpm", BPM);
    //Firebase.pushFloat(firebaseDataone, "/Patient/"+patient_name+"/SpO2", SpO2);
    Firebase.setFloat(firebaseDataone, "/Try2/"+patient_name+"/bodyTemp", bodytemp);
    
  }
}


  //pox.resume();
  
