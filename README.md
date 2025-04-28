EXP 1: 
#include <DHT.h> // Including library for dht
#define DHTPIN 4 //pin where the dht11 is connected
DHT dht(DHTPIN, DHT11);
void setup()
{
Serial.begin(9600); // Setting Baud rate to 9600
} 
void loop()
{ 
float h = dht.readHumidity(); // read humidity 
float t = dht.readTemperature(); //read temp
Serial.println("Prakhar 63");
Serial.print(" Current humidity = ");
Serial.print(h);
Serial.print("% ");
Serial.print("temperature = ");
Serial.print(t);
Serial.println("C ");
delay(800);
}

EXP 2 THINGSPEAK:
#include <DHTesp.h>              // Including library for DHT
#include <ESP8266WiFi.h>         // Including library for WiFi

String apiKey = "TR25FF8MCRN3TA2W";        // Your Write API key from ThingSpeak
const char *ssid = "Varun's M31s";         // Your WiFi SSID
const char *pass = "123456789";            // Your WiFi password
const char *server = "api.thingspeak.com"; // ThingSpeak server

#define DHTPIN 16                 // Pin where DHT11 is connected
DHTesp dht;                       // Create DHT object
WiFiClient client;               // Create WiFi client object

void setup() {
  Serial.begin(9600);            // Start Serial Monitor at 9600 baud rate
  delay(10);                     // Small delay

  dht.setup(DHTPIN, DHTesp::DHT11); // Initialize DHT sensor on GPIO 16

  Serial.println("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, pass);       // Connect to WiFi

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
}

void loop() {
  float h = dht.getHumidity();      // Read humidity
  float t = dht.getTemperature();   // Read temperature

  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  if (client.connect(server, 80)) {
    String postStr = apiKey;
    postStr += "&field1=";
    postStr += String(t);
    postStr += "&field2=";
    postStr += String(h);
    postStr += "\r\n\r\n";

    client.print("POST /update HTTP/1.1\n");
    client.print("Host: api.thingspeak.com\n");
    client.print("Connection: close\n");
    client.print("X-THINGSPEAKAPIKEY: " + apiKey + "\n");
    client.print("Content-Type: application/x-www-form-urlencoded\n");
    client.print("Content-Length: ");
    client.print(postStr.length());
    client.print("\n\n");
    client.print(postStr);

    Serial.print("Temperature: ");
    Serial.print(t);
    Serial.println(" Celsius");

    Serial.print("Humidity: ");
    Serial.print(h);
    Serial.println("%. Sent to ThingSpeak.");
  }

  client.stop();
  Serial.println("Waiting...");
  delay(30000); // Wait 30 seconds before sending next data (minimum 15 sec required)
}

OR

#include <DHT.h>
#include <ESP8266WiFi.h>

// Wi-Fi credentials
const char* ssid = "Varun's M31s";
const char* pass = "123456789";

// ThingSpeak API key
String apiKey = "TR25FF8MCRN3TA2W"; 
const char* server = "api.thingspeak.com";

// DHT sensor setup
#define DHTPIN 16        // GPIO pin where DHT11 is connected
#define DHTTYPE DHT11    // DHT sensor type

DHT dht(DHTPIN, DHTTYPE); // Create DHT object
WiFiClient client;        // Create WiFi client for HTTP

void setup() {
  Serial.begin(9600);           // Begin Serial
  dht.begin();                  // Initialize DHT sensor
  delay(10);                    // Small delay

  Serial.println("Connecting to WiFi...");
  WiFi.begin(ssid, pass);       // Connect to WiFi

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.println("IP Address: " + WiFi.localIP().toString());
}

void loop() {
  float h = dht.readHumidity();       // Read humidity
  float t = dht.readTemperature();    // Read temperature (in °C)

  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  if (client.connect(server, 80)) {
    String postStr = apiKey;
    postStr += "&field1=";
    postStr += String(t);
    postStr += "&field2=";
    postStr += String(h);
    postStr += "\r\n\r\n";

    client.print("POST /update HTTP/1.1\n");
    client.print("Host: api.thingspeak.com\n");
    client.print("Connection: close\n");
    client.print("X-THINGSPEAKAPIKEY: " + apiKey + "\n");
    client.print("Content-Type: application/x-www-form-urlencoded\n");
    client.print("Content-Length: ");
    client.print(postStr.length());
    client.print("\n\n");
    client.print(postStr);

    Serial.print("Temperature: ");
    Serial.print(t);
    Serial.println(" °C");

    Serial.print("Humidity: ");
    Serial.print(h);
    Serial.println(" % - Sent to ThingSpeak!");
  }

  client.stop();
  Serial.println("Waiting 30 seconds before next reading...");
  delay(30000); // Minimum 15 seconds delay for ThingSpeak
}

EXP 3 BLYNK:
#define BLYNK_TEMPLATE_ID "TMPL3jWyYfmsw"
#define BLYNK_TEMPLATE_NAME "Rohan"
#define BLYNK_AUTH_TOKEN "OUvogf34O6jcm4fymlKxSGAbMqscuDr_" 

#include <DHT.h>
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

#define DHTTYPE DHT11           // We're using the DHT11 sensor
#define DHT_PIN 4               // DHT11 is connected to GPIO 4
#define BLYNK_PRINT Serial      // Enable serial prints for Blynk

// WiFi credentials (declared using const char* just like ThingSpeak)
const char* ssid = "Redmi 12 5G";         
const char* pass = "rohan1022";           
const char* auth = "OUvogf34O6jcm4fymlKxSGAbMqscuDr_";  // Blynk authentication token

// Create a DHT object using the DHT class
DHT dht(DHT_PIN, DHTTYPE);

// Declare temperature and humidity variables
float t;  
float h;  

void setup() {
  Serial.begin(9600);  // Start serial communication

  // Connect to WiFi
  Serial.print("Connecting to WiFi");
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // Start Blynk connection
  Blynk.begin(auth, ssid, pass);

  // Start the DHT sensor
  dht.begin();
  Serial.println("DHT sensor initialized");
}

void sendUptime() {
  h = dht.readHumidity();        // Read humidity
  t = dht.readTemperature();     // Read temperature

  if (isnan(h) || isnan(t)) {    // Check if reading failed
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Print values in Serial Monitor
  Serial.println("\nHumidity and Temperature:");
  Serial.print("Humidity = ");
  Serial.print(h);
  Serial.print("%, Temperature = ");
  Serial.print(t);
  Serial.println("°C");

  // Send values to Blynk virtual pins
  Blynk.virtualWrite(V0, t);  // V0 = Temperature
  Blynk.virtualWrite(V1, h);  // V1 = Humidity
  Blynk.virtualWrite(V2, "R. No 05 , 03 , 23 , 19");  // Optional info
}

void loop() {
  Blynk.run();        // Keep Blynk connection active
  sendUptime();       // Send data to app
  delay(2000);        // Wait 2 seconds before next reading
}

EXP 4 PUSHBULLET:
#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <DHT.h>

// DHT sensor setup
#define DHTPIN 4
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

const char* ssid = "Redmi 12 5G";  // Wi-Fi name
const char* password = "rohan1022";  // Wi-Fi password

String pushbulletAPIKey = "o.SbbTDL41fmusYkXn15uKhug88mZ1GWRk"; 
String pushbulletURL = "https://api.pushbullet.com/v2/pushes";

WiFiClientSecure client;

void setup() {
  Serial.begin(9600);
  Serial.println("Experiment by: Rohan , Suhas , Hirdhay , Aditya");
  Serial.println("Experiment by: Roll no. 3, 5 , 23 , 19"); // Display name in Serial Monitor
  dht.begin();
  
  Serial.println("Connecting to Wi-Fi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to Wi-Fi!");

  client.setInsecure();
}

void loop() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Display the readings along with your name in Serial Monitor
  Serial.println("-------------------------------------------------");
  Serial.println("IoT Notification System by Himanshi Bajaj");
  Serial.print("Temperature: "); Serial.print(temperature); Serial.println("°C");
  Serial.print("Humidity: "); Serial.print(humidity); Serial.println("%");
  Serial.println("Sending Pushbullet Notification...");
  Serial.println("-------------------------------------------------");

  String message = "{\"type\": \"note\", \"title\": \"Temp Alert - Himanshi Bajaj\", ";
  message += "\"body\": \"Temperature: " + String(temperature) + "°C, Humidity: " + String(humidity) + "%\"}";

  sendPushbulletNotification(message);
  delay(5000);
}

void sendPushbulletNotification(String message) {
  if (client.connect("api.pushbullet.com", 443)) {
    client.println("POST " + pushbulletURL + " HTTP/1.1");
    client.println("Host: api.pushbullet.com");
    client.println("Authorization: Bearer " + pushbulletAPIKey);
    client.println("Content-Type: application/json");
    client.print("Content-Length: ");
    client.println(message.length());
    client.println();
    client.println(message);
    
    while (client.available() == 0);
    while (client.available()) {
      Serial.write(client.read());
    }
  } else {
    Serial.println("Connection failed");
  }
}

EXP 5 BLYNK:
#define BLYNK_PRINT Serial
#define BLYNK_AUTH_TOKEN "L-FsMX7xKg2tJLAy6-euOcl-LN7h4qnn"
#define BLYNK_TEMPLATE_ID "TMPL3eAKMQiHT"
#define BLYNK_TEMPLATE_NAME "Quickstart Template"

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// Wi-Fi credentials
char auth[] = "L-FsMX7xKg2tJLAy6-euOcl-LN7h4qnn";
char ssid[] = "Suhas's Galaxy M32";
char pass[] = "12345678";

// Use built-in LED (GPIO2 / D4 on NodeMCU)
#define LED_PIN LED_BUILTIN

BLYNK_WRITE(V1) {
  int state = param.asInt();
  digitalWrite(LED_PIN, state ? LOW : HIGH); // Active LOW for built-in LED
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, HIGH); // Start with LED OFF
  Blynk.begin(auth, ssid, pass);
}

void loop() {
  Blynk.run();
}

EXP 6 WEBSERVER HTTP
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <Hash.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>

// Replace with your network credentials
const char* ssid = "AYUSH's A35";
const char* password = "ayush2005";

// DHT Sensor settings
#define DHTPIN 4         // Digital pin connected to the DHT sensor
#define DHTTYPE DHT11    // DHT 11 Sensor type

DHT dht(DHTPIN, DHTTYPE);

// Variables to store temperature & humidity readings
float t = 0.0;
float h = 0.0;

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);

// Timing for sensor reading updates
unsigned long previousMillis = 0;
const long interval = 10000;  // Update readings every 10 seconds

// HTML Page stored in program memory (PROGMEM)
const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr"
crossorigin="anonymous">
<style>
html { font-family: Arial; display: inline-block; margin: 0px auto; text-align: center; }
h2 { font-size: 3.0rem; }
p { font-size: 3.0rem; }
.units { font-size: 1.2rem; }
.dht-labels { font-size: 1.5rem; vertical-align:middle; padding-bottom: 15px; }
</style>
</head>

<body>
<h2>Perform By<br>Roll No.: 43,36</h2>
<h2>ESP8266 DHT Server</h2>

<p>
<i class="fas fa-thermometer-half" style="color:#059e8a;"></i>
<span class="dht-labels">Temperature</span>
<span id="temperature">%TEMPERATURE%</span>
<sup class="units">&deg;C</sup>
</p>

<p>
<i class="fas fa-tint" style="color:#00add6;"></i>
<span class="dht-labels">Humidity</span>
<span id="humidity">%HUMIDITY%</span>
<sup class="units">%</sup>
</p>

<script>
// Update Temperature every 10 seconds
setInterval(function () {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("temperature").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "/temperature", true);
  xhttp.send();
}, 10000);

// Update Humidity every 10 seconds
setInterval(function () {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("humidity").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "/humidity", true);
  xhttp.send();
}, 10000);
</script>

</body>
</html>)rawliteral";

// Function to replace placeholders in HTML page with sensor values
String processor(const String& var) {
  if (var == "TEMPERATURE") {
    return String(t);
  } 
  else if (var == "HUMIDITY") {
    return String(h);
  }
  return String();
}

void setup() {
  // Start Serial Monitor
  Serial.begin(9600);
  
  // Start DHT Sensor
  dht.begin();

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println(".");
  }

  // Print ESP8266 Local IP Address
  Serial.println(WiFi.localIP());

  // Define Web Server routes
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", index_html, processor);
  });

  server.on("/temperature", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/plain", String(t).c_str());
  });

  server.on("/humidity", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/plain", String(h).c_str());
  });

  // Start Server
  server.begin();
}

void loop() {
  unsigned long currentMillis = millis();
  
  // Update readings every 'interval' milliseconds
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    // Read Temperature
    float newT = dht.readTemperature();
    if (isnan(newT)) {
      Serial.println("Failed to read from DHT sensor!");
    } else {
      t = newT;
      Serial.println("Temperature: " + String(t) + " °C");
    }

    // Read Humidity
    float newH = dht.readHumidity();
    if (isnan(newH)) {
      Serial.println("Failed to read from DHT sensor!");
    } else {
      h = newH;
      Serial.println("Humidity: " + String(h) + " %");
    }
  }
}

EXP 7 RELAY:
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>


// Replace with your network credentials
const char* ssid = "AYUSH's A35";
const char* password = "ayush2005";


// Inbuilt LED pin (on NodeMCU, it is usually GPIO2)
#define LED_PIN 2
#define IN1_PIN 5   // D1 (GPIO 5)
#define IN2_PIN 16  // D0 (GPIO 16)
#define IN3_PIN 0   // D3 (GPIO 0)
#define IN4_PIN 4   // D2 (GPIO 4)


// Create an AsyncWebServer object on port 80
AsyncWebServer server(80);


const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html { font-family: Arial; display: inline-block; margin: 0px auto; text-align: center; }
    h2 { font-size: 3.0rem; }
    p { font-size: 3.0rem; }
    .button {
      background-color: #4CAF50;
      border: none;
      color: white;
      padding: 16px 20px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 16px;
      margin: 4px 2px;
      cursor: pointer;
    }
    .button-off {
      background-color: #f44336; /* Red */
    }
  </style>
</head>
<body>
  <h2>NodeMCU Web Server</h2>
  <h2>26, 27, 28, 30, 44</h2>
  <p>
    <!-- Toggle buttons for controlling IN1 to IN4 -->
    <button id="in1Button" class="button" onclick="toggleIN('IN1')">Turn IN1 ON</button>
    <button id="in2Button" class="button" onclick="toggleIN('IN2')">Turn IN2 ON</button>
    <button id="in3Button" class="button" onclick="toggleIN('IN3')">Turn IN3 ON</button>
    <button id="in4Button" class="button" onclick="toggleIN('IN4')">Turn IN4 ON</button>
  </p>


  <script>
  // Function to toggle LED state
  function toggleLED() {
    var xhttp = new XMLHttpRequest();
    xhttp.open("GET", "/toggleLED", true);
    xhttp.send();
  }


  // Function to toggle IN1 to IN4 states
  function toggleIN(inName) {
    var xhttp = new XMLHttpRequest();
    xhttp.open("GET", "/" + inName + "toggle", true);
    xhttp.send();
  }


  // Function to update button text based on state
  function updateButton(buttonId, state) {
    var button = document.getElementById(buttonId);
    if (state) {
      button.innerHTML = "Turn " + buttonId + " OFF";
      button.classList.remove("button-off");
    } else {
      button.innerHTML = "Turn " + buttonId + " ON";  
      button.classList.add("button-off");
    }
  }


  // Function to refresh state from server
  setInterval(function() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        var states = this.responseText.split(",");
        updateButton("in1Button", states[0] == "1");
        updateButton("in2Button", states[1] == "1");
        updateButton("in3Button", states[2] == "1");
        updateButton("in4Button", states[3] == "1");
      }
    };
    xhttp.open("GET", "/getState", true);
    xhttp.send();
  }, 1000);
  </script>
</body>
</html>)rawliteral";


// Route to serve the main HTML page
void setup(){
  // Serial port for debugging purposes
  Serial.begin(9600);
 
  // Initialize the inbuilt LED and IN1 to IN4 pins as outputs
  pinMode(LED_PIN, OUTPUT);
  pinMode(IN1_PIN, OUTPUT);
  pinMode(IN2_PIN, OUTPUT);
  pinMode(IN3_PIN, OUTPUT);
  pinMode(IN4_PIN, OUTPUT);
 
  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }


  // Print the IP address of the NodeMCU once connected to Wi-Fi
  Serial.println("\nConnected to WiFi!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());


  // Serve the HTML page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html);
  });


  // Route to toggle the LED state
  server.on("/toggleLED", HTTP_GET, [](AsyncWebServerRequest *request){
    static bool ledState = false;
    ledState = !ledState;
    digitalWrite(LED_PIN, ledState ? LOW : HIGH); // Toggle the LED (LOW turns it ON, HIGH turns it OFF)
    request->send(200, "text/plain", "LED Toggled");
  });


  // Route to toggle IN1 state
  server.on("/IN1toggle", HTTP_GET, [](AsyncWebServerRequest *request){
    static bool in1State = false;
    in1State = !in1State;
    digitalWrite(IN1_PIN, in1State ? LOW : HIGH); // Toggle IN1
    request->send(200, "text/plain", "IN1 Toggled");
  });


  // Route to toggle IN2 state
  server.on("/IN2toggle", HTTP_GET, [](AsyncWebServerRequest *request){
    static bool in2State = false;
    in2State = !in2State;
    digitalWrite(IN2_PIN, in2State ? LOW : HIGH); // Toggle IN2
    request->send(200, "text/plain", "IN2 Toggled");
  });


  // Route to toggle IN3 state
  server.on("/IN3toggle", HTTP_GET, [](AsyncWebServerRequest *request){
    static bool in3State = false;
    in3State = !in3State;
    digitalWrite(IN3_PIN, in3State ? LOW : HIGH); // Toggle IN3
    request->send(200, "text/plain", "IN3 Toggled");
  });


  // Route to toggle IN4 state
  server.on("/IN4toggle", HTTP_GET, [](AsyncWebServerRequest *request){
    static bool in4State = false;
    in4State = !in4State;
    digitalWrite(IN4_PIN, in4State ? LOW : HIGH); // Toggle IN4
    request->send(200, "text/plain", "IN4 Toggled");
  });


  // Route to get the current state of all pins
  server.on("/getState", HTTP_GET, [](AsyncWebServerRequest *request){
    String state = String(digitalRead(LED_PIN)) + "," +
                   String(digitalRead(IN1_PIN)) + "," +
                   String(digitalRead(IN2_PIN)) + "," +
                   String(digitalRead(IN3_PIN)) + "," +
                   String(digitalRead(IN4_PIN));
    request->send(200, "text/plain", state);
  });


  // Start the server
  server.begin();
}


void loop(){
  // Nothing to do in the loop, everything is handled by the server
}

EXP 8 MQTT
SUBSCRIBER CODE:

#include <WiFi.h>            // For ESP32 use WiFi.h, for ESP8266 use ESP8266WiFi.h
#include <PubSubClient.h>

const char* ssid = "Your_WiFi_Name";  // 🔹 Replace with your WiFi SSID
const char* password = "Your_WiFi_Password";  // 🔹 Replace with your WiFi Password
const char* mqtt_server = "mqtt.eclipseprojects.io";  // 🔹 MQTT broker

WiFiClient espClient;
PubSubClient client(espClient);

// Callback function - Executes when a message is received
void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("\n Message received on topic: ");
  Serial.println(topic);
 
  Serial.print(" Message: ");
  String receivedMessage = "";
 
  for (int i = 0; i < length; i++) {
    receivedMessage += (char)payload[i];  // Convert payload to string
  }

  Serial.println(receivedMessage);

  // Display Roll Number along with the received message
  Serial.println(" Roll Number: 04/10-D10B");
}

void setup() {
  Serial.begin(115200);
 
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n WiFi Connected!");

  // Connect to MQTT broker
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);

  while (!client.connected()) {
    Serial.print("Connecting to MQTT...");
    if (client.connect("ESP32_Subscriber")) {
      Serial.println("Connected!");
      client.subscribe("pi/data");  // Subscribe to the topic
    } else {
      Serial.print("Failed, rc=");
      Serial.print(client.state());
      Serial.println(" Retrying...");
      delay(2000);
    }
  }
}

void loop() {
  if (!client.connected()) {
    setup();  // Reconnect if disconnected
  }
  client.loop();
}


PUBLISHER CODE:

#include <WiFi.h>            // For ESP32 use WiFi.h, for ESP8266 use ESP8266WiFi.h
#include <PubSubClient.h>    

const char* ssid = "";  // 🔹 Replace with your WiFi SSID
const char* password = "";  // 🔹 Replace with your WiFi Password
const char* mqtt_server = "mqtt.eclipseprojects.io";  // 🔹 MQTT broker

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
 
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi Connected!");

  // Connect to MQTT broker
  client.setServer(mqtt_server, 1883);

  while (!client.connected()) {
    Serial.print("Connecting to MQTT...");
    if (client.connect("ESP32_Client")) {
      Serial.println("Connected!");
    } else {
      Serial.print("Failed, rc=");
      Serial.print(client.state());
      Serial.println(" Retrying...");
      delay(2000);
    }
  }
}

void loop() {
  if (!client.connected()) {
    setup();  // Reconnect if disconnected
  }
  client.loop();

  // Publish a message every 2 seconds with Roll Number
  String message = "Hello from ESP32! Roll No: 04/10-D10B";
  client.publish("pi/data", message.c_str());
 
  Serial.println("Message Published: " + message);
  delay(2000);
}

