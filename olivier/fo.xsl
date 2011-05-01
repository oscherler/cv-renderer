<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

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

</xsl:stylesheet>
