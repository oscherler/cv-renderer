<?xml version="1.0" encoding="UTF-8"?>

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

    <fo:block font-weight="600" font-size="18pt" text-align="center" space-after="12pt">
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
		  <fo:table-cell><fo:block font-weight="600">Nationalité :</fo:block></fo:table-cell>
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
    <fo:block><xsl:value-of select="$field"/></fo:block>
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

  <!-- Format the history with the heading "Employment History". -->
  <xsl:template match="r:history">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$history.word"/></xsl:with-param>
    </xsl:call-template>
    <!--fo:list-block provisional-distance-between-starts="3cm"-->
      <xsl:apply-templates/>
    <!-- /fo:list-block -->
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="r:job">
    <fo:block
      font-style="{$job-period.font.style}"
      font-weight="{$job-period.font.weight}">
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
		  <xsl:apply-templates select="r:employer"/>
		</xsl:if>
		<xsl:if test="r:location">
		  <xsl:text>, </xsl:text>
		  <xsl:apply-templates select="r:location"/>
		</xsl:if>
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
      provisional-distance-between-starts="{$bullet.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="r:project"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single project as a bullet -->
  <xsl:template match="r:project">
    <xsl:call-template name="bulletListItem">
      <xsl:with-param name="indent" select="$project.list.indent"/>
      <xsl:with-param name="text">
        <xsl:if test="@title">
          <xsl:value-of select="@title"/>
          <xsl:value-of select="$title.separator"/>
        </xsl:if>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
    <fo:list-block space-after="{$para.break.space}" start-indent="{$project.list.indent}"
      provisional-distance-between-starts="{$bullet.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:for-each select="r:achievement">
        <xsl:call-template name="bulletListItem"><xsl:with-param name="indent" select="$project.list.indent"/></xsl:call-template>
      </xsl:for-each>
    </fo:list-block>
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

</xsl:stylesheet>
