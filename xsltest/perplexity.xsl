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

          <!-- Loop through Sections -->
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
        </script>
      </body>
    </html>
  </xsl:template>

  <!-- SECTION TEMPLATE -->
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
          <!--xsl:value-of select="@title"/-->
		  <xsl:evaluate xpath="@title" context-item="$childContext"/>
        </span>
      </div>
      <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Repeat | beast:Form | beast:Text">
        <xsl:with-param name="context" select="$childContext"/>
        <xsl:with-param name="display" select="$overrideDisplay"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- FIELDS TEMPLATE -->
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
    <table class="table table-bordered table-sm align-middle">
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

  <!-- FIELD TEMPLATE -->
  <xsl:template match="beast:Field">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
    <xsl:variable name="name">
      <xsl:evaluate xpath="@name" context-item="$context"/>
    </xsl:variable>
    <xsl:choose>
    <xsl:when test="not(empty(@expr))">
    <xsl:choose>
    <xsl:when test="$display='list' and (empty(@type) or @type='')">
      <li><strong><xsl:value-of select="$name"/>:</strong> 
        <xsl:variable name="value">
          <xsl:evaluate xpath="@expr" context-item="$context"/>
        </xsl:variable>
        <xsl:text> </xsl:text>
		<!--xsl:value-of select="$value"/-->
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
	<!--xsl:if test="name(parent::node()) = 'Fields'">
	<xsl:message>
	  Parent: <xsl:value-of select="name(parent::node())"/> Cols: <xsl:value-of select="parent::node()/@cols"/> position: <xsl:value-of select="position()"/> Mod: <xsl:value-of select="(position() mod parent::node()/@cols)"/> last: <xsl:value-of select="last()"/> tr-open: <xsl:value-of select="empty(parent::node()/@cols) or (name(parent::node()) = 'Fields' and parent::node()/@cols != '' and (position() mod parent::node()/@cols) = 1)"/> tr-close: <xsl:value-of select="empty(parent::node()/@cols) or (name(parent::node()) = 'Fields' and parent::node()/@cols != '' and ( ((position() mod parent::node()/@cols) = 0) or (position() = last()) ))"/>
	</xsl:message>
	</xsl:if-->
	<!--xsl:choose>
	<xsl:when test="name(parent::node()) = 'Fields' and parent::node()/@cols != '' and (position() mod parent::node()/@cols) = 1">
      <tr>
	</xsl:when>
	<xsl:when test="name(parent::node()) = 'Fields' and parent::node()/@cols = ''">
      <tr>
	</xsl:when>
	</xsl:choose-->
	<xsl:if test="(empty(parent::node()/@cols) or (parent::node()/@cols != '' and (position() mod parent::node()/@cols) = 1)) = true()">
      <xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
	</xsl:if>
      <th>
        <xsl:value-of select="$name"/>
      </th>
      <td>
        <xsl:call-template name="formatFieldValue">
          <xsl:with-param name="field" select="."/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="display" select="$display"/>
        </xsl:call-template>
      </td>
	<xsl:if test="(empty(parent::node()/@cols) or (parent::node()/@cols != '' and ( ((position() mod parent::node()/@cols) = 0) or (position() = last()) ))) = true()">
      <xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
	</xsl:if>
	<!--xsl:choose>
	<xsl:when test="name(parent::node()) = 'Fields' and parent::node()/@cols != '' and ( (position() mod parent::node()/@cols) = 0) or (position() = last()) )">
    </tr>
	</xsl:when>
	<xsl:when test="name(parent::node()) = 'Fields' and parent::node()/@cols = ''">
    </tr>
	</xsl:when>
	</xsl:choose-->
    </xsl:otherwise>
    </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="beast:NestedSection | beast:Fields | beast:Repeat | beast:Form | beast:Text">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
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
		  <!--xsl:otherwise>
			<span class="{$field/@class}"><xsl:value-of select="$value"/></span>
		  </xsl:otherwise-->
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

  <!-- REPEAT TEMPLATE (for lists, e.g., lines) -->
  <xsl:template match="beast:Repeat">
    <xsl:param name="context"/>
    <xsl:param name="display"/>
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
    <xsl:variable name="nodes">
	  <xsl:evaluate xpath="@expr" context-item="$rowContext"/>
	</xsl:variable>
    <xsl:for-each select="$nodes">
      <xsl:variable name="currentDataNode" select="./child::*"/>
      <thead>
      <tr>
        <xsl:for-each select="$currentNode/beast:Field">
          <xsl:variable name="name">
            <xsl:evaluate xpath="@name" context-item="$rowContext"/>
          </xsl:variable>
          <th>
            <xsl:value-of select="$name"/>
          </th>
        </xsl:for-each>
      </tr>
      </thead>
      <tbody>
      <tr>
        <xsl:for-each select="$currentNode/beast:Field">
          <td>
            <!--xsl:variable name="val">
              <xsl:evaluate xpath="@expr" context-item="$currentDataNode"/>
            </xsl:variable>
            <xsl:value-of select="$val"/-->
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
        </xsl:for-each>
      </tr>
      </tbody>
    </xsl:for-each>
  </xsl:template>

  <!-- FORM TEMPLATE (for nested groups) -->
  <xsl:template match="beast:Form">
    <xsl:param name="context"/>
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
    <!--tr>
      <th colspan="2">
        <xsl:value-of select="@title"/>
      </th>
    </tr-->
	<xsl:variable name="varDisplay" select="@display"/>
    <div class="{@class}" style="{@style}">
	  <div class="nested-title"><!--xsl:value-of select="@title"/--><xsl:evaluate xpath="@title" context-item="$childContext"/></div>
	<!--xsl:message>
	  Title: <xsl:value-of select="@title"/> Display: <xsl:value-of select="$varDisplay"/>
	</xsl:message-->
    <xsl:choose>
    <xsl:when test="@display='list'">
    <xsl:apply-templates select="beast:Text">
      <xsl:with-param name="context" select="$childContext"/>
      <xsl:with-param name="display" select="$varDisplay"/>
    </xsl:apply-templates>
        <ul class="property-list">
    <xsl:apply-templates select="beast:Field[empty(@type)]">
      <xsl:with-param name="context" select="$childContext"/>
      <xsl:with-param name="display" select="$varDisplay"/>
    </xsl:apply-templates>
        </ul>
    <xsl:apply-templates select="beast:Field[not(empty(@type))] | beast:Repeat | beast:Form">
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

  <!-- formatAddress TEMPLATE -->
  <xsl:template name="formatAddress">
    <xsl:param name="context"/>
    <xsl:param name="expr"/>
    <xsl:param name="title"/>
	<xsl:variable name="varContext">
	  <xsl:evaluate xpath="$expr" context-item="$context"/>
	</xsl:variable>
	<!--xsl:message>
	  Expr: <xsl:value-of select="$expr"/>
	  Context: <xsl:copy-of select="$varContext"/>
	</xsl:message-->
      <div class="address-block">
	    <xsl:if test="not(empty($title))">
        <strong><xsl:evaluate xpath="$title" context-item="$context"/></strong><br/>
		</xsl:if>
        <xsl:evaluate xpath="concat($expr, '/cbc:StreetName/text()')" context-item="$context"/>, <xsl:evaluate xpath="concat($expr, '/cbc:AdditionalStreetName/text()')" context-item="$context"/><br/>
        <xsl:evaluate xpath="concat($expr, '/cbc:CityName/text()')" context-item="$context"/>, <xsl:evaluate xpath="concat($expr, '/cbc:PostalZone/text()')" context-item="$context"/><br/>
        <xsl:evaluate xpath="concat($expr, '/cbc:CountrySubentity/text()')" context-item="$context"/>, <xsl:evaluate xpath="concat($expr, '/cac:Country/cbc:IdentificationCode/text()')" context-item="$context"/><br/>
      </div>
  </xsl:template>

  <xsl:template name="formatCoordinates">
    <xsl:param name="context"/>
    <xsl:param name="expr"/>
    <xsl:param name="title"/>
	<xsl:variable name="varAltitudeMeasure">
	<xsl:evaluate xpath="concat($expr, '/cbc:AltitudeMeasure')" context-item="$context"/>
	</xsl:variable>
	<strong>Koordinater:</strong><xsl:text> </xsl:text><xsl:evaluate xpath="concat($expr, '/cbc:LatitudeDegreesMeasure/text()')" context-item="$context"/>°N, <xsl:evaluate xpath="concat($expr, '/cbc:LongitudeDegreesMeasure/text()')" context-item="$context"/>°E (<xsl:evaluate xpath="concat($expr, '/cbc:AltitudeMeasure/text()')" context-item="$context"/><xsl:text> </xsl:text><xsl:value-of select="$varAltitudeMeasure/cbc:AltitudeMeasure/@unitCode"/> höjd)
  </xsl:template>

  <!-- DEFAULT: ignore other nodes -->
  <!--xsl:template match="text()|@*"/-->
</xsl:stylesheet>
