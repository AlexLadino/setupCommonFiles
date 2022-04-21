#!/bin/bash
# generates plots from sample utility

monitorProbeName='probes1'
probesToPlot="0 1"
numProbesToPlot=2
tipoTerminal=0    # 0 window, 1 pdf, 2 svg

# MONITORES ENERALES
#monitorProbeName='integralPromedioP'
#probesToPlot="0"        # Siempre 0
#numProbesToPlot=1
#tipoTerminal=0    # 0 window, 1 pdf, 2 svg
#filesToPlot="0.00000000/volFieldValue.dat 50.00000000/volFieldValue.dat"
#variables=('IntP' 'IntP')
#espesor=('1' '1')
#numFilesToPlot=2
#numComponents=1
#yRange="[*:*]"
#xRange="[*:*]"

# # CAMPOS ESCALARES
# filesToPlot="0.00000000/p 0.00000230/pMean"
# # filesToPlot="0.10000000/p 0.10000000/pMean"
# variables=('p' 'pMean')
# espesor=('1' '1')
# numFilesToPlot=2
# numComponents=1
# yRange="[*:*]"
# xRange="[0.0001:*]"

# CAMPOS VECTORIALES
filesToPlot="0.00000000/U 0.00000249/UMean"
variables=('U' 'UMean')
espesor=('1' '1')
numFilesToPlot=2
numComponents=3
yRange="[*:*]"
xRange="[0.0001:*]"

# CAMPOS TENSORIALES SIMETRICOS
#filesToPlot="0.00001333/UPrime2Mean"
#variables=('UPrime2Mean')
#espesor=('1')
#numFilesToPlot=1
#numComponents=6   
#yRange="[*:*]"
#xRange="[*:*]"


echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "      MONITOR DE PROBES TRANSITORIOS"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "VERSION 1   VALIDADO EL PLOTEADO"
echo "            VERSIONES POSTERIORES SOLO MODIFICAN DETALLES DE PLOT"
echo 
echo  "Control de operacion"
echo  "Test de combinacion de casos"
echo  "0 1UND / 1 +UND"
echo  "Result     Probes      File        Component   "
echo  "OK         0           0           0           "  
echo  "FALLA      0           0           1           "           
echo  "OK         0           1           1           "
echo  "OK         1           1           1           "
echo  "OK         0           1           0           "
echo  "OK         1           1           0           "
echo  "OK         1           0           0           "
echo  "OK         1           0           1           "
echo
echo "SUMARIO DEL TRANSIENT"
echo
echo  "monitorProbeName = $monitorProbeName           Nombre de carpeta"
echo  "probesToPlot = $probesToPlot                   Desde cero inclusive"
echo  "numProbesToPlot = $numProbesToPlot             Debe ser igual al numero de probesToPlot"
echo  "tipoTerminal = $tipoTerminal                   0 window, 1 pdf, 2 svg"
echo
echo  "filesToPlot = $filesToPlot                     <path>/<nombre>"
echo  "variables = $variables                         1 a 1 con filesToPlot"
echo  "espesor = $espesor                             1 a 1 con filesToPlot espesor de linea"
echo  "numFilesToPlot = $numFilesToPlot               Igual al cantidad de filesToPlot"
echo  "numComponents = $numComponents                 1 escalar, 3 vectorial, 6 tensorial simetrico"
echo  "yRange = $yRange                               Rango en y-axis * es autoscale"
echo  "xRange = $xRange                               Rango en y-axis * es autoscale"
echo
echo "************************************************************************"


h='\'
rm gnuplot.in*
counter=0

numTotalLines=$((numProbesToPlot*numFilesToPlot))

rm gnuplot.in*
      for i in $(seq 1 1 $numComponents)
      do
      
      graphName="Component$i"
      echo "set xlabel 'tiempo'" >> gnuplot.in
      echo "set ylabel 'Variable'" >> gnuplot.in
      echo "set title 'Componente $i'" >> gnuplot.in
      echo "set grid x mx y my" >> gnuplot.in
      echo "set yrange $yRange" >> gnuplot.in
      echo "set xrange $xRange" >> gnuplot.in
                  
      #      echo "set lmargin 5" >> gnuplot.in
      #      echo "set bmargin -10" >> gnuplot.in
      #      echo "set yzeroaxis" >> gnuplot.in
      #      echo "set xzeroaxis" >> gnuplot.in

      #      echo "set ytics 0.2" >> gnuplot.in
      #      echo "set mytics 4" >> gnuplot.in
      #      echo "set xtics 0.1" >> gnuplot.in
      #      echo "set format x \"%2.2f\"" >> gnuplot.in
      #      echo "set mxtics 4" >> gnuplot.in            
            
      if [ "$tipoTerminal" -eq 0 ]; then
            echo "set terminal x11 $i size 650, 400" >> gnuplot.in
            
      elif [ "$tipoTerminal" -eq 1 ]; then
            echo "set terminal pdf color enhanced" >> gnuplot.in
            echo "set output '$graphName.pdf'" >> gnuplot.in                  
      else
            echo "set terminal svg enhanced size 650, 400" >> gnuplot.in
            echo "set output '$graphName.svg'" >> gnuplot.in            
      fi              
            
      counter=0      
    
      for k in $probesToPlot
      do
           
            nColYIni=$((1 + numComponents*k))
                       
            nColY=$((nColYIni + i))
                                 
            contarVar=0
            for j in $filesToPlot   
            do
                  
                  counter=$((counter + 1))
                                    
                  pathFile="./postProcessing/$monitorProbeName/$j"
                  
#                  echo "probe $k, componente $i, pathfile $pathFile, variable ${variables[contarVar]}"
                  
                  if [ "$counter" -eq 1 ]; then
                  
                        if [ "$numComponents" -eq 1 ]; then
                              echo "plot \"$pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]} title \"Probe $k - ${variables[contarVar]}\", $h" >> gnuplot.in
                        else
                              echo "plot \"< tr '(' ' ' < $pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]} title \"Probe $k - ${variables[contarVar]}\", $h" >> gnuplot.in
                        fi
      
                  elif [ "$counter" -eq $numTotalLines ]; then

                        if [ "$numComponents" -eq 1 ]; then
                              echo "\"$pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]}  title \"Probe $k - ${variables[contarVar]}\"" >> gnuplot.in
                        else
                              echo "\"< tr '(' ' ' < $pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]} title \"Probe $k - ${variables[contarVar]}\"" >> gnuplot.in
                        fi
                        
                  else
                  
                        if [ "$numComponents" -eq 1 ]; then
                              echo entra a una sola componente
                              echo "\"$pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]}  title \"Probe $k - ${variables[contarVar]}\", $h" >> gnuplot.in
                        else
                              echo "\"< tr '(' ' ' < $pathFile\" using 1:$nColY with lines lw ${espesor[contarVar]} title \"Probe $k - ${variables[contarVar]}\", $h" >> gnuplot.in
                        fi
                  fi
                  
                  contarVar=$((contarVar + 1))
                  
            done
            
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

gnuplot gnuplot.in -persist

echo "************************************************************************"
echo "Si aparece un error tipo set REVISAR QUE CON tinc CIERRE EXACTO EN tfin (multiplo)"
echo "Si cannot open file ... Permission denied el archivo esta abierto debe cerrarlo"
echo "************************************************************************"

#rm gnuplot.in*

