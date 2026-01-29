<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:dict="https://beast.se/dictionary"
				exclude-result-prefixes="xsi xsl xs fn dict">


    <xsl:key name="sv" match="dict:sv/entry" use="@key" />
    <xsl:key name="en" match="dict:en/entry" use="@key" />


<xsl:template name="translate">
  <xsl:param name="keyName" />
  <xsl:choose>
    <xsl:when test="$varTranslationXmlFile != ''">
	  <xsl:for-each select="document($varTranslationXmlFile)">
		<xsl:variable name="varDictTrans" select="key($paramLang, $keyName)"/>
		<xsl:choose>
		  <xsl:when test="$varDictTrans != ''">
			<xsl:value-of select="$varDictTrans"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:call-template name="translateFromDefault">
			  <xsl:with-param name="keyName" select="$keyName"/>
			</xsl:call-template>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
      <xsl:call-template name="translateFromDefault">
        <xsl:with-param name="keyName" select="$keyName"/>
      </xsl:call-template>
	</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="translateFromDefault">
  <xsl:param name="keyName" />
  <xsl:for-each select="document($varTranslationDefaultXmlFile)">
    <xsl:variable name="varDictTrans2" select="key($paramLang, $keyName)"/>
    <xsl:choose>
      <xsl:when test="$varDictTrans2 != ''">
        <xsl:value-of select="$varDictTrans2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$keyName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:function name="dict:translate" as="xs:string" visibility="public">
  <xsl:param name="keyName" as="xs:string"/>
  <!-- Function logic here -->
  <!--xsl:sequence select="concat('Prefix-', $input)"/-->
  <xsl:choose>
    <xsl:when test="$varTranslationXmlFile != ''">
	  <xsl:for-each select="document($varTranslationXmlFile)">
		<xsl:variable name="varDictTrans" select="key($paramLang, $keyName)"/>
		<xsl:choose>
		  <xsl:when test="$varDictTrans != ''">
			<xsl:value-of select="$varDictTrans"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:call-template name="translateFromDefault">
			  <xsl:with-param name="keyName" select="$keyName"/>
			</xsl:call-template>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
      <xsl:call-template name="translateFromDefault">
        <xsl:with-param name="keyName" select="$keyName"/>
      </xsl:call-template>
	</xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>