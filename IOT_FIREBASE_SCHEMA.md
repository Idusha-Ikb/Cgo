# SecureTrack SL - IoT Hardware to Cloud Firestore Integration Specification

This document defines the exact Cloud Firestore data schema and REST payload format for the IoT hardware team (ESP32 / GPS / e-Seal sensors).

---

## 🛰️ 1. Cloud Firestore Architecture

### Collection: `containers`
Each physical cargo container has a document in the `containers` collection named after its Container ID (e.g., `CONT-001`).

#### Document Path: `containers/CONT-001`
```json
{
  "id": "CONT-001",
  "owner": "Cargo Overseas Freight Pvt Ltd",
  "route": "Colombo Port - Orugodawatta, Avissawella RD",
  "currentLocation": "Orugodawatta, Colombo, Sri Lanka",
  "destination": "Orugodawatta Logistics Terminal",
  "estimatedArrival": "12 Sep 2026, 10.00 AM",
  "driverName": "S.A. Gamage",
  "sealStatus": "Intact",
  "batteryLevel": 75,
  "status": "On Track",
  "latitude": 6.9455,
  "longitude": 79.8510,
  "speed": 42,
  "last_updated": "SERVER_TIMESTAMP"
}
```

---

## 🚨 2. Real-Time Alert Triggers

### A. e-Seal Tamper Alarm (Critical Security Alert)
When the magnetic/RFID reed switch on the container door is broken during transit:
1. Update `containers/CONT-001`:
   - Set `"sealStatus"` to `"Tampered"`
2. Add a new document to the `alerts` collection:
```json
{
  "title": "CRITICAL: e-Seal Tampered on CONT-001",
  "containerId": "CONT-001",
  "category": "Security",
  "timestamp": "12 Sep 2026, 08:15 AM",
  "created_at": "SERVER_TIMESTAMP"
}
```
* **Mobile App Reaction:** Immediately triggers a red siren security popup modal on the Owner's phone with live GPS coordinates and an emergency action button!

### B. Low Battery Alarm
When IoT battery level drops below 20%:
- Update `batteryLevel` in `containers/CONT-001`.
- Add an alert with `"category": "Battery"`.

---

## ⚡ 3. ESP32 Arduino / C++ Code Snippet (HTTP/Firebase REST)

The ESP32 module can send HTTP POST/PATCH requests to Firebase Realtime Database or Firestore REST API:

```cpp
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* firestore_url = "https://firestore.googleapis.com/v1/projects/track-sl/databases/(default)/documents/containers/CONT-001?updateMask.fieldPaths=latitude&updateMask.fieldPaths=longitude&updateMask.fieldPaths=speed&updateMask.fieldPaths=sealStatus&updateMask.fieldPaths=batteryLevel";

void sendTelemetry(double lat, double lng, int speed, int battery, bool isSealIntact) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(firestore_url);
    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<512> doc;
    JsonObject fields = doc.createNestedObject("fields");

    fields["latitude"]["doubleValue"] = lat;
    fields["longitude"]["doubleValue"] = lng;
    fields["speed"]["integerValue"] = speed;
    fields["batteryLevel"]["integerValue"] = battery;
    fields["sealStatus"]["stringValue"] = isSealIntact ? "Intact" : "Tampered";

    String requestBody;
    serializeJson(doc, requestBody);

    int httpResponseCode = http.PATCH(requestBody);
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}
```

---

## ✅ Integration Checklist for IoT Teammate
- [x] Project ID: `track-sl`
- [x] Package: `com.example.securetrack_sl`
- [x] Containers Collection: `containers`
- [x] Real-time fields: `latitude`, `longitude`, `speed`, `batteryLevel`, `sealStatus`
