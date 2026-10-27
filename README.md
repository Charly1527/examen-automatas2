# Convertidor infijo a prefijo y tokenizador léxico

Proyecto en lenguaje C compuesto por dos programas independientes:

1. **`convertidor`**: transforma expresiones matemáticas de notación infija a prefija.
2. **`tokenizador`**: analiza código de un subconjunto de C y clasifica sus tokens.

Ambos programas incluyen menú interactivo, entrada por archivo y manejo de errores.

## Requisitos

- Compilador `gcc` compatible con C11.
- `make`.
- `bash` para ejecutar los scripts de prueba.

## Compilación

```bash
make
```

Esto genera los ejecutables `convertidor` y `tokenizador`.

## Uso

### Convertidor infijo a prefijo

```bash
# Menú interactivo
./convertidor

# Una expresión directamente
./convertidor --expresion "(A + B) * C"

# Procesar un archivo línea por línea
./convertidor --archivo pruebas.txt

# Ayuda
./convertidor --ayuda
```

Ejemplo:

```text
Entrada : (A + B) * C
Prefija : * + A B C
```

### Tokenizador léxico

```bash
./tokenizador
```

Opciones del menú:

```text
1) Introducir código por terminal
2) Procesar un archivo
0) Salir
```

## Pruebas

```bash
make test              # 17 pruebas del convertidor
make test-tokenizador  # 25 verificaciones del tokenizador
```

Los scripts comprueban conversiones correctas, entradas inválidas, categorías de tokens,
comentarios, literales y errores léxicos.

## Archivos principales

| Archivo | Descripción |
|---|---|
| `convertidor.c` | Código fuente del convertidor. |
| `tokenizador.c` | Código fuente del tokenizador. |
| `Makefile` | Compilación y ejecución de pruebas. |
| `pruebas.txt` | Expresiones de prueba del convertidor. |
| `pruebas_tokenizador.txt` | Código de prueba del tokenizador. |
| `pruebas_tokenizador_errores.txt` | Casos con errores léxicos. |
| `probar.sh` | Pruebas automatizadas del convertidor. |
| `probar_tokenizador.sh` | Pruebas automatizadas del tokenizador. |
| `documentacion/index.html` | Documentación detallada de todo el código. |

## Documentación

Para ver la explicación completa de ambos programas, abre:

```bash
xdg-open documentacion/index.html
```

También se puede abrir directamente el archivo `documentacion/index.html` desde un navegador.

## Notas

- El código compila con `-std=c11 -Wall -Wextra -Wpedantic` sin advertencias.
- El convertidor admite `+`, `-`, `*`, `/`, `%`, `^`, paréntesis y operadores unarios.
- El tokenizador reconoce palabras reservadas, tipos, identificadores, números, cadenas,
  caracteres, operadores, delimitadores y comentarios.
