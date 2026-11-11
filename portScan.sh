#!/bin/bash 


function ctrl_c(){
    echo -e "\n\n[!] Saliendo...\n"
  tput cnorm; exit 1
}
#Ctrl + C
trap ctrl_c SIGINT
#declare -a ports=( $(seq 1 65535) )
count=0
MAX_JOBS=50

function checkPort(){

  (exec 3<> /dev/tcp/$1/$2) 2>/dev/null

  if [ $? -eq 0 ]; then
    echo -e "[+] Host $1 - port $2 OPEN"
  fi
  
}

tput civis #Ocultar cursor
if [ $1 ]; then
  for ((port=1; port<=65535; port++)); do 
    checkPort $1 $port &

    ((count++))

    if ((count >= MAX_JOBS)); then
        wait -n
        ((count--))
    fi
  done 
else
 echo -e "\n[!] Uso: $0 <ip-address>\n" 
fi
tput cnorm #Recuperar cursor
