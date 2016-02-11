CF=node_modules/.bin/commonform

Option-Agreement.docx: Option-Agreement.cform $(CF)
	$(CF) render -f docx -n outline --title "Option Agreement" $< > $@

Option-Notice.docx: Option-Notice.cform Option-Notice.sigs.json $(CF)
	$(CF) render -f docx -n outline --title "Option Notice" -s Option-Notice.sigs.json $< > $@

Stock-Plan.docx: Stock-Plan.cform $(CF)
	$(CF) render --format docx --number pae --title "Stock Plan" $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF):
	npm i

