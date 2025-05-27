# Ruleta del Clima

Aplicación de ruleta que utiliza el clima actual para determinar las apuestas de los jugadores.

## Descripción

Este sistema simula una ruleta donde:
- Las rondas se generan automáticamente cada 3 minutos
- Los jugadores apuestan automáticamente basándose en el clima actual
- Si existe una temperatura pronosticada dentro de los próximos 5 días mayor a 23 grados, las apuestas estarán entre el 3% y el 7%. Si no estarán entre el 5% y el 12%
- Las apuestas también son automáticas según porcentajes.
- Los colores posibles son:
  - Verde (2% probabilidad)
  - Rojo (49% probabilidad)
  - Negro (49% probabilidad)
- Las ganancias dependen del color acertado:
  - Verde: 15 veces lo apostado
  - Rojo/Negro: 2 veces lo apostado
- Los jugadores reciben $10,000 cada hora automáticamente (en cada XX:00)

- De todas formas existen botones que permiten simular las acciones sin tener que esperar el tiempo de generación automática

## Requisitos

- Ruby 3.2.8
- Rails 8.0.2
- PostgreSQL 12 o superior
- Node.js (para Tailwind CSS)
- Redis (para Sidekiq)

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
# Instalar PostgreSQL si no está instalado
sudo apt update
sudo apt install postgresql postgresql-contrib

# Iniciar el servicio
sudo service postgresql start

# Crear usuario y base de datos
sudo -u postgres createuser --superuser tu_usuario
createdb tarea_nnode_development

# Configurar variables de entorno
# Crear archivo .env en la raíz del proyecto con:
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_password

# Crear y migrar la base de datos
rails db:create db:migrate
```

4. Precompilar los assets de Tailwind:
```bash
rails tailwindcss:build
```

5. Configurar variables de entorno para Sidekiq y API de Openweather:
```bash
# Crear archivo .env en la raíz del proyecto
OPENWEATHER_API_KEY=tu_api_key_aquí
REDIS_URL=redis://localhost:6379/0
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

### 3. Ejecutar Sidekiq (para jobs automáticos)

En una terminal separada:
```bash
bundle exec sidekiq
```

Esto iniciará:
- Generación automática de rondas cada 3 minutos
- Actualización automática del dinero de los jugadores cada hora

## Tests

Para ejecutar los tests:

```bash
# Preparar la base de datos de test
rails db:test:prepare

# Ejecutar todos los tests
rails test

# Ejecutar tests específicos
rails test test/models/player_test.rb
rails test test/services/round_generator_service_test.rb
```

## Estructura del Proyecto

- `app/models/`: Modelos de la aplicación (Player, Round, Bet)
- `app/services/`: Servicios para clima y cálculos de apuesta
- `app/controllers/`: Controladores
- `app/views/`: Vistas de la aplicación
- `app/jobs/`: Jobs de Sidekiq para tareas automáticas
- `config/initializers/`: Configuración de Sidekiq y otros servicios

