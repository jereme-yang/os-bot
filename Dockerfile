# Use a base image for runtime (not build)
FROM elixir:1.18 AS runtime

WORKDIR /app

RUN mix local.hex --force

# Copy precompiled build artifacts from your local machine
COPY _build _build
COPY deps deps
COPY config config
COPY lib lib
COPY mix.exs .
COPY mix.lock .

# Start the app using the mix run command
CMD ["elixir", "--erl", "+S 1", "-S", "mix", "run", "--no-halt"]
