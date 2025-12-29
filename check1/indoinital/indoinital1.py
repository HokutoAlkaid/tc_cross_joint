# -*- coding: utf-8 -*-
import os
import numpy as np

# ==========================================
# 1. 参数设置 (必须与 DSurfTomo.in 严格一致)
# ==========================================
# 经度: 97.0 到 102.0, 步长 0.25 (21个点)
lons = np.arange(97.0, 102.25, 0.25) 
# 纬度: 27.0 到 22.0, 步长 0.25 (21个点, 注意从北向南)
lats = np.arange(27.0, 21.75, -0.25) 
# 深度: 16层
deps = np.array([0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0])

nx = len(lons) # 21
ny = len(lats) # 21
nz = len(deps) # 16

print("Grid Check: Lon(%d) x Lat(%d) x Dep(%d)" % (nx, ny, nz))

# ==========================================
# 2. 构建模型矩阵
# ==========================================
# 初始化背景 Vs 矩阵 [depth, lon, lat]
vs_init_3d = np.zeros((nz, nx, ny))
for i, d in enumerate(deps):
    vs_init_3d[i, :, :] = 2.5 + 0.02 * d 

# 初始化真值模型为背景模型的副本 (关键修复：防止出现 0 值)
vs_true_3d = vs_init_3d.copy()

# 读取 GMT 插值生成的 16 个深度切片 (假设在 ../model/ 目录下)
for i, d in enumerate(deps):
    filename = "../model/%03dkm.txt" % int(d)
    if os.path.exists(filename):
        print("Reading slice: %s" % filename)
        try:
            slice_data = np.loadtxt(filename)
            if slice_data.size == 0:
                continue
                
            # 获取列数，确定速度值所在位置 (关键修复：识别是第3列还是第4列)
            # 常见格式 1: Lon Lat Vel (3列)
            # 常见格式 2: Lon Lat Dep Vel (4列)
            num_cols = slice_data.shape[1]
            vel_col_idx = num_cols - 1 

            for row in slice_data:
                ln_val, lt_val, vel = row[0], row[1], row[vel_col_idx]
                
                # 寻找索引
                ln_idx = np.argmin(np.abs(lons - ln_val))
                lt_idx = np.argmin(np.abs(lats - lt_val))
                
                # 只有当坐标匹配时才更新，否则保持背景值
                if np.abs(lons[ln_idx] - ln_val) < 0.1 and np.abs(lats[lt_idx] - lt_val) < 0.1:
                    vs_true_3d[i, ln_idx, lt_idx] = vel
        except Exception as e:
            print("Error reading %s: %s" % (filename, e))
    else:
        print("Warning: Slice %s not found, using background at this depth." % filename)

# ==========================================
# 3. 输出文件 A: MOD/MOD.true (格网格式)
# ==========================================
def save_grid_mod(filename, vs_3d):
    with open(filename, 'w') as f:
        # 第一行写深度
        f.write(" ".join(["%.1f" % d for d in deps]) + "\n")
        # 按照深度层写入
        for i in range(nz):
            # 按照 Lon(慢改变) -> Lat(快改变) 循环写入
            for j in range(nx):
                for k in range(ny):
                    f.write("%.4f " % vs_3d[i, j, k])
                f.write("\n")

save_grid_mod("MOD", vs_init_3d)
save_grid_mod("MOD.true", vs_true_3d)

# ==========================================
# 4. 输出文件 B: indoinital.dat (列向量格式)
# ==========================================
with open("indoinital.dat", "w") as f:
    for i in range(nz):
        for j in range(nx):      # Lon 慢改变
            for k in range(ny):  # Lat 快改变
                ln = lons[j]
                lt = lats[k]
                dp = deps[i]
                v  = vs_true_3d[i, j, k]
                f.write("%8.3f %8.3f %5.1f %8.4f\n" % (ln, lt, dp, v))

print("Success: Generated MOD, MOD.true and indoinital.dat.")
print("The values should now follow background 2.5 + 0.02*depth with checkerboard perturbations.")
