FROM alpine:3.19

RUN apk add --no-cache bash curl openssl

COPY run.sh /run.sh
COPY app /app

RUN chmod +x /run.sh /app/*.sh

CMD [ "/run.sh" ]