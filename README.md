# AL-GetContactsAPI

Extensión de Microsoft Dynamics 365 Business Central desarrollada en AL para consultar una API externa e importar contactos en una tabla local.

## Funcionalidad

- Consulta mediante `HttpClient` el endpoint `https://raydelto.org/agenda.php`.
- Interpreta la respuesta como un arreglo JSON.
- Importa los campos `nombre`, `apellido` y `telefono`.
- Muestra los contactos en la página de lista **JK External Contacts**.
- Permite actualizar la información desde la acción **Get External Contacts**.
- Permite eliminar todos los contactos desde la acción **Clear External Contacts**.
- Valida errores de conexión, códigos HTTP no exitosos y respuestas que no sean arreglos JSON válidos.

## Requisitos

- Visual Studio Code.
- AL Language extension.
- Microsoft Dynamics 365 Business Central 2025, aplicación `25.0.0.0`.
- Runtime AL `14.3`.
- Un entorno de desarrollo de Business Central accesible desde VS Code.
- Acceso de red desde Business Central hacia `https://raydelto.org/agenda.php`.

## Estructura principal

```text
.
├── app.json
├── Base
│   ├── Codeunits
│   │   └── JKAPIManagement.CodeUnit.al
│   ├── Pages
│   │   └── JKAPIContacts.Page.al
│   └── Tables
│       └── JKAPIContacts.Table.al
└── .vscode
    └── launch.json
```

### Objetos AL

| Tipo | ID | Nombre | Responsabilidad |
| --- | ---: | --- | --- |
| Tabla | 50120 | `JK API Contacts` | Almacena los contactos importados. |
| Página | 50120 | `JK API External Contacts` | Lista de consulta y acciones para importar o limpiar. |
| Codeunit | 50120 | `JK API Management` | Ejecuta la llamada HTTP, procesa JSON y administra los registros. |

La extensión utiliza el rango de IDs `50120-50149`.

## Formato esperado de la API

La respuesta debe ser un arreglo JSON cuyos objetos contengan las propiedades siguientes:

```json
[
  {
    "nombre": "Ana",
    "apellido": "García",
    "telefono": "+34 600 123 456"
  },
  {
    "nombre": "Luis",
    "apellido": "Pérez",
    "telefono": "600123457"
  }
]
```

Los registros sin ningún valor en esos tres campos no se insertan. Los valores se recortan al tamaño permitido por la tabla:

- `Name`: `Text[100]`.
- `LastName`: `Text[100]`.
- `Phone Text`: `Text[50]`.

El campo `ID` es entero autoincremental y constituye la clave primaria.

## Instalación y ejecución

1. Abre la carpeta del proyecto en Visual Studio Code.
2. Configura la conexión con tu entorno de Business Central.
3. Descarga los símbolos de Business Central si el proyecto aún no los tiene.
4. Compila y publica la extensión en el entorno de desarrollo.
5. En Business Central, busca y abre **JK External Contacts**.
6. Selecciona **Get External Contacts** y confirma la consulta.
7. Para eliminar los registros locales, selecciona **Clear External Contacts**.

También se incluye el paquete compilado `JuanK_AL-GetContactsAPI_1.0.0.2.app`.

## Flujo de importación

1. La página solicita confirmación al usuario.
2. El codeunit realiza una petición HTTP GET.
3. Se comprueba que la respuesta tenga un código HTTP exitoso.
4. El contenido se convierte a `JsonArray`.
5. Cada objeto se transforma en un registro de `JK API Contacts`.
6. La página se actualiza y muestra el resultado de la operación.

La importación actual **no limpia previamente la tabla**. Si se ejecuta varias veces, los contactos recibidos se agregan como nuevos registros y pueden producir duplicados. Utiliza **Clear External Contacts** cuando necesites reemplazar completamente la información local.

## Configuración y extensibilidad

El codeunit expone el evento de integración `OnBeforeGetExternalContactsAPI`, que permite interceptar o reemplazar el proceso estándar estableciendo `IsHandled` en `true` desde una suscripción.

La política de exposición de recursos del proyecto permite depuración, descarga de código fuente e inclusión del código fuente en el archivo de símbolos, según la configuración actual de `app.json`.

## Pruebas

La carpeta `Base/Tests` está incluida en el proyecto, pero actualmente no contiene codeunits de prueba. Se recomienda añadir pruebas automatizadas para:

- Respuestas JSON válidas y con propiedades ausentes.
- Respuestas vacías o con valores demasiado largos.
- Errores de conexión y códigos HTTP no exitosos.
- Reimportación y limpieza de registros.

## Licencia

No se ha definido una licencia en el proyecto.