# Guía de Desarrollo (Developer Experience)

Este documento centraliza toda la información técnica y de configuración requerida para desarrollar, ejecutar, probar y depurar el proyecto **AURA Boutique**.

## 1. Configuración del Entorno

### Variables de Entorno Necesarias
El proyecto requiere un archivo `.env` en la raíz con las siguientes variables declaradas. (Solicita los valores correctos al administrador del proyecto o utiliza tus propios entornos de desarrollo).

```env
# API Keys de Modelos de Lenguaje
GROQ_API_KEY=

# Base de Datos y CRM (Notion)
NOTION_TOKEN=
NOTION_CLIENTES_DB_ID=
NOTION_ORDENES_DB_ID=

# Autenticación (Firebase)
FIREBASE_API_KEY=
FIREBASE_AUTH_DOMAIN=
FIREBASE_PROJECT_ID=

# Observabilidad (LangSmith - Opcional)
LANGCHAIN_TRACING_V2=
LANGCHAIN_PROJECT=
LANGCHAIN_API_KEY=
```

### Cómo Ejecutar el Proyecto

1. Clona el repositorio e instala dependencias:
   ```bash
   python -m venv .venv
   .\.venv\Scripts\activate   # En Windows
   pip install -r requirements.txt
   ```
2. Configura el archivo `.env` como se indicó arriba.
3. Inicia el servidor de desarrollo (FastAPI levantará tanto la API como el frontend):
   ```bash
   python -m web.api
   # O alternativamente: uvicorn web.api:app --reload
   ```
4. Ingresa a `http://localhost:8000`.

---

## 2. Configuración de Antigravity (y otros IDEs MCP)

El sistema cuenta con un servidor MCP de respaldo (Fallback) para la lógica de la tienda, útil para depuración desde el IDE.

**Para Antigravity:**
1. Abre la paleta de comandos (`Ctrl+Shift+P`).
2. Busca `MCP: Add Server` (o equivalente en tu versión).
3. Pega esta configuración adaptando la ruta de tu PC:
```json
"tienda-virtual": {
  "command": "C:\\ruta\\a\\tu\\python.exe",
  "args": ["-m", "server.mcp_server"],
  "cwd": "C:\\ruta\\al\\proyecto\\tienda-mcp",
  "env": { "PYTHONIOENCODING": "utf-8" }
}
```
4. Guarda y recarga la ventana. Podrás interactuar con las tools de la tienda directamente desde el asistente del IDE.

---

## 3. Pruebas y Flujos de Demostración

### Cómo Ejecutar Pruebas (Automáticas)
Para correr la suite de pruebas unitarias y de integración (adversariales):
```bash
py -m pytest -v
```

### Casos de Uso Principales (Flujos de Negocio)
Para probar manualmente el sistema a través de la UI (`http://localhost:8000`), utiliza los siguientes escenarios clave:

- **Escenario 1 (Feliz):**
  Pide *"laptops de menos de 4000 soles"*. El Agente Catálogo devolverá P001. Luego dile *"añadir al carrito"*. Verás cómo el Agente Ventas toma el control, agrega el item y posiblemente te sugiera un accesorio (upsell). Finaliza pagando con Yape.
- **Escenario 2 (Agotado):**
  Pide *"Consola PlayBox X"*. El inventario devolverá stock 0. Automáticamente, gracias a los eventos, se disparará una búsqueda de alternativas en la misma categoría y la IA te ofrecerá un producto similar.
- **Escenario 3 (Conflicto Concurrente):**
  Abre dos sesiones en paralelo (o usuarios distintos). Ambos piden P009 (que solo tiene 1 unidad de stock). Ambos lo agregan al carrito exitosamente. Al momento del checkout, el *Lock* atómico de concurrencia permitirá el pago solo al primero; el segundo recibirá un error de falta de inventario.

---

## 4. Deuda Técnica y Estrategia de Testing

Durante la migración de un sistema determinista a LangGraph (LLM), los tests tradicionales de aserción literal comenzaron a producir falsos negativos (ej: esperar que el bot diga exactamente `"P005"` cuando ahora dice *"Claro, te sugiero el vestido P005"*).

**Estrategia Futura:**
1. **LLM-as-a-Judge (Evaluación Semántica):** En lugar de aserciones exactas (`==`), utilizar un modelo pequeño para evaluar si la respuesta del agente cumplió con el objetivo. 
   *(Ej: `assert evaluador(respuesta, "Menciona un producto").exito == True`)*
2. **Pruebas de Estado:** Validar mutaciones en la Base de Datos o el Checkpointer, en vez de evaluar la respuesta en texto. *(Ej: `assert len(carrito.items) > 0`)*

---

## 5. Deployment (Despliegue)

> **Pendiente de implementación.**

Actualmente el sistema está optimizado para desarrollo local (usando `MemorySaver` en RAM para LangGraph y variables locales).
Próximos pasos para producción:
- Migrar de `MemorySaver` a `PostgresSaver` (o equivalente) para evitar pérdida de sesiones en reinicios.
- Configurar despliegue de FastAPI a un proveedor Cloud (Vercel, Render o AWS).
- Configurar CI/CD para ejecutar `pytest` antes del despliegue.

---

## 6. Problemas Conocidos y Troubleshooting

- **Antigravity no detecta las tools MCP:**
  1. Verifica que usaste doble barra diagonal `\\` en el JSON de configuración para las rutas en Windows.
  2. Asegúrate de haber recargado el IDE (`Reload Window`).
  3. Ejecuta `py -m scripts.test_stdio_client` para validar que el servidor levanta sin errores de importación.
- **Pérdida de memoria del bot (amnesia repentina):**
  Dado que LangGraph usa `MemorySaver`, si el proceso de `uvicorn` o Python se reinicia durante el desarrollo, todos los IDs de conversación se pierden. Esto es normal en desarrollo.
- **El bot alucina y responde como otro agente:**
  Revisa las trazas de LangSmith (`LANGCHAIN_TRACING_V2=true`). Generalmente se debe a que el *Supervisor* (Llama 3) clasificó incorrectamente el `next_action`. Ajusta el prompt del supervisor.
