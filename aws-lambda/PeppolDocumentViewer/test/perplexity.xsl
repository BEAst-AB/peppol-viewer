<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:beast="https://beast.se/xmltools"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs beast">

  <!-- The business XML document is passed as a parameter -->
  <xsl:param name="doc" />

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- MAIN TEMPLATE -->
  <xsl:template match="/beast:BusinessDocument">
    <html lang="sv">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>
          <xsl:value-of select="beast:PageTitle"/>
        </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <!-- (Add your CSS here, omitted for brevity) -->
      </head>
      <body>
        <div class="container-lg">
          <div class="header text-center rounded shadow-sm mb-4">
            <h1 class="display-5 mb-2">
              <xsl:value-of select="beast:WindowTitle"/>
            </h1>
          </div>

          <!-- Loop through Sections -->
          <xsl:apply-templates select="beast:Section"/>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
          document.querySelectorAll(".section-header").forEach((header) => {
            header.addEventListener("click", () => {
              const content = header.parentElement.querySelector(".section-content");
              const indicator = header.querySelector(".expand-indicator");
              if (content.style.display === "none") {
                content.style.display = "block";
                indicator.textContent = "Expanderad";
              } else {
                content.style.display = "none";
                indicator.textContent = "Komprimerad";
              }
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>

  <!-- SECTION TEMPLATE -->
  <xsl:template match="beast:Section">
    <div class="section card shadow-sm">
      <div class="section-header card-header">
        <span>
          <xsl:value-of select="@icon"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@title"/>
        </span>
        <span class="expand-indicator badge bg-secondary">Expanderad</span>
      </div>
      <div class="section-content card-body">
        <xsl:apply-templates select="beast:Fields"/>
      </div>
    </div>
  </xsl:template>

  <!-- FIELDS TEMPLATE -->
  <xsl:template match="beast:Fields">
    <table class="table table-bordered table-sm align-middle mb-0">
      <tbody>
        <xsl:apply-templates select="beast:Field | beast:Repeat | beast:Form"/>
      </tbody>
    </table>
  </xsl:template>

  <!-- FIELD TEMPLATE -->
  <xsl:template match="beast:Field">
    <tr>
      <th>
        <xsl:value-of select="@name"/>
      </th>
      <td>
        <xsl:variable name="value">
          <xsl:evaluate xpath="@expr" context="$doc"/>
        </xsl:variable>
        <xsl:value-of select="$value"/>
      </td>
    </tr>
  </xsl:template>

  <!-- REPEAT TEMPLATE (for lists, e.g., lines) -->
  <xsl:template match="beast:Repeat">
    <xsl:variable name="nodes" select="xsl:evaluate(@expr, $doc)"/>
    <xsl:for-each select="$nodes">
      <tr>
        <xsl:for-each select="../beast:Field">
          <td>
            <xsl:variable name="val">
              <xsl:evaluate xpath="@expr" context="."/>
            </xsl:variable>
            <xsl:value-of select="$val"/>
          </td>
        </xsl:for-each>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- FORM TEMPLATE (for nested groups) -->
  <xsl:template match="beast:Form">
    <tr>
      <th colspan="2">
        <xsl:value-of select="@title"/>
      </th>
    </tr>
    <xsl:apply-templates select="beast:Field"/>
  </xsl:template>

  <!-- DEFAULT: ignore other nodes -->
  <xsl:template match="text()|@*"/>
</xsl:stylesheet>
