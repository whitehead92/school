FROM python:alpine AS base

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

WORKDIR /app/school
COPY . .

FROM base as static_files
RUN python manage.py collectstatic --noinput

FROM nginx:1.25.1-alpine AS serve_static
COPY --from=static_files /app/school/static /data/static