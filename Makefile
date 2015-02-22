# Options: br de fr it nl uk us es
country = fr

# Options: letter for country=us, a4 for others
papersize = a4

html_style = olivier/$(country)-html.xsl
text_style = olivier/$(country)-text.xsl
fo_style = olivier/$(country)-$(papersize).xsl

out_dir = out
tmp_dir = tmp

# web fonts to copy to output
# source
in_fonts_dir = Bergamo-Std-fontfacekit
in_fonts = $(wildcard $(in_fonts_dir)/*.eot $(in_fonts_dir)/*.svg $(in_fonts_dir)/*.ttf $(in_fonts_dir)/*.woff)
# destination
out_fonts_dir = $(out_dir)/fonts
out_fonts = $(patsubst $(in_fonts_dir)/%,$(out_fonts_dir)/%,$(in_fonts))

common_deps = olivier/params.xsl olivier/fr.xsl olivier/uk.xsl
pdf_deps = $(common_deps) olivier/fo.xsl olivier/fr-a4.xsl olivier/uk-a4.xsl
html_deps = $(common_deps) olivier/html.xsl olivier/fr-html.xsl olivier/uk-html.xsl $(out_dir)/style.css $(out_fonts)
text_deps = $(common_deps) olivier/text.xsl olivier/fr-text.xsl olivier/uk-text.xsl

fo_flags = -c fop.xconf

#------------------------------------------------------------------------------
# Processing software
#------------------------------------------------------------------------------
make = make

xsl_proc = java org.apache.xalan.xslt.Process $(xsl_flags) -in $(in) -xsl $(xsl) -out $(out)
#xsl_proc = java com.icl.saxon.StyleSheet $(xsl_flags) -o $(out) $(in) $(xsl) $(xsl_params)

xmllint = xmllint --format --output $(out) $(out)

pdf_proc = $(FOP_HOME)/fop $(fo_flags) -fo $(in) -pdf $(out)
#pdf_proc = ~/bin/xep/run.sh $(fo_flags) $(in) $(out)

# RTF generation currently requires you download a separate, closed source jar 
# file and add it to your java classpath: 	
# http://www.xmlmind.com/foconverter/downloadperso.shtml
rtf_proc = java com.xmlmind.fo.converter.Driver $(in) $(out)
#rtf_proc = java ch.codeconsult.jfor.main.CmdLineConverter $(in) $(out)

# Element filtering allows you to create targeted resumes.  
# You can create your own targets; just specify them in your resume.xml 
# file with the "targets" attribute.  In this example, the foodservice
# AND carpentry elements will be included in the output, but not the 
# elements targeted to other jobs.  Untargeted elements (those with no 
# "targets" attribute) are always included.  
# Take a look at example2.xml and try changing the filter targets to get a 
# feel for how the filter works.
filter_targets = test
filter_proc = java -cp resume-1_5_1/java/xmlresume-filter.jar:$(CLASSPATH) net.sourceforge.xmlresume.filter.Filter -in $(in) -out $(out) $(filter_targets)

#------------------------------------------------------------------------------
# End configurable parameters
#------------------------------------------------------------------------------

.PHONY: all html text fo pdf clean 13x-140 fonts

# otherwise Make will remove them after running as it considers them intermediate
.SECONDARY: $(out_fonts)

default: pdf
all: html text pdf

# formats
html: $(out_dir)/cv-en.html $(out_dir)/cv-fr.html
text: $(out_dir)/cv-en.txt $(out_dir)/cv-fr.txt
pdf: $(out_dir)/cv-en.pdf $(out_dir)/cv-fr.pdf
rtf: $(out_dir)/cv-en.rtf $(out_dir)/cv-fr.rtf

# fr
$(tmp_dir)/cv-en-filtered.xml: filter_targets = en abroad
$(tmp_dir)/cv-en.fo: country = uk
$(out_dir)/cv-en.pdf: country = uk
$(out_dir)/cv-en.txt: country = uk
$(out_dir)/cv-en.html: country = uk

# en
$(tmp_dir)/cv-fr-filtered.xml: filter_targets = fr abroad
$(tmp_dir)/cv-fr.fo: country = fr
$(out_dir)/cv-fr.pdf: country = fr
$(out_dir)/cv-fr.txt: country = fr
$(out_dir)/cv-fr.html: country = fr

clean: clean-cv-fr clean-cv-en

clean-%:
	rm -f $(out_dir)/$*.html
	rm -f $(out_dir)/$*.txt
	rm -f $(tmp_dir)/$*.fo
	rm -f $(out_dir)/$*.pdf
	rm -f $(out_dir)/$*.rtf
	rm -f $(tmp_dir)/$*-filtered.xml

# html
$(out_dir)/%.html: in = $(tmp_dir)/$*-filtered.xml
$(out_dir)/%.html: out = $(out_dir)/$*.html
$(out_dir)/%.html: xsl = $(html_style)
$(out_dir)/%.html: $(out_dir) $(tmp_dir)/%-filtered.xml $(html_deps)
	$(xsl_proc)

# txt
$(out_dir)/%.txt: in = $(tmp_dir)/$*-filtered.xml
$(out_dir)/%.txt: out = $(out_dir)/$*.txt
$(out_dir)/%.txt: xsl = $(text_style)
$(out_dir)/%.txt: $(out_dir) $(tmp_dir)/%-filtered.xml $(text_deps)
	$(xsl_proc)

# fo
$(tmp_dir)/%.fo: in = $(tmp_dir)/$*-filtered.xml
$(tmp_dir)/%.fo: out = $(tmp_dir)/$*.fo
$(tmp_dir)/%.fo: xsl = $(fo_style)
$(tmp_dir)/%.fo: $(tmp_dir)/%-filtered.xml $(pdf_deps)
	$(xsl_proc)

# pdf
$(out_dir)/%.pdf: in = $(tmp_dir)/$*.fo
$(out_dir)/%.pdf: out = $(out_dir)/$*.pdf
$(out_dir)/%.pdf: $(out_dir) $(tmp_dir)/%.fo
	$(pdf_proc)

# rtf
$(out_dir)/%.rtf: in = $(tmp_dir)/$*.fo
$(out_dir)/%.rtf: out = $(out_dir)/$*.rtf
$(out_dir)/%.rtf: $(out_dir) $(tmp_dir)/%.fo
	$(rtf_proc)

# filter
$(tmp_dir)/%-filtered.xml: in = cv-multilingual.xml
$(tmp_dir)/%-filtered.xml: out = $(tmp_dir)/$*-filtered.xml
$(tmp_dir)/%-filtered.xml: $(tmp_dir) cv-multilingual.xml
	$(filter_proc)

# copy CSS file
$(out_dir)/style.css: $(out_dir) style.css
	cp style.css $(out_dir)/style.css

# make out directory
$(out_dir):
	mkdir -p $(out_dir)

# make tmp directory
$(tmp_dir):
	mkdir -p $(tmp_dir)

# make output fonts directory
$(out_fonts_dir):
	mkdir -p $(out_fonts_dir)

# copy web fonts
$(out_fonts_dir)/%: $(out_fonts_dir) $(in_fonts_dir)/%
	cp $(in_fonts_dir)/$* $(out_fonts_dir)/$*

# list fonts available to FOP
list-fonts:
	java org.apache.fop.tools.fontlist.FontListMain -c fop.xconf
