<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://example.com/schema-1"
                xmlns:xml="http://www.w3.org/XML/1998/namespace"
                version="1.0">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- Root: build HTML skeleton -->
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

    <!-- MovieDatabase: entry point into the data -->
    <xsl:template match="m:MovieDatabase">
        <h2>Movies</h2>
        <xsl:apply-templates select="m:Movies/m:Movie"/>
    </xsl:template>

    <!-- Movie: show title, director, studio, and screenings -->
    <xsl:template match="m:Movie">
        <xsl:variable name="movieId" select="@id"/>
        <!-- Lookup director and studio via IDREFs -->
        <xsl:variable name="director"
                      select="/m:MovieDatabase/m:People/m:Person[@id = current()/m:DirectedBy/@ref]"/>
        <xsl:variable name="studio"
                      select="/m:MovieDatabase/m:Studios/m:Studio[@id = current()/m:ProducedBy/@ref]"/>
        <!-- All screenings that show this movie -->
        <xsl:variable name="screenings"
                      select="/m:MovieDatabase/m:Screenings/m:Screening[m:Shows/@ref = $movieId]"/>

        <div class="movie">
            <h3>
                <!-- Prefer English title if present, otherwise first title -->
                <xsl:value-of select="m:Title[@xml:lang = 'en'][1] | m:Title[1]"/>
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
                <xsl:value-of select="$director/m:FullName[@xml:lang = 'en'][1] | $director/m:FullName[1]"/>
            </p>

            <p>
                <strong>Studio:</strong>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$studio/m:Name[@xml:lang = 'en'][1] | $studio/m:Name[1]"/>
                <xsl:text> (Founded: </xsl:text>
                <xsl:value-of select="$studio/m:FoundedYear"/>
                <xsl:text>, Movies produced: </xsl:text>
                <xsl:value-of select="$studio/m:MoviesProduced"/>
                <xsl:text>)</xsl:text>
            </p>

            <!-- Only show screenings section if there are screenings -->
            <xsl:if test="$screenings">
                <h4>Screenings</h4>
                <ul>
                    <xsl:for-each select="$screenings">
                        <!-- Lookup cinema and country for each screening -->
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
                            <xsl:value-of select="$cinema/m:Name[@xml:lang = 'en'][1] | $cinema/m:Name[1]"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="$country/m:Name[@xml:lang = 'en'][1] | $country/m:Name[1]"/>
                            <xsl:text>)</xsl:text>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="text()"/>

</xsl:stylesheet>

<!--
For each movie, list:
  - title (preferring English),
  - release date and duration,
  - director name,
  - studio (with founded year and movies produced),
  - all screenings (date, time, language, cinema, and country).
-->
