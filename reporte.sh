#!/bin/bash

# HORA|TOTAL|OCUPADA|LIBRE|BÚFERS|CACHE|DISPONIBLE

# Creamos una constante con el nombre y ubicación del archivo temporal auxiliar
TEMPORAL="./temporal.tmp"

# Creamos el archivo temporal con los datos del archivo especial "/proc/meminfo" sin los espacios adicionales
cat /proc/meminfo | tr -s " " >$TEMPORAL

# Creamos todas las variables que refieren a cada campo necesario para el reporte
# Las formulas usadas fueron sacadas de `man free`
hora=$(date | cut -d " " -f4 | cut -d ":" -f1,2)

total=$(cat $TEMPORAL | grep "MemTotal" | cut -d ' ' -f2)

libre=$(cat $TEMPORAL | grep "MemFree" | cut -d ' ' -f2)

buffers=$(cat $TEMPORAL | grep "Buffers" | cut -d ' ' -f2)

cache=$(expr $(cat $TEMPORAL | grep -w "Cached" | cut -d ' ' -f2) + $(cat $TEMPORAL | grep "SReclaimable" | cut -d ' ' -f2))

disponible=$(cat $TEMPORAL | grep "Available" | cut -d ' ' -f2)

usada=$(expr $total - $libre - $buffers - $cache)

# Se genera y añade el reporte al archivo correspondiente
echo "$hora|$total|$usada|$libre|$buffers|$cache|$disponible|" >>~/ReporteDiario

# Se verifica que el reporte no haya excedido las líneas máximas por día
if [ -e ~/ReporteDiario ]; then

	# Si las excede, se actualiza el ReporteDiarioAnterior y se reinicia el ReporteDiario
	if [ $(cat ~/ReporteDiario | wc -l) -eq 1440 ]; then
		mv ~/ReporteDiario ~/ReporteDiarioAnterior
	fi

fi

# Se elimina el archivo temporal auxiliar
rm $TEMPORAL
