NS = sh4rk
REPO = syncthing
VERSION ?= latest

default: deps build

deps:
	docker pull alpine

build:
	docker build -t $(NS)/$(REPO):$(VERSION) --force-rm=true .
