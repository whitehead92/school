FROM python:alpine AS APP

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

WORKDIR /app/school
COPY . .

RUN python manage.py collectstatic --noinput

#FROM nginx:1.25.1-alpine AS STATICFILES

#COPY --from=APP /app/school/static /data/static