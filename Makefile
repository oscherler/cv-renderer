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
html: out/$(resume).html
text: out/$(resume).txt
fo: tmp/$(resume).fo
pdf: out/cv-en.pdf out/cv-fr.pdf
13x-140: $(resume)-140.xml
rtf: out/$(resume).rtf
filter: tmp/$(resume)-filtered.xml

fonts:
	java org.apache.fop.tools.fontlist.FontListMain -c fop.xconf

tmp/cv-en-filtered.xml: filter_targets = en abroad
tmp/cv-en.fo: country = uk
out/cv-en.pdf: country = uk
out/cv-en.txt: country = uk
out/cv-en.html: country = uk

tmp/cv-fr-filtered.xml: filter_targets = fr abroad
tmp/cv-fr.fo: country = fr
out/cv-fr.pdf: country = fr
out/cv-fr.txt: country = fr
out/cv-fr.html: country = fr

clean: clean-cv-fr clean-cv-en

clean-%:
	rm -f out/$*.html
	rm -f out/$*.txt
	rm -f tmp/$*.fo
	rm -f out/$*.pdf
	rm -f out/$*.rtf
	rm -f tmp/$*-filtered.xml

out/%.html: in = tmp/$*-filtered.xml
out/%.html: out = out/$*.html
out/%.html: xsl = $(html_style)
out/%.html: tmp/%-filtered.xml $(html_deps)
	$(xsl_proc)

out/%.txt: in = tmp/$*-filtered.xml
out/%.txt: out = out/$*.txt
out/%.txt: xsl = $(text_style)
out/%.txt: tmp/%-filtered.xml $(text_deps)
	$(xsl_proc)

tmp/%.fo: in = tmp/$*-filtered.xml
tmp/%.fo: out = tmp/$*.fo
tmp/%.fo: xsl = $(fo_style)
tmp/%.fo: tmp/%-filtered.xml $(pdf_deps)
	$(xsl_proc)

out/%.pdf: in = tmp/$*.fo
out/%.pdf: out = out/$*.pdf
out/%.pdf: tmp/%.fo
	$(pdf_proc)

out/%.rtf: in = tmp/$*.fo
out/%.rtf: out = out/$*.rtf
out/%.rtf: tmp/%.fo
	$(rtf_proc)

%-140.xml: in = $*.xml
%-140.xml: out = $*-140.xml
%-140.xml: xsl = $(upgrade_13x_140_style)
%-140.xml: %.xml
	$(xsl_proc)

tmp/%-filtered.xml: in = cv-multilingual.xml
tmp/%-filtered.xml: out = tmp/$*-filtered.xml
tmp/%-filtered.xml: cv-multilingual.xml
	$(filter_proc)
