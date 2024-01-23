FROM python:3.12.1-alpine3.18

WORKDIR /app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY app.py ./

CMD ["python", "app.py"]
