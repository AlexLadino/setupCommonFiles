#!/bin/sh
cd ${0%/*} || exit 1

. $WM_PROJECT_DIR/bin/tools/RunFunctions

numProc=4
numProc_1=3

# cp  ./system/decomposeParDict.orig	./system/decomposeParDict
# UFile="./system/decomposeParDict"
# sed s/"\(numberOfSubdomains[ \t]*\) 4"/"\1 $numProc"/g $UFile > temp.$$
# mv -f temp.$$ $UFile
# decomposePar
# mpiexec -np $numProc renumberMesh -overwrite -parallel

# for j in $(seq 0 1 $numProc_1)
# do
# cp  constant/kinematicCloud1InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud2InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud3InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud4InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud5InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud6InjectionsTable ./processor$j/constant/
# cp  constant/kinematicCloud7InjectionsTable ./processor$j/constant/
# done

# cp ./system/fvSolution.transient ./system/fvSolution
# cp ./system/controlDict.transient ./system/controlDict
# mpiexec -np $numProc -bind-to-core -bycore pimpleFoam -parallel

# cp ./system/fvSolution.lptd ./system/fvSolution
# cp ./system/controlDict.lptd ./system/controlDict
# mpiexec -np $numProc -bind-to-core -bycore pimpleLPTFoam7PV2_2021 -parallel

# cp -f ./system/controlDictLog.lptd ./system/controlDict
# mpiexec -np $numProc -bind-to-core -bycore pimpleLPTFoam7PV2_2021 -parallel > log.lpt

for j in $(seq 0 1 $numProc_1)
do
rm ./processor$j/0.05200105/UMean*
rm ./processor$j/0.05200105/pMean*
rm ./processor$j/0.05200105/RMean*
done

# correr turbulent budgets
cp ./system/controlDict.tke ./system/controlDict
cp ./system/userLocationSamples.docker ./system/userLocationSamples
mpiexec -np $numProc pimpleTKEFoamV2021 -parallel > log.pimpleTKEFoamV2021
# reconstructPar -latestTime > log.reconstrucPar
# pimpleTKEFoamV2021 > log.pimpleTKEFoamV2021
