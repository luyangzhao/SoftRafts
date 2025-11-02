# 🧠 SoftRafts Software

This folder contains Python-based control, analysis, and visualization notebooks for **SoftRafts**, supporting real-time robot control, geometric behavior visualization, and data processing for gait characterization.

---

## 📁 Files

### `SoftRafts-control.ipynb`

A **Jupyter notebook interface** for controlling the SoftRaft robot wirelessly via Wi-Fi.

🔧 **Features**:
* Sends HTTP commands (e.g., `/set`, `/status`, `/pause`) to the onboard ESP32  
* Adjusts motor positions, power, and direction  
* Displays returned status (position, power, battery, etc.)  
* Supports interactive testing of firmware APIs  

📦 **Requirements**:
* `requests`
* `IPython.display`
* Python ≥ 3.7

---

### `snake--curve.ipynb`

A notebook for **visualizing the geometry and curvature** of multi-module snake-like raft configurations.

📐 **Highlights**:
* Computes bend angles (`θ`) and link lengths (`s1`, `s2`) using trigonometry  
* Draws intermediate bend points (`C`, `D`) between modules  
* Propagates curvature along chained modules  
* Estimates directionality and turning radius  

📦 **Requirements**:
* `numpy`
* `matplotlib`

---

### `gaits_data_processing.ipynb`

A **standalone Jupyter notebook** that processes and analyzes the raw gait data used in the paper (Figure 8).  
It provides a fully reproducible pipeline from raw measurements to the final figure.

📊 **Functions**:
* Loads the six JSON files from [`../raw_gaits_data/`](../raw_gaits_data/)  
* Transforms data from distance/orientation changes into a standardized local reference frame  
* Removes outliers using the IQR method  
* Computes gait-specific cluster centers  
* Generates and saves the comparison figure (`../figures/plot_comparison.png`)  

📦 **Requirements**:
* `numpy`
* `matplotlib`
* `json`
* `pathlib`
* `pandas`

---

## 🧰 Setup

Create a virtual environment and install dependencies:

```bash
python3 -m venv venv
source venv/bin/activate
pip install numpy matplotlib requests pandas notebook
