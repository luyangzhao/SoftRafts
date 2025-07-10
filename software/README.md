
# 🧠 SoftRafts Software

This folder contains Python-based control and simulation notebooks for **SoftRafts**, supporting both real-time robot control and geometric behavior visualization.

---

## 📁 Files

### `SoftRafts-control.ipynb`

A **Jupyter notebook interface** to control the SoftRaft robot wirelessly via Wi-Fi.

🔧 **Features**:

* Sends HTTP commands (e.g., `/set`, `/status`, `/pause`) to the onboard ESP32
* Adjusts motor positions, power, and direction
* Displays returned status (position, power, battery, etc.)
* Supports interactive testing of firmware APIs

📦 **Requirements**:

* `requests` (for HTTP)
* `IPython.display` (for dynamic visualization)
* Python 3.7+

---

### `snake--curve.ipynb`

A notebook for **visualizing the geometry and curvature** of a multi-module snake-like raft configuration.

📐 **Highlights**:

* Calculates bend angles (`θ`) and link lengths (`s1`, `s2`) using trigonometry
* Draws intermediate bend points (`C`, `D`) between modules
* Propagates curvature along chained modules
* Estimates directionality by extending lines between final and initial segments

🧪 Use this to explore **how different actuator lengths affect the overall shape** and turning radius of SoftRafts in modular configurations.

📦 **Requirements**:

* `numpy`
* `matplotlib`

---

## 🧰 Setup

Create a virtual environment and install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate
pip install numpy matplotlib requests notebook
```

Then launch:

```bash
jupyter notebook
```

---

## 🧭 Use Cases

* 🔬 Prototype control strategies before deploying to hardware
* 🎯 Visualize planning algorithms for swarm or locomotion behavior
* 🧪 Debug firmware response without compiling Arduino code

---

## 📜 License

This software is released under the [MIT License](../LICENSE).

