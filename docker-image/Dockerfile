FROM python:alpine

ENV TZ=Europe/Berlin

WORKDIR /app

RUN pip3 install flask

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]