<?xml version="1.0" encoding="UTF-8"?>

<!--
olivier/text.xsl
Transform XML resume into plain text.

Based on text.xsl Copyright (c) 2000-2002 by Vlad Korolev, Sean Kelly, and Bruce Christensen

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

<!--
In general, each block is responsible for outputting a newline after itself.
-->

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="http://olivier.ithink.ch/resume/extension/0.0">

  <xsl:import href="../../resume-1_5_1/xsl/format/text.xsl"/>

  <xsl:output method="text" omit-xml-declaration="yes" indent="no"
    encoding="UTF-8"/>
  <xsl:output doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="../common/params.xsl"/>

  <xsl:template match="r:contact/r:url">
    <xsl:choose>
      <xsl:when test="@x:label">
        <xsl:value-of select="@x:label"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url.word"/>
      </xsl:otherwise>
    </xsl:choose><xsl:text>: </xsl:text>
    <xsl:apply-templates/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Objective, with level 2 heading. -->
  <xsl:template match="r:objective">
    <xsl:if test="$objective.heading.display = 1">
      <xsl:call-template name="Heading">
        <xsl:with-param name="Text" select="$objective.word"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the referees -->
  <xsl:template match="r:referees">
    <xsl:call-template name="Heading">
      <xsl:with-param name="Text" select="$referees.word"/>
    </xsl:call-template>

    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:choose>

          <xsl:when test="$referees.display = 1">
            <xsl:apply-templates select="r:referee"/>
          </xsl:when>

          <xsl:otherwise>
            <xsl:call-template name="Wrap">
              <xsl:with-param name="Text">
                <xsl:value-of select="$referees.hidden.phrase"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="NewLine"/>
          </xsl:otherwise>

        </xsl:choose>
        <xsl:if test="$referees.no_contact = 1">
          <xsl:call-template name="NewLine"/>
          <xsl:value-of select="$referees.no_contact.phrase"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:copyright"/>

</xsl:stylesheet>
