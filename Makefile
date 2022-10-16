.PHONY: $(MAKECMDGOALS)
SHELL:=/bin/bash
PHX_SECRET := $(shell v='$(mix phx.gen.secret)'; echo "$${v%.*}")

~/.asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
	echo ". ~/.asdf/asdf.sh" >> ~/.bashrc
	echo ". ~/.asdf/completions/asdf.bash" >> ~/.bashrc

.env:
	cp .env.sample .env
	sed -i '$$d' .env

# `make setup` will be used after cloning or downloading to fulfill
# dependencies, and setup the the project in an initial state.
# This is where you might download rubygems, node_modules, packages,
# compile code, build container images, initialize a database,
# anything else that needs to happen before your server is started
# for the first time
setup: ~/.asdf .env
	# https://github.com/asdf-vm/asdf/issues/841
	asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git || true # Add Elixir plugin to ASDF
	asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git || true # Add Erlang plugin to ASDF
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true # Add Node.js plugin to ASDF
	asdf install erlang
	asdf install elixir
	asdf install nodejs
	mix local.hex --force && mix local.rebar --force
	mix deps.get
	printf "SECRET_KEY_BASE=%s\n" $$(mix phx.gen.secret) >> .env
	npm install --prefix ./assets
	docker-compose up -d db
	mix do ecto.drop, ecto.create, ecto.migrate

# `make server` will be used after `make setup` in order to start
# an http server process that listens on any unreserved port
#	of your choice (e.g. 8080).
server: .env
	docker-compose up

# `make test` will be used after `make setup` in order to run
# your test suite.
test:
	docker-compose up -d db
	MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate
	mix test
