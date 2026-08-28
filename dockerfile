FROM python:3.12-slim-bookworm@sha256:ac212230555ffb7ec17c214fb4cf036ced11b30b5b460994376b0725c7f6c151

# using a hash
COPY --from=ghcr.io/astral-sh/uv:0.12.5@sha256:e85be844203885286c60ffad8a858d48afb6c5a5c237ca0e67f12e74b8f174b1 /uv /uvx /bin/

# Disable development dependencies
ENV UV_NO_DEV=1


WORKDIR /app
COPY . /app


# Sync the project into a new environment, asserting the lockfile is up to date

RUN uv sync --locked






# Presuming there is a `my_app` command provided by the project
CMD ["uv", "run", "app.py"]
