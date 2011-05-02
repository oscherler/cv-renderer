<?xml version="1.0" encoding="UTF-8"?>

<!--
olivier/html.xsl by Olivier Scherler
Transform XML resume into HTML.

Based on html.xsl Copyright (c) 2001 Sean Kelly
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->

<xsl:stylesheet xmlns:r="http://xmlresume.sourceforge.net/resume/0.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0" 
 exclude-result-prefixes="r">

  <xsl:import href="../resume-1_5_1/xsl/format/html.xsl"/>

  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="UTF-8" 
   doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
   doctype-system="http://www.w3.org/TR/xhtml1/DTD/strict.dtd"/>
   
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>

</xsl:stylesheet>
