<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://example.com/movies"
                xmlns:xml="http://www.w3.org/XML/1998/namespace"
                version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="en">
            <head>
                <title>Movies and Screenings</title>
            </head>
            <body>
                <h1>Movies and Screenings</h1>
                <xsl:apply-templates select="m:MovieDatabase"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="m:MovieDatabase">
        <h2>Movies</h2>
        <xsl:apply-templates select="m:Movies/m:Movie"/>
    </xsl:template>

    <xsl:template match="m:Movie">
        <xsl:variable name="movieId" select="@id"/>
        <xsl:variable name="director"
            select="/m:MovieDatabase/m:People/m:Person[@id = current()/m:DirectedBy/@ref]"/>
        <xsl:variable name="studio"
            select="/m:MovieDatabase/m:Studios/m:Studio[@id = current()/m:ProducedBy/@ref]"/>
        <xsl:variable name="screenings"
            select="/m:MovieDatabase/m:Screenings/m:Screening[m:Shows/@ref = $movieId]"/>

        <div class="movie">
            <h3 xml:lang="{m:Title[1]/@xml:lang}">
                <xsl:value-of select="m:Title[1]"/>
            </h3>


            <p>
                <strong>Release date:</strong>
                <xsl:text> </xsl:text>
                <xsl:value-of select="m:ReleaseDate"/>
                <xsl:text>; </xsl:text>
                <strong>Duration:</strong>
                <xsl:text> </xsl:text>
                <xsl:value-of select="m:Duration"/>
                <xsl:text> minutes</xsl:text>
            </p>

            <p>
                <strong>Director:</strong>
                <xsl:text> </xsl:text>
                <span xml:lang="{$director/m:FullName[1]/@xml:lang}">
                    <xsl:value-of select="$director/m:FullName[1]"/>
                </span>
            </p>


            <p>
                <strong>Studio:</strong>
                <xsl:text> </xsl:text>
                <span xml:lang="{$studio/m:Name[1]/@xml:lang}">
                    <xsl:value-of select="$studio/m:Name[1]"/>
                </span>
                <xsl:text> (Founded: </xsl:text>
                <xsl:value-of select="$studio/m:FoundedYear"/>
                <xsl:text>, Movies produced: </xsl:text>
                <xsl:value-of select="$studio/m:MoviesProduced"/>
                <xsl:text>)</xsl:text>
            </p>


            <xsl:if test="$screenings">
                <h4>Screenings</h4>
                <ul>
                    <xsl:for-each select="$screenings">
                        <xsl:variable name="cinema"
                            select="/m:MovieDatabase/m:Cinemas/m:Cinema[@id = current()/m:TakesPlaceAt/@ref]"/>
                        <xsl:variable name="country"
                            select="/m:MovieDatabase/m:Countries/m:Country[@id = $cinema/m:Location/@ref]"/>

                        <li>
                            <xsl:value-of select="m:Date"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="m:Time"/>
                            <xsl:text> — Language: </xsl:text>
                            <xsl:value-of select="m:Language"/>
                            <xsl:text>; Cinema: </xsl:text>
                            <span xml:lang="{$cinema/m:Name[1]/@xml:lang}">
                                <xsl:value-of select="$cinema/m:Name[1]"/>
                            </span>

                            <xsl:text> (</xsl:text>
                            <span xml:lang="{$country/m:Name[1]/@xml:lang}">
                                <xsl:value-of select="$country/m:Name[1]"/>
                            </span>
                            <xsl:text>)</xsl:text>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="text()"/>

</xsl:stylesheet>