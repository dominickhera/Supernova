#!/bin/bash

oldsuffix="Test.txt"
newsuffix="MortUSA.txt"

for i in `seq 1995 2014`;
do
    ns=$i
    ns+=$newsuffix
    os=$i
    os+=$oldsuffix
    mv $os $ns
done
