# AURA Boutique - Tienda Virtual Multi-Agente con Memoria Evolutiva

Bienvenido al repositorio principal de **AURA Boutique**, un sistema de tienda virtual impulsado por una arquitectura Multi-Agente avanzada (LangGraph), memoria a corto plazo, memoria semántica a largo plazo (Notion CRM) y un Profiler Agent impulsado por LLM.

Este proyecto destaca por implementar una inteligencia artificial proactiva, asíncrona y estructurada mediante arquitecturas modernas.

---

## 🎯 Descripción del Proyecto y Arquitectura Resumida

AURA Boutique es un ecosistema comercial interactivo. En lugar de navegar estáticamente por productos, los clientes conversan con un enjambre (swarm) de agentes de IA coordinados por un "Supervisor". 

La arquitectura general se compone de:
1. **Sistema de Enrutamiento**: LangGraph dirige el flujo de usuario al especialista correcto (Catálogo, Inventario, Pagos, etc.).
2. **Memoria de Sesión**: Un `Checkpointer` conserva el estado conversacional del carrito e interacciones.
3. **Eventos y Memoria Evolutiva**: Un bus de eventos asíncrono informa las acciones críticas (como compras) al *Profiler Agent*, que analiza los gustos del usuario sin interrumpir su navegación, y los persiste en un CRM.

---

## 🛠️ Stack Tecnológico

El proyecto se sustenta en tecnologías líderes del mercado:
- **FastAPI** & **Uvicorn**: Servidor backend web asíncrono y de alto rendimiento.
- **LangChain** & **LangGraph**: Framework de agentes de IA y manejo de flujos de estados deterministas.
- **Groq** (LLama 3): Proveedor de inferencia LLM ultra rápido.
- **Notion SDK**: Base de datos externa utilizada como *Headless CRM*.
- **Firebase Admin SDK**: Autenticación segura y emisión de tokens de sesión inmutables JWT.
- **Pydantic**: Validación robusta de estructuras de datos y schemas (Tools).
- **SQLite (MemorySaver)**: Almacenamiento rápido en memoria/disco para manejo de hilos de LangGraph.

---

## 📂 Estructura del Proyecto

```text
tienda-mcp/
├── agents/                 # Profiler Agent y Event Bus asíncrono
├── docs/                   # Documentación principal del proyecto (Arquitectura y Desarrollo)
├── graph/                  # LangGraph multi-agente, builder y states
├── scripts/                # Scripts utilitarios (diagnóstico y tests E2E)
├── server/                 # Infraestructura MCP heredada y configuraciones
├── services/               # Lógica de negocio core (Tienda, Notion API, Auth)
├── tools/                  # Herramientas de LangChain expuestas a los subagentes
├── web/                    # Capa de red (FastAPI) y frontend estático (HTML/JS)
├── .env                    # Configuración sensible local
└── requirements.txt        # Dependencias
```

---

## 🚀 Cómo Ejecutar (Quickstart)

1. **Clonar e instalar dependencias:**
   ```bash
   git clone <URL_DEL_REPO>
   cd tienda-mcp
   python -m venv .venv
   # Activa el entorno virtual (.venv/Scripts/activate en Windows)
   pip install -r requirements.txt
   ```

2. **Configurar el Entorno:**
   Crea un archivo `.env` en la raíz (revisa [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) para ver la lista de variables requeridas de Groq, Notion y Firebase).

3. **Iniciar el servidor web:**
   ```bash
   python -m web.api
   ```
   Entra en tu navegador a 👉 `http://localhost:8000`

---

## 📖 Documentación Disponible

Toda la documentación técnica se ha condensado y estructurado profesionalmente en dos archivos principales. Recomendamos su lectura detallada:

- 🏛️ [ARCHITECTURE.md](docs/ARCHITECTURE.md) - **Arquitectura del Sistema:**
  Contiene las decisiones de diseño arquitectónico, el diagrama completo del flujo de LangGraph, los roles de los especialistas de IA, y la justificación de uso de cada componente (Notion, Profiler Agent, Firebase, etc.).

- 💻 [DEVELOPMENT.md](docs/DEVELOPMENT.md) - **Guía de Desarrollo y QA:**
  Contiene la configuración de variables de entorno, tutoriales de ejecución, conexión con IDEs, Casos de Prueba (escenarios), Estrategia de Testing (Deuda Técnica) e instrucciones de Despliegue.

- 📜 [MIGRATION_PLAN.md](docs/MIGRATION_PLAN.md) - **Documentación Histórica (Evolución del Sistema):**
  Detalle profundo capa por capa de cómo el sistema evolucionó desde su versión legacy basada en MCP hacia la orquestación actual con LangGraph, preservando la trazabilidad técnica de las decisiones.
