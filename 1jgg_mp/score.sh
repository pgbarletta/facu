#! /bin/bash


file="s"
for i in {1..50}
do

to_score=${file/*/$i"_score.py"}

mod9.18 $to_score

done
exit 0
