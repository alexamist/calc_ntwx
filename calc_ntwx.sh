#!/bin/bash

 # usage: ./ntwx_number.sh time_to_run [in ps]

 # colors
RED='\033[1;31m'
NC='\033[0m'
GRAY='\033[1;37m'
BLUE='\033[1;34m'
UND='\e[4m'
NUND='\e[24m'

 # defining flags and options
while getopts "pgn:t:d:h" option;
do
 case $option in
  p)
   prev=1
   ;;
  g)
   gg=1
   ;;
  n)
  natoms=$OPTARG
   ;;
  t)
  tr=$OPTARG
   ;;
  d)
  dtr=$OPTARG
   ;;
  h)
   echo -e "${RED} Help calc_ntwx.sh:${NC}"
   echo -e "  Calculate ntwx value based in a guess or previous run, to generate a .nc file of 500Mb.\n"
   echo -e "${GRAY}  Use -p option to calculate ntwx based in previous md run. (consider dt of previous run)${NC}"
   echo -e "   *files needed: mdin, mdout, md01.nc"
   echo -e "${GRAY}  Use -g option to calculate ntwx based in a guess.${NC}"
   echo -e "${GRAY}  Use -t time [ps] to set how many time you wanna simulate.${NC}"
   echo -e "${GRAY}  Use -n n_atoms to set the number of atoms in your simulation.${NC}"
   echo -e "${GRAY}  Use -d dt_value to set dt value of your simulation.\n${NC}"
   echo -e "${GRAY}  usage: ${BLUE}./calc_ntwx.sh -g -t 200000 -n 30000 -d 0.002 ${NC}"
   echo -e "${GRAY}         ${BLUE}./calc_ntwx.sh -p -t 200000 ${NC}\n"; exit
   ;;
  :)
   echo -e "${RED}Type ./calc_ntwx.sh -h for help.${NC}"; exit
   ;;
  *)
   echo -e "${RED}Type ./calc_ntwx.sh -h for help.${NC}"; exit
   ;;
 esac
done



#------------- defining previous
function previous(){
if [ -n "${tr}" ]; then
 echo ""
 else
 echo -e "${RED}Define -t option! Type ./calc_ntwx.sh -h for help.${NC}" ; exit
fi

 # test
ntwxt=$(grep 'ntwx' mdin | awk '{print $3}' | sed 's/,//g')
dtt=$(grep 'dt' mdin | awk '{print $3}' | sed 's/,//g')
tt=$(tac mdout |grep -m 1 'TIME(PS)'|awk '{print $6}' | sed 's/.000//g')
natoms=$(grep 'NATOM' mdout|awk '{print $3}')

size=$(du -h md01.nc| awk '{print $1}')
end=$(echo $size) ; i=$((${#end}-1)); last=$(echo "${end:$i:1}")
if [ "$last" == "M" ]; then
nct=$(echo $size | sed 's/M//g')
else
  if [ "$last" == "G" ]; then
  nct=$(echo "$size" | sed 's/G/00/g' | sed 's/,//g')
  fi
fi

#echo "ntwxt=$ntwxt" ; echo "dtt=$dtt" ; echo "tt=$tt"
#echo "natoms=$natoms" ; echo "size=$size" ; echo "nct=$nct"
#byatom=$(echo "scale=7; (${dtt}*${ntwxt}*${nct})/(${tt}*${natoms})" | bc)

 # for run
dtr=${dtt}
ncr=500 #Mb

ntwxr=$(echo "scale=0; (${tr}*${dtt}*${ntwxt}*${nct})/(${dtr}*${tt}*${ncr})" | bc)
echo -e "${GRAY}Use ntwx of ${RED}${UND}~$ntwxr${NUND}${GRAY} to generate a simulation of ${UND}${tr} ps${NUND} with a .nc file of ${UND}~${ncr} Mb${NUND}${NC}\n"

}
#------------- end previous

#------------- defining guess
function guess(){
if [ -n "${natoms}" ]; then
  if [ -n "${tr}" ]; then
    if [ -n "${dtr}" ]; then
    echo ""
    else
    echo -e "${RED}Define -d option! Type ./calc_ntwx.sh -h for help.${NC}" ; exit
    fi
  else
  echo -e "${RED}Define -t option! Type ./calc_ntwx.sh -h for help.${NC}" ; exit
  fi
else
echo -e "${RED}Define -n option! Type ./calc_ntwx.sh -h for help.${NC}" ; exit
fi


ncr=500 #Mb
byatom='0.0000114' #Mb/atom*print
ntwxr=$(echo "scale=0; (${tr}*${natoms}*${byatom})/(${dtr}*${ncr})" | bc)

echo -e "${GRAY}Use ntwx of ${RED}${UND}~$ntwxr${NUND}${GRAY} to generate a simulation of ${UND}${tr} ps${NUND} with a .nc file of ${UND}~${ncr} Mb${NUND}${NC}\n"
}
#------------- end guess




if [[ "${prev}" -eq "1" ]]; then
previous
else
  if [[ "${gg}" -eq "1" ]]; then
  guess
  fi
fi
