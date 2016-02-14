CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate

TARGETS=Option-Exercise-Agreement Option-Agreement Option-Notice Stock-Plan Stockholder-Approval Board-Approval Restricted-Stock-Purchase-Agreement Stock-Power Receipt-from-Purchaser 83b-Election Receipt-from-Company 83b-Acknowledgment-and-Statement

all: $(TARGETS:=.docx)

pdf: $(TARGETS:=.pdf)

%.docx: %.cform %.sigs.json %.options $(CF)
	$(CF) render -s $*.sigs.json --format docx $(shell cat $*.options) $< > $@

%.docx: %.cform %.options $(CF)
	$(CF) render --format docx $(shell cat $*.options) $< > $@

%.cform: %.cftemplate options.json $(CFT)
	$(CFT) $*.cftemplate options.json > $@

options.json:
	echo '{}' > $@

%.pdf: %.docx
	doc2pdf $<

$(CF) $(CFT):
	npm i

.PHONY: clean

clean:
	rm -f $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.cform)
