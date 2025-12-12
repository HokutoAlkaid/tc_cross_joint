#!/usr/bin/env python
#----
#    This python script is used to convert S-wave velocity to density structure
#    Author:: Haopeng Chen from HUST
#----
import sys
import numpy as np

def main():
    # 允许通过命令行参数指定输入输出，更灵活
    if len(sys.argv) < 3:
        print("Usage: python3 veltodensi.py <input_Vs_model> <output_Density_model>")
        # 默认回退逻辑，兼容旧用法
        input_file = "joint_mod_iter10.dat"
        output_file = "joint_densi_iter10.dat"
        print(f"Using default: {input_file} -> {output_file}")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]

    try:
        data = np.loadtxt(input_file)
    except IOError:
        print(f"Error: Cannot open {input_file}")
        sys.exit(1)

    with open(output_file, "w") as f1:
        for row in data:
            lon, lat, depth, vs = row[0], row[1], row[2], row[3]
            
            # Brocher (2005) Vs -> Vp
            vp = 0.9409 + 2.0947*vs - 0.8206*vs**2 + 0.2683*vs**3 - 0.0251*vs**4
            
            # Brocher (2005) Vp -> Density
            rho = 1.6612*vp - 0.4721*vp**2 + 0.0671*vp**3 - 0.0043*vp**4 + 0.000106*vp**5
            
            # 安全截断，防止非物理值
            if rho < 1.5: rho = 1.5
            if rho > 3.5: rho = 3.5
            
            f1.write(f'{lon:8.2f} {lat:8.2f} {depth:6.1f} {rho:10.4f} \n')

    print(f"Successfully converted Vs to Density: {output_file}")

if __name__ == "__main__":
    main()
