-- 1. Maestros
CREATE TABLE IF NOT EXISTS maestros (
    maestro_id CHAR(36) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido_paterno VARCHAR(255) NOT NULL,
    apellido_materno VARCHAR(255),
    avatar VARCHAR(255),
    fecha_ingreso DATE DEFAULT (CURRENT_DATE),
    fecha_salida DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Grupos
CREATE TABLE IF NOT EXISTS grupos (
    grupo_id INT AUTO_INCREMENT PRIMARY KEY,
    clave_grupo VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Materias
CREATE TABLE IF NOT EXISTS materias (
    materia_id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_materia VARCHAR(50) NOT NULL UNIQUE,
    nombre_materia VARCHAR(255) NOT NULL,
    numero_unidades TINYINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Periodos
CREATE TABLE IF NOT EXISTS periodos (
    periodo_id INT AUTO_INCREMENT PRIMARY KEY,
    clave_periodo VARCHAR(50) NOT NULL UNIQUE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Clases
CREATE TABLE IF NOT EXISTS clases (
    clase_id INT AUTO_INCREMENT PRIMARY KEY,
    materia_id INT NOT NULL,
    maestro_id CHAR(36) NOT NULL,
    grupo_id INT NOT NULL,
    periodo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (materia_id) REFERENCES materias(materia_id),
    FOREIGN KEY (maestro_id) REFERENCES maestros(maestro_id),
    FOREIGN KEY (grupo_id) REFERENCES grupos(grupo_id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(periodo_id),
    -- una misma materia, en el mismo periodo, con el mismo maestro y grupo, solo una vez
    UNIQUE (materia_id, maestro_id, grupo_id, periodo_id)
);

-- 6. Alumnos
CREATE TABLE IF NOT EXISTS alumnos (
    alumno_id INT AUTO_INCREMENT PRIMARY KEY,
    numero_control VARCHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    apellido_paterno VARCHAR(255) NOT NULL,
    apellido_materno VARCHAR(255),
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_egreso DATE,
    direccion TEXT,
    telefono VARCHAR(50),
    promedio DECIMAL(5,2) DEFAULT 0.00,
    estado ENUM('Activo', 'Baja temporal', 'Baja definitiva', 'Egresado') DEFAULT 'Activo',
    correo_institucional VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Alumno_Clase
CREATE TABLE IF NOT EXISTS alumno_clase (
    alumno_clase_id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT NOT NULL,
    clase_id INT NOT NULL,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    fecha_baja DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id) ON DELETE CASCADE,
    FOREIGN KEY (clase_id) REFERENCES clases(clase_id) ON DELETE CASCADE,
    UNIQUE (alumno_id, clase_id)   -- el alumno no se inscribe dos veces a la misma clase
);

-- 8. Alumno_Grupo
CREATE TABLE IF NOT EXISTS alumno_grupo (
    alumno_grupo_id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT NOT NULL,
    grupo_id INT NOT NULL,
    periodo_id INT NOT NULL,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    fecha_finalizacion DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id) ON DELETE CASCADE,
    FOREIGN KEY (grupo_id) REFERENCES grupos(grupo_id),
    FOREIGN KEY (periodo_id) REFERENCES periodos(periodo_id),
    UNIQUE (alumno_id, grupo_id, periodo_id)
);

-- 9. Asistencias
CREATE TABLE IF NOT EXISTS asistencias (
    asistencia_id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_clase_id INT NOT NULL,
    fecha DATE NOT NULL,
    estado ENUM('Presente', 'Ausente', 'Retardo') NOT NULL DEFAULT 'Presente',
    observacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_clase_id) REFERENCES alumno_clase(alumno_clase_id) ON DELETE CASCADE,
    UNIQUE (alumno_clase_id, fecha)    -- no duplicar asistencia del mismo día
);

-- 10. Calificaciones
CREATE TABLE IF NOT EXISTS calificaciones (
    calificacion_id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_clase_id INT NOT NULL,
    numero_unidad TINYINT NOT NULL,
    nota DECIMAL(5,2) NOT NULL,
    fecha_evaluacion DATE NOT NULL,
    observacion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_clase_id) REFERENCES alumno_clase(alumno_clase_id) ON DELETE CASCADE,
    UNIQUE (alumno_clase_id, numero_unidad)
);

-- 11. FactoresCatalogo
CREATE TABLE IF NOT EXISTS factores_catalogo (
    factor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_factor VARCHAR(255) NOT NULL UNIQUE,
    categoria VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. AlumnoFactor
CREATE TABLE IF NOT EXISTS alumno_factor (
    registro_id INT AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT NOT NULL,
    factor_id INT NOT NULL,
    observacion TEXT,
    fecha_identificacion DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(alumno_id) ON DELETE CASCADE,
    FOREIGN KEY (factor_id) REFERENCES factores_catalogo(factor_id) ON DELETE CASCADE,
    UNIQUE (alumno_id, factor_id, fecha_identificacion)
);