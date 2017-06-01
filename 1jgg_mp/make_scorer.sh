#! /bin/bash


file="s"
for i in {1..50}
do

to_score=${file/*/$i"_score.py"}
profile=${file/*/"profile_"$i}
if [[ $i -lt 10 ]] 
then
    pdb=${file/*/"mp.B9999000"$i".pdb"}
else
    pdb=${file/*/"mp.B999900"$i".pdb"}
fi

cat <<EOF > $to_score
from modeller import *
from modeller.scripts import complete_pdb

log.verbose()    # request verbose output
env = environ()
env.libs.topology.read(file='\$(LIB)/top_heav.lib') # read topology
env.libs.parameters.read(file='\$(LIB)/par.lib') # read parameters

# read model file
mdl = complete_pdb(env, '$pdb')

# Assess with DOPE:
s = selection(mdl)   # all atom selection
s.assess_dope(output='ENERGY_PROFILE NO_REPORT', file='$profile',
              normalize_profile=True, smoothing_window=15)
EOF

done
exit 0
