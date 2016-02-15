CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
JSON=node_modules/.bin/json
SHARED=$(wildcard shared/*.cform)

BASENAMES=Option-Exercise-Agreement Option-Agreement Option-Notice Stock-Plan Stockholder-Approval Board-Approval Restricted-Stock-Purchase-Agreement Stock-Power Receipt-from-Purchaser 83b-Election Receipt-from-Company 83b-Statement
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

TERMS_FROM_PLAN=Restricted-Stock-Purchase-Agreement Option-Exercise-Agreement

.PHONY: clean lint

clean:
	rm -f $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.cform)

lint: $(LINT_TARGETS)

%.lint: %.cform $(CF)
	$(CF) lint $*.cform
