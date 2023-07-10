FROM golang:1.18-alpine
ARG CORE_VERSION
ARG TZ
ARG CONTAINER_PACKAGE_URL

RUN sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories
WORKDIR /opt
RUN go env -w GOPROXY=http://mirrors.aliyun.com/goproxy/

RUN apk add --no-cache tzdata ca-certificates curl unzip && mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray

RUN curl -o /opt/v2ray.zip https://ghproxy.com/https://github.com/v2fly/v2ray-core/releases/download/${CORE_VERSION}/v2ray-linux-64.zip -L && unzip /opt/v2ray.zip && chmod +x v2ray
RUN mv /opt/v2ray /usr/bin/ && chmod +x /usr/bin/v2ray

ENV V2RAY_GEO_CONFIG "${V2RAY_GEO_CONFIG}"
ENV V2RAY_LOCATION_CONFIG "${V2RAY_CONFIG_LOCATION}"

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
