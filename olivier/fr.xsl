<?xml version="1.0" encoding="UTF-8"?>

<!--
olivier/fr.xsl by Olivier Scherler
Parameters for French resumes.

Based on fr.xsl Copyright (c) 2001 Sean Kelly
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
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../resume-1_5_1/xsl/country/fr.xsl"/>

  <xsl:param name="resume.word">CV</xsl:param>

  <xsl:param name="address.word">Adresse</xsl:param>
  <xsl:param name="nationality.word">Nationalité</xsl:param>
  <xsl:param name="birth.word">Date de naissance</xsl:param>

  <xsl:param name="phone.word">Téléphone</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="phone.mobile.phrase">Mobile</xsl:param> 
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase"><xsl:value-of select="$phone.word"/> prof.</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/> privé</xsl:param>
  <xsl:param name="fax.work.phrase"><xsl:value-of select="$fax.word"/> prof.</xsl:param>

  <xsl:param name="email.word">E-mail</xsl:param>
  <xsl:param name="url.word">Site Web</xsl:param>

  <xsl:param name="contact.word">Détails personnels</xsl:param>
  <xsl:param name="label.colon"> :</xsl:param>

  <xsl:param name="achievements.word">Réalisations</xsl:param>
  <xsl:param name="projects.word">Missions</xsl:param>
  <xsl:param name="other.skills.word">Autres compétences</xsl:param>
  <xsl:param name="miscellany.word">Remarques</xsl:param>

  <xsl:param name="title.separator"> : </xsl:param>

  <xsl:param name="referees.hidden.phrase">Disponibles sur demande.</xsl:param>
  <xsl:param name="referees.no_contact.phrase">Merci de ne pas contacter mon employeur actuel directement.</xsl:param>

  <!-- Format a date. -->
  <xsl:template match="r:date">
    <xsl:if test="r:dayOfMonth">
      <xsl:apply-templates select="r:dayOfMonth"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="r:month">
      <xsl:apply-templates select="r:month"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="r:year"/>
  </xsl:template>

</xsl:stylesheet>
