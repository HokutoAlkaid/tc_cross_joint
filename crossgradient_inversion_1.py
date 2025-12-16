import scipy
import sys
import numpy as np
from concurrent.futures import ThreadPoolExecutor
from scipy.sparse import diags, bmat, eye
from scipy.sparse.linalg import lsmr
from concurrent.futures import ProcessPoolExecutor

# Multithreaded central difference calculation
def central_difference_worker(i, j, k, m1, m2, dx, dy, dz):
    tx = ((m1[i, j+1, k] - m1[i, j-1, k]) / (2*dy)) * ((m2[i, j, k+1] - m2[i, j, k-1]) / (2*dz)) \
       - ((m1[i, j, k+1] - m1[i, j, k-1]) / (2*dz)) * ((m2[i, j+1, k] - m2[i, j-1, k]) / (2*dy))
    ty = ((m1[i, j, k+1] - m1[i, j, k-1]) / (2*dz)) * ((m2[i+1, j, k] - m2[i-1, j, k]) / (2*dx)) \
       - ((m1[i+1, j, k] - m1[i-1, j, k]) / (2*dx)) * ((m2[i, j, k+1] - m2[i, j, k-1]) / (2*dz))
    tz = ((m1[i+1, j, k] - m1[i-1, j, k]) / (2*dx)) * ((m2[i, j+1, k] - m2[i, j-1, k]) / (2*dy)) \
       - ((m1[i, j+1, k] - m1[i, j-1, k]) / (2*dy)) * ((m2[i+1, j, k] - m2[i-1, j, k]) / (2*dx))
    return i, j, k, tx, ty, tz

def central_difference(m1, m2, dx, dy, dz):
    nx, ny, nz = m1.shape
    tx, ty, tz = np.zeros_like(m1), np.zeros_like(m1), np.zeros_like(m1)
    
    # Parallel execution of central difference calculation using ProcessPoolExecutor
    with ProcessPoolExecutor() as executor:  # Use ProcessPoolExecutor
        futures = []
        for i in range(1, nx-1):
            for j in range(1, ny-1):
                for k in range(1, nz-1):
                    futures.append(executor.submit(central_difference_worker, i, j, k, m1, m2, dx, dy, dz))
        
        # Collect results from processes
        for future in futures:
            i, j, k, tx_val, ty_val, tz_val = future.result()
            tx[i, j, k] = tx_val
            ty[i, j, k] = ty_val
            tz[i, j, k] = tz_val
    
    return tx, ty, tz

# Multithreaded gradient derivative calculation
def gradient_derivative_worker(i, j, k, m1, m2, dx, dy, dz):
    dtx_dms_x = ((m2[i, j, k+1] - m2[i, j, k-1]) / (2*dz)) * (1 / (2*dy)) \
              - ((m2[i, j+1, k] - m2[i, j-1, k]) / (2*dy)) * (1 / (2*dz))
    dtx_dms_y = ((m2[i+1, j, k] - m2[i-1, j, k]) / (2*dx)) * (1 / (2*dz)) \
              - ((m2[i, j+1, k] - m2[i, j-1, k]) / (2*dy)) * (1 / (2*dz))
    dtx_dms_z = ((m2[i+1, j, k] - m2[i-1, j, k]) / (2*dx)) * (1 / (2*dy)) \
              - ((m2[i, j+1, k] - m2[i, j-1, k]) / (2*dy)) * (1 / (2*dx))
    
    dtx_dmg_x = ((m1[i, j+1, k] - m1[i, j-1, k]) / (2*dy)) * (1 / (2*dz)) \
              - ((m1[i, j, k+1] - m1[i, j, k-1]) / (2*dz)) * (1 / (2*dy))
    dtx_dmg_y = ((m1[i+1, j, k] - m1[i-1, j, k]) / (2*dx)) * (1 / (2*dz)) \
              - ((m1[i, j, k+1] - m1[i, j, k-1]) / (2*dz)) * (1 / (2*dx))
    dtx_dmg_z = ((m1[i+1, j, k] - m1[i-1, j, k]) / (2*dx)) * (1 / (2*dy)) \
              - ((m1[i, j+1, k] - m1[i, j-1, k]) / (2*dy)) * (1 / (2*dx))
    
    return i, j, k, dtx_dms_x, dtx_dms_y, dtx_dms_z, dtx_dmg_x, dtx_dmg_y, dtx_dmg_z

def calculate_gradient_derivatives(m1, m2, dx, dy, dz):
    nx, ny, nz = m1.shape
    dtx_dms_x, dtx_dms_y, dtx_dms_z = np.zeros_like(m1), np.zeros_like(m1), np.zeros_like(m1)
    dtx_dmg_x, dtx_dmg_y, dtx_dmg_z = np.zeros_like(m1), np.zeros_like(m1), np.zeros_like(m1)
    
    # Parallel execution of gradient derivative calculation using ProcessPoolExecutor
    with ProcessPoolExecutor() as executor:  # Use ProcessPoolExecutor
        futures = []
        for i in range(1, nx-1):
            for j in range(1, ny-1):
                for k in range(1, nz-1):
                    futures.append(executor.submit(gradient_derivative_worker, i, j, k, m1, m2, dx, dy, dz))
        
        # Collect results from processes
        for future in futures:
            i, j, k, dx_val, dy_val, dz_val, dgx_val, dgy_val, dgz_val = future.result()
            dtx_dms_x[i, j, k], dtx_dms_y[i, j, k], dtx_dms_z[i, j, k] = dx_val, dy_val, dz_val
            dtx_dmg_x[i, j, k], dtx_dmg_y[i, j, k], dtx_dmg_z[i, j, k] = dgx_val, dgy_val, dgz_val
    
    return dtx_dms_x, dtx_dms_y, dtx_dms_z, dtx_dmg_x, dtx_dmg_y, dtx_dmg_z


# Sparse matrix least squares solver
def solve_least_squares(A, B):
    result = lsmr(A, B)
    return result[0]  # Return the solution

def main():
    # File paths
    file1 = 'data/delta_ms0.dat'
    file2 = 'data/delta_mg0.dat'
    file3 = 'data/mod_iter0.dat'   #file3 = 'data/mod_iter1.dat'
    file4 = 'data/joint_mod_iter0.dat'  #file4 = 'data/joint_mod_iter1.dat'

    # Load data
    data1 = np.loadtxt(file1)
    data2 = np.loadtxt(file2)
    data3 = np.loadtxt(file3)
    data4 = np.loadtxt(file4)

    # Parse data
    ms_y1, ms_x1, ms_z1, ms_v1 = data3[:, 0], data3[:, 1], data3[:, 2], data3[:, 3]
    mg_y1, mg_x1, mg_z1, mg_v1 = data4[:, 0], data4[:, 1], data4[:, 2], data4[:, 3]

    # Reshape initial models
    nx = len(np.unique(ms_x1))
    ny = len(np.unique(ms_y1))
    nz = len(np.unique(ms_z1))
    
    ms_0 = ms_v1.reshape((nx, ny, nz), order='F')
    mg_0 = mg_v1.reshape((nx, ny, nz), order='F')

    # Compute initial model cross-gradient
    tx0, ty0, tz0 = central_difference(ms_0, mg_0, 1, 1, 1)

    # Compute initial model cross-gradient derivatives
    dtx_dms_x, dtx_dms_y, dtx_dms_z, dtx_dmg_x, dtx_dmg_y, dtx_dmg_z = calculate_gradient_derivatives(ms_0, mg_0, 1, 1, 1)

    # Convert 3D model results to column vectors
    tx0_col = tx0.flatten(order='F')
    ty0_col = ty0.flatten(order='F')
    tz0_col = tz0.flatten(order='F')

    dtx_dms_x_col = dtx_dms_x.flatten(order='F')
    dtx_dms_y_col = dtx_dms_y.flatten(order='F')
    dtx_dms_z_col = dtx_dms_z.flatten(order='F')

    dtx_dmg_x_col = dtx_dmg_x.flatten(order='F')
    dtx_dmg_y_col = dtx_dmg_y.flatten(order='F')
    dtx_dmg_z_col = dtx_dmg_z.flatten(order='F')

    # Set up joint inversion system
    alpha_s = 1
    alpha_g = 0.4
    beta_t = 0.1

    n = len(data1[:, 3])
    I = eye(n, format='csr')  # Sparse identity matrix

    Delta_m_s0 = data1[:, 3]
    Delta_m_g0 = data2[:, 3]
    
    # ==========================================
    norm_s = np.mean(np.abs(Delta_m_s0))
    norm_g = np.mean(np.abs(Delta_m_g0))
    
    print("-" * 40)
    print("DEBUG: Surface Wave Gradient Magnitude (Mean Abs): {:.6e}".format(norm_s))
    print("DEBUG: Gravity Gradient Magnitude      (Mean Abs): {:.6e}".format(norm_g))
    
    if norm_g > 0:
        ratio = norm_s / norm_g
        print("DEBUG: Suggested Scaling Factor for Gravity: {:.2f}".format(ratio))
    else:
        print("DEBUG: Gravity gradient is practically ZERO.")
    print("-" * 40)
    sys.stdout.flush() 
    # ==========================================
 
    # Construct sparse matrix A
    I_s = I * alpha_s  # alpha_s * I
    I_g = I * alpha_g  # alpha_g * I

    # Diagonal matrices
    dtx_dms_x_diag = diags(beta_t * dtx_dms_x_col)
    dtx_dmg_x_diag = diags(beta_t * dtx_dmg_x_col)
    dtx_dms_y_diag = diags(beta_t * dtx_dms_y_col)
    dtx_dmg_y_diag = diags(beta_t * dtx_dmg_y_col)
    dtx_dms_z_diag = diags(beta_t * dtx_dms_z_col)
    dtx_dmg_z_diag = diags(beta_t * dtx_dmg_z_col)

    # Construct block sparse matrix A
    A = bmat([
        [I_s, None],
        [None, I_g],
        [dtx_dms_x_diag, dtx_dmg_x_diag],
        [dtx_dms_y_diag, dtx_dmg_y_diag],
        [dtx_dms_z_diag, dtx_dmg_z_diag]
    ], format='csr')

    # Construct sparse vector B
    B = np.concatenate([
        alpha_s * Delta_m_s0,
        alpha_g * Delta_m_g0,
        -beta_t * tx0_col[:n],
        -beta_t * ty0_col[:n],
        -beta_t * tz0_col[:n]
    ])

    # Solve the system using least squares
    X = solve_least_squares(A, B)

    # Extract solutions
    Delta_m_s = X[:n]
    Delta_m_g = X[n:]

    # Update models
    ms_v2 = ms_v1 + Delta_m_s
    mg_v2 = mg_v1 + Delta_m_g

    # Save the updated velocity model
    ms_data = np.column_stack((ms_y1, ms_x1, ms_z1, ms_v2))
    np.savetxt('results/mod_iter.dat', ms_data, fmt='%f')

    # Save the updated density model
    mg_data = np.column_stack((mg_y1, mg_x1, mg_z1, mg_v2))
    np.savetxt('results/joint_mod_iter.dat', mg_data, fmt='%f')

    print("Joint inversion completed successfully.")

if __name__ == "__main__":
    main()

