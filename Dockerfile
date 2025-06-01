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
    find /usr/local/lib/python3.9/site-packages -name "__pycache__" -type d -exec rm -rf {} +

# Runtime stage
FROM python:3.9-alpine

WORKDIR /app

# Copy ALL installed packages AND executables from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application code
COPY . .

# Create non-root user for security
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=hello \
    FLASK_ENV=production \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Use flask command directly
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]