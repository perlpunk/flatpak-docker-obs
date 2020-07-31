.PHONY: docker build-mahjongg install-run-mahjongg build-chess
	install-run-chess xeyes

docker-builder:
	docker build -t flatpak-build .
docker-rpm:
	docker build -t flatpak-rpm -f Dockerfile.flatpakrpm .
docker-leap:
	docker build -t flatpak -f Dockerfile.leap-with-flatpak .

#xauth:
#	export XSOCK=/tmp/.X11-unix
#	export XAUTH=/tmp/.docker.xauth
#	xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -

xeyes:
	docker run -it --rm --network none -e DISPLAY=$(DISPLAY) \
	-v $(XSOCK):$(XSOCK) -v $(XAUTH):$(XAUTH) -e XAUTHORITY=$(XAUTH) \
	flatpak bash

build-mahjongg:
	$(MAKE) build PROGRAM=mahjongg
build-chess:
	$(MAKE) build PROGRAM=chess

build:
	docker run -it --rm --privileged --network none  \
		-v$(PWD)/scripts:/scripts \
		-v$(PWD)/src:/source \
		-v$(PWD)/repo:/repo \
		flatpak-rpm /scripts/build-$(PROGRAM).sh

install-run-mahjongg:
	$(MAKE) install-run PROGRAM=mahjongg
install-run-chess:
	$(MAKE) install-run PROGRAM=chess

install-run: docker-leap
	docker run -it --rm --privileged -e DISPLAY=$(DISPLAY) \
		-v $(XSOCK):$(XSOCK) -v $(XAUTH):$(XAUTH) -e XAUTHORITY=$(XAUTH) \
		-v$(PWD)/scripts:/scripts \
		-v$(PWD)/repo:/repo \
		flatpak /scripts/install-$(PROGRAM).sh

