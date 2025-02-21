#!/bin/bash
# Ignoraren esto
SCRIPT_PATH="$(pwd)/ffmcap.sh"

# Asegurarse de que el script sea ejecutable
chmod +x "$SCRIPT_PATH"

if ! grep -q "alias ffmcap=" ~/.bashrc; then
  echo "Agregando alias a .bashrc..."
  echo "alias ffmcap='$SCRIPT_PATH'" >>~/.bashrc
  echo "Alias añadido."
else
  echo "El alias 'ffmcap' ya está configurado en .bashrc."
fi

source ~/.bashrc

clear

echo "====================================="
echo "           BIENVENIDOS A            "
echo "          ffmpeg-bash-god           "
echo "====================================="

echo ""
echo "¡Disfruta grabando tu pantalla! Espero te sea util, y recuerda apoyarme en mi"
echo "github: https://github.com/DumbNoxx"
echo ""

echo "Cargando..."
for i in {1..3}; do
  sleep 0.5
  echo -n "."
done
echo ""
# Función para verificar si ffmpeg está instalado
check_ffmpeg() {
  if command -v ffmpeg &>/dev/null; then
    echo "Ya tienes ffmpeg instalado que bien!!."
    return 0
  else
    echo "ffmpeg no está instalado."
    echo " "
    read -p "Quieres instalarlo (y/s/yes/YES/n/no/NO)" respuesta
    respuesta=${respuesta,,}
    if [[ "$respuesta" == *"y"* ]] || [[ "$respuesta" == *"s"* ]] || [[ "$respuesta" == *"si"* ]] || [[ "$respuesta" == *"yes"* ]]; then
      echo " "
      echo "Perfecto, vamos a ello"
      echo " "
      return 1
    elif [[ "$respuesta" == *"n"* ]] || [[ "$respuesta" == *"no"* ]]; then
      echo " "
      echo "Entiendo, puedes descargarlo por tu cuenta si deseas, si no, no podras ejecutar el programa"
      echo " "
      exit 0
    fi
  fi
}

# Función para instalar ffmpeg
install_ffmpeg() {
  echo "Instalando ffmpeg..."

  # Detección del gestor de paquetes
  if [ -x "$(command -v apt)" ]; then
    # Para distribuciones basadas en Debian/Ubuntu
    sudo apt update
    sudo apt install -y ffmpeg
  elif [ -x "$(command -v pacman)" ]; then
    # Para Arch Linux
    sudo pacman -Syu --noconfirm ffmpeg
  elif [ -x "$(command -v dnf)" ]; then
    # Para Fedora
    sudo dnf install -y ffmpeg
  elif [ -x "$(command -v yum)" ]; then
    # Para CentOS/RHEL
    sudo yum install -y ffmpeg
  elif [ -x "$(command -v zypper)" ]; then
    # Para openSUSE
    sudo zypper install -y ffmpeg
  else
    echo "No se pudo determinar el gestor de paquetes. Por favor, instala ffmpeg manualmente."
    exit 1
  fi
  echo " "
  echo "ffmpeg ha sido instalado."
  echo " "
}

# Verificar si ffmpeg está instalado
if ! check_ffmpeg; then
  install_ffmpeg
fi
# Pedir al usuario el tamaño del video
dimensions=$(xdpyinfo | grep dimensions)
echo " "
echo "Las dimensiones de su pantalla son:"
echo " "
echo "$dimensions"
echo " "
read -p "Ingrese la resolución del video (ejemplo: 1366x768): " video_size

# Pedir al usuario el framerayte
echo " "
echo "Los framerate son los FPS"
echo " "
read -p "Ingrese el framerate (ejemplo: 60):  " framerate

# Pedir al usuario la fuente de audio seleccionada
echo " "
echo "Fuentes de audio disponibles: "
pactl list sources short
echo " "
echo "La lista va desde el 1 hacia adelante, no se deje guiar por el indice de la lista"
echo " "
read -p "Ingrese la entrada de audio:  " audio_choice
audio_input=$(pactl list sources short | awk "NR==$audio_choice {print \$2}")

# Pedir al usuario la entrada de video
echo " "
read -p "Ingrese la entrada de video (ejemplo: :0.0): " video_input

# Pedir al usuario como se llamara el archivo
echo " "
read -p "Ingrese el nombre del archivo con la extension (ejemplo: output(sin la extensión)):" output_name

# Comando completo de ffmpeg
ffmpeg -f x11grab -video_size "$video_size" -framerate "$framerate" -i "$video_input" -f pulse -i "$audio_input" -map 0:v -map 1:a -c:v libx264 -preset ultrafast -crf 18 -c:a aac -b:a 192k "rendered_$output_name.mp4" 2>&1 |
  while IFS= read -r line; do
    if [[ "$line" == *"frame="* || "$line" == *"Lsize="* || "$line" == *"time="* ]]; then
      echo " "
      echo "$line"
    fi
  done &

# Mostrar el mensaje de grabación
echo " "
echo "Puedes cerrar la grabacion apretando [q]"
echo " "
echo "Grabando..."

# Esperar a que ffmpeg termine
wait
# Manejo de errores
if [ $? -eq 0 ]; then
  echo " "
  echo "Grabación completada con éxito."
  # Tomando el nombre de la variable por cualquier cosa que pueda suceder
  out_video="$output_name"
  # Ejecutando el renderizado
  ffmpeg -i "rendered_$output_name.mp4" -vcodec libx264 -af "anlmdn" -acodec aac "$out_video.mp4" 2>&1 |
    # Filtrando texto
    while IFS= read -r line; do
      if [[ "$line" == *"frame="* ]]; then
        echo " "
        echo "$line"
      fi
    done &
  echo " "
  echo "Renderizando..."
  # Esperar que el programa termine
  wait
  # Manejo de errores del renderizado
  if [ $? -eq 0 ]; then
    echo " "
    echo "Renderizado con Exito..."
    echo " "
    echo "Exportando..."
    echo " "
    # Eliminando el video anterior de la grabacion
    rm "rendered_$output_name.mp4"
  else
    echo " "
    echo "Hubo un error en el renderizado"
    echo " "
  fi
  echo " "
  echo "Saliendo..."
  echo " "
else
  echo " "
  echo "Hubo un error al grabar."
  echo " "
fi
