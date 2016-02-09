Stock-Plan.docx: Stock-Plan.cform
	commonform render --format docx --number pae --title "Stock Plan" $< > $@

%.pdf: %.docx
	doc2pdf $<
