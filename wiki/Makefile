sources := $(wildcard *.md)
html    := $(sources:.md=.html)

html: $(html)

%.html : %.md
	pandoc --template template.html $< --output $@

clean:
	rm $(html)
