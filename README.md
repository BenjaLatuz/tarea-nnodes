# Ruleta del Clima

Aplicación de ruleta que utiliza el clima actual para determinar las apuestas de los jugadores.

## Descripción

Este sistema simula una ruleta donde:
- Las rondas se generan automáticamente cada 3 minutos
- Los jugadores apuestan automáticamente basándose en el clima actual
- Los colores posibles son:
  - Verde (2% probabilidad)
  - Rojo (49% probabilidad)
  - Negro (49% probabilidad)
- Las ganancias dependen del color acertado:
  - Verde: 15 veces lo apostado
  - Rojo/Negro: 2 veces lo apostado

## Requisitos

- Ruby 3.2.8
- Rails 8.0.2
- SQLite3
- Node.js (para Tailwind CSS)

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/BenjaLatuz/tarea-nnode.git
cd tarea-nnode
```

2. Instalar las dependencias:
```bash
bundle install
```

3. Configurar la base de datos:
```bash
rails db:create
rails db:migrate
```

4. Precompilar los assets de Tailwind:
```bash
rails tailwindcss:build
```

## Desarrollo

Hay dos formas de ejecutar el servidor de desarrollo:

### 1. Desarrollo con Auto-reload de CSS

```bash
bin/dev
```

Este comando inicia dos procesos:
- El servidor de Rails en http://localhost:3000
- El compilador de Tailwind CSS en modo watch (recompila automáticamente cuando hay cambios)

### 2. Desarrollo Simple

```bash
rails tailwindcss:build
rails server
```

Este método funciona si ya has precompilado los assets de Tailwind (`rails tailwindcss:build`). 

> **Nota**: Si haces cambios en los estilos y usas `rails server`, necesitarás ejecutar `rails tailwindcss:build` para ver los cambios.

## Estructura del Proyecto

- `app/models/`: Modelos de la aplicación (Player, Round, Bet)
- `app/services/`: Servicios para clima y cálculos
- `app/controllers/`: Controladores
- `app/views/`: Vistas de la aplicación
