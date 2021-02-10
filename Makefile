DIR := $(PWD)
BUILD := $(shell git rev-parse --short HEAD)
PROJECTNAME := $(shell basename "$(PWD)")
DATE=$(shell date +%FT%T%z)

STATUS_CODE := $(shell docker-compose run --rm e2e bash -c 'curl -o /dev/null -s -w "%{http_code}\n" $$CYPRESS_baseUrl')

all: install

# deps:
# ifndef DEP
# 	$(error "DEP is not available, please install")
# endif

# .PHONY: clean
# clean:
# 	rm -rf e2e/node_modules

install: build install-drupal

build:
	@echo "> Docker build ${PROJECTNAME}: "
	docker-compose build

up:
	docker-compose up -d --scale e2e=0

healthz:
	@echo "> Checking health of site"
ifeq ($(STATUS_CODE), 200)
	@echo "Site is running"
	@exit 0
else
	@echo "Site is not running"
	@exit 1
endif

tests-info:
	docker-compose run --rm e2e npx cypress info

tests-all: up healthz
	docker-compose run --rm --name cypress-e2e e2e

ci-tests-all: healthz
	docker-compose up --abort-on-container-exit --exit-code-from e2e

stop:
	docker-compose stop

down:
	docker-compose down

install-drupal:
	@echo "> Installing Drupal unami demo..."
	docker-compose exec cli bash -c 'cd drupal && drush -y si demo_umami --account-name=admin --account-pass=admin --no-interaction'
