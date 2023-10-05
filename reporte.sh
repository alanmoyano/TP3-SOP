# HORA|TOTAL|OCUPADA|LIBRE|BÚFERS|CACHE|DISPONIBLE

texto=`cat /proc/meminfo | tr -s " "`

hora=`date | cut -d " " -f5 | cut -d ":" -f1,2`

total=`cat /proc/meminfo | tr -s ' ' | grep "MemTotal" | cut -d ' ' -f2`

libre=`cat /proc/meminfo | tr -s ' ' | grep "MemFree" | cut -d ' ' -f2`

buffers=`cat /proc/meminfo | tr -s ' ' | grep "Buffers" | cut -d ' ' -f2`

cache=$(expr `cat /proc/meminfo | tr -s ' ' | grep -w "Cached" | cut -d ' ' -f2` + `cat /proc/meminfo | tr -s ' ' | grep -w "SReclaimable" | cut -d ' ' -f2`)

disponible=`cat /proc/meminfo | tr -s ' ' | grep "Available" | cut -d ' ' -f2`

usada=`expr $total - $libre - $buffers - $cache`

echo "$hora|$total|$usada|$libre|$buffers|$cache|$disponible|" >> ~/ReporteDiario


if [ -e ~/ReporteDiario ];then

	if [ `cat ~/ReporteDiario | wc -l` -eq 1440 ];then
		mv ~/ReporteDiario ~/ReporteDiarioAnterior
	fi

fi
