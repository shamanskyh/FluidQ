//
//  Outgoing.ino
//  FluidQ Outgoing Arduino
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
  if (Serial1.available()) {
    // read the character from Serial1 (TX/RX)
    incomingByte = Serial1.read();

    // write the character to the HID (USB)
    Keyboard.write(incomingByte);
  }
}
