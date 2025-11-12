# 3D Computer Vision — Point Cloud Reconstruction & Surface Processing  
**Author:** Nikita Chevokin | MSc Artificial Intelligence, University of Bologna  

---

## 🧭 Overview  
This project focuses on transforming **normalised 3D car meshes** into **algorithm-friendly point clouds**, implementing a multi-step 3D data preprocessing pipeline in **Python + Open3D**.  
The workflow ensures surface uniformity, removes interior points, and refines the resulting geometry for subsequent computer vision or shape analysis tasks.

---

## ⚙️ Pipeline  

### 1️⃣ Resampling  
**`resampling(mesh)`** — applies Poisson disk sampling and optional voxel downsampling.  
> Balances mesh density and reduces local geometric noise.  

### 2️⃣ Surface Extraction  
**`extract_shell(pcd, views=64)`** — leverages a Fibonacci sphere of virtual camera viewpoints for visibility analysis (using hidden point removal).  
> Retains only surface-level points visible from at least one direction.  

### 3️⃣ Refinement: Surface Reconstruction & Smoothing  
**`reconstruct_and_smooth(pcd_ext)`** — performs Poisson surface reconstruction, followed by cleanup (duplicate, degenerate, and non-manifold removal) and Taubin smoothing.  
> Produces a topologically consistent and smoothed mesh surface.  

### 4️⃣ Final Uniform Point Cloud Generation  
**`final_pcd(mesh_smooth, n=150_000, voxel=0.003)`** — performs Poisson-disk resampling and normal re-estimation to obtain a uniform surface point cloud.  
> Delivers a smooth, homogeneous representation suitable for downstream analysis.  

---

## 🧠 Design Parameters  
| Parameter | Value | Description |
|------------|--------|-------------|
| `VIEWS` | 64 | Number of virtual camera viewpoints |
| `VOXEL` | 0.003 | Downsampling voxel size |
| `POISSON_DEPTH` | 10 | Poisson reconstruction depth |
| `TAUBIN_ITERS` | 10 | Iterations for Taubin smoothing |

---

## 📈 Output  
Each processed car mesh yields:  
1. **Exterior-only point cloud** (surface visible from outside).  
2. **Uniform & smoothed surface point cloud** (refined for 3D ML algorithms).  

