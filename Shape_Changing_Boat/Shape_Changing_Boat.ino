#include <WiFi.h>
#include <ArduinoOTA.h>

static const int32_t tolerance = 30;

static const int M1A = 3;
static const int M1B = 4;
static const int M1EA = 5;
static const int M1EB = 6;
static const int M2A = 41;
static const int M2B = 42;
static const int M2EA = 39;
static const int M2EB = 40;
static const int M3A = 10;
static const int M3B = 11;
static const int LED = 16;
static const int VBAT = 1;

static const char *ssid = "BotTest";
static const char *password = "123456789";

// Set web server port number to 80
WiFiServer server(80);
// Variable to store the HTTP request
String header;

volatile int32_t M1_target = 0;
volatile int32_t M1_current = 0;
volatile int32_t M1_error = 0;
volatile uint8_t M1_power = 0;
volatile int32_t M2_target = 0;
volatile int32_t M2_current = 0;
volatile int32_t M2_error = 0;
volatile uint8_t M2_power = 0;
volatile bool M3_direction = true;
volatile uint8_t M3_power = 0;
volatile bool pause_bot = false;

volatile uint8_t M1_rec, M2_rec;

void motor()
{
  if (M1_target - tolerance > M1_current && !pause_bot)
  {
    ledcWrite(M1A, M1_power);
    ledcWrite(M1B, 0);
  }
  else if (M1_target + tolerance < M1_current && !pause_bot)
  {
    ledcWrite(M1A, 0);
    ledcWrite(M1B, M1_power);
  }
  else
  {
    ledcWrite(M1A, 0);
    ledcWrite(M1B, 0);
  }
  if (M2_target - tolerance > M2_current && !pause_bot)
  {
    ledcWrite(M2A, M2_power);
    ledcWrite(M2B, 0);
  }
  else if (M2_target + tolerance < M2_current && !pause_bot)
  {
    ledcWrite(M2A, 0);
    ledcWrite(M2B, M2_power);
  }
  else
  {
    ledcWrite(M2A, 0);
    ledcWrite(M2B, 0);
  }
  if (M3_direction && !pause_bot)
  {
    ledcWrite(M3A, M3_power);
    ledcWrite(M3B, 0);
  }
  else if (!M3_direction && !pause_bot)
  {
    ledcWrite(M3A, 0);
    ledcWrite(M3B, M3_power);
  }
  else
  {
    ledcWrite(M3A, 0);
    ledcWrite(M3B, 0);
  }
}

void IRAM_ATTR isr()
{
  uint8_t M1_now = (digitalRead(M1EA) << 1) | digitalRead(M1EB);
  uint8_t M2_now = (digitalRead(M2EA) << 1) | digitalRead(M2EB);

  // 00,01,11,10
  if ((M1_rec == 0b00 && M1_now == 0b01) || (M1_rec == 0b01 && M1_now == 0b11) || (M1_rec == 0b11 && M1_now == 0b10) || (M1_rec == 0b10 && M1_now == 0b00))
    M1_current++;
  else if ((M1_rec == 0b10 && M1_now == 0b11) || (M1_rec == 0b11 && M1_now == 0b01) || (M1_rec == 0b01 && M1_now == 0b00) || (M1_rec == 0b00 && M1_now == 0b10))
    M1_current--;
  else if (M1_rec != M1_now)
    M1_error++;
  if ((M2_rec == 0b00 && M2_now == 0b01) || (M2_rec == 0b01 && M2_now == 0b11) || (M2_rec == 0b11 && M2_now == 0b10) || (M2_rec == 0b10 && M2_now == 0b00))
    M2_current++;
  else if ((M2_rec == 0b10 && M2_now == 0b11) || (M2_rec == 0b11 && M2_now == 0b01) || (M2_rec == 0b01 && M2_now == 0b00) || (M2_rec == 0b00 && M2_now == 0b10))
    M2_current--;
  else if (M2_rec != M2_now)
    M2_error++;

  M1_rec = M1_now;
  M2_rec = M2_now;

  motor();
}

long HexToLong(String s)
{
  char arr[13] = {0};
  s.toCharArray(arr, sizeof(arr));
  volatile long result = 0;
  for (uint8_t i = 0; i < 12 && arr[i] != 0; i++) {
    if (arr[i] >= '0' && arr[i] <= '9') {
      result <<= 4;
      result |= (arr[i] - '0');
    }
    else if (arr[i] >= 'A' && arr[i] <= 'F') {
      result <<= 4;
      result |= (arr[i] - 'A' + 10);
    }
  }
  return result;
}

float getBattery()
{
  int temp = 0;
  for(int i=0;i<8;i++)
    temp += analogRead(VBAT);
  return (float)temp * 0.0000765735320709761f + 0.04f;
}

void setup()
{
  Serial.begin(115200);

  pinMode(LED, OUTPUT);
  digitalWrite(LED, HIGH);
  
  ledcAttach(M1A, 50000, 8);
  ledcAttach(M1B, 50000, 8);
  ledcAttach(M2A, 50000, 8);
  ledcAttach(M2B, 50000, 8);
  ledcAttach(M3A, 50000, 8);
  ledcAttach(M3B, 50000, 8);
  ledcWrite(M1A, 0);
  ledcWrite(M1B, 0);
  ledcWrite(M2A, 0);
  ledcWrite(M2B, 0);
  ledcWrite(M3A, 0);
  ledcWrite(M3B, 0);

  pinMode(VBAT, INPUT);
  analogSetAttenuation(ADC_0db);
  pinMode(M1EA, INPUT);
  pinMode(M1EB, INPUT);
  pinMode(M2EA, INPUT);
  pinMode(M2EB, INPUT);
  attachInterrupt(M1EA, isr, CHANGE);
  attachInterrupt(M1EB, isr, CHANGE);
  attachInterrupt(M2EA, isr, CHANGE);
  attachInterrupt(M2EB, isr, CHANGE);

  M1_rec = (digitalRead(M1EA) << 1) | digitalRead(M1EB);
  M2_rec = (digitalRead(M2EA) << 1) | digitalRead(M2EB);
  delay(500);
  digitalWrite(LED, LOW);

  // Connect to Wi-Fi network with SSID and password
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
    digitalWrite(LED, !digitalRead(LED));
  }
  // Print local IP address and start web server
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.print("MAC address: ");
  Serial.println(WiFi.macAddress());
  server.begin();

  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
        type = "sketch";
      else // U_SPIFFS
        type = "filesystem";

      // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
      Serial.println("Start updating " + type);
    })
    .onEnd([]() {
      Serial.println("\nEnd");
    })
    .onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
      digitalWrite(LED, !digitalRead(LED));
    })
    .onError([](ota_error_t error) {
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
    });

  ArduinoOTA.begin();
  digitalWrite(LED, LOW);
}

void loop()
{
  ArduinoOTA.handle();
  WiFiClient client = server.available(); // Listen for incoming clients

  if (client)
  {                                 // If a new client connects,
    Serial.println("New Request."); // print a message out in the serial port
    String currentLine = "";        // make a String to hold incoming data from the client
    while (client.connected())
    { // loop while the client's connected
      if (client.available())
      {                         // if there's bytes to read from the client,
        char c = client.read(); // read a byte, then
        Serial.write(c);        // print it out the serial monitor
        header += c;
        if (c == '\n')
        { // if the byte is a newline character
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0)
          {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:application/json");
            client.println("Connection: close");
            client.println();

            // GET /?status HTTP/1.1
            if (header.indexOf("status") >= 0)
            {
              Serial.println("status requested");
              // Get the status of the system
              // Including IP address, MAC address, current position (M1, M2), target position (M1, M2), current power (M1, M2, M3), error (M1, M2), battery, pause
              client.println("{\"status\":\"ok\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            else if (header.indexOf("set") >= 0)
            {
              Serial.println("set requested");
              // Set the target and power of motors
              // Format: /set=[M1 position, HEX8][M1 power, HEX2][M2 position, HEX8][M2 power, HEX2][M3 direction, bit][M3 power, HEX2]
              // Totally 22 characters in the parameter
              int pos = header.indexOf('=');
              String M1_pos = header.substring(pos + 1, pos + 9);
              String M1_pow = header.substring(pos + 9, pos + 11);
              String M2_pos = header.substring(pos + 11, pos + 19);
              String M2_pow = header.substring(pos + 19, pos + 21);
              String M3_dir = header.substring(pos + 21, pos + 22);
              String M3_pow = header.substring(pos + 22, pos + 24);
              M1_target = (int32_t)HexToLong(M1_pos);
              M1_power = (uint8_t)HexToLong(M1_pow);
              M2_target = (int32_t)HexToLong(M2_pos);
              M2_power = (uint8_t)HexToLong(M2_pow);
              M3_direction = M3_dir=="1" ? true : false;
              M3_power = (uint8_t)HexToLong(M3_pow);
              client.println("{\"status\":\"set ok\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            else if (header.indexOf("calibrate") >= 0)
            {
              Serial.println("calibrate requested");
              // Set target and current position to 0
              // Format: /calibrate=[M1, bit][M2, bit]
              // Totally 2 characters in the parameter
              int pos = header.indexOf('=');
              if (header.substring(pos + 1, pos + 2)[0] == '1')
              {
                M1_target = M1_current = 0;
              }
              if (header.substring(pos + 2, pos + 3)[0] == '1')
              {
                M2_target = M2_current = 0;
              }
              client.println("{\"status\":\"calibrate ok\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            else if (header.indexOf("reach") >= 0)
            {
              Serial.println("reach requested");
              // Set current position to target position
              // Format: /reach=[M1, bit][M2, bit]
              // Totally 2 characters in the parameter
              int pos = header.indexOf('=');
              if (header.substring(pos + 1, pos + 2)[0] == '1')
              {
                M1_current = M1_target;
              }
              if (header.substring(pos + 2, pos + 3)[0] == '1')
              {
                M2_current = M2_target;
              }
              client.println("{\"status\":\"reach ok\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            else if (header.indexOf("pause") >= 0)
            {
              Serial.println("pause requested");
              // Set current position to target position
              // Format: /pause=[pause/resume, bit]
              // Totally 2 characters in the parameter
              int pos = header.indexOf('=');
              if (header.substring(pos + 1, pos + 2)[0] == '0')
              {
                pause_bot = false;
              }
              else
              {
                pause_bot = true;
              }
              client.println("{\"status\":\"" + (pause_bot ? String("pause") : String("resume")) + " ok\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            else
            {
              Serial.println("error requested");
              client.println("{\"status\":\"error\", \"ip\":\"" + WiFi.localIP().toString() + "\", \"mac\":\"" + String(WiFi.macAddress()) + "\", \"m1_current\":" + M1_current + ", \"m1_target\":" + M1_target + ", \"m2_current\":" + M2_current + ", \"m2_target\":" + M2_target + ", \"m1_power\": " + M1_power + ", \"m2_power\": " + M2_power + ", \"m3_power\": " + M3_power + ", \"m1_error\": " + M1_error + ", \"m2_error\": " + M2_error + ", \"battery\": " + getBattery() + ", \"pause\":" + (pause_bot ? String("true") : String("false")) + "}");
            }
            // The HTTP response ends with another blank line
            client.println();
            // Break out of the while loop
            break;
          }
          else
          { // if you got a newline, then clear currentLine
            currentLine = "";
          }
        }
        else if (c != '\r')
        {                   // if you got anything else but a carriage return character,
          currentLine += c; // add it to the end of the currentLine
        }
      }
    }
    // Clear the header variable
    header = "";
    // Close the connection
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
    motor();
  }
}


