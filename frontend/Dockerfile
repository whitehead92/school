FROM oven/bun as base
WORKDIR /usr/src/app

FROM base as install
RUN mkdir /tmp/dev
COPY package.json bun.lockb /tmp/dev/
RUN cd /tmp/dev && bun install --frozen-lockfile

FROM base as prerelease
COPY --from=install /tmp/dev/node_modules node_modules
COPY . .

# TODO: add build stage and nginx, deploying it