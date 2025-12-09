<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:ps="http://example.com/movies"
   exclude-result-prefixes="ps">
   
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="base">https://data.example.org/</xsl:variable>
    
    <xsl:template match="/ps:StudiosAndCountries">
@base &lt;<xsl:value-of select="$base"/>&gt;.
@prefix ex:      &lt;http://example.org/vocabulary/&gt;.
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;.
@prefix foaf:    &lt;http://xmlns.com/foaf/0.1/&gt;.
@prefix xsd:     &lt;http://www.w3.org/2001/XMLSchema#&gt;.
@prefix rdf:     &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;.
@prefix rdfs:    &lt;http://www.w3.org/2000/01/rdf-schema#&gt;.


### COUNTRIES
<xsl:apply-templates select="ps:Countries/ps:Country"/>

### STUDIOS
<xsl:apply-templates select="ps:Studios/ps:Studio"/>

    </xsl:template>
    
    <xsl:template match="ps:Country">
&lt;country/<xsl:value-of select="substring-after(@id, 'country_')"/>&gt; a ex:Country;
    rdfs:label "<xsl:value-of select="ps:Name"/>"<xsl:if test="ps:Name/@xml:lang">@<xsl:value-of select="ps:Name/@xml:lang"/></xsl:if>;
    ex:isoCode "<xsl:value-of select="ps:Code"/>" .

</xsl:template>
    
    <xsl:template match="ps:Studio">
&lt;studio/<xsl:value-of select="substring-after(@id, 'studio_')"/>&gt; a ex:Studio;
    foaf:name "<xsl:value-of select="ps:Name"/>"<xsl:if test="ps:Name/@xml:lang">@<xsl:value-of select="ps:Name/@xml:lang"/></xsl:if>;
    ex:foundedYear "<xsl:value-of select="ps:FoundedYear"/>"^^xsd:gYear;
    ex:moviesProduced <xsl:value-of select="ps:MoviesProduced"/>;
    ex:basedIn &lt;country/<xsl:value-of select="substring-after(ps:Location/@ref, 'country_')"/>&gt;.

</xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>