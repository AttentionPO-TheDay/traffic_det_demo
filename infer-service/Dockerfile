# 注意：torch 仅提供 manylinux(glibc) wheel，无 musl(alpine) 版本，必须使用 glibc 基础镜像
FROM python:3.12-slim
WORKDIR /app
# 先拷贝依赖清单，利用构建缓存
COPY pyproject.toml uv.lock ./
RUN pip install --no-cache-dir uv && \
    uv sync
ENV PATH="/app/.venv/bin:$PATH"
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
