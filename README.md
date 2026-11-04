# karate-api
Automation API
# QA Labs Test

Este proyecto contiene pruebas y ejemplos para el laboratorio de QA utilizando [Karate DSL].

## Descripción

Se han implementado pruebas automatizadas de servicios REST utilizando Karate DSL.  
Entre los servicios probados se incluyen:
- Autenticación y autorización
- Consultas a APIs de usuarios y productos
- Validación de respuestas y manejo de errores

Las pruebas cubren escenarios funcionales y de integración, asegurando la calidad de los servicios expuestos.

## Requisitos

- Java 17 o superior
- Maven

## Instalación

Clona el repositorio y asegúrate de tener Java 17 y Maven instalados.

## Ejecución de pruebas


### Ejecución básica
```bash
mvn test
```

### Ejecutar pruebas con tags y ambiente
```bash
mvn clean test -Dkarate.env=test "-Dkarate.options=--tags @<tag>"
```

### Solo ejecutar pruebas con tags
```bash
mvn test "-Dkarate.options=--tags @test"
```

## Estructura del proyecto

- `/src/main/java`: Código fuente principal (si aplica)
- `/src/test/java/bdd`: Features de Karate organizados por dominio (api_rest, api_soap, autenticaciones, mascotas, usuarios)
- `/src/test/java/headers`, `/params`, `/requests`, `/responses`: Archivos auxiliares para pruebas (headers, parámetros, requests y respuestas)
- `/src/test/java/utils`: Utilidades y helpers para las pruebas
- `karate-config.js`: Configuración global de Karate
- `KarateRunner.java`: Clase runner para ejecutar los tests
- `logback-test.xml`: Configuración de logs para pruebas
- `pom.xml`: Archivo de configuración de Maven

## Contribución

1. Haz un fork del repositorio.
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`).
3. Realiza tus cambios y haz commit.
4. Envía un pull request.

## Licencia

Este proyecto es solo para fines educativos y de prueba.

