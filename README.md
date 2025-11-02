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
├── CAD/                     # STL models for 3D printing
│   └── softraft.png         # Render of full assembled raft
│
├── firmware/                # ESP32-S2 microcontroller firmware
│   └── firmware_softrafts.ino
│
├── software/                # Control, analysis, and visualization notebooks
│   ├── SoftRafts-control.ipynb
│   ├── snake--curve.ipynb
│   └── gaits_data_processing.ipynb
│
├── raw_gaits_data/          # Raw positional and orientational data (6 gaits)
│   ├── forward_data.json
│   ├── backward_data.json
│   ├── left_front_data.json
│   ├── right_front_data.json
│   ├── left_back_data.json
│   ├── right_back_data.json
│   └── README.md
│
├── figures/                 # Auto-generated plots (e.g., Figure 8)
│   └── plot_comparison.png
│
├── LICENSE
└── README.md
```

---

## 🧱 CAD Models

The `CAD/` folder contains 3D-printable STL models for all robot parts:

* `Whole_SoftRaft.stl` — complete raft assembly (for reference)  
* `Board.stl`, `Middle.stl`, `Tail.stl`, `Head.stl` — core structural modules  
* `Motor.stl`, `Motor Cover.stl` — motor housing components  
* `Winch.stl` — for cable-driven actuation  
* `Cover.stl` — protective enclosure for electronics  
* `softraft.png` — visual rendering of the assembled robot  

---

## 🔧 Firmware

Located in the `firmware/` folder, `firmware_softrafts.ino` is the control firmware for the **ESP32-S2** microcontroller.

**Features:**
* Wi-Fi web server interface for motor control (port 80)  
* OTA (Over-the-Air) firmware updates via ArduinoOTA  
* Encoder-based position feedback and calibration  
* REST-style HTTP commands for live control (`/set`, `/status`, `/pause`, etc.)

> Upload via the **Arduino IDE** with the ESP32 board selected.

---

## 🧠 Software

The `software/` folder contains all Python-based notebooks for **robot control, gait data analysis, and visualization**.

### Included Notebooks:
- **`SoftRafts-control.ipynb`** — Wi-Fi control interface for the SoftRaft robot  
- **`snake--curve.ipynb`** — Geometry and curvature visualization of chained modules  
- **`gaits_data_processing.ipynb`** — Reproducible gait data processing and analysis notebook for Figure 8

The analysis notebook:
* Loads raw data from `raw_gaits_data/`  
* Performs coordinate transformation to the local reference frame  
* Removes outliers and computes cluster centers  
* Generates the comparison figure automatically (`figures/plot_comparison.png`)

> Requires Python ≥ 3.7 with `numpy`, `matplotlib`, `requests`, `pandas`, and `notebook`.

---

## 📊 Raw Data

The `raw_gaits_data/` folder contains six JSON files corresponding to different gaits  
(forward, backward, left-front, right-front, left-back, right-back).  
Each file contains 35 recorded trials of positional and orientational data (in cm and degrees).

A detailed `README.md` in that folder explains:
* The meaning and units of each field  
* How to reproduce Figure 8 using the analysis notebook in `software/`

---

## ⚙️ Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/SMILE-Robotics-Lab/SoftRafts.git
   cd SoftRafts/software
   ```

2. Create and activate a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install numpy matplotlib pandas requests notebook
   ```

4. Launch Jupyter:
   ```bash
   jupyter notebook
   ```

---

## 📬 Contact

For questions, collaboration, or reproducibility assistance:

📧 **Luyang Zhao** — [luyangz@clemson.edu](mailto:luyangz@clemson.edu)  
📧 **Yitao Jiang** — [yitao.jiang.gr@dartmouth.edu](mailto:yitao.jiang.gr@dartmouth.edu)

---

## 📄 License

This project is licensed under the **MIT License**.
