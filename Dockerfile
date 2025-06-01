FROM python:3.9-slim

WORKDIR /app

# Copy requirements first for better caching
COPY setup.py .

# Install dependencies
RUN pip install --no-cache-dir .

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=hello
ENV FLASK_ENV=dev

# Run the application
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]