FROM bitwalker/alpine-elixir-phoenix:1.9.0.1.9
WORKDIR /app

COPY mix.* ./ 

RUN mix do deps.get, deps.compile, compile

COPY . /app

RUN cd assets && npm install && cd ..

EXPOSE 4000

CMD [ "/app/run.sh" ]