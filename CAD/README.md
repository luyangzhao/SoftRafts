# **SoftRafts CAD Models and 3D Printing Guide**

## 🏗️ Overview

This folder contains **3D models** for all key components of **SoftRafts**, supporting modular design and assembly for soft robotic rafts.

### **🔹 Full SoftRaft Assembly**

![SoftRaft Full Assembly](softraft.png)

---

## 📂 Files in this Folder

* `Whole_SoftRaft.stl` → Assembled complete raft for reference or full printing.
* `Board.stl` → Main base board structure.
* `Tail.stl` → Rear-end module for propulsion or structure.
* `Middle.stl` → Central body segment for structural extension.
* `Motor Cover.stl` → Protective shell for the motor enclosure.
* `Motor.stl` → Motor housing unit.
* `Cover.stl` → General-purpose cover or enclosure.
* `Winch.stl` → Mechanical winch for tensioning or cable deployment.
* `Head.stl` → Frontal module, possibly for sensor mounting.
* `softraft.png` → Rendered image of the complete SoftRaft assembly.

---

## 🔩 **Component Descriptions**

### **1️⃣ Whole Assembly (`Whole_SoftRaft.stl`)**

* Fully assembled reference model combining all modules.
* Use for **scale check, visualization**, or single-print prototypes.

**🔧 Printing Tips:**

* Print at **larger scale FDM** for exhibition or full-size prototype.
* May require **supports** and **larger nozzle diameter** (0.6–1.0 mm) depending on printer capability.

---

### **2️⃣ Modular Parts**

#### `Board.stl`, `Tail.stl`, `Middle.stl`, `Head.stl`

* These represent the **core structural elements** of the raft.
* Can be printed and assembled modularly to form the complete raft body.
* Each part is designed for **easy alignment** and **snap or bolt fit**.

#### `Motor.stl` & `Motor Cover.stl`

* Designed to house compact **brushless or geared motors** for thrust or steering.
* Include optional ventilation slots and access panels.

#### `Winch.stl`

* Winch mechanism base to integrate cable or string-based actuation or payload release.
* May interface with standard servo or stepper motor via top hole slot.

#### `Cover.stl`

* A universal part used to seal components such as battery chambers or electronics.

**🔧 General Printing Guidelines for All Parts:**

* **Material**: PLA or PETG for general use; ABS or ASA for waterproof versions
* **Layer Height**: 0.15–0.2 mm
* **Infill**: 25–50% depending on load-bearing needs
* **Supports**: Enabled for overhangs (e.g., motor housing)

---

## 🛠️ **Assembly Instructions**

1️⃣ Print the required modules individually or print `Whole_SoftRaft.stl` directly for a static prototype.
2️⃣ Insert **motors** into `Motor.stl` and seal using `Motor Cover.stl`.
3️⃣ Connect structural parts: `Board`, `Tail`, `Middle`, and `Head` using snap joints or screws.
4️⃣ Mount `Winch` mechanism if required.
5️⃣ Use `Cover.stl` to close off sensitive modules.
6️⃣ Confirm waterproofing and buoyancy if deploying in water.

---

## 🔧 **Modifying the CAD Models**

* For Fusion 360 or SolidWorks editing, convert STL to mesh body or re-model using `Whole_SoftRaft.stl` as reference.
* Recommended to re-export assemblies from native CAD format for major modifications.

