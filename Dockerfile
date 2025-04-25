FROM python:3.13-alpine AS builder
WORKDIR /usr/src/app
RUN apk add --no-cache gcc libffi-dev postgresql-dev musl-dev
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.13-alpine
WORKDIR /usr/src/app
RUN apk add --no-cache libffi postgresql-libs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# ENV DEBUG=0
# ENV DJANGO_ALLOWED_HOSTS='localhost 127.0.0.1 [::1]'
# ENV SECRET_KEY='django-insecure-4@v1!$@#xg3&*0^2bq5j6z7h8w9z0y1z2a3b4c5d6e7f8g9h0i'

# ENV DATABASE_URL='postgres://user:password@db:5432/dbname'

COPY --from=builder /install /usr/local
COPY . .
RUN adduser -D usfachb && chown -R usfachb:usfachb /usr/src/app
USER usfachb
EXPOSE 8000
CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8080", "--workers", "1"]