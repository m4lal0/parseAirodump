# parseAirodump
<p align="center" style="color:#4169e1">
┏━━━┓━━━━━━━━━━━━━━━━━━━━┏━━━┓━━━━━━━━━━━┏┓━━━━━━━━━━━━
┃┏━┓┃━━━━━━━━━━━━━━━━━━━━┃┏━┓┃━━━━━━━━━━━┃┃━━━━━━━━━━━━
┃┗━┛┃┏━━┓━┏━┓┏━━┓┏━━┓━━━━┃┃━┃┃┏┓┏━┓┏━━┓┏━┛┃┏┓┏┓┏┓┏┓┏━━┓
┃┏━━┛┗━┓┃━┃┏┛┃━━┫┃┏┓┃━━━━┃┗━┛┃┣┫┃┏┛┃┏┓┃┃┏┓┃┃┃┃┃┃┗┛┃┃┏┓┃
┃┃━━━┃┗┛┗┓┃┃━┣━━┃┃┃━┫━━━━┃┏━┓┃┃┃┃┃━┃┗┛┃┃┗┛┃┃┗┛┃┃┃┃┃┃┗┛┃
┗┛━━━┗━━━┛┗┛━┗━━┛┗━━┛━━━━┗┛━┗┛┗┛┗┛━┗━━┛┗━━┛┗━━┛┗┻┻┛┃┏━┛
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━
</p>
Script en Bash para representar toda la información de los datos capturados sobre una red objetivo al correr Airodump.

## Instalación
```bash
git clone https://github.com/m4lal0/parseAirodump
cd parseAirodump
chmod +x parseAirodump.sh
```

## Uso
Primero deberas capturar todo el trafico de todas las redes disponibles en el entorno en un fichero:
```bash
airodump-ng wlan0mon -w Captura
```
¿Por qué íbamos a querer hacer esto?, bueno, desde airodump-ng, en el momento de escanear las redes del entorno, lo vemos todo claro, bien representado, sin embargo, una vez las evidencias son exportadas al fichero especificado, ya la manera de representar los datos no son los mismos.

Por ello vamos a ejecutar el script para Parsear las redes del entorno:

```bash
./parseAirodump.sh Captura.csv
```

Como vemos, la primera vez que lo corremos, en caso de no contar con el fichero **'oui.txt'**, se genera un pequeño aviso para avisar de que necesitamos descargarlo para correr el script, pues en caso contrario los datos no serán bien representados.

Una vez realizado lo anterior, vuelve a ejecutar el script.