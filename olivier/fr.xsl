<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../resume-1_5_1/xsl/country/fr.xsl"/>

  <xsl:param name="address.word">Adresse</xsl:param>
  <xsl:param name="nationality.word">Nationalité</xsl:param>
  <xsl:param name="birth.word">Date de naissance</xsl:param>

  <xsl:param name="phone.word">Tél.</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="phone.mobile.phrase">Mobile</xsl:param> 
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/> privé</xsl:param>
  <xsl:param name="phone.work.phrase"><xsl:value-of select="$phone.word"/> prof.</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/> privé</xsl:param>
  <xsl:param name="fax.work.phrase"><xsl:value-of select="$fax.word"/> prof.</xsl:param>

  <xsl:param name="email.word">E-mail</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>

  <xsl:param name="contact.word">Détails personnels</xsl:param>
  <xsl:param name="label.colon"> :</xsl:param>

  <xsl:param name="date.first.suffix">er</xsl:param>
  <xsl:param name="date.second.suffix"></xsl:param>
  <xsl:param name="date.third.suffix"></xsl:param>

  <xsl:param name="achievements.word">Réalisations</xsl:param>
  <xsl:param name="projects.word">Projets</xsl:param>

  <!-- Format a date. -->
  <xsl:template match="r:date" mode="numeric">
    <xsl:apply-templates select="r:dayOfMonth"/>
    <xsl:text>.</xsl:text>
    <xsl:apply-templates select="r:month" mode="numeric"/>
    <xsl:text>.</xsl:text>
    <xsl:apply-templates select="r:year"/>
  </xsl:template>

</xsl:stylesheet>
