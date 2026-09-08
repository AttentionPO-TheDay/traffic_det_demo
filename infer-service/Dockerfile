FROM python:3.12-alpine
WORKDIR /app
COPY pyproject.toml .
RUN pip install --no-cache-dir uv && \
    uv sync
ENV PATH="/app/.venv/bin:$PATH"
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
