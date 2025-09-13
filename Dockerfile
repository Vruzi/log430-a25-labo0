FROM python:3.13-slim

WORKDIR /app

COPY src/ ./src/

CMD ["python", "src/calculator.py"]
