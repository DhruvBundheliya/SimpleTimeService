FROM python:3.11-slim

RUN useradd -m appuser

WORKDIR /home/appuser

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py ./

USER appuser

EXPOSE 5000

CMD ["python", "main.py"]