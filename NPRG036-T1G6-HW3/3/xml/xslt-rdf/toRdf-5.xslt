<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:ac="http://example.com/movies"
   exclude-result-prefixes="ac">
   
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="base">https://data.example.org/</xsl:variable>
    
    <xsl:template match="/ac:DirectorsAndCountries">
@base &lt;<xsl:value-of select="$base"/>&gt;.
@prefix ex:      &lt;http://example.org/vocabulary/&gt;.
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;.
@prefix foaf:    &lt;http://xmlns.com/foaf/0.1/&gt;.
@prefix xsd:     &lt;http://www.w3.org/2001/XMLSchema#&gt;.
@prefix rdf:     &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;.
@prefix rdfs:    &lt;http://www.w3.org/2000/01/rdf-schema#&gt;.


### COUNTRIES
<xsl:apply-templates select="ac:Countries/ac:Country"/>

### DIRECTORS
<xsl:apply-templates select="ac:Directors/ac:Director"/>
    </xsl:template>
    
    <xsl:template match="ac:Country">
&lt;country/<xsl:value-of select="substring-after(@id, 'country_')"/>&gt; a ex:Country;
    rdfs:label "<xsl:value-of select="ac:Name"/>"<xsl:if test="ac:Name/@xml:lang">@<xsl:value-of select="ac:Name/@xml:lang"/></xsl:if>;
    ex:isoCode "<xsl:value-of select="ac:Code"/>" .

    </xsl:template>
    
    <xsl:template match="ac:Director">
&lt;person/<xsl:value-of select="substring-after(@id, 'person_')"/>&gt; a ex:Director;
    foaf:name "<xsl:value-of select="ac:FullName"/>"<xsl:if test="ac:FullName/@xml:lang">@<xsl:value-of select="ac:FullName/@xml:lang"/></xsl:if>;
    ex:activeSince "<xsl:value-of select="ac:ActiveSince"/>"^^xsd:gYear;
    ex:birthDate "<xsl:value-of select="ac:BirthDate"/>"^^xsd:date;
    ex:awardsCount <xsl:value-of select="ac:AwardsCount"/>;
    ex:bornIn &lt;country/<xsl:value-of select="substring-after(ac:BornIn/@ref, 'country_')"/>&gt;.

    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>