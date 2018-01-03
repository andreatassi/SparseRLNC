License
-------
Please note that the code contained in
    - ./trunk/export_fig
    - ./trunk/+helpers/plotTickLatex2D.m
have been developed by third parties. These pieces of software can be downloaded from MATLAB Central File Exchange (https://uk.mathworks.com/matlabcentral/fileexchange/), for free.


Requirements
------------
The code is compatible with Linux (Ubuntu 14.04 LTS) and OS X 10.11.6. The figure generation process is only compatible with OS X 10.11.6.

Furthermore, the code requires what follows:
    - A working installation of kodo-20.0.0 (https://github.com/steinwurf). The library can only be downloaded after that an application for a non-commercial license has been made (and accepted) online at http://steinwurf.com/. The library has be accessible by the MATLAB MEX compiler. This step is only required to re-build the Monte Carlo simulation framework used in the manuscript.
    - MATLAB R2017a (including the Parallel Computing Toolbox) with the capability of building MEX files by means of g++. Please be aware that our MEX files are compiled by using the g++ compiler flag --std=c++11.


To Replicate the results and the figures reported in the manuscript:
-------------------------------------------------------------
    0. Add to the MATLAB path the folder ./export_fig
    1. Change the MATLAB folder to ./trunk
    2. Run in MATLAB the script main.m - This will both generate the results (in ./trunk/data) and all the figures included in the manuscript (in ./trunk/doc/img). 
