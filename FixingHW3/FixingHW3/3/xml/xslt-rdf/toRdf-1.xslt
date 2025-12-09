<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:md="http://example.com/movies"
   exclude-result-prefixes="md">
   
    <xsl:output method="text" encoding="UTF-8" />
    <xsl:variable name="base">https://data.example.org/</xsl:variable>
    
    <xsl:template match="/md:MovieDatabase">
@base &lt;<xsl:value-of select="$base"/>&gt;.
@prefix ex:      &lt;http://example.org/vocabulary/&gt;.
@prefix dcterms: &lt;http://purl.org/dc/terms/&gt;.
@prefix foaf:    &lt;http://xmlns.com/foaf/0.1/&gt;.
@prefix xsd:     &lt;http://www.w3.org/2001/XMLSchema#&gt;.
@prefix rdf:     &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;.
@prefix rdfs:    &lt;http://www.w3.org/2000/01/rdf-schema#&gt;.


### COUNTRIES
<xsl:apply-templates select="md:Countries/md:Country"/>

### STUDIOS
<xsl:apply-templates select="md:Studios/md:Studio"/>

### CINEMAS
<xsl:apply-templates select="md:Cinemas/md:Cinema"/>

### PEOPLE: DIRECTORS &amp; ACTORS
<xsl:apply-templates select="md:People/md:Person"/>

### MOVIES
<xsl:apply-templates select="md:Movies/md:Movie"/>

### SCREENINGS
<xsl:apply-templates select="md:Screenings/md:Screening"/>

### ACTOR &lt;-&gt; MOVIE
<xsl:apply-templates select="md:People/md:Person[@type='Actor']/md:ActedIn" mode="actedIn"/>
    </xsl:template>
    
    <xsl:template match="md:Country">
&lt;country/<xsl:value-of select="substring-after(@id, 'c-')"/>&gt; a ex:Country;
    rdfs:label "<xsl:value-of select="md:Name"/>"@en;
    ex:isoCode "<xsl:value-of select="md:Code"/>" .

    </xsl:template>
    
    <xsl:template match="md:Studio">
&lt;studio/<xsl:value-of select="translate(substring-after(@id, 's-'), '-', '')"/>&gt; a ex:Studio;
    foaf:name "<xsl:value-of select="md:Name"/>"@en;
    ex:foundedYear "<xsl:value-of select="md:FoundedYear"/>"^^xsd:gYear;
    ex:moviesProduced <xsl:value-of select="md:MoviesProduced"/>;
    ex:basedIn &lt;country/<xsl:value-of select="substring-after(md:Location/@ref, 'c-')"/>&gt;.

    </xsl:template>
    
    <xsl:template match="md:Cinema">
&lt;cinema/<xsl:value-of select="translate(substring-after(@id, 'cin-'), '-', '')"/>&gt; a ex:Cinema;
    foaf:name "<xsl:value-of select="md:Name"/>"@en;
    ex:capacity <xsl:value-of select="md:Capacity"/>;
    ex:isLuxury <xsl:value-of select="lower-case(md:Luxury)"/>;
        <xsl:if test="md:Phone">ex:phone &lt;tel:<xsl:value-of select="translate(md:Phone, '-', '')"/>&gt;;
</xsl:if>    ex:locatedIn &lt;country/<xsl:value-of select="substring-after(md:Location/@ref, 'c-')"/>&gt;.

    </xsl:template>
    
    <xsl:template match="md:Person">
        <xsl:variable name="personId" select="translate(substring-after(@id, 'p-'), '-', '')"/>
        <xsl:variable name="personType" select="@type"/>
        
&lt;person/<xsl:value-of select="$personId"/>&gt; a ex:<xsl:value-of select="$personType"/>;
    foaf:name "<xsl:value-of select="md:FullName"/>"@en;
        <xsl:choose>
            <xsl:when test="@type='Director'">
    ex:birthDate "<xsl:value-of select="md:BirthDate"/>"^^xsd:date;
    ex:activeSince "<xsl:value-of select="md:ActiveSince"/>"^^xsd:gYear;
    ex:awardsCount <xsl:value-of select="md:AwardsCount"/>;
            </xsl:when>
            <xsl:when test="@type='Actor'">
    ex:birthDate "<xsl:value-of select="md:BirthDate"/>"^^xsd:date;
    ex:stageName "<xsl:value-of select="md:StageName"/>"@en;
    ex:debutYear "<xsl:value-of select="md:DebutYear"/>"^^xsd:gYear;
            </xsl:when>
        </xsl:choose>
    ex:bornIn &lt;country/<xsl:value-of select="substring-after(md:BornIn/@ref, 'c-')"/>&gt;.

    </xsl:template>
    
    <xsl:template match="md:Movie">
&lt;movie/<xsl:value-of select="translate(substring-after(@id, 'm-'), '-', '')"/>&gt; a ex:Movie;
    dcterms:title "<xsl:value-of select="md:Title"/>"<xsl:if test="md:Title/@xml:lang">@<xsl:value-of select="md:Title/@xml:lang"/></xsl:if>;
    ex:durationMinutes <xsl:value-of select="md:Duration"/>;
    ex:releaseDate "<xsl:value-of select="md:ReleaseDate"/>"^^xsd:date;
    ex:directedBy &lt;person/<xsl:value-of select="translate(substring-after(md:DirectedBy/@ref, 'p-'), '-', '')"/>&gt;;
    ex:producedBy &lt;studio/<xsl:value-of select="translate(substring-after(md:ProducedBy/@ref, 's-'), '-', '')"/>&gt;.

    </xsl:template>
    
    <xsl:template match="md:Screening">
&lt;screening/<xsl:value-of select="translate(substring-after(@id, 'scr'), '-', '')"/>&gt; a ex:Screening;
    ex:shows &lt;movie/<xsl:value-of select="translate(substring-after(md:Shows/@ref, 'm-'), '-', '')"/>&gt;;
    ex:takesPlaceAt &lt;cinema/<xsl:value-of select="translate(substring-after(md:TakesPlaceAt/@ref, 'cin-'), '-', '')"/>&gt;;
    ex:screeningDate "<xsl:value-of select="md:Date"/>"^^xsd:date;
    ex:screeningTime "<xsl:value-of select="md:Time"/>"^^xsd:time;
    dcterms:language "<xsl:value-of select="md:Language"/>"^^xsd:language.

    </xsl:template>
    
    <xsl:template match="md:ActedIn" mode="actedIn">
&lt;person/<xsl:value-of select="translate(substring-after(../@id, 'p-'), '-', '')"/>&gt; ex:actedIn &lt;movie/<xsl:value-of select="translate(substring-after(@ref, 'm-'), '-', '')"/>&gt;.
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>