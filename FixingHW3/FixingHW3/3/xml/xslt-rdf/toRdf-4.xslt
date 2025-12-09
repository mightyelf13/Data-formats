 <?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:ps="http://example.com/schema-4"
   exclude-result-prefixes="ps">
   
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="base">https://data.example.org/</xsl:variable>
    
    <xsl:template match="/ps:PeopleAndStudios">
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

### PEOPLE: DIRECTORS &amp; ACTORS
<xsl:apply-templates select="ps:People/ps:Person"/>
    </xsl:template>
    
    <xsl:template match="ps:Country">
&lt;country/<xsl:value-of select="substring-after(@id, 'country_')"/>&gt; a ex:Country;
    rdfs:label "<xsl:value-of select="ps:Name"/>"<xsl:if test="ps:Name/@xml:lang">@<xsl:value-of select="ps:Name/@xml:lang"/></xsl:if>;
    ex:isoCode "<xsl:value-of select="ps:Code"/>" .

</xsl:template>
    
    <xsl:template match="ps:Studio">
&lt;studio/<xsl:value-of select="translate(substring-after(@id, 'studio_'), '_', '-')"/>&gt; a ex:Studio;
    foaf:name "<xsl:value-of select="ps:Name"/>"<xsl:if test="ps:Name/@xml:lang">@<xsl:value-of select="ps:Name/@xml:lang"/></xsl:if>;
    ex:foundedYear "<xsl:value-of select="ps:FoundedYear"/>"^^xsd:gYear;
    ex:moviesProduced <xsl:value-of select="ps:MoviesProduced"/>;
    ex:basedIn &lt;country/<xsl:value-of select="substring-after(ps:Location/@ref, 'country_')"/>&gt;.

</xsl:template>
    
    <xsl:template match="ps:Person">
        <xsl:variable name="personId" select="translate(substring-after(@id, 'actor_'), '_', '-')"/>
        <xsl:variable name="personType" select="@type"/>
        
        <xsl:choose>
            <xsl:when test="@type = 'Actor'">
                <xsl:variable name="actorId" select="translate(substring-after(@id, 'actor_'), '_', '-')"/>
&lt;person/<xsl:value-of select="$actorId"/>&gt; a ex:Actor;
    foaf:name "<xsl:value-of select="ps:FullName"/>"<xsl:if test="ps:FullName/@xml:lang">@<xsl:value-of select="ps:FullName/@xml:lang"/></xsl:if>;
    ex:stageName "<xsl:value-of select="ps:StageName"/>"<xsl:if test="ps:StageName/@xml:lang">@<xsl:value-of select="ps:StageName/@xml:lang"/></xsl:if>;
    ex:birthDate "<xsl:value-of select="ps:BirthDate"/>"^^xsd:date;
    ex:debutYear "<xsl:value-of select="ps:DebutYear"/>"^^xsd:gYear;
    ex:bornIn &lt;country/<xsl:value-of select="substring-after(ps:BornIn/@ref, 'country_')"/>&gt;.

            </xsl:when>
            <xsl:when test="@type = 'Director'">
                <xsl:variable name="directorId" select="translate(substring-after(@id, 'director_'), '_', '-')"/>
&lt;person/<xsl:value-of select="$directorId"/>&gt; a ex:Director;
    foaf:name "<xsl:value-of select="ps:FullName"/>"<xsl:if test="ps:FullName/@xml:lang">@<xsl:value-of select="ps:FullName/@xml:lang"/></xsl:if>;
    ex:birthDate "<xsl:value-of select="ps:BirthDate"/>"^^xsd:date;
    ex:activeSince "<xsl:value-of select="ps:ActiveSince"/>"^^xsd:gYear;
    ex:awardsCount <xsl:value-of select="ps:AwardsCount"/>;
    ex:bornIn &lt;country/<xsl:value-of select="substring-after(ps:BornIn/@ref, 'country_')"/>&gt;.

            </xsl:when>
        </xsl:choose>
</xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>