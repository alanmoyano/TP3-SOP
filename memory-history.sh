#!/bin/bash

if [ $(echo $(echo "$1" | grep -E "[0-9]{2}:[0-9]{2}") | wc -m) -eq 6 ]; then

    texto=$(cat ~/ReporteDiario | grep $1)

    if [ -z $texto ]; then
        echo "No existe un reporte de la hora ingresada"

    else
        echo "Memoria Total:       $(echo $texto | cut -d '|' -f2) KB"
        echo "Memoria Ocupada:     $(echo $texto | cut -d '|' -f3) KB"
        echo "Memoria Libre:       $(echo $texto | cut -d '|' -f4) KB"
        echo "Memoria en Búfers:   $(echo $texto | cut -d '|' -f5) KB"
        echo "Memoria en Caché:    $(echo $texto | cut -d '|' -f6) KB"
        echo "Memoria Disponible:  $(echo $texto | cut -d '|' -f7) KB"
    fi

elif [ -z "$1" ]; then
    echo "No se ingresó el parámetro <hora>"

else
    echo "Error al ingresar el parámetro <hora>"

   # (.)(.)
