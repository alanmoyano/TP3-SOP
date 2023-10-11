#!/bin/bash

# Se verifica que se haya ingresado el parámetro hora
if [ -z "$1" ]; then
    echo "No se ingresó el parámetro <hora>"

# Se verifica que el parámetro ingresado posea el formato de hora deseado ('12:00' por ejemplo)
# Se cuentan los caracteres de la salida del grep y se comparan con 6, puesto que una hora del formato correcto debería tener 5 caracteres, más 1 que es el salto de línea
elif [ $(echo $(echo "$1" | grep -E "[0-9]{2}:[0-9]{2}") | wc -m) -eq 6 ]; then

    # Creamos la variable que contendrá el renglón de la hora especifica que se ingresó
    texto=$(cat ~/ReporteDiario | grep $1)

    # Verificamos que exista un reporte de dicha hora
    if [ -z $texto ]; then
        echo "No existe un reporte de la hora ingresada"

    # Si existe reporte, es mostrado al usuario
    else
        echo "Memoria Total:       $(echo $texto | cut -d '|' -f2) KB"
        echo "Memoria Ocupada:     $(echo $texto | cut -d '|' -f3) KB"
        echo "Memoria Libre:       $(echo $texto | cut -d '|' -f4) KB"
        echo "Memoria en Búfers:   $(echo $texto | cut -d '|' -f5) KB"
        echo "Memoria en Caché:    $(echo $texto | cut -d '|' -f6) KB"
        echo "Memoria Disponible:  $(echo $texto | cut -d '|' -f7) KB"
    fi

# En el caso de que las 2 verificaciones anteriores hayan fallado, se informa el error al usuario
else
    echo "Error al ingresar el parámetro <hora>"
fi
