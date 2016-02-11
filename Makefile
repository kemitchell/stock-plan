CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate

TARGETS=Option-Exercise-Agreement Option-Agreement Option-Notice Stock-Plan

all: $(TARGETS:=.docx)

pdf: $(TARGETS:=.pdf)

Option-Exercise-Agreement.docx: Option-Exercise-Agreement.cform Option-Exercise-Agreement.sigs.json $(CF)
	$(CF) render -f docx -n outline --title "Option Exercise Agreement" -s Option-Exercise-Agreement.sigs.json $< > $@

Option-Agreement.docx: Option-Agreement.cform $(CF)
	$(CF) render -f docx -n ase --title "Option Agreement" $< > $@

Option-Notice.docx: Option-Notice.cform Option-Notice.sigs.json $(CF)
	$(CF) render -f docx -n outline --title "Option Notice" -s Option-Notice.sigs.json $< > $@

Stock-Plan.docx: Stock-Plan.cform $(CF)
	$(CF) render --format docx --number pae --title "Stock Plan" $< > $@

%.cform: %.cftemplate options.json $(CFT)
	$(CFT) $*.cftemplate options.json > $@

options.json:
	echo '{}' > $@

%.pdf: %.docx
	doc2pdf $<

$(CF):
	npm i

.PHONY: clean

clean:
	rm -f $(TARGETS:=.docx) $(TARGETS:=.pdf) $(TARGETS:=.cform)
