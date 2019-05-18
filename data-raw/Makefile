#! make

all: build favicon.ico clean

build: png2ico/png2ico

png2ico/png2ico:
	wget http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz
	gunzip png2ico-src-2002-12-08.tar.gz
	tar xvf png2ico-src-2002-12-08.tar
	make -C png2ico
	rm png2ico-src-2002-12-08.tar

square:
	convert -define jpeg:size=155x55 logo-orig.png \
		-thumbnail '128x128>' \
		-background transparent \
		-gravity center \
		-extent 128x128 \
			logo-square.png

favicon.ico: build
	convert logo-square.png -resize 16x16^ favicon-16.png
	convert logo-square.png -resize 32x32^ favicon-32.png
	convert logo-square.png -resize 64x64^ favicon-64.png
	png2ico/png2ico favicon.ico favicon-16.png favicon-32.png favicon-64.png

clean:
	rm favicon-*.png
	rm -rf png2ico