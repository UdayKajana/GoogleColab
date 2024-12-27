# Use Apache Beam's official Python SDK image
FROM apache/beam_python3.9_sdk:2.48.0

# Set working directory
WORKDIR /opt/google/dataflow

# Install additional system dependencies if needed
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy requirements file
COPY requirements.txt requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy pipeline and launcher code
COPY pipeline.py pipeline.py
COPY launcher.py python_template_launcher

# Set permissions
RUN chown -R appuser:appuser /opt/google/dataflow && \
    chmod +x python_template_launcher && \
    mkdir -p /home/appuser/.local && \
    chown -R appuser:appuser /home/appuser

# Switch to non-root user
USER appuser

# Set Python path to include user site-packages
ENV PYTHONPATH=/home/appuser/.local/lib/python3.9/site-packages:$PYTHONPATH

# Use the custom launcher
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
