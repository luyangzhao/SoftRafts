# Raw Gait Data for SoftRafts (Used in Figure 8)

This folder contains the **raw positional and orientational data** used to generate **Figure 8** in the paper:  
*“Comparison of x–y positions for different gaits and their corresponding cluster centers with positions and orientations.”*

---

## Folder Contents

| File | Description |
|------|--------------|
| `forward_data.json` | Raw trajectory data for the forward gait |
| `backward_data.json` | Raw trajectory data for the backward gait |
| `left_front_data.json` | Raw trajectory data for the left-front gait |
| `right_front_data.json` | Raw trajectory data for the right-front gait |
| `left_back_data.json` | Raw trajectory data for the left-back gait |
| `right_back_data.json` | Raw trajectory data for the right-back gait |

Each file contains **recorded trials** of that gait, each stored as one JSON object per line.

---

## Data Format

Every JSON line includes the following fields:

| Key | Description | Unit |
|-----|--------------|------|
| `robot_id` | Robot identifier (constant = 2) | — |
| `tag_id` | AprilTag marker ID used for tracking | — |
| `start_x`, `start_y`, `start_theta` | Start position and orientation in the world (AprilTag) frame | **cm**, degrees |
| `goal_x`, `goal_y`, `goal_theta` | Final position and orientation after one gait cycle | **cm**, degrees |

All positions are expressed in the **AprilTag world coordinate frame**,  
with the robot’s initial pose standardized to \((0, 0, 0)\) and the orientation parallel to the x-axis.

---

## Processing and Reproduction

The Jupyter notebook [`../software/gaits_data_processing.ipynb`](../software/gaits_data_processing.ipynb)  
loads these JSON files, removes outliers, computes cluster centers,  
and reproduces **Figure 8** (the comparison of \(x\)–\(y\) positions and orientations).

Example usage:

```python
import json
from pathlib import Path

DATA_DIR = Path("../raw_gaits_data")
with open(DATA_DIR / "forward_data.json") as f:
    data = [json.loads(line) for line in f]

print(f"Loaded {len(data)} trials.")
print(data[0])
