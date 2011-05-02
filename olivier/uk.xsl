<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../resume-1_5_1/xsl/country/uk.xsl"/>

  <xsl:param name="address.word">Address</xsl:param>
  <xsl:param name="nationality.word">Nationality</xsl:param>
  <xsl:param name="birth.word">Date of birth</xsl:param>

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

  <xsl:param name="title.separator">: </xsl:param>

</xsl:stylesheet>
