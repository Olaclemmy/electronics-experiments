/********************************************
 *
 * ESP8266 UDP broadcast
 *
 * @author Glenn De Backer <glenn@simplicity.be>
 *
 ********************************************/

#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

const char* ssid     = "AC3200";
const char* password = "S1L3NTL8N";
IPAddress broadcastIp;
WiFiUDP udp;

void setup() {
  // open serial connection
  Serial.begin(115200);

  // start connecting with our
  // wifi network
  WiFi.begin(ssid, password);

  // loop as long we are not connected
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Waiting for connection");
  }

  // set broadcast and gateway ip
  broadcastIp = ~WiFi.subnetMask() | WiFi.gatewayIP();
}

void loop() {
  // broadcast udp package
  udp.beginPacket(broadcastIp, 5005);
  udp.write("{ \"sensor\" : \"esp8266\", \"value\": \"hello from esp8266\" }");
  udp.endPacket();

  // wait 10 seconds
  delay(10000);
}
