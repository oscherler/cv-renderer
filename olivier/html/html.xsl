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

<xsl:stylesheet version="1.0"
  xmlns:r="http://xmlresume.sourceforge.net/resume/0.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
  xmlns:x="http://olivier.ithink.ch/resume/extension/0.0"
  exclude-result-prefixes="r x">

  <xsl:import href="../../resume-1_5_1/xsl/format/html.xsl"/>

  <xsl:strip-space elements="*"/>

  <xsl:include href="../common/params.xsl"/>

  <xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="UTF-8" 
   doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" 
   doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>

  <xsl:template name="Heading">
    <xsl:param name="Text">HEADING NOT DEFINED</xsl:param>
    <h2><xsl:copy-of select="$Text"/></h2>
  </xsl:template>

  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:apply-templates select="r:resume/r:header/r:name"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="$resume.word"/>
        </title>
		<link rel="stylesheet" type="text/css">
		  <xsl:attribute name="href"><xsl:value-of select="$css.href"/></xsl:attribute>
		</link>
        <xsl:apply-templates select="r:resume/r:keywords" mode="header"/>
      </head>
      <body>
        <xsl:apply-templates select="r:resume"/>
      </body>
    </html>
  </xsl:template>

  <!-- Output your name and the word "Resume". -->
  <xsl:template match="r:header" mode="standard">
    <h1>
      <xsl:apply-templates select="r:name"/>
      <xsl:text> – </xsl:text>
      <xsl:value-of select="$resume.word"/>
    </h1>
    <div id="header">
      <div id="birth-address">
      	<dl>
          <dt><xsl:value-of select="$birth.word"/><xsl:value-of select="$label.colon"/></dt>
          <dd><xsl:apply-templates select="r:birth/r:date"/></dd>
        </dl>
      	<dl>
          <dt><xsl:value-of select="$address.word"/><xsl:value-of select="$label.colon"/></dt>
          <dd><xsl:apply-templates select="r:address"/></dd>
        </dl>
      </div>
      <div id="nat-contact">
      	<dl>
          <dt><xsl:value-of select="$nationality.word"/><xsl:value-of select="$label.colon"/></dt>
          <dd><xsl:apply-templates select="r:birth/x:nationality"/></dd>
      	</dl>
        <xsl:apply-templates select="r:contact"/>
      </div>
    </div>
  </xsl:template>

  <!-- Named template to format a single contact field *SE* -->
  <!-- Don't print the label if the field value is empty *SE* -->
  <xsl:template name="contact">
    <xsl:param name="label"/>
    <xsl:param name="field"/>
    <xsl:param name="link" select="''"/>
    <xsl:if test="string-length($field) > 0">
      <dt><xsl:value-of select="$label"/><xsl:value-of select="$label.colon"/></dt>
      <dd>
        <xsl:choose>
          <xsl:when test="string-length( $link ) > 0">
            <a href="{$link}"><xsl:value-of select="$field"/></a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$field"/>
          </xsl:otherwise>
        </xsl:choose>
      </dd>
    </xsl:if>
  </xsl:template>

  <!-- Format contact information. -->

  <xsl:template match="r:contact">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="r:contact/r:phone">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:call-template name="PhoneLocation">
          <xsl:with-param name="Location" select="@location"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
      	<xsl:text>tel:</xsl:text>
      	<xsl:value-of select="translate( ., ' ', '' )"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:fax">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:call-template name="FaxLocation">
          <xsl:with-param name="Location" select="@location"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:pager">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:value-of select="$pager.word"/>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:email">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:value-of select="$email.word"/>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
        <xsl:text>mailto:</xsl:text><xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:url">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:value-of select="$url.word"/>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:instantMessage">
    <xsl:call-template name="contact">
      <xsl:with-param name="label">
        <xsl:call-template name="IMServiceName">
          <xsl:with-param name="Service" select="@service"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format a period. -->
  <xsl:template match="r:period">
    <xsl:apply-templates select="r:from"/> – <xsl:apply-templates select="r:to"/>
  </xsl:template>

<!-- Past jobs, with level 2 heading. -->
  <xsl:template match="r:history">
    <xsl:call-template name="Heading">
      <xsl:with-param name="Text">
        <xsl:value-of select="$history.word"/>
      </xsl:with-param>
    </xsl:call-template>
    <dl class="jobs">
      <xsl:apply-templates select="r:job"/>
    </dl>
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="r:job">
    <dt><xsl:apply-templates select="r:date|r:period"/></dt>
	<dd>
	  <p>
		<span class="title"><xsl:apply-templates select="r:jobtitle"/></span>
		<xsl:if test="r:employer">
		  <xsl:text>, </xsl:text>
		  <span class="employer"><xsl:apply-templates select="r:employer"/></span>
		</xsl:if>
		<xsl:if test="r:location">
		  <xsl:text>, </xsl:text>
		  <xsl:apply-templates select="r:location"/>
		</xsl:if>
		<xsl:text>.</xsl:text>
	  </p>
	  <xsl:if test="r:description">
		<xsl:apply-templates select="r:description"/>
	  </xsl:if>
	  <xsl:if test="r:projects/r:project">
		<h4><xsl:value-of select="$projects.word"/><xsl:value-of select="$label.colon"/></h4>
		<xsl:apply-templates select="r:projects"/>
	  </xsl:if>
	  <xsl:if test="r:achievements/r:achievement">
		<h4><xsl:value-of select="$achievements.word"/><xsl:value-of select="$label.colon"/></h4>
		<xsl:apply-templates select="r:achievements"/>
	  </xsl:if>
    </dd>
  </xsl:template>

  <!-- Format the projects section -->
  <xsl:template match="r:projects">
    <ul class="projects">
      <xsl:apply-templates select="r:project"/>
    </ul>
  </xsl:template>

  <!-- Format a single project as a bullet -->
  <xsl:template match="r:project">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="text">
        <xsl:if test="@title">
          <strong><xsl:value-of select="@title"/>
			<xsl:choose>
			  <xsl:when test="string-length(.) &gt; 0"><xsl:value-of select="$title.separator"/></xsl:when>
			  <xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
          </strong>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
    <ul class="achievements">
      <xsl:for-each select="r:achievement">
        <xsl:call-template name="bulletListItem"/>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="r:degrees">
    <dl class="degrees">
      <xsl:apply-templates select="r:degree"/>
    </dl>
    <xsl:apply-templates select="r:note"/>
  </xsl:template>

  <!-- Format a single degree -->
  <xsl:template match="r:degree">
    <dt><xsl:apply-templates select="r:date|r:period"/></dt>
	<dd>
	  <p>
        <span class="title">
          <xsl:apply-templates select="r:level"/>
          <xsl:if test="r:major">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$in.word"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="r:major"/>
          </xsl:if>
        </span>
        <xsl:apply-templates select="r:minor"/>
        <xsl:if test="r:institution">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="r:institution"/>
        </xsl:if>
        <xsl:if test="r:location">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="r:location"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="r:annotation">
            <xsl:text>. </xsl:text>
            <xsl:apply-templates select="r:annotation"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <xsl:apply-templates select="r:gpa"/>
      <xsl:if test="r:subjects/r:subject">
        <xsl:apply-templates select="r:subjects"><xsl:with-param name="indent" select="$job.list.indent"/></xsl:apply-templates>
      </xsl:if>
      <xsl:if test="r:projects/r:project">
        <xsl:apply-templates select="r:projects"><xsl:with-param name="indent" select="$job.list.indent"/></xsl:apply-templates>
      </xsl:if>
    </dd>
  </xsl:template>

  <!-- Format the subjects as a list -->
  <xsl:template match="r:subjects" mode="comma">
    <p class="subjects">
      <xsl:call-template name="Title">
        <xsl:with-param name="Title" select="$subjects.word"/>
        <xsl:with-param name="Separator" select="$title.separator"/>
      </xsl:call-template>
      <xsl:apply-templates select="r:subject" mode="comma"/>
      <xsl:value-of select="$subjects.suffix"/>
    </p>
  </xsl:template>

  <!-- Format a single bullet and its text -->
  <xsl:template name="bulletListItem">
    <xsl:param name="text"/>
    <li>
	  <xsl:choose>
		<xsl:when test="string-length($text) > 0">
		  <xsl:copy-of select="$text"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:apply-templates/>
		</xsl:otherwise>
	  </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="r:skillarea">
    <xsl:variable name="pos"><xsl:number/></xsl:variable>
    <xsl:if test="$pos = 1">
      <xsl:call-template name="Heading">
        <xsl:with-param name="Text" select="$other.skills.word"/>
      </xsl:call-template>
    </xsl:if>
	<dl class="skillarea">
	  <dt><xsl:apply-templates select="r:title"/><xsl:value-of select="$label.colon"/></dt>
	  <dd>
		<xsl:apply-templates select="r:skillset"/>
	  </dd>
	</dl>
  </xsl:template>

  <!-- Format a skillset's title (if any) and then the skills underneath it. -->
  <xsl:template match="r:skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <p>
          <xsl:if test="r:title">
			<span class="title">
			  <xsl:apply-templates select="r:title">
				<xsl:with-param name="Separator" select="$title.separator"/>
			  </xsl:apply-templates>
			</span>
          </xsl:if>
          <xsl:apply-templates select="r:skill" mode="comma"/>
          <!-- The following line should be removed in a future version. -->
          <xsl:apply-templates select="r:skills" mode="comma"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h4>
          <xsl:apply-templates select="r:title"/>
        </h4>
        <xsl:if test="r:skill">
          <ul class="skillset">
            <xsl:apply-templates select="r:skill" mode="bullet"/>
          </ul>
        </xsl:if>

        <!-- The following block should be removed in a future version. -->
        <xsl:if test="r:skills">
          <ul class="skillset">
            <xsl:apply-templates select="r:skills" mode="bullet"/>
          </ul>
        </xsl:if>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- Format the referees -->
  <xsl:template match="r:referees">
    <xsl:call-template name="Heading">
      <xsl:with-param name="Text">
        <xsl:value-of select="$referees.word"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$referees.display = 1">
        <xsl:choose>
	  <xsl:when test="$referees.layout = 'compact'">
            <table class="referees">
              <xsl:apply-templates select="r:referee" mode="compact"/>
            </table>
          </xsl:when>
	  <xsl:otherwise>
	    <div class="referees">
	      <xsl:apply-templates select="r:referee" mode="standard"/>
	    </div>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:value-of select="$referees.hidden.phrase"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$referees.no_contact = 1">
      <p>
        <xsl:value-of select="$referees.no_contact.phrase"/>
      </p>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="r:copyright"/>

</xsl:stylesheet>
