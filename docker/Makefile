#! make

all: build up browse

build:
	docker build -t recraft/retrosearch:0.6 -t recraft/retrosearch:latest .

up:
	docker-compose up -d

clean:
	docker-compose down

browse:
	firefox http://localhost:3838 &

browse-ext:
	firefox https://retrosearch.recraft.me &


