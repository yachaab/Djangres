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

COPY --from=builder /install /usr/local
COPY . .
RUN adduser -D usfachb && chown -R usfachb:usfachb /usr/src/app
USER usfachb
EXPOSE 8000
CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:$PORT", "--workers", "1"]