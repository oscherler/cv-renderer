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
all: cv-fr.html cv-fr.txt cv-fr.fo cv-fr.pdf cv-en.html cv-en.txt cv-en.fo cv-en.pdf
html: $(resume).html
text: $(resume).txt
fo: $(resume).fo
pdf: $(resume).pdf
13x-140: $(resume)-140.xml
rtf: $(resume).rtf
filter: $(resume)-filtered.xml

fonts:
	java org.apache.fop.tools.fontlist.FontListMain -c fop.xconf

cv-en.fo: country = uk
cv-en.pdf: country = uk
cv-en.txt: country = uk
cv-en.html: country = uk

cv-fr.fo: country = fr
cv-fr.pdf: country = fr
cv-fr.txt: country = fr
cv-fr.html: country = fr

clean: clean-cv-fr clean-cv-en

clean-%:
	rm -f $*.html
	rm -f $*.txt
	rm -f $*.fo
	rm -f $*.pdf
	rm -f $*.rtf
	rm -f $*-filtered.xml
	rm -f $*-filtered.html
	rm -f $*-filtered.txt
	rm -f $*-filtered.pdf
	rm -f $*-filtered.fo
	rm -f $*-filtered.rtf

%.html: in = $*-filtered.xml
%.html: out = $*.html
%.html: xsl = $(html_style)
%.html: %-filtered.xml $(html_deps)
	$(xsl_proc)

%.txt: in = $*-filtered.xml
%.txt: out = $*.txt
%.txt: xsl = $(text_style)
%.txt: %-filtered.xml $(text_deps)
	$(xsl_proc)

%.fo: in = $*-filtered.xml
%.fo: out = $*.fo
%.fo: xsl = $(fo_style)
%.fo: %-filtered.xml $(pdf_deps)
	$(xsl_proc)

%.pdf: in = $*.fo
%.pdf: out = $*.pdf
%.pdf: %.fo
	$(pdf_proc)

%.rtf: in = $*.fo
%.rtf: out = $*.rtf
%.rtf: %.fo
	$(rtf_proc)

%-140.xml: in = $*.xml
%-140.xml: out = $*-140.xml
%-140.xml: xsl = $(upgrade_13x_140_style)
%-140.xml: %.xml
	$(xsl_proc)

%-filtered.xml: in = $*.xml
%-filtered.xml: out = $*-filtered.xml
%-filtered.xml: %.xml
	$(filter_proc)
	$(make) all resume=$*-filtered

cv-fr-filtered.xml: in = cv-multilingual.xml
cv-fr-filtered.xml: out = cv-fr-filtered.xml
cv-fr-filtered.xml: filter_targets = fr abroad
cv-fr-filtered.xml: cv-multilingual.xml
	$(filter_proc)
	$(make) all resume=cv-fr-filtered

cv-en-filtered.xml: in = cv-multilingual.xml
cv-en-filtered.xml: out = cv-en-filtered.xml
cv-en-filtered.xml: filter_targets = en abroad
cv-en-filtered.xml: cv-multilingual.xml
	$(filter_proc)
	$(make) all resume=cv-en-filtered
