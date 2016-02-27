default:
	./make.sh $(shell id -u)
dockerimage:
	docker build -t jenkins-plugins-build .
