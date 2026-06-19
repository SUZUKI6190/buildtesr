FROM vreitech/docker-ldc:2-v1.42.0 AS build

WORKDIR /app

COPY dub.json dub.selections.json ./
COPY source ./source
COPY public ./public

RUN dub build --build=release --cache=local --compiler=ldc2 && \
	install -m 755 "$(find . -name buildtesr -type f -perm /111 | head -n1)" /usr/local/bin/buildtesr

FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	libssl3 \
	zlib1g \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /usr/local/bin/buildtesr /usr/local/bin/buildtesr
COPY public ./public

ENV PORT=8080
EXPOSE 8080

CMD ["buildtesr"]
