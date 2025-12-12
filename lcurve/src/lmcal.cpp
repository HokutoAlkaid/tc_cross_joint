#include<iostream>
#include"csr_matrix.hpp"
#include<math.h>
#include<stdlib.h>
#include<stdio.h>
#include <sstream>
#include <iomanip>

//---
//  This code is written by Nanqiao Du and then modified by Haopeng Chen, 2021.01.25 
//  This code is used to calculate the 2-rd order regularization term "D*M" of inverted model.
//  You need to change the dimension of model (nx = 34,ny=37,nz=21) for your own use
//  Modified time :: 2021.01.25 07:43
//  compile this code:: g++ lcurve.cpp -std=c++11 -o lcurve 
//                      csr_matrix.hpp  lsmr.hpp are needed  
//---

void add_regularization(csr_matrix<float> &smat,float weight,int nx,int ny,int nz)
{
    // get parameters required
    int n = (nx-2) * (ny -2) * (nz  - 1); // model dimension
    int nar = smat.nonzeros - n * 7; // nonzeros excluding smooth term
    int m = smat.rows() - n; // data dimension

    int count = 0;
    for(int k=0;k<nz-1;k++){
    for(int j=0;j<ny-2;j++){
    for(int i=0;i<nx-2;i++){
        if( i==0 || i==nx-3 || j==0 || j==ny-3 || k==0 || k==nz-2){
            
            // and more restrictions to boundary points
            if(nar + 1 > smat.nonzeros){
                std::cout << "please increase sparse ratio!" << std::endl;
                exit(0);
            }
            int rwc = count + m;
            smat.data[nar] = 2.0 * weight;
            smat.indices[nar] = k * (ny -2) * (nx -2) + j * (nx -2) + i;
            smat.indptr[rwc + 1] = smat.indptr[rwc] + 1;
            nar += 1;
            count += 1;
            
           continue;
        }
        else{
            if(nar  + 7 > smat.nonzeros){
                std::cout << "please increase sparse ratio!" << std::endl;
                exit(0);
            }
            int rwc = count + m;  // current row
            smat.indptr[rwc +1] = smat.indptr[rwc] + 7;
            int clc = k * (ny -2) * (nx -2) + j * (nx -2) + i;// current column
            smat.data[nar] = 6.0 * weight;
            smat.indices[nar] = clc;

            // x direction
            smat.data[nar + 1] = -weight;
            smat.indices[nar + 1] = clc - 1;
            smat.data[nar + 2] = -weight;
            smat.indices[nar + 2] = clc + 1;

            // y direction
            smat.data[nar + 3] = -weight;
            smat.indices[nar + 3] = clc - (nx - 2);
            smat.data[nar + 4] = -weight;
            smat.indices[nar + 4] = clc + (nx - 2);

            // z direction
            smat.data[nar + 5] = -weight;
            smat.indices[nar + 5] = clc - (nx - 2) * (ny - 2);
            smat.data[nar + 6] = -weight;
            smat.indices[nar + 6] = clc + (nx - 2) * (ny - 2);

            nar += 7;
            count += 1;
        }
    }}}
    smat.nonzeros = nar;
}

int main()
{
    int nx = 34,ny=37,nz=21;
    int n = (nx-2) * (ny-2) * (nz - 1);
    

    // read true model
    float v[n];
    FILE *fp1 = fopen("lm.txt","w");
    for(int ii=0;ii<1;ii++){
        std::string filename = "mod_iter.dat";
        std::cout << filename << "\n";
        FILE *fp = fopen(filename.c_str(),"r");
        for(int i=0;i<nz;i++){
        for(int j=0;j<ny;j++){
        for(int k=0;k<nx;k++){
            float lon,lat,z;
            int idx = i * (ny-2) * (nx-2) + (j-1) * (nx-2) + k-1;
            if(i<nz-1 && j>=1 && j<=ny-2 && k>=1 && k<=nx-2){
                 fscanf(fp,"%f%f%f%f\n",&lon,&lat,&z,v+idx);
            }
        }}}
        fclose(fp);

        // compute L matrix and L * m;
        csr_matrix<float> smat(n,n,n*7);
        add_regularization(smat,1.0,nx,ny,nz);
        float *y = new float [n]();
        smat.aprod(1,v,y);

        float lm = 0.0;
        for(int i=0;i<n;i++){
            lm += y[i] * y[i];
        }
        lm = sqrt(lm);

        fprintf(fp1,"%.3f\n",lm);

        delete[] y;
    }
}
