LATEXMK      = ./out/latexmk.pl
LATEXMK_LINK = https://cedrickc.net/res/latexmk.pl
LATEXMK_ARGS = --pdf --outdir="../out/build" --jobname=document --cd --interaction=nonstopmode --bibtex

PLANTUML      = ./out/plantuml.jar
PLANTUML_LINK = https://cedrickc.net/res/plantuml.jar
PLANTUML_ARGS = -o ../out/build/ -tpng

TARGET_PDF = ./out/software-design-document.pdf
BUILD_PDF  = ./out/build/document.pdf

all: $(TARGET_PDF)

out/build/:
	mkdir -p out/build

$(LATEXMK): | out/build/
	wget $(LATEXMK_LINK) -O $(LATEXMK)
	chmod +x $(LATEXMK)

$(PLANTUML): | out/build/
	wget $(PLANTUML_LINK) -O $(PLANTUML)
	chmod +x $(PLANTUML)

prebuild: $(LATEXMK) $(PLANTUML)

$(TARGET_PDF): prebuild $(BUILD_PDF)
	cp $(BUILD_PDF) $(TARGET_PDF)

$(BUILD_PDF): prebuild ./src/*.tex diagrams
	$(LATEXMK) $(LATEXMK_ARGS) ./src/sdd.tex

diagrams: ./plantuml/*.uml
	java -jar $(PLANTUML) $(PLANTUML_ARGS) $^

clean:
	-rm -f ./out/*.jar
	-rm -f ./out/latexmk.pl
	-rm -f ./out/*.pdf
	-rm -f ./out/build/*

.PHONY: all diagrams prebuild clean
