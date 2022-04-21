#!/bin/bash
# generates plots from sample utility
# plot each variable vs x for each time
# TODO:plot a variable for each time in same plot
cd ${0%/*} || exit 1    # Run from this directory

# fileName='inlet3D_U_UMean.xy'
# fileName='outlet3D_U_UMean.xy'
# fileName='outlet02D_U_UMean.xy'
fileName='outlet0D_U_UMean.xy'
variables=('U1' 'U2' 'U3' 'U1Mean' 'U2Mean' 'U3Mean')
numVariables=6
lineSampleName='monitorSamples'
tini=0.07800105
tfin=0.08400105
tinc=0.00200000
formato=\"%.8f\"  # para tiempos decimales
tipoTerminal=0    # 0 window, 1 pdf
yRange="[*:*]"
xRange="[*:*]"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "      MONITOR DE SAMPLES"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "VERSION 1   VALIDADO EL PLOTEADO"
echo "            VERSIONES POSTERIORES SOLO MODIFICAN DETALLES DE PLOT"
echo "      Cada columna se considera una variable"
echo
echo "Ejemplo campos vectoriales"
echo
echo "      fileName='nombre_U_UMean.xy'"
echo "      variables=('U1' 'U2' 'U3' 'UMean1' 'UMean2' 'UMean3')"
echo "      numVariables=6"
echo
echo "Ejemplo campos escalares"
echo
echo "      fileName='nombre_p_pMean_k_kMean_Q.xy'"
echo "      variables=('p' 'pMean' 'k' 'kMean' 'Q')"
echo "      numVariables=5"
echo
echo "************************************************************************"
echo
echo "fileName=$fileName"
echo "numVariables=$numVariables"
echo "lineSampleName=$lineSampleName"
echo "tini=$tini"
echo "tfin=$tfin"
echo "tinc=$tinc"
echo 
echo "************************************************************************"

numTimeSteps=0

for j in $(seq $tini $tinc $tfin)
      do
      numTimeSteps=$((numTimeSteps + 1))
done

h='\'

for i in $(seq 1 1 $numVariables)
do
      k=$((i + 1))          
      colY=$k

      graphName="${variables[i-1]}.pdf"
      
            
                                  
      echo "set xlabel 'Distance'" >> gnuplot.ina
      echo "set ylabel 'Velocity'" >> gnuplot.ina
      echo "set title '$graphName'" >> gnuplot.ina
      echo "set grid x mx y my" >> gnuplot.ina
      echo "set yrange $yRange" >> gnuplot.ina
      echo "set xrange $xRange" >> gnuplot.ina
      
         echo "set lmargin 5" >> gnuplot.ina
         echo "set bmargin -10" >> gnuplot.ina
         echo "set yzeroaxis" >> gnuplot.ina
         echo "set xzeroaxis" >> gnuplot.ina
         
#         echo "set ytics 0.2" >> gnuplot.ina
#         echo "set mytics 10" >> gnuplot.ina
#         echo "set xtics 0.02" >> gnuplot.ina
#         echo "set format x \"%2.2f\"" >> gnuplot.ina
#         echo "set mxtics 4" >> gnuplot.ina

#         echo "set y2tics 0.2" >> gnuplot.ina
#         echo "set my2tics 4" >> gnuplot.ina
#         echo "set x2tics 0.1" >> gnuplot.ina
#         echo "set format x2 \"%2.2f\"" >> gnuplot.ina
#         echo "set mx2tics 4" >> gnuplot.ina
              
#       echo "set style line 100 lt 1 lc rgb \"gray\" lw 2" >> gnuplot.ina
#       echo  "set style line 101 lt 0.5 lc rgb \"gray\" lw 1 " >> gnuplot.ina

#       echo  "set grid mytics ytics ls 100, ls 101 " >> gnuplot.ina
#       echo  "set grid mxtics xtics ls 100, ls 101 " >> gnuplot.ina

      if [ "$tipoTerminal" -eq 0 ]; then
            echo "set terminal x11 $i size 650, 400" >> gnuplot.ina
      else
            echo "set terminal pdf color enhanced" >> gnuplot.ina
            echo "set output '$graphName'" >> gnuplot.ina            
      fi      

      counter=0
            
#            echo Procesando ${variables[i-1]}
            
            for j in $(seq $tini $tinc $tfin)
            do
                  counter=$((counter + 1))

                  # echo "$counter"
                  timeValue=$j
                  echo Procesando $timeValue
                  dirLog="./postProcessing/$lineSampleName/$timeValue/"
                  pathFile="$dirLog$fileName"

                  if [ "$counter" -eq 1 ]; then
                        echo "plot \"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\", $h" >> gnuplot.ina
#                        echo "plot \"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\", $h"
                  elif [ "$counter" -eq $numTimeSteps ]; then
                        echo "\"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\"" >> gnuplot.ina
#                        echo "\"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\""
                  else
                        echo "\"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\", $h" >> gnuplot.ina
#                        echo "\"$pathFile\" using 1:$colY with linespoints ls $counter title \"$timeValue\", $h"
                  fi

            done

done

if [ "$tipoTerminal" -eq 0 ]; then
      echo "------------------------------------------------------------------" 
      echo "      Output en window"
      echo "------------------------------------------------------------------"  
else
      echo "      Output pdf REVISE CARPETA DE CASO"
      echo "------------------------------------------------------------------"  
      echo
fi      

gnuplot gnuplot.ina -persist

echo "************************************************************************"
echo "Si aparece un error tipo set REVISAR QUE CON tinc CIERRE EXACTO EN tfin (multiplo)"
echo "Si cannot open file ... Permission denied el archivo esta abierto debe cerrarlo"
echo "************************************************************************"

rm gnuplot.i*
