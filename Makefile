### parameters ###

cv = cv-multilingual.xml
theme = olivier
# options: letter for country=us, a4 for others
papersize = a4
languages = fr en
filters = abroad

# final names (online)
fn_en_pdf = Olivier\ Scherler\ CV\ English.pdf
fn_en_html = Olivier\ Scherler\ CV\ English.html
fn_en_txt = Olivier\ Scherler\ CV\ English.txt
fn_fr_pdf = Olivier\ Scherler\ CV\ Français.pdf
fn_fr_html = Olivier\ Scherler\ CV\ Français.html
fn_fr_txt = Olivier\ Scherler\ CV\ Français.txt

# language mappings
country_fr := fr
language_label_fr := Français

country_en := uk
language_label_fr := English

# default country
# options: br de fr it nl uk us es
country = fr

### variables ###

html_style = $(theme)/html/$(country)-html.xsl
text_style = $(theme)/text/$(country)-text.xsl
fo_style = $(theme)/pdf/$(country)-$(papersize).xsl

tmp_dir = tmp
out_dir = out
out_fonts_dir = $(out_dir)/fonts
upload_dir = upload

# web fonts to copy to output
# source
in_fonts_dir = Bergamo-Std-fontfacekit
in_fonts = $(wildcard $(in_fonts_dir)/*.eot $(in_fonts_dir)/*.svg $(in_fonts_dir)/*.ttf $(in_fonts_dir)/*.woff)
# destination
out_fonts = $(in_fonts:$(in_fonts_dir)/%=$(out_fonts_dir)/%)

common_deps = $(theme)/common/*.xsl
pdf_deps = $(common_deps) $(theme)/pdf/*.xsl
html_deps = $(common_deps) $(theme)/html/*.xsl $(out_dir)/style.css $(out_fonts)
text_deps = $(common_deps) $(theme)/text/*.xsl

fo_flags = -c fop.xconf

### processing ###

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
# $(call xsl_proc_xalan,xsl,in,out,xsl_params)
xsl_proc_xalan = $(java) $(xalan_class) $(5) -in $(2) -xsl $(1) -out $(3) $(xsl_flags)
# $(call xsl_proc_saxon,xsl,in,out,xsl_params)
xsl_proc_saxon = $(java) $(saxon_class) $(5) -o $(3) $(2) $1 $(xsl_flags)
# $(call xsl_proc_saxon,xsl,in,out,xsl_params)
xsl_proc_xsltproc = xsltproc -o $(3) $(5) $(xsl_flags) $(1) $(2)

# $(call pdf_proc_fop,in,out)
pdf_proc_fop = $(FOP_HOME)/fop $(fo_flags) -fo $(1) -pdf $(2)
# $(call pdf_proc_xep,in,out)
pdf_proc_xep = ~/bin/xep/run.sh $(fo_flags) $(1) $(2)

# RTF generation currently requires you download a separate, closed source jar 
# file and add it to your java classpath: 	
# http://www.xmlmind.com/foconverter/downloadperso.shtml

# $(call rtf_proc_xmlmind,in,out)
rtf_proc_xmlmind = $(java) $(xmlmind_rtf_class) $(1) $(2)
# $(call rtf_proc_codeconsult,in,out)
rtf_proc_codeconsult = $(java) $(codeconsult_rtf_class) $(1) $(2)

# Element filtering allows you to create targeted resumes.  
# You can create your own targets; just specify them in your resume.xml 
# file with the "targets" attribute.  In this example, the foodservice
# AND carpentry elements will be included in the output, but not the 
# elements targeted to other jobs.  Untargeted elements (those with no 
# "targets" attribute) are always included.  
# Take a look at example2.xml and try changing the filter targets to get a 
# feel for how the filter works.

# $(call filter_proc,in,out,filter_targets)
filter_proc = $(java) $(filter_class) -in $(1) -out $(2) $(3)

# $(call xmllint,in,out)
xmllint = xmllint --format --output $(2) $(1)

# processor selection

xsl_proc = $(xsl_proc_xalan) # xsl_proc_xsltproc is faster, use later
pdf_proc = $(pdf_proc_fop)
rtf_proc = $(rtf_proc_xmlmind)

### targets ###

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

# filter
$(filtered_target): $(cv) $(tmp_dir)
	$(call filter_proc,$<,$@,$* $(filters))

# html
$(html_target): country = $(country_$*)
$(html_target): $(filtered_target) $(out_dir) $(html_deps)
	$(call xsl_proc,$(html_style),$<,$@)

# txt
$(txt_target): country = $(country_$*)
$(txt_target): $(filtered_target) $(out_dir) $(text_deps)
	$(call xsl_proc,$(text_style),$<,$@)

# fo
$(fo_target): country = $(country_$*)
$(fo_target): $(filtered_target) $(pdf_deps)
	$(call xsl_proc,$(fo_style),$<,$@)

# pdf
$(pdf_target): $(fo_target) $(out_dir)
	$(call pdf_proc,$<,$@)

# rtf
$(rtf_target): $(fo_target) $(out_dir)
	$(call rtf_proc,in,out)

# copy CSS file
$(out_dir)/style.css: style.css $(out_dir)
	cp $< $@

# make out directory
$(out_dir):
	mkdir -p $(out_dir)

# make tmp directory
$(tmp_dir):
	mkdir -p $(tmp_dir)

# make upload directory
$(upload_dir):
	mkdir -p $(upload_dir)

# make output fonts directory
$(out_fonts_dir):
	mkdir -p $(out_fonts_dir)

# copy web fonts
$(out_fonts_dir)/%: $(out_fonts_dir) $(in_fonts_dir)/%
	cp $(in_fonts_dir)/$* $(out_fonts_dir)/$*

# list fonts available to FOP
list-fonts:
	$(java) $(font_list_class) -c fop.xconf

# remove referees from xml
$(out_dir)/cv.xml: $(cv) deref.php
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
