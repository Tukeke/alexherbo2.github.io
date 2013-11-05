sources := $(wildcard *.md)
PDFs    := $(sources:.md=.pdf)

pdfs: $(PDFs)

%.pdf : %.md
	pandoc $< --output $@

clean:
	rm $(PDFs)
