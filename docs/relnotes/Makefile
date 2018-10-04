all: relnotes-1.0.html relnotes-0.5.html

%.html: %.md
	pandoc -o $@ $< --css style.css --standalone

clean:
	-rm *.html
