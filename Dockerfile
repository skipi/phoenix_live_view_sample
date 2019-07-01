FROM bitwalker/alpine-elixir-phoenix:1.9.0.1.9
WORKDIR /app

COPY mix.exs ./ 

RUN mix do deps.get

COPY . /app

RUN cd assets && npm install && cd ..

EXPOSE 4000

CMD [ "/app/run.sh" ]