
#include <Servo.h>
#include <HX711.h>
#include <Wire.h>
#include "Adafruit_MPR121.h"
//
////capacitive touch 
#ifndef _BV
#define _BV(bit) (1 << (bit)) 
#endif

//weight sensor setup
#define calibration_factor -197780.0
int addr = 0;
int triggeredTimes = 0;

const int LOADCELL_DOUT_PIN = 3;
const int LOADCELL_SCK_PIN = 2;

HX711 scale;
float weight;

//servo setup
Servo servo_test;        //initialize a servo object for the connected servo  
int angle = 0; 

Adafruit_MPR121 cap = Adafruit_MPR121();
uint16_t lasttouched = 0;
uint16_t currtouched = 0;
 
void setup() {
  Serial.begin(9600);
  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");
  
  //scale setup
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);  
  scale.set_scale(calibration_factor); //This value is obtained by using the SparkFun_HX711_Calibration sketch
  scale.tare();  //Assuming there is no weight on the scale at start up, reset the scale to 0

  //servo setup
  servo_test.attach(9);
  servo_test.write(0); 
}
 
void loop() {
  
  checkTouch();

//  
  weight = scale.get_units();
  if (weight <= -0.01) {
//    Serial.println("detect!");
    runServo(false);

    triggeredTimes ++;

//    delay(2000); // delay 2 sec
    scale.tare();  //Assuming there is no weight on the scale at start up, reset the scale to 0
  }
 
  
  if (Serial.available()) {
        runServo(true);
    while (Serial.available()) {
        Serial.read();
    }
  }

//  
  
}

void checkTouch() {
  for (uint8_t i=0; i<=10; i+=2) {
    currtouched = cap.touched();
//    if (_BV(i)) {
//      Serial.println(i);
//    }
//Serial.print((currtouched & _BV(i)) && !(lasttouched & _BV(i)));
    // it if *is* touched and *wasnt* touched before, alert!
    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
      Serial.println(i);
    }
  }

  // reset our state
  lasttouched = currtouched;//  for (uint8_t i=0; i<=8; i+=2) {
//    // it if *is* touched and *wasnt* touched before, alert!
//    
//    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
//      Serial.print(i); Serial.println(" touched");
//    }
//  }
//  lasttouched = currtouched;
}


void runServo(boolean open) {
  if (open) {
    for(angle = 0; angle < 110; angle++) {  // command to move from 0 degrees to 180 degrees 
      servo_test.write(angle);                 //command to rotate the servo to the specified angle
      delay(15);
    }
//    clock=0;
    return; 
  } else {
    for (angle; angle >= 1; angle--) {   // command to move from 180 degrees to 0 degrees 
      servo_test.write(angle);              //command to rotate the servo to the specified angle
      delay(10);                       
    }
  }
}
