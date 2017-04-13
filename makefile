LATEXMK      = ./out/latexmk.pl
LATEXMK_LINK = https://cedrickc.net/res/latexmk.pl
LATEXMK_ARGS = --pdf --outdir="../out/build" --jobname=document --cd --interaction=nonstopmode --bibtex

TARGET_PDF = ./out/software-design-document.pdf
BUILD_PDF  = ./out/build/document.pdf

all: $(TARGET_PDF)

out/build/:
	mkdir -p out/build

$(LATEXMK): | out/build/
	wget $(LATEXMK_LINK) -O $(LATEXMK)
	chmod +x $(LATEXMK)

prebuild: $(LATEXMK)

$(TARGET_PDF): prebuild $(BUILD_PDF)
	cp $(BUILD_PDF) $(TARGET_PDF)

$(BUILD_PDF): prebuild ./src/*.tex
	$(LATEXMK) $(LATEXMK_ARGS) ./src/sdd.tex

clean:
	-rm -f ./out/latexmk*
	-rm -f ./out/*.pdf
	-rm -f ./out/build/*

.PHONY: all prebuild clean
