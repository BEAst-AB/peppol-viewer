<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
				xmlns:sbdh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
				xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2"
                xmlns:beast="https://beast.se/xmltools"
				xmlns:dict="https://beast.se/dictionary"
				exclude-result-prefixes="xs xsi xsl xs fn sbdh ubl cac cbc beast dict">

  <xsl:param name="paramDataXml" required="yes" />
  <xsl:param name="paramLang" required="yes" />
  <xsl:param name="paramUrlRepo" required="yes" />

  <!-- The business XML document is passed as a parameter -->
  <xsl:variable name="doc" select="document($paramDataXml)"/>

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/beast:BusinessDocument">
    <html lang="sv">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>
          <xsl:value-of select="beast:PageTitle"/>
        </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <style>
      body {
        background: #f4f6f9;
      }
      .header {
        background: #6c757d; /* This is Bootstrap's bg-secondary color */
        color: #fff;
        padding: 2rem 0;
        margin-bottom: 2rem;
      }
      .section {
        margin-bottom: 2rem;
      }
      .section-header {
        background: #f8f9fa;
        font-weight: 600;
        color: #343a40;
        border-bottom: 1px solid #dee2e6;
        cursor: pointer;
        padding: 1rem 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }
      .nested-section {
        background: #f8f9fa;
        border-left: 4px solid #0d6efd;
        border-radius: 0.25rem;
        padding: 1rem;
        margin: 1rem 0;
      }
      .nested-title {
        font-weight: 600;
        color: #343a40;
        margin-bottom: 0.5rem;
      }
      .address-block {
        background: #fff3cd;
        padding: 0.75rem;
        border-left: 3px solid #ffc107;
        border-radius: 0.25rem;
        margin-top: 0.5rem;
      }
      .highlight-value {
        font-weight: 600;
        color: #0d6efd;
      }
      .danger-indicator {
        background: #f8d7da;
        color: #842029;
        padding: 0.25rem 0.5rem;
        border-radius: 0.2rem;
        font-size: 0.9em;
      }
      .safe-indicator {
        background: #d1e7dd;
        color: #0f5132;
        padding: 0.25rem 0.5rem;
        border-radius: 0.2rem;
        font-size: 0.9em;
      }
      .property-list {
        margin: 0;
        padding-left: 1rem;
      }
      .property-list li {
        margin-bottom: 0.25rem;
      }
      .party-info {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        margin-bottom: 1rem;
      }
      .party-card {
        background: #f8f9fa;
        padding: 1rem;
        border-radius: 0.25rem;
        border-left: 4px solid #198754;
        flex: 1 1 300px;
        min-width: 250px;
      }
      @media (max-width: 768px) {
        .party-info {
          flex-direction: column;
        }
      }
        </style>
      </head>
      <body>
        <div class="container-lg">
          <div class="header text-center rounded shadow-sm mb-4">
            <h1 class="display-5 mb-2">
              <xsl:value-of select="beast:WindowTitle"/>
            </h1>
          </div>
          <xsl:apply-templates select="beast:Section">
            <xsl:with-param name="context" select="$doc"/>
          </xsl:apply-templates>
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
          function toggleRow(row) {
            var next = row.nextElementSibling;
            if (next &amp;&amp; next.classList.contains("expanded-row")) {
              next.style.display = next.style.display === "none" ? "table-row" : "none";
            }
          }
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="beast:Section">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
	<xsl:variable name="childContext">
      <xsl:choose>
        <xsl:when test="not(empty(@expr))">
		  <xsl:evaluate xpath="concat(@expr, '/child::*')" context-item="$context"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$context"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="overrideDisplay">
      <xsl:choose>
        <xsl:when test="not(empty(@display))">
		  <xsl:evaluate xpath="@display" context-item="$childContext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$display"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
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
        <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Repeat | beast:Form">
          <xsl:with-param name="context" select="$childContext"/>
          <xsl:with-param name="display" select="$overrideDisplay"/>
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="beast:NestedSection">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
	<xsl:variable name="childContext">
      <xsl:choose>
        <xsl:when test="not(empty(@expr))">
		  <xsl:evaluate xpath="concat(@expr, '/child::*')" context-item="$context"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$context"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="overrideDisplay">
      <xsl:choose>
        <xsl:when test="not(empty(@display))">
		  <xsl:evaluate xpath="@display" context-item="$childContext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$display"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="nested-section">
      <div class="nested-title">
        <span>
          <xsl:value-of select="@icon"/>
          <xsl:text> </xsl:text>
		  <xsl:evaluate xpath="@title" context-item="$childContext"/>
        </span>
      </div>
      <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Repeat | beast:Form | beast:Text">
        <xsl:with-param name="context" select="$childContext"/>
        <xsl:with-param name="display" select="$overrideDisplay"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="beast:Fields">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
	<xsl:variable name="childContext">
      <xsl:choose>
        <xsl:when test="not(empty(@expr))">
		  <xsl:evaluate xpath="concat(@expr, '/child::*')" context-item="$context"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$context"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="overrideDisplay">
      <xsl:choose>
        <xsl:when test="not(empty(@display))">
		  <xsl:evaluate xpath="@display" context-item="$childContext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$display"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@type='block'">
        <div class="{@class}">
          <xsl:apply-templates select="beast:Field | beast:Repeat | beast:Form | beast:Text">
            <xsl:with-param name="context" select="$childContext"/>
		    <xsl:with-param name="display" select="$overrideDisplay"/>
          </xsl:apply-templates>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <table class="table table-bordered table-sm align-middle" style="{@style}">
          <tbody>
            <xsl:apply-templates select="beast:Field | beast:Repeat | beast:Form | beast:Text">
              <xsl:with-param name="context" select="$childContext"/>
		      <xsl:with-param name="display" select="$overrideDisplay"/>
            </xsl:apply-templates>
          </tbody>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="beast:Text">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
    <xsl:choose>
      <xsl:when test="not(empty(@expr))">
        <xsl:variable name="value">
          <xsl:evaluate xpath="@expr" context-item="$context"/>
        </xsl:variable>
        <xsl:call-template name="formatFieldValue">
          <xsl:with-param name="field" select="."/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="display" select="$display"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="beast:Field">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
    <xsl:variable name="name">
      <xsl:if test="not(empty(@name))">
        <xsl:evaluate xpath="@name" context-item="$context"/>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$display='list' and (empty(@type) or @type='')">
        <li><strong><xsl:value-of select="$name"/>:</strong> 
        <xsl:variable name="value">
          <xsl:evaluate xpath="@expr" context-item="$context"/>
        </xsl:variable>
        <xsl:text> </xsl:text>
        <xsl:call-template name="formatFieldValue">
          <xsl:with-param name="field" select="."/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="display" select="$display"/>
        </xsl:call-template>
        </li>
      </xsl:when>
      <xsl:when test="@type='address'">
        <xsl:call-template name="formatAddress">
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="expr" select="@expr"/>
          <xsl:with-param name="title" select="@title"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@type='coordinates'">
        <xsl:call-template name="formatCoordinates">
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="expr" select="@expr"/>
          <xsl:with-param name="title" select="@title"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="(empty(parent::node()/@cols) or (parent::node()/@cols != '' and (position() mod parent::node()/@cols) = 1)) = true()">
          <xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
        </xsl:if>
        <xsl:if test="$name != ''">
          <th>
            <xsl:value-of select="$name"/>
          </th>
        </xsl:if>
        <td style="vertical-align: top; text-align: left;">
          <xsl:if test="parent::node()/@cols != '' and position() = last()">
            <xsl:attribute name="colspan">
              <xsl:value-of select="parent::node()/@cols - (position() mod parent::node()/@cols) + 1"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="not(empty(@expr))">
              <xsl:call-template name="formatFieldValue">
                <xsl:with-param name="field" select="."/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="display" select="$display"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Field | beast:Repeat | beast:Form | beast:Text">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <xsl:if test="(empty(parent::node()/@cols) or (parent::node()/@cols != '' and ( ((position() mod parent::node()/@cols) = 0) or (position() = last()) ))) = true()">
          <xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="formatFieldValue">
    <xsl:param name="field"/>
    <xsl:param name="context"/>
    <xsl:param name="display"/>
	<xsl:if test="not(empty($field/@expr))">
      <xsl:variable name="value">
        <xsl:evaluate xpath="$field/@expr" context-item="$context"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="not(empty($field/@class))">
          <xsl:choose>
            <xsl:when test="$value = false() and not(empty($field/@exprFalse))">
              <xsl:variable name="valueFalse">
                <xsl:evaluate xpath="$field/@exprFalse" context-item="$context"/>
              </xsl:variable>
			<span class="{$field/@class}"><xsl:value-of select="$valueFalse"/></span>
            </xsl:when>
            <xsl:when test="$value = true() and not(empty($field/@exprTrue))">
              <xsl:variable name="valueTrue">
                <xsl:evaluate xpath="$field/@exprTrue" context-item="$context"/>
              </xsl:variable>
              <span class="{$field/@class}"><xsl:value-of select="$valueTrue"/></span>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="(not(empty($field/@exprTrue)) or not(empty($field/@exprFalse))) and $value = 'false'">
              <xsl:variable name="valueFalse">
                <xsl:evaluate xpath="$field/@exprFalse" context-item="$context"/>
              </xsl:variable>
              <xsl:value-of select="$valueFalse"/>
            </xsl:when>
            <xsl:when test="(not(empty($field/@exprTrue)) or not(empty($field/@exprFalse))) and $value = 'true'">
              <xsl:variable name="valueTrue">
                <xsl:evaluate xpath="$field/@exprTrue" context-item="$context"/>
              </xsl:variable>
              <xsl:value-of select="$valueTrue"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$value"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
	</xsl:if>
  </xsl:template>

  <xsl:template match="beast:Repeat">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
	<xsl:variable name="repeatExpr" select="@expr"/>
	<xsl:variable name="rowContext">
      <xsl:choose>
        <xsl:when test="not(empty(@expr))">
		  <xsl:evaluate xpath="@expr" context-item="$context"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$context"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="currentNode" select="."/>
    <xsl:choose>
      <xsl:when test="not(empty(@display)) and @display='list'">
        <xsl:for-each select="$rowContext/child::*">
          <xsl:variable name="currentDataNode" select="."/>
          <xsl:if test="position() != 1"><br/></xsl:if>
          <xsl:for-each select="$currentNode/beast:Field[not(empty(@expr))]">
            <xsl:variable name="name">
              <xsl:evaluate xpath="@name" context-item="$currentDataNode"/>
            </xsl:variable>
            <li><strong><xsl:value-of select="$name"/>: </strong><xsl:call-template name="formatFieldValue">
                        <xsl:with-param name="field" select="."/>
                        <xsl:with-param name="context" select="$currentDataNode"/>
                        <xsl:with-param name="display" select="$display"/>
                      </xsl:call-template>
            </li>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="lastColumnAsExpandedRow" as="xs:boolean">
          <xsl:choose>
            <xsl:when test="empty(@lastColumnAsExpandedRow)">
              <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@lastColumnAsExpandedRow"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="numberOfColumns" select="count($currentNode/beast:Field)"/>
        <thead>
          <tr>
            <xsl:if test="$lastColumnAsExpandedRow">
              <xsl:attribute name="class">
                <xsl:value-of select="'expandable-row'"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:for-each select="$currentNode/beast:Field">
              <xsl:variable name="name">
                <xsl:evaluate xpath="@name" context-item="$rowContext/child::*[1]"/>
              </xsl:variable>
              <xsl:if test="not($lastColumnAsExpandedRow) or ($lastColumnAsExpandedRow and position() != $numberOfColumns)">
                <th>
                  <xsl:value-of select="$name"/>
                </th>
              </xsl:if>
            </xsl:for-each>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="$rowContext/child::*">
            <xsl:variable name="currentDataNode" select="."/>
            <xsl:choose>
              <xsl:when test="$lastColumnAsExpandedRow">
                <xsl:text disable-output-escaping="yes">&lt;tr class="main-row" onclick="toggleRow(this)"></xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="$currentNode/beast:Field">
              <xsl:if test="($lastColumnAsExpandedRow and position() = $numberOfColumns)">
                <xsl:text disable-output-escaping="yes">&lt;/tr>&lt;tr class="expanded-row" style="display: table-row;"></xsl:text>
              </xsl:if>
              <td>
                <xsl:if test="($lastColumnAsExpandedRow and position() = $numberOfColumns)">
                  <xsl:attribute name="colspan">
                    <xsl:value-of select="$numberOfColumns - 1"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="not(empty(@expr))">
                    <xsl:call-template name="formatFieldValue">
                      <xsl:with-param name="field" select="."/>
                      <xsl:with-param name="context" select="$currentDataNode"/>
                      <xsl:with-param name="display" select="$display"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Repeat | beast:Form | beast:Text">
                      <xsl:with-param name="context" select="$currentDataNode/child::*"/>
                      <xsl:with-param name="display" select="$display"/>
                    </xsl:apply-templates>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <xsl:if test="($lastColumnAsExpandedRow and position() = $numberOfColumns)">
                <xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:if test="not($lastColumnAsExpandedRow)">
              <xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
            </xsl:if>
          </xsl:for-each>
        </tbody>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="beast:Form">
    <xsl:param name="context"/>
	<xsl:variable name="tempContext">
	  <xsl:element name="Temp">
	    <xsl:copy-of select="$context"/>
	  </xsl:element>
    </xsl:variable>
	<xsl:variable name="childContext">
      <xsl:choose>
        <xsl:when test="not(empty(@expr))">
		  <xsl:evaluate xpath="concat('Temp/', @expr, '/child::*')" context-item="$tempContext"/>
        </xsl:when>
        <xsl:otherwise>
		  <xsl:evaluate xpath="'Temp/child::*'" context-item="$tempContext"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<xsl:variable name="varDisplay" select="@display"/>
    <div class="{@class}" style="{@style}">
      <xsl:if test="not(empty(@title))"><div class="nested-title"><xsl:evaluate xpath="@title" context-item="$childContext"/></div></xsl:if>
      <xsl:choose>
        <xsl:when test="@display='list'">
          <xsl:apply-templates select="beast:Text">
            <xsl:with-param name="context" select="$childContext"/>
            <xsl:with-param name="display" select="$varDisplay"/>
          </xsl:apply-templates>
          <ul class="property-list">
            <xsl:apply-templates select="beast:Field[empty(@type)] | beast:Repeat | beast:Form">
              <xsl:with-param name="context" select="$childContext"/>
              <xsl:with-param name="display" select="$varDisplay"/>
            </xsl:apply-templates>
          </ul>
          <xsl:apply-templates select="beast:Field[not(empty(@type))]">
            <xsl:with-param name="context" select="$childContext"/>
            <xsl:with-param name="display" select="$varDisplay"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="beast:Field | beast:Form | beast:Repeat | beast:Text">
            <xsl:with-param name="context" select="$childContext"/>
            <xsl:with-param name="display" select="$varDisplay"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
	</div>
  </xsl:template>

  <xsl:template match="beast:NewLine">
    <xsl:param name="context"/>
    <br/>
  </xsl:template>

  <xsl:template name="formatAddress">
    <xsl:param name="context"/>
    <xsl:param name="expr"/>
    <xsl:param name="title"/>
    <xsl:variable name="varContext">
      <xsl:evaluate xpath="$expr" context-item="$context"/>
    </xsl:variable>
    <div class="address-block">
      <xsl:if test="not(empty($title))">
        <strong><xsl:evaluate xpath="$title" context-item="$context"/></strong><br/>
      </xsl:if>
      <xsl:variable name="varStreetName">
        <xsl:evaluate xpath="concat($expr, '/cbc:StreetName/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:variable name="varAdditionalStreetName">
        <xsl:evaluate xpath="concat($expr, '/cbc:AdditionalStreetName/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:variable name="varCityName">
        <xsl:evaluate xpath="concat($expr, '/cbc:CityName/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:variable name="varPostalZone">
        <xsl:evaluate xpath="concat($expr, '/cbc:PostalZone/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:variable name="varCountrySubentity">
        <xsl:evaluate xpath="concat($expr, '/cbc:CountrySubentity/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:variable name="varCountry">
        <xsl:evaluate xpath="concat($expr, '/cac:Country/cbc:IdentificationCode/text()')" context-item="$context"/>
      </xsl:variable>
      <xsl:value-of select="$varStreetName"/>
      <xsl:if test="$varAdditionalStreetName!=''">, <xsl:value-of select="$varAdditionalStreetName"/></xsl:if>
      <br/>
      <xsl:value-of select="$varCityName"/>, <xsl:value-of select="$varPostalZone"/>
      <br/>
      <xsl:if test="$varCountrySubentity!=''"><xsl:value-of select="$varCountrySubentity"/>, </xsl:if><xsl:value-of select="$varCountry"/>
    </div>
  </xsl:template>

  <xsl:template name="formatCoordinates">
    <xsl:param name="context"/>
    <xsl:param name="expr"/>
    <xsl:param name="title"/>
    <xsl:variable name="varAltitudeMeasure">
      <xsl:evaluate xpath="concat($expr, '/cbc:AltitudeMeasure')" context-item="$context"/>
    </xsl:variable>
    <xsl:variable name="varLatitudeDegreesMeasure">
      <xsl:evaluate xpath="concat($expr, '/cbc:LatitudeDegreesMeasure')" context-item="$context"/>
    </xsl:variable>
    <xsl:variable name="varLongitudeDegreesMeasure">
      <xsl:evaluate xpath="concat($expr, '/cbc:LongitudeDegreesMeasure')" context-item="$context"/>
    </xsl:variable>
	<strong>Koordinater:</strong><xsl:text> </xsl:text>
	<xsl:value-of select="$varLatitudeDegreesMeasure/cbc:LatitudeDegreesMeasure/text()"/>°N, 
	<xsl:value-of select="$varLongitudeDegreesMeasure/cbc:LongitudeDegreesMeasure/text()"/>°E 
	(<xsl:value-of select="$varAltitudeMeasure/cbc:AltitudeMeasure/text()"/><xsl:text> </xsl:text>
	 <xsl:value-of select="$varAltitudeMeasure/cbc:AltitudeMeasure/@unitCode"/> höjd)
  </xsl:template>

  <!--xsl:template match="text()|@*"/-->
</xsl:stylesheet>
