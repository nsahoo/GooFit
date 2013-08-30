#ifndef MAPPED_THRUST_FUNCTOR_HH
#define MAPPED_THRUST_FUNCTOR_HH

#include "EngineCore.hh" 

class MappedThrustFunctor : public EngineCore {
public:
  MappedThrustFunctor (std::string n, EngineCore* m, vector<EngineCore*>& t); 
  // Map function m must be custom written to correspond to order of function list t. 
  __host__ fptype normalise () const;
private:

};

#endif
