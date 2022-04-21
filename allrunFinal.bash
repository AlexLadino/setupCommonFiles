#!/bin/sh
cd ${0%/*} || exit 1

. $WM_PROJECT_DIR/bin/tools/RunFunctions

numProc=6
numProc_1=5

# cp ./system/userLocationSamples.v5 ./system/userLocationSamples
# cp  ./system/decomposeParDict.orig	./system/decomposeParDict
# UFile="./system/decomposeParDict"
# sed s/"\(numberOfSubdomains[ \t]*\) 4"/"\1 $numProc"/g $UFile > temp.$$
# mv -f temp.$$ $UFile
# decomposePar
# mpiexec -np $numProc renumberMesh -overwrite -parallel

for j in $(seq 0 1 $numProc_1)
do
cp  constant/kinematicCloud1InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud2InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud3InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud4InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud5InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud6InjectionsTable ./processor$j/constant/
cp  constant/kinematicCloud7InjectionsTable ./processor$j/constant/
done

mpiexec -np $numProc ARKBudgetDissipationFoamOF5 -parallel
