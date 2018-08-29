# calc_ntwx
Calculate ntwx value based in a guess or previous run, to generate a .nc file of 500Mb.

  Use -p option to calculate ntwx based in previous md run. (consider dt of previous run)
     **--files needed: mdin, mdout, md01.nc**
  
  Use **-g** option to calculate ntwx based in a guess.
  
  Use **-t** time [ps] to set how many time you wanna simulate.
  
  Use **-n** n_atoms to set the number of atoms in your simulation.
  
  Use **-d** dt_value to set dt value of your simulation.

  Usage: `./calc_ntwx.sh -g -t 200000 -n 30000 -d 0.002 `
  
  `./calc_ntwx.sh -p -t 200000 `
  
 
