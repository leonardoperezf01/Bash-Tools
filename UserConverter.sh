#!/bin/bash

export_file=""

generar_ad() {
    local nombre="$1"
    local ape1="$2"
    local ape2="$3"

    nombre=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
    ape1=$(echo "$ape1" | tr '[:upper:]' '[:lower:]')
    ape2=$(echo "$ape2" | tr '[:upper:]' '[:lower:]')

    local inicial="${nombre:0:1}"

    echo "$inicial.$ape1"
    echo "$inicial.$ape1$ape2"
    echo "$nombre.$ape1"
    echo "$nombre.$ape1$ape2"
}

active_dir() {
    local ruta="$1"

    while IFS=' ' read -r nombre apellido1 apellido2; do
        [[ -z "$nombre" ]] && continue

        echo "Usuario: $nombre $apellido1 $apellido2"

        generar_ad "$nombre" "$apellido1" "$apellido2"

        if [[ -n "$export_file" ]]; then
            generar_ad "$nombre" "$apellido1" "$apellido2" >> "$export_file"
        fi

        echo
    done < "$ruta"
}


archivos() {
    ruta="$1"

    if [[ -f "$ruta" ]]; then
        active_dir "$ruta"
    else
        echo "El archivo no existe"
        exit 1
    fi
}

while getopts "af:e:" opt; do
    case "$opt" in
        a)
            echo "Active Directory (-a)"
            ;;
        f)
            archivos "$OPTARG"
            ;;
        e)
            export_file="$OPTARG"
            echo "Exportando resultados a: $export_file"
            > "$export_file"   # Vaciar archivo antes de escribir
            ;;
        *)
            echo "Uso: $0 -a -e salida.txt -f archivo"
            exit 1
            ;;
    esac
