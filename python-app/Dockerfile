FROM python:3-alpine

WORKDIR /usr/src/app

COPY . .

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev

RUN pip install --no-cache-dir -r requirement.txt

CMD [ "python", "./lambdaexe.py" ]
