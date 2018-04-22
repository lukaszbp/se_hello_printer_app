.PHONY: test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test #noqa

test:
	PYTHONPATH=. py.test

test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=. --cov-report xml

test_xunit:
	PYTHONPATH=. py.test -s --cov=. --junit-xml=test_results.xml

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
		--name hello-world-printer-dev \
		 -p 5000:5000 \
		 -d hello-world-printer

USERNAME=lukaszbp
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker push $(TAG); \
	docker logout;
