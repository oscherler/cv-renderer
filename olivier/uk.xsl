<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="../resume-1_5_1/xsl/country/uk.xsl"/>

  <xsl:param name="resume.word">Curriculum Vitae</xsl:param>

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
  <xsl:param name="miscellany.word">Miscellany</xsl:param>

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
  <xsl:param name="url.word">URL</xsl:param>

  <xsl:param name="contact.word">Personal Details</xsl:param>
  <xsl:param name="label.colon">:</xsl:param>

  <xsl:param name="achievements.word">Achievements</xsl:param>
  <xsl:param name="projects.word">Projects</xsl:param>
  <xsl:param name="other.skills.word">Other Skills</xsl:param>

  <xsl:param name="title.separator">: </xsl:param>

</xsl:stylesheet>
