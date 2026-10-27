#!/usr/bin/env bash

set -u

PROGRAMA="./convertidor"

if [[ ! -x "$PROGRAMA" ]]; then
    echo "Error: no existe '$PROGRAMA'. Ejecuta 'make' primero." >&2
    exit 1
fi

casos=(
    "A + B * C|+ A * B C"
    "(A + B) * C|* + A B C"
    "A + B * C - D / E|- + A * B C / D E"
    "2 ^ 3 ^ 2|^ 2 ^ 3 2"
    "(A + B) * (C - D) / E ^ F|/ * + A B - C D ^ E F"
    "-A * (B + C)|* - A + B C"
    "123 + 45 * 6|+ 123 * 45 6"
    "variable_1 + total_2 * 3|+ variable_1 * total_2 3"
    "((A + B) * C - D / E) ^ 2|^ - * + A B C / D E 2"
    "A * -B + C|+ * A - B C"
    "a / (b - c) % d|% / a - b c d"
    "3.14 * .5 + 7.|+ * 3.14 .5 7."
)

pruebas_totales=0
pruebas_fallidas=0

for caso in "${casos[@]}"; do
    entrada="${caso%%|*}"
    esperado="${caso#*|}"
    salida=$("$PROGRAMA" --expresion "$entrada")
    estado=$?
    prefija=$(printf '%s\n' "$salida" | sed -n 's/^Prefija : //p')
    pruebas_totales=$((pruebas_totales + 1))

    if [[ $estado -eq 0 && "$prefija" == "$esperado" ]]; then
        printf 'OK    %-36s -> %s\n' "$entrada" "$prefija"
    else
        printf 'FALLO %-36s -> esperado "%s", obtenido "%s"\n' \
            "$entrada" "$esperado" "$prefija"
        pruebas_fallidas=$((pruebas_fallidas + 1))
    fi
done

# Entradas inválidas: el programa debe terminar con código distinto de cero.
entradas_invalidas=(
    "A + * B"
    "(A + B"
    "A + B)"
    "A @ B"
    ""
)

for entrada in "${entradas_invalidas[@]}"; do
    "$PROGRAMA" --expresion "$entrada" >/dev/null 2>&1
    estado=$?
    pruebas_totales=$((pruebas_totales + 1))

    if [[ $estado -ne 0 ]]; then
        printf 'OK    %-36s -> error detectado\n' "$entrada"
    else
        printf 'FALLO %-36s -> debía detectar un error\n' "$entrada"
        pruebas_fallidas=$((pruebas_fallidas + 1))
    fi
done

printf '\n%d prueba(s), %d fallo(s).\n' "$pruebas_totales" "$pruebas_fallidas"

if [[ $pruebas_fallidas -ne 0 ]]; then
    exit 1
fi

exit 0
