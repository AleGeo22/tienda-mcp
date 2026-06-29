FROM python:3.11-slim

# Directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código fuente
COPY . .

# Puerto que expone FastAPI
EXPOSE 8000

# Comando de arranque
CMD ["uvicorn", "web.api:app", "--host", "0.0.0.0", "--port", "8000"]
