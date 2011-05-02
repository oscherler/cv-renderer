<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../resume-1_5_1/xsl/country/uk.xsl"/>

  <xsl:param name="address.word">Address</xsl:param>
  <xsl:param name="nationality.word">Nationality</xsl:param>
  <xsl:param name="birth.word">Date or birth</xsl:param>

  <xsl:param name="phone.word">Phone</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="phone.mobile.phrase">Mobile</xsl:param> 
  <xsl:param name="phone.home.phrase">Home <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase">Work <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="fax.home.phrase">Home <xsl:value-of select="$fax.word"/></xsl:param>
  <xsl:param name="fax.work.phrase">Work <xsl:value-of select="$fax.word"/></xsl:param>

  <xsl:param name="email.word">E-mail</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>

  <xsl:param name="contact.word">Personal Details</xsl:param>
  <xsl:param name="label.colon">:</xsl:param>

  <xsl:param name="date.first.suffix">st</xsl:param>
  <xsl:param name="date.second.suffix">nd</xsl:param>
  <xsl:param name="date.third.suffix">rd</xsl:param>

  <!-- Format a date. -->
  <xsl:template match="r:date">
    <xsl:if test="r:month">
      <xsl:apply-templates select="r:month"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="r:dayOfMonth">
      <xsl:apply-templates select="r:dayOfMonth"/>
      <xsl:choose>
        <xsl:when test="r:month and r:year">
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates select="r:year"/>
  </xsl:template>

</xsl:stylesheet>
