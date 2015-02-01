<?xml version="1.0" encoding="UTF-8"?>

<!--
olivier/uk.xsl by Olivier Scherler
Parameters for UK resumes.

Based on uk.xsl Copyright (c) 2001 Sean Kelly
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

  <xsl:import href="../resume-1_5_1/xsl/country/uk.xsl"/>

  <xsl:param name="resume.word">CV</xsl:param>

  <xsl:param name="page.word">page</xsl:param>
  
  <!-- Word to use for "Contact Information" -->
  <xsl:param name="contact.word">Contact Information</xsl:param>
  <xsl:param name="objective.word">Professional Objective</xsl:param>

  <!-- Word to use for "Employment History" -->
  <xsl:param name="history.word">Employment History</xsl:param>
  <xsl:param name="academics.word">Education</xsl:param>
  <xsl:param name="publications.word">Publications</xsl:param>
  <xsl:param name="interests.word">Interests</xsl:param>
  <xsl:param name="security-clearances.word">Security Clearances</xsl:param>
  <xsl:param name="awards.word">Awards</xsl:param>
  <xsl:param name="miscellany.word">Remarks</xsl:param>

  <!-- Word to use for "in", as in "bachelor degree *in* political science" -->
  <xsl:param name="in.word">in</xsl:param>
  <!-- Word to use for "and", as in "Minors in political science, English, *and*
  business" -->
  <xsl:param name="and.word">and</xsl:param>
  <!-- Word to use for "Copyright (c)" -->
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <!-- Word to use for "by", as in "Copyright by Joe Doom" -->
  <xsl:param name="by.word">by</xsl:param>

  <!-- Word to use for "present", as in "Period worked: August 1999-Present" -->
  <xsl:param name="present.word">Present</xsl:param>
  <!-- Word to use for "minor" (lesser area of study), singluar and plural. -->
  <xsl:param name="minor.word">minor</xsl:param>
  <xsl:param name="minors.word">minors</xsl:param>
  <xsl:param name="referees.word">Referees</xsl:param>
  <!-- Word to use for "Overall GPA", as in "*Overall GPA*: 3.3" -->
  <xsl:param name="overall-gpa.word">Overall GPA</xsl:param>
  <!-- Word to use for "GPA in Major", as in "*GPA in Major*: 3.3" -->
  <xsl:param name="major-gpa.word">GPA in Major</xsl:param>
  <!-- Text to use for "out of", as in "GPA: 3.71* out of *4.00" -->
  <xsl:param name="out-of.word"> out of </xsl:param>

  <!-- Phrase to display when referees are hidden. -->
  <xsl:param name="referees.hidden.phrase">Available upon request.</xsl:param>
  <xsl:param name="last-modified.phrase">Last modified</xsl:param>

  <!-- Instant messenger service names -->
  <!-- (When you add or remove a service here, don't forget to update
  ../../lib/common.xsl and element.instantMessage.xml in the user guide.)
  -->
  <xsl:param name="im.aim.service">AIM</xsl:param>
  <xsl:param name="im.icq.service">ICQ</xsl:param>
  <xsl:param name="im.irc.service">IRC</xsl:param>
  <xsl:param name="im.jabber.service">Jabber</xsl:param>
  <xsl:param name="im.msn.service">MSN Messenger</xsl:param>
  <xsl:param name="im.yahoo.service">Yahoo! Messenger</xsl:param>

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

  <xsl:param name="pager.word">Pager</xsl:param>
  <xsl:param name="email.word">E-mail</xsl:param>
  <xsl:param name="url.word">Website</xsl:param>

  <xsl:param name="contact.word">Personal Details</xsl:param>
  <xsl:param name="label.colon">:</xsl:param>

  <xsl:param name="achievements.word">Achievements</xsl:param>
  <xsl:param name="projects.word">Mission</xsl:param>
  <xsl:param name="other.skills.word">Other Skills</xsl:param>

  <xsl:param name="title.separator">: </xsl:param>

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
