#! make

VER := 0.8
#PKGSRC := $(shell basename `pwd`)

all: clean build up browse

build:
	#cd ..; R -e "devtools::build()"
	cd ..; R CMD build --no-manual .
	cd ..; mv retrosearch_$(VER).tar.gz docker
	cp retrosearch_$(VER).tar.gz retrosearch.tar.gz
	docker build -t recraft/retrosearch:$(VER) -t recraft/retrosearch:latest .

up:
	docker-compose up -d

clean:
	docker-compose down

browse:
	firefox http://localhost:3838 &

browse-ext:
	firefox https://retrosearch.recraft.me &

release:
	docker push recraft/retrosearch:$(VER) 
	docker push recraft/retrosearch:latest
