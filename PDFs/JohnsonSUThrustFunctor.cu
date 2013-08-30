#include "JohnsonSUThrustFunctor.hh"

const fptype SQRT2PI = 2.506628; 

__device__ fptype device_JohnsonSU (fptype* evt, fptype* p, unsigned int* indices) {
  fptype _Jm = p[indices[1]];
  fptype _Js = p[indices[2]];
  fptype _Jg = p[indices[3]];
  fptype _Jd = p[indices[4]];
  fptype x = evt[indices[2 + indices[0]]]; 

  fptype px       = (x -_Jm)/_Js; 
  fptype px2      = px * px; 
  fptype sqrt_arg = SQRT(1+px2); 
  fptype inv_sinh = LOG(px + sqrt_arg); 
  fptype gaus_arg = _Jg + _Jd * inv_sinh; 
  //if ((gpuDebug & 1) && (0 == blockIdx.x) && (0 == threadIdx.x))
  //if (gpuDebug & 1)
    //printf("Johnson SU: %f %f %f %f | %f %f %i\n", _Jm, _Js, _Jg, _Jd, x, _Jd / (_Js * SQRT2PI * sqrt_arg) * EXP(-0.5 * gaus_arg * gaus_arg), indices[2 + indices[0]]); 
    //printf("Johnson SU: %f %f %f %f | %f %f %f %f\n", _Jm, _Js, _Jg, _Jd, x, _Jd / (_Js * SQRT2PI * sqrt_arg) * EXP(-0.5 * gaus_arg * gaus_arg), cudaArray[indices[1]], cudaArray[indices[2]]);
  return _Jd / (_Js * SQRT2PI * sqrt_arg) * EXP(-0.5 * gaus_arg * gaus_arg );
}

__device__ device_function_ptr ptr_to_JohnsonSU = device_JohnsonSU; 

__host__ JohnsonSUThrustFunctor::JohnsonSUThrustFunctor (std::string n, Variable* _x, Variable* mean, Variable* sigma, Variable* gamma, Variable* delta) 
  : EngineCore(_x, n) 
{
  std::vector<unsigned int> pindices;
  pindices.push_back(registerParameter(mean));
  pindices.push_back(registerParameter(sigma));
  pindices.push_back(registerParameter(gamma));
  pindices.push_back(registerParameter(delta));
  cudaMemcpyFromSymbol((void**) &host_fcn_ptr, ptr_to_JohnsonSU, sizeof(void*));
  initialise(pindices); 
}

__host__ fptype JohnsonSUThrustFunctor::integrate (fptype lo, fptype hi) const {
  return 1.0; // Analytic integral included in device function! (Correct for minus to plus inf.) 
}
