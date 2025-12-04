# Temas Avanzados de desarrollo de software


<img width="693" height="115" alt="Screenshot 2025-11-02 181621" src="https://github.com/user-attachments/assets/8accd650-b5fb-4641-b829-1879fa6d3bac" />

## **TECNOLÓGICO NACIONAL DE MÉXICO**
**INSTITUTO TECNOLÓGICO DE TIJUANA**

---
### **SUBDIRECCIÓN ACADÉMICA**
**DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN**

---

### **SEMESTRE:**
Agosto - Diciembre 2025

### **CARRERA:**
Ingeniería en Sistemas Computacionales

### **MATERIA:**
Temas avanzados de desarrollo de software

### **TÍTULO ACTIVIDAD:**
Examen

### **UNIDAD A EVALUAR:**
II

---

### **NOMBRE Y NÚMERO DE CONTROL DEL ALUMNO:**
* Morales Calvo Ángel Omar - 21212000
* Aganza Molina Abraham Armando - 19210455

### **NOMBRE DEL MAESTRO (A):**
Maribel Guerrero Luis


---

### **Objetivo**
<div align="justify">
De forma general se tiene propósito del desarrollo de una aplicación con las capacidades de mostrar datos estadísticos en un entorno educativo, de forma más específica se diseña un sistema para ayuda a los maestros en la toma de decisiones gracias a gráficos estadísticos qué permiten ver el desempeño de los alumnos registrados.
El profesor en turno puede revisar las tablas de información de los alumnos asi como poder agregar nuevos alumnos a su materia.

---

## **Desarrollo**

### **Introducción a la calidad**
La Calidad es uno de los puntos mas importantes en el desarrollo de una aplicacion,sistema o producto, son las bases fundamentales en las que se rige la estructura del proyecto, se incluyen como parte de los requisitos de desarrollo e impactan la percepcion al publico de la empresa.
Para el usuario, la calidad se traduce en la experiencia que tiene al interactuar con el software. Si el software falla en este punto, el impacto es inmediato y directo:

1. Satisfacción y Lealtad: Un software de alta calidad (rápido, intuitivo, sin errores) genera confianza y lealtad. El usuario percibe valor, reduce su frustración y es menos probable que cambie a un competidor.
2. Baja Calidad: Fomenta la frustración, las quejas públicas (redes sociales, foros) y la búsqueda activa de alternativas.
3. Importancia para la Empresa (Organización).
Para la empresa que desarrolla o posee el software, la calidad es una inversión que reduce costos y protege la reputación:

1. Reducción de Costos a Largo Plazo: Invertir en calidad (pruebas, buen diseño de código) al inicio reduce el costo total de propiedad (TCO). Corregir errores en etapas avanzadas (o, peor, después del lanzamiento) es exponencialmente más caro.
2. Mantenibilidad: El código de alta calidad es fácil de entender, modificar y mantener, reduciendo el tiempo y el costo de futuras actualizaciones o correcciones de errores.
3. Reputación y Marca: Un producto de calidad refuerza la marca como sinónimo de profesionalismo y fiabilidad, lo que facilita la captación de nuevos clientes.

Competencia y Venta

En un mercado saturado, la calidad es un diferenciador clave y una herramienta de venta esencial:

1. Ventaja Competitiva (VC): Un software que es notablemente más rápido, más seguro o más fácil de usar que el de la competencia puede justificar un precio más alto y dominar la cuota de mercado. La calidad se convierte en un argumento de venta primario.
2. Costo de la Inacción: Si los competidores ofrecen constantemente productos de mayor calidad, tu producto será percibido como obsoleto o inferior, forzando reducciones de precio que erosionan los márgenes de ganancia.
3. Cumplimiento Normativo: La calidad en el desarrollo a menudo implica el cumplimiento de normas legales (ej. privacidad de datos, GDPR, LOPD). El cumplimiento es una necesidad que permite la venta en ciertos mercados o sectores (como el educativo o el gubernamental).

### **Normas de calidad**
ISO/IEC 25010: Modelo de Calidad del Producto

Esta norma define las ocho características de calidad que debe cumplir. Al desarrollar y probar el sistema, debes asegurarte de que cumpla con los requisitos en estas áreas clave:
1. Adecuación Funcional: El software debe generar correctamente los diagramas (Pareto, Ishikawa, etc.) y los reportes, y los cálculos de reprobación deben ser correctos y completos.
2. Eficiencia de Desempeño: El sistema debe ser rápido al filtrar y analizar grandes volúmenes de datos (calificaciones, alumnofactor) y al generar gráficos.
3. Usabilidad: La Interfaz de Usuario (UI) debe ser intuitiva (fácil de entender y usar) para el docente, permitiendo seleccionar semestres y variables con facilidad.
4. Fiabilidad: El sistema debe funcionar de manera estable y estar disponible (sin caídas) y debe asegurar la integridad de los datos (las calificaciones y factores no se pierden ni se corrompen).
5. Seguridad: Proteger los datos sensibles de los alumnos (calificaciones, factores, información personal) y asegurar que solo el docente con acceso pueda ver/exportar la información.
6. Mantenibilidad: El código debe ser fácil de modificar, corregir y adaptar a futuras necesidades, como agregar nuevos tipos de reportes o factores.
7. Compatibilidad: Capacidad de interoperar con el entorno, especialmente al Exportar archivos a formatos estándar (CSV, Excel, PDF).
8. Portabilidad: Capacidad de funcionar en diferentes entornos (ej. si el docente usa Windows, Mac o Linux).

**ISO/IEC 25012: Modelo de Calidad de Datos**

Esta norma es crucial para el programa, ya que se enfoca en la calidad de los datos (Calificaciones, Factores, Registros de Alumnos).
Exactitud: Que las notas registradas sean las notas reales del alumno.
Completitud: Que todos los alumnos tengan registro de sus calificaciones y, si aplica, de sus factores de riesgo.
Consistencia: Que la información de un alumno sea coherente en todas las tablas (ej. que la fecha_nacimiento sea lógica).

**ISO/IEC 27001 - Seguridad de la Información**

Dado que el sistema maneja datos sensibles (calificaciones, desempeño, factores de riesgo/deserción), la implementación de un Sistema de Gestión de Seguridad de la Información (SGSI) basado en ISO/IEC 27001 es fundamental.

Propósito: Garantizar la confidencialidad, integridad y disponibilidad de los datos.

Aplicación: Cubre aspectos como control de acceso, cifrado, copias de seguridad y manejo de incidentes de seguridad para la información de los estudiantes.

**ISO 21001 - Sistemas de Gestión para Organizaciones Educativas**

Si bien esta norma se aplica a la organización educativa en general, el software debe ser una herramienta que apoye este sistema de gestión.

Propósito: Proporcionar un marco para la gestión que mejore la satisfacción de los alumnos y partes interesadas.

Aplicación: El programa de análisis de datos es una herramienta clave de la ISO 21001, ya que permite la evaluación del desempeño educativo y la mejora continua basada en evidencia (los reportes y gráficos).

### **Explicación de las tecnologías**

1. Flutter (Frontend (Cliente Móvil)):	Es el framework que permite construir la interfaz de usuario y toda la lógica del cliente. Permite compilar la aplicación.
2. MySQL (Backend (Base de Datos)):	Almacena toda la información académica (alumnos, maestros, calificaciones, etc.) que se necesita para el análisis.
3. Android Studio (Entorno de Desarrollo (IDE)):	Es la herramienta donde escribes el código Flutter, compilas la aplicación y simulas/pruebas la versión Android.
4. Dart (Lenguaje de Programación):	Es el lenguaje principal usado en Flutter para escribir toda la lógica del cliente, incluyendo la manipulación de datos (\models) y las peticiones a la API.

### **Diagrama uml**

<img width="2243" height="2280" alt="Untitled diagram-2025-11-03-123919" src="https://github.com/user-attachments/assets/ecc257f2-0dd3-4ce6-bc58-ea84988c3f2c" />


### **Diagrama de relación de la base de datos**

<img width="7306" height="3384" alt="Untitled diagram-2025-11-03-123531" src="https://github.com/user-attachments/assets/f1ca0969-3968-458a-b404-1c16bdc5fb6b" />



### **Manual de usuario**

### **Resultados**

### **Conclusiones**
**Abraham Armando Aganza molina**

Los modelos de calidad son una herramienta poderosa para identificar datos de manera sencilla, su manera visual de representar los datos nos permite explicar datos a personas que no tienen el conocimiento de uso de tablas de base de datos, lo cual es eficiente para dar a entender una idea, lo cual es imprescindibles a la hora de presentar un proyecto a una empresa o stakeholder que este interesado en tu proyecto.
No solo eso permiten corregir errores a la hora de desarrollar un sistema o producto, la forma en la que se crea una relacion en los datos aumenta considerablemente la identificaciones de posibles errores en el plan de desarrollo de un producto
Las metricas de calidad son importantes en el dia a dia, estamos en tiempos de competencia tecnologica donde los clientes y empresas busacan ciertos requisitos para comprar un proyecto, es necesario cumplir con estas mdeidads para garantizar un producto con un nivel de competencia que sobreviva en el mercado


### **Recomendaciones**
1. Normalizar los datos a utilizar para tener un mejor control y darle un mejor aspecto visaul con consistencia.
2. Crear un plan de desarrollo con requisitos a cumplir para aumentar la calidad del producto
3. Seguir las normas iso a la hora de desarrollar un sistema comercial
4. Ser las buenas practicas para trabajar en equipo de forma eficaz, esto mas importante si se utilizan base de datos
5. cumplir con las funcionalidades basicas para el proyecto y de ahi ir mejorando el sistema.
6. Tener un cronograma de actividades a seguir para no perder el tiempo
7. Si se tienen datos sensibles en la base de datos, tener medidas de seguridad necesarias

</div>

---

# REPOSITORIO
Aplicación académica que permite a los docentes autenticarse, ver su panel, gestionar información educativa, y visualizar estadísticas. El proyecto está pensado para ejecutarse rápidamente en un navegador, así como en dispositivos móbiles.

Se debe verificar que flutter está instalado correctamente, con el siguiente comando:

```
flutter doctor
```

## Instalación
Para instalar el proyecto, debes clonar el repositorio:

```
git clone https://github.com/Angelburgie22/tads.git

cd tads
```

Luego, una vez dentro del proyecto, instala las dependencias:

```
flutter pub get
```


## Configuración del entorno
La app lee las variables desde un archivo .env en la raíz del proyecto. Para lograr esto, se utiliza una dependencia que permite leer variables de entorno.

Para que la dependencia pueda leerlos, debes de crear un archivo `.env` en la raíz del proyecto (al mismo nivel que `pubspec.yaml`).

Después debes agregar la URL base de tu API:

```
API_URL=https://tuservidor.com/api
```

Si el backend está en local, entonces:

```
API_URL=http://localhost:8000/api
# o si estás desde un dispositivo/emulador cambia el host según tu red local
```

## Cómo ejecutar el proyecto
Para correr el proyecto en web (Chrome), ejecuta el siguiente comando:

```
flutter run -d chrome
```

Esto ejecuta la aplicación en el navegador, permitiendo probar sin necesidad de un emulador o dispositivo físico móvil, además de que permite visualizar la responsividad en acción.

Si se quiere cambiar de dispositivo, basta con especificarlo en la bandera `-d`.

## Estructura del proyecto
El proyecto posee la siguiente estructura:

```
\assets
    logo_tec.svg # Logo para la pantalla de login
\lib
    \api
        endpoints.dart # Define las cadenas de los endpoints a los que la app hace las peticiones
    \core
        \network
            api_service.dart # Configura Dio (paquete para hacer networking HTTP) para saber cómo reaccionar a distintos códigos HTTP, cuánto tiempo esperar para conectar y recibir una respuesta, entre otros
        \storage
            secure_storage_service.dart # Define funciones básicas como guardar token de autenticación y los datos del usuario en el almacenamiento seguro del dispositivo
        layout_scaffold.dart # Define la barra de navegación con las pestañas de la aplicación
        router_observer.dart # Define cómo se comporta cuando se redirege o retrocede a una pantalla
        router.dart # Registro de las distintas pantallas en las varias rutas nombradas para que la aplicación sepa cómo navegar en estas
        routes.dart # Define las cadenas de las rutas de las pantallas, que se asocian en router.dart
    \features
        \auth
            \controllers
                login_controller.dart # Controla el estado del inicio de sesión, y qué datos se guardan en el dispositivos cuando se inicia sesión
            \data_sources
                auth_local_data_source.dart # Define funciones para obtener datos del usuario localmente en el dispositivo
                auth_remote_data_source.dart # Define funciones de autorización para interactuar con la API
            \models
                login_response.dart # Define el modelo de la respuesta que se espera cuando se inicia sesión
                user_dto.dart # Define el modelo del usuario obtenido cuando se inicia sesión, que se emplea en login_response.dart y en otros lados de la aplicación
            \presentation
                login_page.dart # Crea la interfaz de la pantalla de inicio de sesión
            \repositories
                auth_repository_impl.dart # Agrega la implementación de las funciones login y logout
                auth_repository.dart # Define las funciones login y logout
            \widgets
                login_form.dart # Crea el formulario de inicio de sesión con los campos de correo y contraseña, y botón de Iniciar sesión, que envía los datos y actúa acordemente
        \dashboard
            \presentation
                dashboard_page.dart # Define la pantalla de panel de control que contiene información y acciones que puede hacer el maestro
        \settings
            \presentation
                settings_page.dart # Define la pantalla de ajustes con el botón de Cerrar sesión
    \models
        navigation_tabs.dart # Estructura que guarda las pestañas (nombre e ícono) que se renderizan en la barra de navegación
    \providers
        route_notifier.dart # Notifica cuando se cambia de pantalla
    \shared
        \components
            login_background.dart # Fondo de gradiente que se utiliza en la pantalla de inicio de sesión
            login_button.dart # Botón de inicio de sesión
        \theme
            colors.dart # Estructura con los colores que se utilizan a lo largo de la interfaz
    main.dart # Punto de entrada de la aplicación
.env # Archivo que guarda variables de entorno
```

### De momento solo debe de funcionar el login
