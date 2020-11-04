#!/bin/bash

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Color_Off='\033[0m'     # Text Reset

# Additional colors
LGray='\033[0;37m'      # Ligth Gray
DGray='\033[0;90m'      # Dark Gray
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan

# Background
On_Black='\033[40m'     # Black
On_Red='\033[41m'       # Red
On_Green='\033[42m'     # Green
On_Yellow='\033[43m'    # Yellow
On_Blue='\033[44m'      # Blue
On_Purple='\033[45m'    # Purple
On_Cyan='\033[46m'      # Cyan
On_White='\033[47m'     # White

if [[ "$1" && -f "$1" ]]; then
    FILE="$1"
else
    echo -e "\n${LBlue}[${Yellow}!${LBlue}] ${LGray}Especifica el fichero .csv a analizar${Color_Off}\n";
    echo 'Uso:';
    echo -e "\t${LGray}./parser.sh ${LCyan}Captura-01.csv${Color_Off}\n";
    exit
fi

test -f oui.txt 2>/dev/null

if [ "$(echo $?)" == "0" ]; then
    echo -e "\n${LGray}Número total de puntos de acceso: ${Red}`grep -E '([A-Za-z0-9._: @\(\)\\=\[\{\}\"%;-]+,){14}' $FILE | wc -l`${Color_Off}"
    echo -e "${LGray}Número total de estaciones: ${Red}`grep -E '([A-Za-z0-9._: @\(\)\\=\[\{\}\"%;-]+,){5} ([A-Z0-9:]{17})|(not associated)' $FILE | wc -l`${Color_Off}"
    echo -e "${LGray}Número total de estaciones no asociadas: ${Red}`grep -E '(not associated)' $FILE | wc -l`${Color_Off}"
    echo -e "\n${LBlue}Puntos de acceso disponibles:${Color_Off}"

    while read -r line ; do
        if [ "`echo "$line" | cut -d ',' -f 14`" != " " ]; then
            echo -e "${LGray}" `echo -e "$line" | cut -d ',' -f 14` "${Color_Off}"
        else
            echo -e " ${Red}No es posible obtener el nombre de la red (ESSID)${Color_Off}"
        fi

        fullMAC=`echo "$line" | cut -d ',' -f 1`
        echo -e "\tDirección MAC: $fullMAC"

        MAC=`echo "$fullMAC" | sed 's/ //g' | sed 's/-//g' | sed 's/://g' | cut -c1-6`

        result="$(grep -i -A 1 ^$MAC ./oui.txt)";

        if [ "$result" ]; then
            echo -e "\tVendor: `echo "$result" | cut -f 3`"
        else
            echo -e "\tVendor: ${Red}Información no encontrada en la base de datos${Color_Off}"
        fi

        is5ghz=`echo "$line" | cut -d ',' -f 4 | grep -i -E '36|40|44|48|52|56|60|64|100|104|108|112|116|120|124|128|132|136|140'`

        if [ "$is5ghz" ]; then
            echo -e "\t${Blue}Opera en 5 GHz!${Color_Off}"
        fi

        printonce="\tEstaciones:"

        while read -r line2 ; do

            clientsMAC=`echo $line2 | grep -E "$fullMAC"`
            if [ "$clientsMAC" ]; then

                if [ "$printonce" ]; then
                    echo -e $printonce
                    printonce=''
                fi

                echo -e "\t\t${Green}" `echo $clientsMAC | cut -d ',' -f 1` "${Color_Off}"
                MAC2=`echo "$clientsMAC" | sed 's/ //g' | sed 's/-//g' | sed 's/://g' | cut -c1-6`
    
                result2="$(grep -i -A 1 ^$MAC2 ./oui.txt)";
    
                if [ "$result2" ]; then
                    echo -e "\t\t\tVendor: `echo "$result2" | cut -f 3`"
                    ismobile=`echo $result2 | grep -i -E 'Olivetti|Sony|Mobile|Apple|Samsung|HUAWEI|Motorola|TCT|LG|Ragentek|Lenovo|Shenzhen|Intel|Xiaomi|zte'`
                    warning=`echo $result2 | grep -i -E 'ALFA|Intel'`
                    if [ "$ismobile" ]; then
                        echo -e "\t\t\t${Yellow}Es probable que se trate de un dispositivo móvil${Color_Off}"
                    fi
    
                    if [ "$warning" ]; then
                        echo -e "\t\t\t${Purple}El dispositivo soporta el modo monitor${Color_Off}"
                    fi
    
                else
                    echo -e "\t\t\tVendor: ${Black}${On_White}Información no encontrada en la base de datos${Color_Off}"
                fi
    
                probed=`echo $line2 | cut -d ',' -f 7`
    
                if [ "`echo $probed | grep -E [A-Za-z0-9_\\-]+`" ]; then
                    echo -e "\t\t\tRedes a las que el dispositivo ha estado asociado: $probed"
                fi
            fi
        done < <(grep -E '([A-Za-z0-9._: @\(\)\\=\[\{\}\"%;-]+,){5} ([A-Z0-9:]{17})|(not associated)' $FILE)
        
    done < <(grep -E '([A-Za-z0-9._: @\(\)\\=\[\{\}\"%;-]+,){14}' $FILE)
    
    echo -e "\n${LBlue}Estaciones no asociadas:${Color_Off}\n"
    
    while read -r line2 ; do
    
        clientsMAC=`echo $line2  | cut -d ',' -f 1`
    
        echo -e "${Green}" `echo $clientsMAC | cut -d ',' -f 1` "${Color_Off}"
        MAC2=`echo "$clientsMAC" | sed 's/ //g' | sed 's/-//g' | sed 's/://g' | cut -c1-6`
    
        result2="$(grep -i -A 1 ^$MAC2 ./oui.txt)";
    
        if [ "$result2" ]; then
            echo -e "\tVendor: `echo "$result2" | cut -f 3`"
            ismobile=`echo $result2 | grep -i -E 'Olivetti|Sony|Mobile|Apple|Samsung|HUAWEI|Motorola|TCT|LG|Ragentek|Lenovo|Shenzhen|Intel|Xiaomi|zte'`
            warning=`echo $result2 | grep -i -E 'ALFA|Intel'`
            if [ "$ismobile" ]; then
                echo -e "\t${Yellow}Es probable que se trate de un dispositivo móvil${Color_Off}"
            fi
            if [ "$warning" ]; then
                echo -e "\t${Purple}El dispositivo soporta el modo monitor${Color_Off}"
            fi
        else
            echo -e "\tVendor: ${Black}${On_White}Información no encontrada en la base de datos${Color_Off}"
        fi

        probed=`echo $line2 | cut -d ',' -f 7`

        if [ "`echo $probed | grep -E [A-Za-z0-9_\\-]+`" ]; then
            echo -e "\tRedes a las que el dispositivo ha estado asociado: $probed"
        fi
    
    done < <(grep -E '(not associated)' $FILE)
else
    echo -e "\n${LBlue}[${Yellow}!${LBlue}] ${LGray}Archivo oui.txt no encontrado, descárgalo desde aquí: ${LBlue}http://standards-oui.ieee.org/oui/oui.txt${Color_Off}\n"
fi