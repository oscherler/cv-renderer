# Options: br de fr it nl uk us es
country = fr

# Options: letter for country=us, a4 for others
papersize = a4

theme = olivier

html_style = $(theme)/html/$(country)-html.xsl
text_style = $(theme)/text/$(country)-text.xsl
fo_style = $(theme)/pdf/$(country)-$(papersize).xsl

tmp_dir = tmp
out_dir = out
out_fonts_dir = $(out_dir)/fonts
upload_dir = upload

folders = $(out_dir) $(tmp_dir) $(upload_dir) $(out_fonts_dir)

filters = abroad
languages = fr en

# language to country mapping
country_fr := fr
country_en := uk

# web fonts to copy to output
# source
in_fonts_dir = Bergamo-Std-fontfacekit
in_fonts = $(wildcard $(in_fonts_dir)/*.eot $(in_fonts_dir)/*.svg $(in_fonts_dir)/*.ttf $(in_fonts_dir)/*.woff)
# destination
out_fonts = $(in_fonts:$(in_fonts_dir)/%=$(out_fonts_dir)/%)

common_deps = folders $(theme)/common/*.xsl
pdf_deps = $(common_deps) $(theme)/pdf/*.xsl
html_deps = $(common_deps) $(theme)/html/*.xsl $(out_dir)/style.css $(out_fonts)
text_deps = $(common_deps) $(theme)/text/*.xsl

# final names (online)
fn_en_pdf = Olivier\ Scherler\ CV\ English.pdf
fn_en_html = Olivier\ Scherler\ CV\ English.html
fn_en_txt = Olivier\ Scherler\ CV\ English.txt
fn_fr_pdf = Olivier\ Scherler\ CV\ Français.pdf
fn_fr_html = Olivier\ Scherler\ CV\ Français.html
fn_fr_txt = Olivier\ Scherler\ CV\ Français.txt

fo_flags = -c fop.xconf

#------------------------------------------------------------------------------
# Processing software
#------------------------------------------------------------------------------
make = make

# JAVA_HOME should be defined in the environment with `export JAVA_HOME=$(/usr/libexec/java_home)`
# FOP_HOME = fop-1.1 # if not defined system-wide
local_classpath = resume-1_5_1/java/xmlresume-filter.jar:$(CLASSPATH)
java = java -cp $(local_classpath)

xalan_class = org.apache.xalan.xslt.Process
saxon_class = com.icl.saxon.StyleSheet
xmlmind_rtf_class = com.xmlmind.fo.converter.Driver
codeconsult_rtf_class = ch.codeconsult.jfor.main.CmdLineConverter
filter_class = net.sourceforge.xmlresume.filter.Filter
font_list_class = org.apache.fop.tools.fontlist.FontListMain

# processors
xsl_proc_xalan = $(java) $(xalan_class) $(xsl_flags) -in $(in) -xsl $(xsl) -out $(out) $(xsl_params)
xsl_proc_saxon = $(java) $(saxon_class) $(xsl_flags) -o $(out) $(in) $(xsl) $(xsl_params)
xsl_proc_xsltproc = xsltproc -o $(out) $(xsl_flags) $(xsl_params) $(xsl) $(in)

pdf_proc_fop = $(FOP_HOME)/fop $(fo_flags) -fo $(in) -pdf $(out)
pdf_proc_xep = ~/bin/xep/run.sh $(fo_flags) $(in) $(out)

# RTF generation currently requires you download a separate, closed source jar 
# file and add it to your java classpath: 	
# http://www.xmlmind.com/foconverter/downloadperso.shtml
rtf_proc_xmlmind = $(java) $(xmlmind_rtf_class) $(in) $(out)
rtf_proc_codeconsult = $(java) $(codeconsult_rtf_class) $(in) $(out)

# Element filtering allows you to create targeted resumes.  
# You can create your own targets; just specify them in your resume.xml 
# file with the "targets" attribute.  In this example, the foodservice
# AND carpentry elements will be included in the output, but not the 
# elements targeted to other jobs.  Untargeted elements (those with no 
# "targets" attribute) are always included.  
# Take a look at example2.xml and try changing the filter targets to get a 
# feel for how the filter works.
filter_proc = $(java) $(filter_class) -in $(in) -out $(out) $(filter_targets)

xmllint = xmllint --format --output $(out) $(out)

# processor selection

xsl_proc = $(xsl_proc_xalan) # xsl_proc_xsltproc is faster, use later
pdf_proc = $(pdf_proc_fop)
rtf_proc = $(rtf_proc_xmlmind)

#------------------------------------------------------------------------------
# End configurable parameters
#------------------------------------------------------------------------------

.PHONY: all html text pdf rtf clean list-fonts upload_files sync

# otherwise Make will remove them after running as it considers them intermediate
.SECONDARY: $(out_fonts)

default: pdf
all: html text pdf

# formats
html: $(languages:%=$(out_dir)/cv-%.html)
text: $(languages:%=$(out_dir)/cv-%.txt)
pdf: $(languages:%=$(out_dir)/cv-%.pdf)
rtf: $(languages:%=$(out_dir)/cv-%.rtf)

clean: clean-cv-fr clean-cv-en

clean-%:
	rm -f $(out_dir)/$*.html
	rm -f $(out_dir)/$*.txt
	rm -f $(tmp_dir)/$*.fo
	rm -f $(out_dir)/$*.pdf
	rm -f $(out_dir)/$*.rtf
	rm -f $(tmp_dir)/$*-filtered.xml

filtered_target = $(tmp_dir)/cv-%-filtered.xml
html_target = $(out_dir)/cv-%.html
txt_target = $(out_dir)/cv-%.txt
fo_target = $(tmp_dir)/cv-%.fo
pdf_target = $(out_dir)/cv-%.pdf
rtf_target = $(out_dir)/cv-%.rtf

# html
$(html_target): country = $(country_$*)
$(html_target): in = $<
$(html_target): out = $@
$(html_target): xsl = $(html_style)
$(html_target): $(filtered_target) $(out_dir) $(html_deps)
	$(xsl_proc)

# txt
$(txt_target): country = $(country_$*)
$(txt_target): in = $<
$(txt_target): out = $@
$(txt_target): xsl = $(text_style)
$(txt_target): $(filtered_target) $(out_dir) $(text_deps)
	$(xsl_proc)

# fo
$(fo_target): country = $(country_$*)
$(fo_target): in = $<
$(fo_target): out = $@
$(fo_target): xsl = $(fo_style)
$(fo_target): $(filtered_target) $(pdf_deps)
	$(xsl_proc)

# pdf
$(pdf_target): in = $<
$(pdf_target): out = $@
$(pdf_target): $(tmp_dir)/%.fo $(out_dir)
	$(pdf_proc)

# rtf
$(rtf_target): in = $<
$(rtf_target): out = $@
$(rtf_target): $(tmp_dir)/%.fo $(out_dir)
	$(rtf_proc)

# filter
$(filtered_target): in = $<
$(filtered_target): out = $@
$(filtered_target): filter_targets = $* $(filters)
$(filtered_target): cv-multilingual.xml $(tmp_dir)
	$(filter_proc)

# copy CSS file
$(out_dir)/style.css: style.css $(out_dir)
	cp $< $@

folders:
	mkdir -p $(folders)

# copy web fonts
$(out_fonts_dir)/%: $(out_fonts_dir) $(in_fonts_dir)/%
	cp $(in_fonts_dir)/$* $(out_fonts_dir)/$*

# list fonts available to FOP
list-fonts:
	$(java) $(font_list_class) -c fop.xconf

# remove referees from xml
$(out_dir)/cv.xml: cv-multilingual.xml deref.php
	php deref.php $< $@

# copy online files to upload dir
upload_files: $(upload_dir) $(upload_dir)/$(fn_en_pdf) $(upload_dir)/$(fn_fr_pdf) $(upload_dir)/$(fn_en_txt) $(upload_dir)/$(fn_fr_txt) $(upload_dir)/$(fn_en_html) $(upload_dir)/$(fn_fr_html) $(upload_dir)/Source\ CV.xml

# English pdf
$(upload_dir)/$(fn_en_pdf): src = cv-en.pdf
$(upload_dir)/$(fn_en_pdf): $(out_dir)/cv-en.pdf
# French pdf
$(upload_dir)/$(fn_fr_pdf): src = cv-fr.pdf
$(upload_dir)/$(fn_fr_pdf): $(out_dir)/cv-fr.pdf
# English txt
$(upload_dir)/$(fn_en_txt): src = cv-en.txt
$(upload_dir)/$(fn_en_txt): $(out_dir)/cv-en.txt
# French txt
$(upload_dir)/$(fn_fr_txt): src = cv-fr.txt
$(upload_dir)/$(fn_fr_txt): $(out_dir)/cv-fr.txt
# English html
$(upload_dir)/$(fn_en_html): src = cv-en.html
$(upload_dir)/$(fn_en_html): $(out_dir)/cv-en.html
# French html
$(upload_dir)/$(fn_fr_html): src = cv-fr.html
$(upload_dir)/$(fn_fr_html): $(out_dir)/cv-fr.html
# Source xml
$(upload_dir)/Source\ CV.xml: src = cv.xml
$(upload_dir)/Source\ CV.xml: $(out_dir)/cv.xml

# upload copy rule
$(upload_dir)/%: $(src)
	cp $(out_dir)/$(src) '$(upload_dir)/$*'

# upload
sync: upload_files $(out_fonts) $(out_dir)/style.css
	# main files
	rsync -avz upload/ its:domains/olivier.ithink.ch/www/cv/_public/
	# fonts
	rsync -avz out/fonts/ its:domains/olivier.ithink.ch/www/cv/fonts/
	# css
	scp out/style.css its:domains/olivier.ithink.ch/www/cv/style.css
