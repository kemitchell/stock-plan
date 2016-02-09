CF=node_modules/.bin/commonform

Stock-Plan.docx: Stock-Plan.cform $(CF)
	$(CF) render --format docx --number pae --title "Stock Plan" $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF):
	npm i

