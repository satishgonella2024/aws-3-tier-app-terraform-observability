FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /app /app
COPY . .
ENV PYTHONPATH=/app
EXPOSE 5000
CMD ["python", "app.py"]
