# **SoftRafts: Floating and Adaptive Soft Modular Robots**

## 🚀 Overview

**SoftRafts** is a modular soft robotic system that integrates rigid 3D-printed components, soft foam, a cable-driven actuation mechanism, and a propeller for aquatic mobility. Using permanent magnets for fast inter-module connections, each unit can **bend**, **steer**, **connect**, and operate collectively in a swarm. It serves multiple functions, such as:

* Acting as a **gripper** to retrieve debris from water
* Assembling into a **floating raft** for drone landing
* Forming a **snake-like chain** that transitions between land and water
* Working collaboratively to **transport payloads**

This platform demonstrates how soft deformation and modularity enable adaptive, multifunctional robotics for real-world aquatic environments.

---

## 📁 Repository Structure

```
SoftRafts/
│
├── CAD/                    # STL models for physical modules
│   └── softraft.png        # Render of full assembled raft
│
├── firmware/               # Microcontroller firmware for ESP32
│   └── firmware_softrafts.ino
│
├── software/               # Control and behavior logic in Jupyter
│   ├── SoftRafts-control.ipynb
│   └── snake--curve.ipynb
│
├── LICENSE
└── README.md
```

---

## 🧱 CAD Models

The `CAD/` folder contains 3D-printable STL models for all robot parts:

* `Whole_SoftRaft.stl` — full raft assembly (visual/reference)
* `Board.stl`, `Middle.stl`, `Tail.stl`, `Head.stl` — structural modules
* `Motor.stl`, `Motor Cover.stl` — motor housing components
* `Winch.stl` — for cable-based actuation
* `Cover.stl` — protective cover for electronics
* `softraft.png` — visualization of complete system


---

## 🔧 Firmware

Located in the `firmware/` folder, `firmware_softrafts.ino` is the ESP32 control code supporting:

* Wi-Fi web server interface for motor control (port 80)
* OTA (Over-the-Air) updates via ArduinoOTA
* Encoder-based position feedback and calibration
* REST-style HTTP commands for live control (`/set`, `/status`, `/pause`, etc.)

> Flash using the Arduino IDE with ESP32 board selected.

---

## 🧠 Software

Jupyter notebooks in `software/` allow real-time control and behavior programming:

* `SoftRafts-control.ipynb`: Interface to send motor commands and visualize responses
* `snake--curve.ipynb`: Curve/path behavior for snake-like collective motion

> Requires Python 3 with `requests`, `matplotlib`, and `notebook`.

---

## 📬 Help Desk

We are open to collaboration and questions!
📧 Luyang Zhao: [luyang.zhao.gr@dartmouth.edu](mailto:luyang.zhao.gr@dartmouth.edu)
📧 Yitao Jiang: [yitao.jiang.gr@dartmouth.edu](mailto:yitao.jiang.gr@dartmouth.edu)

---

## 📄 License

This project is licensed under the **MIT License**.

