//
//  Incoming.ino
//  FluidQ Incoming Arduino
//
//  Created by Harry Shamansky on 11/1/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

int incomingByte = 0;

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  if (Serial.available()) {
    // read the character from Serial (USB)
    incomingByte = Serial.read();
      
    // write the character to the TX/RX pair
    Serial1.write(incomingByte);
  }
}
