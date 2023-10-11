#!/bin/bash

# Se crea una constante en la que se almacenará el directorio en donde se guardarán los reportes
DIRECTORIO=$HOME

# Se verifica la existencia del reporte (por las dudas)
if [ -e $DIRECTORIO/ReporteDiario ]; then
	# Se verifica que el reporte no vaya a exceder las líneas máximas por día
	# Si las excedería, se actualiza el ReporteDiarioAnterior y se reinicia el ReporteDiario agregándole el primer reporte del día
	if [ $(cat $DIRECTORIO/ReporteDiario | wc -l) -eq 1399 ]; then
		mv $DIRECTORIO/ReporteDiario $DIRECTORIO/ReporteDiarioAnterior
	fi
fi

# Creamos una constante con el nombre y ubicación del archivo temporal auxiliar
TEMPORAL="./temporal.tmp"

# Creamos el archivo temporal con los datos del archivo especial "/proc/meminfo" sin los espacios adicionales
cat /proc/meminfo | tr -s " " >$TEMPORAL

# Creamos la variable que contendrá la hora de ejecución del script
hora=$(date | cut -d " " -f4 | cut -d ":" -f1,2)

# Creamos todas las variables que refieren a cada campo necesario para el reporte
# Las formulas usadas fueron sacadas de `man free`
total=$(cat $TEMPORAL | grep "MemTotal" | cut -d ' ' -f2)
libre=$(cat $TEMPORAL | grep "MemFree" | cut -d ' ' -f2)
buffers=$(cat $TEMPORAL | grep "Buffers" | cut -d ' ' -f2)
# Se usa la opción -w en el grep, para evitar que aparezca la línea "SwapCached" que también forma parte del archivo especial "/proc/meminfo"
cache=$(expr $(cat $TEMPORAL | grep -w "Cached" | cut -d ' ' -f2) + $(cat $TEMPORAL | grep "SReclaimable" | cut -d ' ' -f2))
disponible=$(cat $TEMPORAL | grep "Available" | cut -d ' ' -f2)

# Calculamos finalmente la memoria usada
usada=$(expr $total - $libre - $buffers - $cache)

# Se genera y añade el reporte al archivo correspondiente
echo "$hora|$total|$usada|$libre|$buffers|$cache|$disponible|" >>$DIRECTORIO/ReporteDiario

# Se elimina el archivo temporal auxiliar
rm $TEMPORAL
