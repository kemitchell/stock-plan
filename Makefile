CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
JSON=node_modules/.bin/json
SHARED=$(wildcard shared/*.cform)

TARGETS=Option-Exercise-Agreement Option-Agreement Option-Notice Stock-Plan Stockholder-Approval Board-Approval Restricted-Stock-Purchase-Agreement Stock-Power Receipt-from-Purchaser 83b-Election Receipt-from-Company 83b-Statement

all: $(TARGETS:=.docx)

pdf: $(TARGETS:=.pdf)

%.docx: %.cform %.sigs.json %.options %.blanks $(SHARED) $(CF)
	$(CF) render -s $*.sigs.json --format docx -b $*.blanks $(shell cat $*.options) $< > $@

%.docx: %.cform %.options %.blanks $(SHARED) $(CF)
	$(CF) render --format docx -b $*.blanks $(shell cat $*.options) $< > $@

%.docx: %.cform %.sigs.json %.options $(SHARED) $(CF)
	$(CF) render -s $*.sigs.json --format docx $(shell cat $*.options) $< > $@

%.docx: %.cform %.options $(SHARED) $(CF)
	$(CF) render --format docx $(shell cat $*.options) $< > $@

%.cform: %.cftemplate options.json $(CFT)
	$(CFT) $*.cftemplate options.json > $@

%.blanks: %.blanks.json blanks.json $(JSON)
	cat blanks.json $*.blanks.json | $(JSON) --merge > $@

%.blanks: blanks.json
	cp $< $@

options.json blanks.json:
	echo '{}' > $@

%.pdf: %.docx
	doc2pdf $<

$(CF) $(CFT):
	npm i

.PHONY: clean

clean:
	rm -f $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.cform)
