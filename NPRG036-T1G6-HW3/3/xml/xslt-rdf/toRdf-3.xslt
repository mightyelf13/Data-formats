<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:cc="http://example.com/movies"
   exclude-result-prefixes="cc">
   
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="base">https://data.example.org/</xsl:variable>
    
    <xsl:template match="/cc:CinemasAndCountries">
@base &lt;<xsl:value-of select="$base"/>&gt;.
@prefix ex:      &lt;http://example.org/vocabulary/&gt;.
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;.
@prefix foaf:    &lt;http://xmlns.com/foaf/0.1/&gt;.
@prefix xsd:     &lt;http://www.w3.org/2001/XMLSchema#&gt;.
@prefix rdf:     &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;.
@prefix rdfs:    &lt;http://www.w3.org/2000/01/rdf-schema#&gt;.


### COUNTRIES
<xsl:apply-templates select="cc:Countries/cc:Country"/>

### CINEMAS
<xsl:apply-templates select="cc:Cinemas/cc:Cinema"/>
    </xsl:template>
    
    <xsl:template match="cc:Country">
&lt;country/<xsl:value-of select="substring-after(@id, 'country_')"/>&gt; a ex:Country;
    rdfs:label "<xsl:value-of select="cc:Name"/>"<xsl:if test="cc:Name/@xml:lang">@<xsl:value-of select="cc:Name/@xml:lang"/></xsl:if>;
    ex:isoCode "<xsl:value-of select="cc:Code"/>" .

</xsl:template>
    
    <xsl:template match="cc:Cinema">
        <xsl:variable name="hasPhones" select="exists(cc:Phone)"/>
&lt;cinema/<xsl:value-of select="substring-after(@id, 'cinema_')"/>&gt; a ex:Cinema;
    foaf:name "<xsl:value-of select="cc:Name"/>"<xsl:if test="cc:Name/@xml:lang">@<xsl:value-of select="cc:Name/@xml:lang"/></xsl:if>;
    ex:capacity <xsl:value-of select="cc:Capacity"/>;
    ex:isLuxury <xsl:value-of select="cc:Luxury"/><xsl:choose>
        <xsl:when test="$hasPhones">;</xsl:when>
        <xsl:otherwise>;</xsl:otherwise>
    </xsl:choose>
        <xsl:if test="$hasPhones">
    ex:phone <xsl:for-each select="cc:Phone">
        <xsl:if test="position() = 1">&lt;tel:<xsl:value-of select="."/>&gt;</xsl:if>
        <xsl:if test="position() > 1">,
        &lt;tel:<xsl:value-of select="."/>&gt;</xsl:if>
        <xsl:if test="position() = last()">;</xsl:if>
    </xsl:for-each>
        </xsl:if>
    ex:locatedIn &lt;country/<xsl:value-of select="substring-after(cc:Location/@ref, 'country_')"/>&gt;.

</xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>