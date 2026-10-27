#!/usr/bin/env bash

set -u

PROGRAMA="./tokenizador"
ARCHIVO_VALIDO="pruebas_tokenizador.txt"
ARCHIVO_ERRORES="pruebas_tokenizador_errores.txt"
TOTAL=0
FALLOS=0

if [[ ! -x "$PROGRAMA" ]]; then
    echo "Error: no existe '$PROGRAMA'. Ejecuta 'make' primero." >&2
    exit 1
fi

comprobar_contiene() {
    local descripcion="$1"
    local salida="$2"
    local patron="$3"

    TOTAL=$((TOTAL + 1))

    if grep -Eq -- "$patron" <<< "$salida"; then
        printf 'OK    %s\n' "$descripcion"
    else
        printf 'FALLO %s\n' "$descripcion"
        FALLOS=$((FALLOS + 1))
    fi
}

comprobar_no_contiene() {
    local descripcion="$1"
    local salida="$2"
    local patron="$3"

    TOTAL=$((TOTAL + 1))

    if ! grep -Eq -- "$patron" <<< "$salida"; then
        printf 'OK    %s\n' "$descripcion"
    else
        printf 'FALLO %s\n' "$descripcion"
        FALLOS=$((FALLOS + 1))
    fi
}

SALIDA_TERMINAL=$(printf '1\nint x = 42; if (x != 0) { x = x + 1; }\n0\n' |
    "$PROGRAMA" 2>&1)

comprobar_contiene "entrada por terminal: tipo int" \
    "$SALIDA_TERMINAL" 'TIPO_DATO[[:space:]]+int'
comprobar_contiene "entrada por terminal: identificador x" \
    "$SALIDA_TERMINAL" 'IDENTIFICADOR[[:space:]]+x'
comprobar_contiene "entrada por terminal: operador !=" \
    "$SALIDA_TERMINAL" 'OPERADOR[[:space:]]+!='
comprobar_contiene "entrada por terminal: entero 42" \
    "$SALIDA_TERMINAL" 'ENTERO[[:space:]]+42'
comprobar_contiene "entrada por terminal: palabra reservada if" \
    "$SALIDA_TERMINAL" 'PALABRA_RESERVADA[[:space:]]+if'
comprobar_contiene "entrada por terminal: punto y coma" \
    "$SALIDA_TERMINAL" 'PUNTO_Y_COMA[[:space:]]+;'
comprobar_contiene "entrada por terminal sin errores" \
    "$SALIDA_TERMINAL" 'Errores léxicos: 0'

SALIDA_ARCHIVO=$(printf '2\n%s\n0\n' "$ARCHIVO_VALIDO" | "$PROGRAMA" 2>&1)

comprobar_contiene "archivo: palabra reservada while" \
    "$SALIDA_ARCHIVO" 'PALABRA_RESERVADA[[:space:]]+while'
comprobar_contiene "archivo: tipo char" \
    "$SALIDA_ARCHIVO" 'TIPO_DATO[[:space:]]+char'
comprobar_contiene "archivo: número decimal" \
    "$SALIDA_ARCHIVO" 'DECIMAL[[:space:]]+3\.0'
comprobar_contiene "archivo: cadena" \
    "$SALIDA_ARCHIVO" 'CADENA[[:space:]]+"Hola, mundo!"'
comprobar_contiene "archivo: carácter" \
    "$SALIDA_ARCHIVO" "CARACTER[[:space:]]+'A'"
comprobar_contiene "archivo: operador >=" \
    "$SALIDA_ARCHIVO" 'OPERADOR[[:space:]]+>='
comprobar_contiene "archivo: operador &&" \
    "$SALIDA_ARCHIVO" 'OPERADOR[[:space:]]+&&'
comprobar_contiene "archivo: operador !=" \
    "$SALIDA_ARCHIVO" 'OPERADOR[[:space:]]+!='
comprobar_contiene "archivo procesado sin errores" \
    "$SALIDA_ARCHIVO" 'Errores léxicos: 0'
comprobar_no_contiene "archivo: comentario de línea ignorado" \
    "$SALIDA_ARCHIVO" 'Este comentario se ignora'
comprobar_no_contiene "archivo: comentario de bloque ignorado" \
    "$SALIDA_ARCHIVO" 'Comentario[[:space:]]+de bloque'

SALIDA_ERRORES=$(printf '2\n%s\n0\n' "$ARCHIVO_ERRORES" | "$PROGRAMA" 2>&1)

comprobar_contiene "errores: carácter no permitido" \
    "$SALIDA_ERRORES" 'Carácter no permitido'
comprobar_contiene "errores: cadena sin cerrar" \
    "$SALIDA_ERRORES" 'Cadena sin cerrar'
comprobar_contiene "errores: comentario sin cerrar" \
    "$SALIDA_ERRORES" 'Comentario de bloque sin cerrar'
comprobar_contiene "errores: resumen de tres errores" \
    "$SALIDA_ERRORES" 'Errores léxicos: 3'
comprobar_contiene "errores: continúa tras el error" \
    "$SALIDA_ERRORES" 'DECIMAL[[:space:]]+3\.5'

SALIDA_RUTA_INVALIDA=$(printf '2\narchivo_que_no_existe.txt\n0\n' |
    "$PROGRAMA" 2>&1)

comprobar_contiene "archivo inexistente informado" \
    "$SALIDA_RUTA_INVALIDA" 'No se pudo abrir el archivo'

SALIDA_OPCION_INVALIDA=$(printf '9\n0\n' | "$PROGRAMA" 2>&1)

comprobar_contiene "opción de menú inválida" \
    "$SALIDA_OPCION_INVALIDA" 'Opción no válida'

printf '\n%d prueba(s), %d fallo(s).\n' "$TOTAL" "$FALLOS"

if [[ $FALLOS -ne 0 ]]; then
    exit 1
fi

exit 0
