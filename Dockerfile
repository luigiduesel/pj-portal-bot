FROM python:3.10-slim
WORKDIR /usr/src/app
COPY . .
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
CMD ["sh", "-c", "while true; do python pjportal.py || break; sleep 180; done"]