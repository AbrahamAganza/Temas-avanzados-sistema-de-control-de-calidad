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
3. Importancia para la Empresa (Organización)

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
Se tiene como pantalla principal un login basico de usuario para maestro, los logins solo se pueden conseguir mediante la insercion de usario en la base de datos, es decir directamente con el encargado de las base de datos
<img width="1235" height="643" alt="image" src="https://github.com/user-attachments/assets/6c67bb4b-9658-42cd-95db-5f1c6016616c" />

Ingresar datos errones no mostrara la siguente respuesta
<img width="1225" height="276" alt="image" src="https://github.com/user-attachments/assets/b878ee1d-3a02-4f17-9000-8388581e6137" />
o en caso de que sea un correo valido pero un dato erroneo
<img width="1253" height="619" alt="image" src="https://github.com/user-attachments/assets/8f819f3c-f0db-4b15-875e-5771cd1331cb" />

La pagina de bienvenida nos muestra los datos de total de alumnos, total de alumnos con un factor de riesgo y el promedio grupal por alumno

<img width="1566" height="837" alt="image" src="https://github.com/user-attachments/assets/87c5b27e-0c4c-4b75-a1f8-f30695e9eb82" />

Estos datos se actualizan en tiempo real

Se puede observar un catalogo aqui, se puede cambiar los datos que se estan mostrando por materia impartida

<img width="1566" height="850" alt="image" src="https://github.com/user-attachments/assets/f125a50a-c484-40a8-9a8d-ad2069436d7c" />

<img width="1569" height="745" alt="image" src="https://github.com/user-attachments/assets/84046545-7274-4bb1-a137-f4808d28ed8e" />

Este es el menu desplegable para mostrar la navegacion

<img width="520" height="374" alt="image" src="https://github.com/user-attachments/assets/05af5e1c-bb1c-433c-9ad5-df3873e0d2a8" />

<img width="850" height="770" alt="image" src="https://github.com/user-attachments/assets/c6d43445-7454-425e-9f4f-2efb8aed172b" />

La pantalla gestionar materias es para ingresar la nueva materia

<img width="1061" height="399" alt="image" src="https://github.com/user-attachments/assets/4c99f6c4-ffe2-4598-9aef-ebcc66712ac6" />

<img width="997" height="504" alt="image" src="https://github.com/user-attachments/assets/da91c55e-76ad-4c6e-b569-35ff636c6a4f" />

En registro de estudiante tenemos para agregar a un nuevo estudiante

<img width="1573" height="841" alt="image" src="https://github.com/user-attachments/assets/0bc32047-7d36-4477-a231-06a6c634e945" />

Los datos de nombre estan normalizados para no aceptar numeros o simbolos y se transforman a mayusculas

<img width="1470" height="556" alt="image" src="https://github.com/user-attachments/assets/542b041d-de1c-4fe0-abfb-f091fe0c097b" />

Se puede observar el boton de eliminar en rojo en alumnos sin calificaciones y los que ya tienen no se pueden eliminar

<img width="1443" height="566" alt="image" src="https://github.com/user-attachments/assets/d979179f-61a4-405d-9187-f7ed862aaac7" />

No puedes guardar un alumno sin sus datos principales 

<img width="1545" height="592" alt="image" src="https://github.com/user-attachments/assets/6bb612c9-cb40-4312-9a00-acec545303b5" />

ni tampoco con el mismo ID

<img width="1569" height="571" alt="image" src="https://github.com/user-attachments/assets/8c61f9da-0926-4c28-9e0b-b6c248d7cd9d" />

El boton del menu de lista detallada muestra los alumnos registrados en la base de datos

<img width="1690" height="691" alt="image" src="https://github.com/user-attachments/assets/b24dc0e4-1c30-4b7f-a7f8-5625b4a0f05b" />

El boton de registro de asistencias muestra el total de dias que se impartio la materia y las asistencias dodne se hace el calculo de porcentaje de asistencia por unidad

<img width="1627" height="763" alt="image" src="https://github.com/user-attachments/assets/e79452c9-c252-4f6d-9b7d-ec6ef8b59a98" />

no puedes ingresar valores mas grandes que los dias de materias impartidos 

<img width="1022" height="815" alt="image" src="https://github.com/user-attachments/assets/1c8f7e05-3722-4c80-a8ab-307a8146cdf6" />


el boton de auditoria muestra los registros hechos por el usuario

<img width="1763" height="828" alt="image" src="https://github.com/user-attachments/assets/d3806623-8b5c-47d0-bf4a-7c60c1d91d2b" />

Exportar datos permite exportar archivos html y csv de la lista de estudiantes

<img width="1735" height="489" alt="image" src="https://github.com/user-attachments/assets/f20758f4-9b13-4a0b-a4be-6d0f85ff181d" />



<img width="218" height="159" alt="image" src="https://github.com/user-attachments/assets/7c1666db-2210-444a-ac6d-825cf8f27ebb" />


<img width="1915" height="615" alt="image" src="https://github.com/user-attachments/assets/3075331d-c7d0-44b2-ac8d-8bf0368c4db4" />



<img width="1129" height="270" alt="image" src="https://github.com/user-attachments/assets/d7906b0f-7574-4cc7-92ca-2feb899bf8fc" />

### **Matriz de cumplimiento**

<img width="1477" height="669" alt="image" src="https://github.com/user-attachments/assets/5ee6af8c-1566-4cca-9d3b-b11e15e3d817" />


### **Registro de Pruebas de Accesibilidad (Testing Log)**
•Caso de Prueba: CP-01: Activación de Texto a Voz◦Pasos de Prueba: 
1. Navegar a LoginPage.
2. Presionar el botón "Texto a Voz".
3. Presionarlo de nuevo mientras habla.
4. ◦Resultado Esperado:
1. Se escucha la descripción correcta de la página de login.
2. La locución se detiene.
3. ◦Problemas Encontrados y Soluciones: Ninguno.La funcionalidad de play/stop funcionó como se esperaba.

•Caso de Prueba: CP-02: Persistencia del Texto a Voz en Navegación
◦Pasos de Prueba: 
1. Ir a Dashboard.
2. Navegar a Registro de Estudiante.
3. Presionar "Atrás" para volver al Dashboard.
4. Activar texto a voz.
◦Resultado Esperado:
El texto leído debe ser el del Dashboard, no el de la página anterior.
◦Problemas Encontrados y Soluciones: Inicialmente se leía la descripción de la página anterior.
La solución fue implementar un RouteObserver global y convertir DashboardPage y LoginPage a StatefulWidgets con el mixin RouteAware para actualizar el texto en el evento didPopNext.

Caso de Prueba: CP-03: Activación del Modo Dislexia
◦Pasos de Prueba: 
1. Iniciar la app.
2. 2. Presionar el botón "Modo Dislexia".
3. Observar el texto en LoginPage.
4. Navegar a Dashboard.
◦Resultado Esperado:
La fuente en toda la UI cambia a OpenDyslexic con mayor espaciado.
El modo persiste entre páginas.
◦Problemas Encontrados y Soluciones: Ninguno. El cambio de tema a través del Provider funcionó globalmente como se esperaba.

Caso de Prueba: CP-04: Compilación y Ejecución en Windows
◦Pasos de Prueba: 
1. Limpiar el proyecto (flutter clean).
2. Obtener dependencias (flutter pub get).
3. Intentar compilar para Windows.
◦Resultado Esperado: La aplicación debe compilar y ejecutarse sin errores.
◦Problemas Encontrados y Soluciones: La versión inicial de flutter_tts causaba un error de compilación de CMake.
Se investigó y se cambió la dependencia a una versión anterior más estable (3.8.5), solucionando el problema.

### **Acta o Bitácora de Implementación**
•Fase 1
◦Actividad: Implementación inicial de Texto a Voz (TTS) en el widget de zoom.
◦Responsable(s): Desarrollador Abraham Armando Aganza Molina
◦Cambios Realizados: Modificación de zoom_buttons.dart y adición de flutter_tts al pubspec.yaml.

•Fase 2
◦Actividad: Depuración de errores de compilación y refactorización.
◦Responsable(s): Desarrollador Abraham Armando Aganza Molina
◦Cambios Realizados: Se cambió la versión de flutter_tts. Se refactorizó la lógica de TTS a accessibility_buttons.dart.

Fase 3
◦Actividad: Creación de sistema de TTS dinámico por página.
◦Responsable(s): Asistente AI
◦Cambios Realizados: Creación de AccessibilityTextProvider. Modificación de main.dart, LoginPage, DashboardPage, etc., para usar el nuevo Provider.

•Fase 4
◦Actividad: Corrección de bug de estado en navegación "hacia atrás".
◦Responsable(s): Asistente AI, Desarrollador◦Cambios Realizados: Creación de RouteObserver en main.dart y router.dart. Refactorización de páginas clave a StatefulWidget con RouteAware.

Fase 5◦Actividad: Implementación de Modo de Lectura para Dislexia.
◦Responsable(s): Desarrollador Abraham Armando Aganza Molina
◦Cambios Realizados: Adición de fuentes a assets/fonts. Modificación de pubspec.yaml. Creación de DyslexiaFriendlyProvider. Edición de theme.dart y accessibility_buttons.dart.

### **Análisis de Público Objetivo / Necesidades Especiales**
Tipo de Usuario: Usuarios con Baja Visión
◦Necesidades Específicas: Textos más grandes y legibles. Interfaz con buen contraste.
◦Cómo el Proyecto las Cubre:
▪Función de Zoom: Permite escalar el texto de la UI.
▪Modo Oscuro: Ofrece una alternativa de alto contraste que reduce el deslumbramiento.

Tipo de Usuario: Usuarios con Dislexia
◦Necesidades Específicas: Tipografías diseñadas para evitar la rotación de caracteres. Mayor espaciado entre letras y palabras.
◦Cómo el Proyecto las Cubre: Modo de Lectura para Dislexia: Cambia toda la tipografía de la app a OpenDyslexic y aumenta el letterSpacing.

•Tipo de Usuario: Usuarios Ciegos / Dependientes de Lectores de Pantalla
◦Necesidades Específicas: Contexto auditivo sobre la página actual y su propósito.
◦Cómo el Proyecto las Cubre: Navegación por Voz: Proporciona una descripción verbal del contenido y la función de cada pantalla.

Tipo de Usuario: Usuarios con Fotosensibilidad
◦Necesidades Específicas: Reducción del brillo general de la pantalla.
◦Cómo el Proyecto las Cubre: Modo Oscuro: Reduce significativamente la emisión de luz blanca.


### **Resultados**

Grafica de pareto que muestra los factores de riesgo mas comunes en los alumnos 

<img width="1735" height="811" alt="image" src="https://github.com/user-attachments/assets/5d63eeab-eb94-46d4-a16f-eefb09115968" />


Diagrama de dispersion que muestra los alumnos con calificacion y asistencia

<img width="1744" height="824" alt="image" src="https://github.com/user-attachments/assets/abf14c77-b89e-4ea2-b8cd-5f5278519894" />

<img width="1728" height="806" alt="image" src="https://github.com/user-attachments/assets/1cf9d66c-a46f-4a6a-8143-2782088b0543" />


grafico de barras para los promedios generales del grupo


<img width="1729" height="445" alt="image" src="https://github.com/user-attachments/assets/ea367cb5-9523-4f40-86a5-6de5fd2c5c20" />





### **Conclusiones**
**Abraham Armando Aganza molina**

Los modelos de calidad son una herramienta poderosa para identificar datos de manera sencilla, su manera visual de representar los datos nos permite explicar datos a personas que no tienen el conocimiento de uso de tablas de base de datos, lo cual es eficiente para dar a entender una idea, lo cual es imprescindibles a la hora de presentar un proyecto a una empresa o stakeholder que este interesado en tu proyecto.
No solo eso permiten corregir errores a la hora de desarrollar un sistema o producto, la forma en la que se crea una relacion en los datos aumenta considerablemente la identificaciones de posibles errores en el plan de desarrollo de un producto
Las metricas de calidad son importantes en el dia a dia, estamos en tiempos de competencia tecnologica donde los clientes y empresas busacan ciertos requisitos para comprar un proyecto, es necesario cumplir con estas mdeidads para garantizar un producto con un nivel de competencia que sobreviva en el mercado

La implementación de funciones de accesibilidad no es solo una tarea técnica, sino un ejercicio de empatía que requiere entender las barreras que enfrentan diferentes usuarios. La arquitectura de Flutter con Providers demostró ser muy flexible para implementar cambios globales en la UI, como el cambio de tema o fuente

A través de esta práctica, he aprendido a manejar el estado de la aplicación de manera más eficiente, a depurar errores de compilación específicos de una plataforma (Windows/CMake) y, lo más importante, a integrar pautas de accesibilidad (WCAG) en un ciclo de desarrollo real. Mi comprensión sobre la importancia de los lectores de pantalla y las tipografías especializadas ha aumentado significativamente

Considero que mi desempeño en esta práctica merece una calificación de 80, ya que no solo se cumplieron los objetivos técnicos de la implementación, pero aun asi faltan agregar mas sistemas de accesibilidad y considerar ciertas problematicas que no se contemplan a la hora de crear el sistema

**Ángel Omar Morales Calvo**

En un entorno altamente competitivo, donde cientos de sistemas nacen constantemente, resulta difícil diferenciarse si no se cumplen con diversos aspectos de calidad que permiten sobreponerse ante otras propuestas. Los modelos de calidad en software establecen criterios y métricas con las cuales podemos evaluar y medir puntos clave como la funcionalidad, confiabilidad, usabilidad y mantenibilidad. Tomando en cuenta estos puntos a la hora de conceptualizar un sistema hasta desarrollarlo y entregarlo, se vuelve mucho más fácil saber si un proyecto es viable o no a medida en que se progresa en su ciclo de vida.

Establecer un estándar de calidad permite no solo que se tenga como resultado un producto de alto valor para el cliente, si no que también hace más predecible el desarrollo, por lo que en términos de tiempo y costos, su factibilidad y aumenta, y se ve reflejado en el producto final, si es que en un inicio este tiene potencial.

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
