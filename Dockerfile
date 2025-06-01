# Build stage
FROM python:3.9-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev python3-dev

# Copy requirements first for better caching
COPY setup.py .

# Install dependencies
RUN pip install --no-cache-dir . && \
    # Clean up pip cache and temporary files
    rm -rf /root/.cache/pip/* && \
    find /usr/local/lib/python3.9/site-packages -name "*.pyc" -delete && \
    find /usr/local/lib/python3.9/site-packages -name "_pycache_" -delete

# Runtime stage
FROM python:3.9-alpine

WORKDIR /app

# Copy only the installed packages from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=hello
ENV FLASK_ENV=dev

# Fixed CMD format using JSON array
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]