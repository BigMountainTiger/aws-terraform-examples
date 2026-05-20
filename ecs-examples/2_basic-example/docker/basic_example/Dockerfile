FROM python:3.14-slim

WORKDIR /app

COPY python/requirements.tx[t] .
RUN <<EOF
if [ -f "requirements.txt" ]; then 
    pip install -r requirements.txt --no-cache-dir --no-deps -t .
fi

find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.py[co]" -delete
EOF

COPY --exclude=requirements.txt python/ .

CMD ["python", "app.py"]