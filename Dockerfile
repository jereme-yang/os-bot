FROM elixir:latest AS build

WORKDIR /app

COPY . .

RUN mix deps.get
RUN mix compile

CMD ["mix", "run", "--no-halt"]