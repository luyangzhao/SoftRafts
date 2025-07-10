# 📡 SoftRafts Firmware

This folder contains the Arduino-based firmware (`firmware_softrafts.ino`) for the **ESP32** microcontroller onboard each SoftRaft module. It enables real-time wireless control of motors, position feedback via encoders, and OTA (Over-the-Air) firmware updates.

---

## 🔌 Features

* ✅ Controls **3 motors** (2 linear actuators, 1 propulsion)
* ✅ Reads **quadrature encoders** for M1 and M2
* ✅ Supports **position control**, **power modulation**, and **direction switching**
* ✅ Hosts a **web server** on port `80` for HTTP-based control
* ✅ Supports **OTA updates** using `ArduinoOTA`
* ✅ Reports **battery voltage**, motor errors, and pause state

---

## 📁 File

* `firmware_softrafts.ino`: Main control firmware for SoftRaft hardware (ESP32)

---

## 🌐 Command Interface (via HTTP GET)

| Command      | URL Format            | Description                                                      |
| ------------ | --------------------- | ---------------------------------------------------------------- |
| Status       | `/status`             | Returns system status (motor position, power, battery, errors)   |
| Set Motors   | `/set=XXXXXXXXXXXXXX` | Set targets/powers for M1, M2, M3. Format: 8+2+8+2+1+2 hex chars |
| Calibrate    | `/calibrate=XY`       | Reset M1 and/or M2 encoder to zero                               |
| Reach Target | `/reach=XY`           | Snap current position to target (for M1 and/or M2)               |
| Pause/Resume | `/pause=X`            | Pause (`1`) or resume (`0`) all motors                           |

Example:

```
/set=000000640A000000C80A11
```

sets:

* M1 target = 100 (0x00000064), power = 10
* M2 target = 200 (0x000000C8), power = 10
* M3 direction = `1` (forward), power = 17

---

## 📶 Wi-Fi Setup

The ESP32 connects to:

* **SSID**: `BotTest`
* **Password**: `123456789`

You can modify these at the top of `firmware_softrafts.ino`.

Once connected, the ESP32 prints its IP address and MAC address over serial.

---

## ⚙️ Flashing Instructions

1. Open `firmware_softrafts.ino` in the Arduino IDE
2. Select **ESP32 Dev Module** as the board
3. Install required libraries:

   * `WiFi.h` (default with ESP32 core)
   * `ArduinoOTA.h`
4. Connect the ESP32 via USB and upload
5. After upload, monitor via serial at 115200 baud to confirm Wi-Fi and OTA readiness

---

## 🔄 OTA Updates

Once connected to Wi-Fi, you can push firmware updates wirelessly using ArduinoOTA. The device will blink its onboard LED during OTA transfer.

---

## 📞 Troubleshooting

* Ensure your router allows devices to connect over 2.4GHz Wi-Fi.
* Use Serial Monitor to debug IP address and errors.
* Confirm the motor driver pins are correctly wired as per your PCB design.

---

## 📜 License

This firmware is released under the [MIT License](../LICENSE).
