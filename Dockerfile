FROM bitwalker/alpine-elixir-phoenix:1.9.0.1.9



WORKDIR /app

ADD . /app

EXPOSE 4000

RUN mix do deps.get, compile
CMD ["/app/run.sh"]