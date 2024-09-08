#!/bin/sh

docker compose run --rm --no-deps web rails new . --force --database=postgresql --css=bootstrap --skip-docker


