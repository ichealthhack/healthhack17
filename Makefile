HEAD_REV=$(shell git rev-parse HEAD)

all: update build

setup:
	npm install -g pug-cli
	npm install

update:
	npm install
	npm update

build: build/index.html build/images build/css build/js

build/index.html: index.pug
	pug $< -o ./build

build/images: images
	rsync -rupE $< build/

build/css: css
	rsync -rupE $< build/

build/js: js
	rsync -rupE $< build/

deploy: build
	rm -rf build/.git
	git -C build init .
	git -C build fetch "git@github.com:ichealthhack/ichealthhack.github.io.git" master
	git -C build reset --soft FETCH_HEAD
	git -C build add .
	if ! git -C build diff-index --quiet HEAD ; then \
		git -C build commit -m "Deploy ichealthhack/healthhack17@${HEAD_REV}" && \
		git -C build push "git@github.com:ichealthhack/ichealthhack.github.io.git" master:master ; \
		fi
	cd ..

clean:
	rm -rf ./build
