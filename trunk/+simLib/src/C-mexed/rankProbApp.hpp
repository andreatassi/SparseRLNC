#include <boost/math/special_functions/binomial.hpp>

#include <iostream>
#include <ctime>
#include <cassert>
#include <vector>
#include <algorithm>
#include <math.h> 

double condRankP(unsigned int r, unsigned int c, double p, unsigned int q);
double nCkF(unsigned int n, unsigned int k);
double rhoF(unsigned int l, unsigned int e, unsigned int q, double p);
double piF(unsigned int l, unsigned int e, unsigned int q, double p);
