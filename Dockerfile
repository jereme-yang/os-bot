# Use a base image for runtime (not build)
FROM elixir:1.18 AS runtime

WORKDIR /app

# Copy precompiled build artifacts and dependencies from your local machine
COPY _build /app/_build
COPY deps /app/deps
COPY config /app/config
COPY lib /app/lib
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock

# Start the app using the mix run command
CMD ["elixir", "--erl", "+S 1", "-S", "mix", "run", "--no-halt"]