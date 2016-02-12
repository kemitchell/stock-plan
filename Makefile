CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate

TARGETS=Option-Exercise-Agreement Option-Agreement Option-Notice Stock-Plan Stockholder-Approval-of-Stock-Plan Board-Approval-of-Stock-Plan Restricted-Stock-Purchase-Agreement Stock-Power Receipt-and-Consent 83b-Election Receipt

all: $(TARGETS:=.docx)

pdf: $(TARGETS:=.pdf)

Receipt.docx: Receipt.cform Receipt.sigs.json $(CF)
	$(CF) render -f docx -n decimal -s Receipt.sigs.json --title "Receipt" Receipt.cform > $@

83b-Election.docx: 83b-Election.cform 83b-Election.sigs.json $(CF)
	$(CF) render -f docx -n decimal -s 83b-Election.sigs.json --title "Election Under Section 83(b) of the Internal Revenue Code of 1986" 83b-Election.cform > $@

Receipt-and-Consent.docx: Receipt-and-Consent.cform Receipt-and-Consent.sigs.json $(CF)
	$(CF) render -f docx -n ase --title "Receipt and Consent" -s Receipt-and-Consent.sigs.json $< > $@

Stock-Power.docx: Stock-Power.cform Stock-Power.sigs.json $(CF)
	$(CF) render -f docx -n decimal --title "Stock Power" -s Stock-Power.sigs.json Stock-Power.cform > $@

Board-Approval-of-Stock-Plan.docx: Board-Approval-of-Stock-Plan.cform Board-Approval-of-Stock-Plan.sigs.json $(CF)
	$(CF) render -f docx -n rse --title "Action by Written Consent of the Board" -s Board-Approval-of-Stock-Plan.sigs.json $< > $@

Stockholder-Approval-of-Stock-Plan.docx: Stockholder-Approval-of-Stock-Plan.cform Stockholder-Approval-of-Stock-Plan.sigs.json $(CF)
	$(CF) render -f docx -n rse --title "Action by Written Consent of Stockholders" -s Stockholder-Approval-of-Stock-Plan.sigs.json $< > $@

Option-Exercise-Agreement.docx: Option-Exercise-Agreement.cform Option-Exercise-Agreement.sigs.json $(CF)
	$(CF) render -f docx -n outline --title "Option Exercise Agreement" -s Option-Exercise-Agreement.sigs.json $< > $@

Option-Agreement.docx: Option-Agreement.cform $(CF)
	$(CF) render -f docx -n ase --title "Option Agreement" $< > $@

Restricted-Stock-Purchase-Agreement.docx: Restricted-Stock-Purchase-Agreement.cform Restricted-Stock-Purchase-Agreement.sigs.json $(CF)
	$(CF) render -f docx -n ase --title "Restricted-Stock-Purchase Agreement" -s Restricted-Stock-Purchase-Agreement.sigs.json $< > $@

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
