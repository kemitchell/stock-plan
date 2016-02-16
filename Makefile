CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
JSON=node_modules/.bin/json
SHARED=$(wildcard shared/*.cform)

BASENAMES=option-exercise-agreement option-agreement option-notice stock-plan stockholder-approval board-approval restricted-stock-purchase-agreement stock-power receipt-from-recipient 83b-election receipt-from-company 83b-statement
TARGETS=$(addprefix output/,$(BASENAMES))

all: output $(TARGETS:=.docx)

pdf: output $(TARGETS:=.pdf)

output:
	mkdir -p $@

# Build with Docker

docker:
	docker build -t stock-plan .
	docker run -v $(shell pwd)/output:/app/output stock-plan

# DocX Rules

output/%.docx: %.cform %.sigs.json %.options %.blanks $(SHARED) $(CF)
	$(CF) render -s $*.sigs.json --format docx -b $*.blanks $(shell cat $*.options) $< > $@

output/%.docx: %.cform %.options %.blanks $(SHARED) $(CF)
	$(CF) render --format docx -b $*.blanks $(shell cat $*.options) $< > $@

output/%.docx: %.cform %.sigs.json %.options $(SHARED) $(CF)
	$(CF) render -s $*.sigs.json --format docx $(shell cat $*.options) $< > $@

output/%.docx: %.cform %.options $(SHARED) $(CF)
	$(CF) render --format docx $(shell cat $*.options) $< > $@

# Templating

%.cform: %.cftemplate options.json $(CFT)
	$(CFT) $*.cftemplate options.json > $@

# Template Options

options.json blanks.json:
	echo '{}' > $@

# Fill-in-the-Blanks

%.blanks: %.blanks.json blanks.json $(JSON)
	cat blanks.json $*.blanks.json | $(JSON) --merge > $@

%.blanks: blanks.json
	cp $< $@

# PDF Conversion

output/%.pdf: output/%.docx
	doc2pdf $<

# npm Build Tools

$(CF) $(CFT):
	npm i

LINT_TARGETS=$(BASENAMES:=.lint)

TERMS_FROM_PLAN=restricted-stock-purchase-agreement option-exercise-agreement

.PHONY: clean lint

clean:
	rm -f $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.cform)

lint: $(LINT_TARGETS)

%.lint: %.cform $(CF)
	$(CF) lint $*.cform
