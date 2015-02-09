<?xml version="1.0" encoding="UTF-8"?>

<!--
olivier/fo.xsl by Olivier Scherler
Transform XML resume into XSL-FO, for formatting into PDF.

Based on fo.xsl Copyright (c) 2001 Sean Kelly
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
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:x="http://olivier.ithink.ch/resume/extension/0.0">

  <xsl:import href="../resume-1_5_1/xsl/format/fo.xsl"/>

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"
    encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>

  <!-- Format the document. -->
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="resume-page"
          margin-top="{$margin.top}"
          margin-left="{$margin.left}"
          margin-right="{$margin.right}"
          margin-bottom="{$margin.bottom}"
          page-height="{$page.height}"
          page-width="{$page.width}">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="resume-page">

        <fo:flow flow-name="xsl-region-body">
          <fo:block font-family="{$body.font.family}" font-weight="normal" font-size="{$body.font.size}" language="fr" hyphenate="true">
            <xsl:apply-templates select="r:resume"/>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Callable template to format a heading: -->
  <!--
      Call "heading" with parameter "text" being the text of the heading.
      GH: As heading.indent is less than body.indent, this is a hanging
          indent of the heading.
  -->
  <xsl:template name="heading">
    <xsl:param name="text">Heading Not Defined</xsl:param>
    <fo:block
      start-indent="{$heading.indent}"
      font-family="{$heading.font.family}"
      font-weight="{$heading.font.weight}"
      font-size="{$heading.font.size}"
      space-before="{$heading.space.before}"
      space-after="{$heading.space.after}"
      border-bottom-style="{$heading.border.bottom.style}"
      border-bottom-width="{$heading.border.bottom.width}"
      keep-with-next="always">
      <xsl:value-of select="$text"/>
    </fo:block>
  </xsl:template>

  <!-- Header information -->
  <xsl:template match="r:header" mode="standard">

    <fo:block font-weight="{$global.bold.weight}" font-size="18pt" text-align="center" space-after="12pt">
    	<xsl:apply-templates select="r:name"/>
    	<xsl:text> – </xsl:text>
    	<xsl:value-of select="$resume.word"/>
    </fo:block>

    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$contact.word"/></xsl:with-param>
    </xsl:call-template>

	<fo:table table-layout="fixed" width="17cm" space-after="32pt">
	  <fo:table-column column-width="4.0cm"/>
	  <fo:table-column column-width="5.5cm"/>
	  <fo:table-column column-width="3.0cm"/>
	  <fo:table-column column-width="4.5cm"/>
	  <fo:table-body>
		<fo:table-row>
		  <fo:table-cell padding-bottom="6pt">
		    <xsl:call-template name="contact-label">
			  <xsl:with-param name="label"><xsl:value-of select="$birth.word"/></xsl:with-param>
			</xsl:call-template>
          </fo:table-cell>
		  <fo:table-cell><fo:block><xsl:apply-templates select="r:birth/r:date"/></fo:block></fo:table-cell>
		  <fo:table-cell>
            <xsl:call-template name="contact-label">
			  <xsl:with-param name="label"><xsl:value-of select="$nationality.word"/></xsl:with-param>
			</xsl:call-template>
		  </fo:table-cell>
		  <fo:table-cell><fo:block><xsl:value-of select="r:birth/x:nationality"/></fo:block></fo:table-cell>
		</fo:table-row>
		<fo:table-row>
		  <fo:table-cell>
			<xsl:call-template name="contact-label">
			  <xsl:with-param name="label" select="$address.word"/>
			</xsl:call-template>
		  </fo:table-cell>
		  <fo:table-cell>
		  	<xsl:apply-templates select="r:address"/>
		  </fo:table-cell>
		  <fo:table-cell>
		    <xsl:apply-templates select="r:contact" mode="label"/>
		  </fo:table-cell>
		  <fo:table-cell>
		    <xsl:apply-templates select="r:contact"/>
           </fo:table-cell>
		</fo:table-row>
	  </fo:table-body>
	</fo:table>
  </xsl:template>

  <!-- Format a period. -->
  <xsl:template match="r:period">
    <xsl:apply-templates select="r:from"/> – <xsl:apply-templates select="r:to"/>
  </xsl:template>

  <!-- Named template to format a single contact field *SE* -->
  <!-- Don't print the label if the field value is empty *SE* -->
  <xsl:template name="contact-label">
    <xsl:param name="label"/>
	<fo:block font-style="{$header.item.font.style}" font-weight="{$header.item.font.weight}">
	  <xsl:value-of select="$label"/><xsl:value-of select="$label.colon"/>
	</fo:block>
  </xsl:template>

  <xsl:template name="contact-data">
    <xsl:param name="field"/>
    <xsl:param name="link" select="''"/>
    <fo:block>
      <xsl:choose>
        <xsl:when test="string-length( $link ) > 0">
	      <fo:basic-link external-destination="{$link}">
	    	<xsl:value-of select="$field"/>
          </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
	    	<xsl:value-of select="$field"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- Format contact information. -->

  <xsl:template match="r:contact/r:phone" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:call-template name="PhoneLocation">
          <xsl:with-param name="Location" select="@location"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:phone">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
      	<xsl:text>tel:</xsl:text>
      	<xsl:value-of select="translate( ., ' ', '' )"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:fax" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:call-template name="FaxLocation">
          <xsl:with-param name="Location" select="@location"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:fax">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:pager" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:value-of select="$pager.word"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:pager">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:email" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:value-of select="$email.word"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:email">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
        <xsl:text>mailto:</xsl:text><xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:url" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:value-of select="$url.word"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:url">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="link">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:instantMessage" mode="label">
    <xsl:call-template name="contact-label">
      <xsl:with-param name="label">
        <xsl:call-template name="IMServiceName">
          <xsl:with-param name="Service" select="@service"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:contact/r:instantMessage">
    <xsl:call-template name="contact-data">
      <xsl:with-param name="field">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="r:job">
    <fo:block
      font-style="{$job-period.font.style}"
      font-weight="{$job-period.font.weight}"
      keep-with-next="always">
      <xsl:apply-templates select="r:date|r:period"/>
    </fo:block>
	<fo:block start-indent="{$job.list.indent}">
	  <fo:block keep-with-next="always"
		space-before="6pt" space-after="6pt">
		<fo:inline font-style="{$jobtitle.font.style}" font-weight="{$jobtitle.font.weight}">
		  <xsl:apply-templates select="r:jobtitle"/>
		</fo:inline>
		<xsl:if test="r:employer">
		  <xsl:text>, </xsl:text>
		  <fo:inline
	        font-style="{$employer.font.style}"
            font-weight="{$employer.font.weight}">
            <xsl:apply-templates select="r:employer"/>
		  </fo:inline>
		</xsl:if>
		<xsl:if test="r:location">
		  <xsl:text>, </xsl:text>
		  <xsl:apply-templates select="r:location"/>
		</xsl:if>
		<xsl:text>.</xsl:text>
	  </fo:block>
	  <xsl:if test="r:description">
		<fo:block
		  provisional-distance-between-starts="0.5em">
		  <xsl:apply-templates select="r:description"/>
		</fo:block>
	  </xsl:if>
	  <xsl:if test="r:projects/r:project">
		<fo:block>
		  <fo:block
			  keep-with-next="always"
			  font-style="{$job-subheading.font.style}"
			  font-weight="{$job-subheading.font.weight}">
			<xsl:value-of select="$projects.word"/><xsl:value-of select="$label.colon"/>
		  </fo:block>
		  <xsl:apply-templates select="r:projects"><xsl:with-param name="indent" select="$job.list.indent"/></xsl:apply-templates>
		</fo:block>
	  </xsl:if>
	  <xsl:if test="r:achievements/r:achievement">
		<fo:block>
		  <fo:block
			  keep-with-next="always"
			  font-style="{$job-subheading.font.style}"
			  font-weight="{$job-subheading.font.weight}">
			<xsl:value-of select="$achievements.word"/><xsl:value-of select="$label.colon"/>
		  </fo:block>
		  <xsl:apply-templates select="r:achievements"/>
		</fo:block>
	  </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format the projects section -->
  <xsl:template match="r:projects">
    <xsl:param name="indent" select="$body.indent"/>
    <fo:list-block space-after="{$para.break.space}" start-indent="{$project.list.indent}"
      provisional-distance-between-starts="{$bullet.space}" provisional-label-separation="{$bullet.sep}">
      <xsl:apply-templates select="r:project"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single project as a bullet -->
  <xsl:template match="r:project">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="indent" select="$project.list.indent"/>
      <xsl:with-param name="text">
        <xsl:if test="@title">
          <fo:inline
            font-style="{$project.title.font.style}"
			font-weight="{$project.title.font.weight}"><xsl:value-of select="@title"/>
			<xsl:choose>
			  <xsl:when test="string-length(.) &gt; 0"><xsl:value-of select="$title.separator"/></xsl:when>
			  <xsl:otherwise>.</xsl:otherwise>
			</xsl:choose>
			</fo:inline>
        </xsl:if>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
    <fo:list-block space-after="{$para.break.space}" start-indent="{$project.list.indent}"
      provisional-distance-between-starts="{$bullet.space}" provisional-label-separation="{$bullet.sep}">
      <xsl:for-each select="r:achievement">
        <xsl:call-template name="bulletListItem"><xsl:with-param name="indent" select="$project.list.indent"/></xsl:call-template>
      </xsl:for-each>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single degree -->
  <xsl:template match="r:degree">
    <fo:block
      font-style="{$job-period.font.style}"
      font-weight="{$job-period.font.weight}"
      keep-with-next="always">
      <xsl:apply-templates select="r:date|r:period"/>
    </fo:block>
	<fo:block start-indent="{$job.list.indent}">
	  <fo:block keep-with-next="always"
		space-before="6pt" space-after="6pt">
        <fo:inline
            font-style="{$degree.font.style}"
            font-weight="{$degree.font.weight}">
          <xsl:apply-templates select="r:level"/>
          <xsl:if test="r:major">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$in.word"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="r:major"/>
          </xsl:if>
        </fo:inline>
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
      </fo:block>
      <xsl:apply-templates select="r:gpa"/>
      <xsl:if test="r:subjects/r:subject">
        <fo:block space-before="{$half.space}">
          <xsl:apply-templates select="r:subjects"><xsl:with-param name="indent" select="$job.list.indent"/></xsl:apply-templates>
        </fo:block>
      </xsl:if>
      <xsl:if test="r:projects/r:project">
        <fo:block space-before="{$half.space}">
          <xsl:apply-templates select="r:projects"><xsl:with-param name="indent" select="$job.list.indent"/></xsl:apply-templates>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format a single bullet and its text -->
  <xsl:template name="bulletListItem">
    <xsl:param name="indent" select="$body.indent"/>
    <xsl:param name="text"/>
    <fo:list-item>
      <fo:list-item-label start-indent="{$indent}"
        end-indent="label-end()">
        <fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:choose>
            <xsl:when test="string-length($text) > 0">
              <xsl:copy-of select="$text"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="r:skillarea">
    <xsl:variable name="pos"><xsl:number/></xsl:variable>
    <xsl:if test="$pos = 1">
      <xsl:call-template name="heading">
        <xsl:with-param name="text" select="$other.skills.word"/>
      </xsl:call-template>
    </xsl:if>
	<fo:list-block provisional-distance-between-starts="3.5cm" hyphenate="false">
	  <fo:list-item space-after="6pt">
		  <fo:list-item-label><fo:block font-weight="{$global.bold.weight}"><xsl:apply-templates select="r:title"/><xsl:value-of select="$label.colon"/></fo:block></fo:list-item-label>
		  <fo:list-item-body start-indent="body-start()">
            <xsl:apply-templates select="r:skillset"/>
		  </fo:list-item-body>
	  </fo:list-item>
	</fo:list-block>
  </xsl:template>

  <!-- Format a skillset's title (if any) and then the skills underneath it. -->
  <xsl:template match="r:skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <fo:block space-after="{$skillset.space}">
          <fo:inline
           font-style="{$skillset-title.font.style}"
           font-weight="{$skillset-title.font.weight}">
            <xsl:apply-templates select="r:title">
	      <xsl:with-param name="Separator" select="$title.separator"/>
	    </xsl:apply-templates>
          </fo:inline>
          <xsl:apply-templates select="r:skill" mode="comma"/>
          <!-- The following line should be removed in a future version. -->
          <xsl:apply-templates select="r:skills" mode="comma"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block
         keep-with-next="always"
         font-style="{$skillset-title.font.style}"
         font-weight="{$skillset-title.font.weight}">
          <xsl:apply-templates select="r:title"/>
        </fo:block>
        <xsl:if test="r:skill">
          <fo:list-block space-after="{$para.break.space}"
            provisional-distance-between-starts="{$bullet.space}"
             provisional-label-separation="{$bullet.sep}">
            <xsl:apply-templates select="r:skill" mode="bullet"/>
          </fo:list-block>
        </xsl:if>

        <!-- The following block should be removed in a future version. -->
        <xsl:if test="r:skills">
          <fo:list-block space-after="{$para.break.space}"
            provisional-distance-between-starts="{$bullet.space}"
            provisional-label-separation="{$bullet.sep}">
            <xsl:apply-templates select="r:skills" mode="bullet"/>
          </fo:list-block>
        </xsl:if>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Format the referees -->
  <xsl:template match="r:referees">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$referees.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$referees.display = 1">
        <xsl:choose>
          <xsl:when test="$referees.layout = 'compact'">
            <fo:table table-layout="fixed" width="90%">
              <fo:table-column width="40%"/>
              <fo:table-column width="40%"/>
              <fo:table-body>
                <xsl:apply-templates select="r:referee" mode="compact"/>
              </fo:table-body>
            </fo:table>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="r:referee" mode="standard"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <fo:block space-after="{$para.break.space}">
          <xsl:value-of select="$referees.hidden.phrase"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$referees.no_contact = 1">
      <fo:block space-after="{$para.break.space}">
        <xsl:value-of select="$referees.no_contact.phrase"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

<!-- link -> make link from href attribute -->
  <xsl:template match="r:link">
    <fo:basic-link text-decoration="underline">
      <xsl:attribute name="external-destination">
        <xsl:apply-templates select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="r:url">
    <fo:basic-link external-destination="{.}">
      <xsl:apply-templates/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="r:copyright"/>

</xsl:stylesheet>
