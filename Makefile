# Makefile
#
# Makefile for resumes
#
# Modification by Olivier Scherler
# Copyright (c) 2002 Bruce Christensen
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#------------------------------------------------------------------------------
# To create example.html, example.txt, example.fo, and example.pdf from
# example.xml, with Italian localization and a4 paper size, use this command:
#
# 	gmake resume=example country=it papersize=a4
#
# To generate just the html version of cv.xml with UK localization, use this
# command:
#
# 	gmake html resume=cv country=uk
#
# To remove all generated files, run:
#
# 	gmake clean
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Basename (filename minus .xml extension) of resume to process
# For example, put "myresume" here to process "myresume.xml".
#------------------------------------------------------------------------------
resume = cv-fr

#------------------------------------------------------------------------------
# Stylesheets
#------------------------------------------------------------------------------
# Options: br de fr it nl uk us es
country = fr
# Options: letter for country=us, a4 for others
papersize = a4

#xsl_base = http://xmlresume.sourceforge.net/xsl
#xsl_base = ../xsl
#xsl_base = ../src/www/xsl
xsl_base = resume-1_5_1/xsl

#html_style = $(xsl_base)/output/$(country)-html.xsl
#text_style = $(xsl_base)/output/$(country)-text.xsl
#fo_style = $(xsl_base)/output/$(country)-$(papersize).xsl
html_style = olivier/$(country)-html.xsl
text_style = olivier/$(country)-text.xsl
fo_style = olivier/$(country)-$(papersize).xsl

pdf_deps = olivier/fo.xsl olivier/fr-a4.xsl olivier/fr.xsl olivier/params.xsl olivier/uk-a4.xsl olivier/uk.xsl
html_deps = olivier/fr-html.xsl olivier/fr.xsl olivier/html.xsl olivier/params.xsl olivier/uk-html.xsl olivier/uk.xsl
text_deps = olivier/fr-text.xsl olivier/fr.xsl olivier/params.xsl olivier/text.xsl olivier/uk-text.xsl olivier/uk.xsl
out_dir = out
tmp_dir = tmp

upgrade_13x_140_style = $(xsl_base)/misc/13x-140.xsl

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
filter_targets = foodservice carpentry
filter_proc = java -cp resume-1_5_1/java/xmlresume-filter.jar:$(CLASSPATH) net.sourceforge.xmlresume.filter.Filter -in $(in) -out $(out) $(filter_targets)

#------------------------------------------------------------------------------
# End configurable parameters
#------------------------------------------------------------------------------

.PHONY: all html text fo pdf clean 13x-140 fonts

default: pdf
all: out/cv-fr.html out/cv-fr.txt tmp/cv-fr.fo out/cv-fr.pdf out/cv-en.html out/cv-en.txt tmp/cv-en.fo out/cv-en.pdf
html: $(out_dir)/cv-en.html $(out_dir)/cv-fr.html
text: $(out_dir)/cv-en.txt $(out_dir)/cv-fr.txt
pdf: $(out_dir)/cv-en.pdf $(out_dir)/cv-fr.pdf
13x-140: $(resume)-140.xml
rtf: $(out_dir)/$(resume).rtf
filter: $(tmp_dir)/$(resume)-filtered.xml

fonts:
	java org.apache.fop.tools.fontlist.FontListMain -c fop.xconf

$(tmp_dir)/cv-en-filtered.xml: filter_targets = en abroad
$(tmp_dir)/cv-en.fo: country = uk
$(out_dir)/cv-en.pdf: country = uk
$(out_dir)/cv-en.txt: country = uk
$(out_dir)/cv-en.html: country = uk

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

$(out_dir)/%.html: in = $(tmp_dir)/$*-filtered.xml
$(out_dir)/%.html: out = $(out_dir)/$*.html
$(out_dir)/%.html: xsl = $(html_style)
$(out_dir)/%.html: $(out_dir) $(tmp_dir)/%-filtered.xml $(html_deps)
	$(xsl_proc)

$(out_dir)/%.txt: in = $(tmp_dir)/$*-filtered.xml
$(out_dir)/%.txt: out = $(out_dir)/$*.txt
$(out_dir)/%.txt: xsl = $(text_style)
$(out_dir)/%.txt: $(out_dir) $(tmp_dir)/%-filtered.xml $(text_deps)
	$(xsl_proc)

$(tmp_dir)/%.fo: in = $(tmp_dir)/$*-filtered.xml
$(tmp_dir)/%.fo: out = $(tmp_dir)/$*.fo
$(tmp_dir)/%.fo: xsl = $(fo_style)
$(tmp_dir)/%.fo: $(tmp_dir)/%-filtered.xml $(pdf_deps)
	$(xsl_proc)

$(out_dir)/%.pdf: in = $(tmp_dir)/$*.fo
$(out_dir)/%.pdf: out = $(out_dir)/$*.pdf
$(out_dir)/%.pdf: $(out_dir) $(tmp_dir)/%.fo
	$(pdf_proc)

$(out_dir)/%.rtf: in = $(tmp_dir)/$*.fo
$(out_dir)/%.rtf: out = $(out_dir)/$*.rtf
$(out_dir)/%.rtf: $(out_dir) $(tmp_dir)/%.fo
	$(rtf_proc)

%-140.xml: in = $*.xml
%-140.xml: out = $*-140.xml
%-140.xml: xsl = $(upgrade_13x_140_style)
%-140.xml: %.xml
	$(xsl_proc)

$(tmp_dir)/%-filtered.xml: in = cv-multilingual.xml
$(tmp_dir)/%-filtered.xml: out = $(tmp_dir)/$*-filtered.xml
$(tmp_dir)/%-filtered.xml: $(tmp_dir) cv-multilingual.xml
	$(filter_proc)

# make out directory
$(out_dir):
	mkdir -p $(out_dir)

# make tmp directory
$(tmp_dir):
	mkdir -p $(tmp_dir)
