import numpy as np
import matplotlib.pyplot as plt

def analyze_dat(filename):
    print(f"正在分析文件: {filename}")
    # 读取数据: Lon, Lat, Depth, Vs
    try:
        data = np.loadtxt(filename)
    except Exception as e:
        print(f"读取失败: {e}")
        return

    lons = np.unique(data[:, 0])
    lats = np.unique(data[:, 1])
    deps = np.unique(data[:, 2])

    nx, ny, nz = len(lons), len(lats), len(deps)
    
    print(f"\n--- 网格统计 ---")
    print(f"经度范围: {lons.min()} ~ {lons.max()} (点数: {nx}, 步长: {np.diff(lons)[0] if nx>1 else 0:.3f})")
    print(f"纬度范围: {lats.min()} ~ {lats.max()} (点数: {ny}, 步长: {np.diff(lats)[0] if ny>1 else 0:.3f})")
    print(f"深度层数: {nz} 层")
    print(f"总记录数: {len(data)} (理论应为: {nx*ny*nz})")

    if len(data) == nx * ny * nz:
        print("✅ 结论: 网格完整，排列规整。")
    else:
        print("❌ 警告: 数据点缺失或重复，请检查 indoinital.py 的循环逻辑。")

    # 可视化一个中间深度层 (例如 10km)
    target_dep = deps[len(deps)//3]
    slice_data = data[data[:, 2] == target_dep]
    
    # 重组为矩阵用于绘图
    # 注意: 通常顺序是 Lat 变化慢, Lon 变化快
    vs_matrix = slice_data[:, 3].reshape((ny, nx))

    plt.figure(figsize=(8, 6))
    plt.pcolormesh(lons, lats, vs_matrix, cmap='seismic', shading='auto')
    plt.colorbar(label='Vs (km/s)')
    plt.title(f"Checkerboard Slice at Depth: {target_dep}km")
    plt.xlabel("Longitude")
    plt.ylabel("Latitude")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.show()

# 执行诊断
analyze_dat("indoinital.dat")
