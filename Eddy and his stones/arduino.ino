// Import libraries
#include <SPI.h>
#include <EddystoneBeacon.h>

// You need to change this if you use something
// other then the RedBearlab BLE shield
#define EDDYSTONE_BEACON_REQ   9
#define EDDYSTONE_BEACON_RDY   8
#define EDDYSTONE_BEACON_RST   UNUSED

EddystoneBeacon eddystoneBeacon = EddystoneBeacon(
    EDDYSTONE_BEACON_REQ,
    EDDYSTONE_BEACON_RDY,
    EDDYSTONE_BEACON_RST
);

void setup() {
  Serial.begin(9600);
  delay(1000);
  eddystoneBeacon.begin(-18, "http://www.simplicity.be");
}

void loop() {
  eddystoneBeacon.loop();
}
