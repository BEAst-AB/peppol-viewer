<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
				xmlns:sbdh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
				xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2"
				xmlns:doc="https://beast.se/xmltools"
				xmlns:dict="https://beast.se/dictionary"
				exclude-result-prefixes="xsi xsl xs fn sbdh ubl cac cbc doc">
	<xsl:param name="paramDataXml" required="yes" />
	<xsl:param name="paramLang" required="yes" />
	<xsl:variable name="varDataXml" select="document($paramDataXml)"/>
	<xsl:variable name="varTranslationXmlFile" select="/doc:BusinessDocument/doc:TranslationXmlFile"/>
	<xsl:output method="html" indent="yes"/>

	<xsl:import href="Dictionary.xsl"/>

	<xsl:template match="/">
	<!--xsl:variable name="varTranslationXmlFile">
	  <xsl:evaluate xpath="/doc:BusinessDocument/doc:TranslationXmlFile" context-item="$varDataXml"/>
    </xsl:variable-->
<html>
<head profile="http://www.w3.org/2005/10/profile">
<title><xsl:call-template name="translate"><xsl:with-param name="keyName" select="/doc:BusinessDocument/doc:WindowTitle"/></xsl:call-template></title>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3pro.css"/>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
.container {
  display: grid;
  grid-template-columns: auto auto auto;
  padding: 10px;
  gap: 20px 20px;
  justify-content: start;
  align-content: space-between;
}
.container > div {
  background-color: #f1f1f1;
  padding: 10px;
  text-align: left;
}
.expandable-table {
}
.expandable-row {
   display: grid;
   cursor: pointer;
}
.expanded-row-content {
   display: grid;
   grid-column: 1/-1;
}
.line-main-row {
   grid-template-columns: 3% 25% 7% repeat(5, 1fr);
}
.line-detail-panel {
  padding: 0 18px;
  background-color: white;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.2s ease-out;
}
.accordion {
  background-color: #bbb;
  color: #444;
  cursor: pointer;
  padding-left: 5px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
  transition: 0.4s;
}
.active, .accordion:hover {
  background-color: #ccc;
}
.expand-table-row:before {
    content: "+";
    display: block;
    cursor: pointer;
}
.expand-table-row.selected:before {
    content: "-";
}
.navbar {
    display:table;
    border-collapse:collapse;
    border-radius:.25em;
    box-shadow:#d0d0d0 0px 0px 0px 1px;
    li{
        display:table-cell;
        box-sizing:border-box;
        border-left:#e0e0e0 10px solid;
        border-right:#e0e0e0 10px solid;
        &amp;:first-child{
          border-left:0;
          &amp; > a{ border-top-left-radius: .25em; border-bottom-left-radius: .25em; }
        }
        &amp;:last-child{
          border-right:0;
          &amp; > a{ border-top-right-radius: .25em; border-bottom-right-radius: .25em; }
        }
    }
}
</style>
</head>
<body>
<div style="background-color:orange" class="w3-container w3-card">
<h2 style="color:white">
<xsl:variable name="varFileName">
<xsl:call-template name="fileNameFromPath">
  <xsl:with-param name="path" select="base-uri($varDataXml)" />
</xsl:call-template>
</xsl:variable>
<xsl:call-template name="translate"><xsl:with-param name="keyName" select="$varFileName"/></xsl:call-template>
</h2>
</div>
<h3>
<xsl:evaluate xpath="/doc:BusinessDocument/doc:DocumentTitle" context-item="$varDataXml"/>
</h3>

    <xsl:apply-templates select="/doc:BusinessDocument/doc:Section">
      <xsl:with-param name="context" select="$varDataXml"/>
	</xsl:apply-templates>

<script>
const toggleRowExpand = (element) => {  
  element.classList.toggle("active");
  var lineDetailPanel = element.nextElementSibling;
  if (lineDetailPanel.style.maxHeight) {
	lineDetailPanel.style.maxHeight = null;
  } else {
	lineDetailPanel.style.maxHeight = lineDetailPanel.scrollHeight + "px";
  } 
}

const toggleRowExpandSelected = (element) => {  
  element.classList.toggle("selected").closest('tr').next().toggle();
}

const allRowExpandToggle = (element) => {  
  var lineTable = element.closest('ul').nextElementSibling;
  for (var i = 0, row; i &lt; lineTable.rows.length; i++) {
    row = lineTable.rows[i];
	for (var j = 0, col; j &lt; row.cells.length; j++) {
	  col = row.cells[j];
	  if (col.classList.contains("expanded-row-content")) {
	    var lineDetailButton = col.children[0];
		if (lineDetailButton != null &amp;&amp; lineDetailButton.classList.contains("accordion")) {
		  var lineDetailSpan = lineDetailButton.children[0];
		  if (lineDetailSpan != null &amp;&amp; lineDetailSpan.classList.contains("expand-table-row")) {
		    lineDetailSpan.classList.toggle("selected"); // .closest('tr').next().toggle();
		  }
		}
	    var lineDetailPanel = col.children[1];
		if (lineDetailPanel != null &amp;&amp; lineDetailPanel.classList.contains("line-detail-panel")) {
          if (lineDetailPanel.style.maxHeight) {
            lineDetailPanel.style.maxHeight = null;
          } else {
	        lineDetailPanel.style.maxHeight = lineDetailPanel.scrollHeight + "px";
          } 
		}
	  }
	}
  }
}
</script>

</body>
</html>
	</xsl:template>

    <xsl:template match="doc:Section">
	  <xsl:param name="context"/>
	  <xsl:apply-templates select="doc:Fields | doc:Note | doc:Party | doc:Section">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
	</xsl:template>

    <xsl:template match="doc:Fields">
	  <xsl:param name="context"/>
	  <xsl:apply-templates select="doc:Form | doc:Key | doc:Table">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
	</xsl:template>

    <xsl:template match="doc:Form">
	  <xsl:param name="context"/>
<div class = "w3-group" style="width:30%" >
  <form class = "w3-container w3-card-8">
	 <fieldset>
		<legend><xsl:call-template name="translate"><xsl:with-param name="keyName" select="@title"/></xsl:call-template></legend>
	  <xsl:apply-templates select="doc:Field">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
	 </fieldset>
  </form>
</div>
	</xsl:template>

    <xsl:template match="doc:Key">
	  <xsl:param name="context"/>
<div class="container">
  <table class="w3-table w3-card-4">
	 <thead>
		<tr>
		<xsl:for-each select="doc:Field">
		  <th>
		    <!--xsl:value-of select="doc:Name"/-->
	  <xsl:apply-templates select="doc:Name">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
		  </th>
		</xsl:for-each>
		</tr>
	 </thead>
	 <tbody>
		<tr>
		<xsl:for-each select="doc:Field">
		  <td>
	  <xsl:apply-templates select="doc:DisplayBlock | doc:Expr">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
		  </td>
		</xsl:for-each>
		</tr>
	 </tbody>
  </table>
</div>
	</xsl:template>

    <xsl:template match="doc:Table">
	  <xsl:param name="context"/>
	    <xsl:variable name="varCurrentTable" select="."/>
	    <xsl:variable name="varContextPath" select="@foreach"/>
	    <xsl:variable name="varHasRowDetail" select="upper-case(@hasRowDetail)"/>
	    <xsl:variable name="varHeaderPosition" select="upper-case(@headerPosition)"/>
	    <xsl:variable name="varRows">
          <xsl:evaluate xpath="$varContextPath" context-item="$context"/>
	    </xsl:variable>
<div class="w3-container">
<xsl:if test="$varHasRowDetail = 'TRUE'">
<ul class="navbar">
  <li>
    <input type="button" id="expand_all" value="Expand or Collapse All" onclick="allRowExpandToggle(this)">
	  <xsl:attribute name="value">
	    <xsl:call-template name="translate"><xsl:with-param name="keyName" select="'Expand or Collapse All'"/></xsl:call-template>
	  </xsl:attribute>
	</input>
  </li>
</ul>
</xsl:if>
<table>
		<xsl:choose>
		  <xsl:when test="$varHasRowDetail = 'TRUE'">
			<xsl:attribute name="class">
			  <xsl:value-of select="'expandable-table w3-table w3-striped w3-bordered w3-border'"/>
			</xsl:attribute>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:attribute name="class">
			  <xsl:value-of select="'w3-table w3-striped w3-bordered w3-border'"/>
			</xsl:attribute>
		  </xsl:otherwise>
		</xsl:choose>
        <xsl:if test="$varHeaderPosition = '' or $varHeaderPosition = 'VERTICAL'">
<thead>
<tr>
		<xsl:choose>
		  <xsl:when test="$varHasRowDetail = 'TRUE'">
			<xsl:attribute name="class">
			  <xsl:value-of select="'expandable-row line-main-row'"/>
			</xsl:attribute>
		  </xsl:when>
		</xsl:choose>
		<xsl:for-each select="doc:Field[doc:Name != '']">
		  <th>
		  <xsl:variable name="varFieldTranslate" select="upper-case(doc:Name/@translate)"/>
		  <xsl:choose>
			<xsl:when test="$varFieldTranslate = 'TRUE'">
			  <xsl:call-template name="translate"><xsl:with-param name="keyName" select="doc:Name"/></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="doc:Name"/>
			</xsl:otherwise>
		  </xsl:choose>
		  </th>
		</xsl:for-each>
		</tr>
	 </thead>
		</xsl:if>
	 <tbody>
		<xsl:for-each select="$varRows/child::*">
     <xsl:variable name="varContext" select="."/>
		<tr>
		  <xsl:if test="$varHasRowDetail = 'TRUE'">
			<xsl:attribute name="class">
			  <xsl:value-of select="'expandable-row line-main-row'"/>
			</xsl:attribute>
		  </xsl:if>
		<xsl:variable name="varFieldCount" select="count($varCurrentTable/doc:Field)"/>
		<xsl:for-each select="$varCurrentTable/doc:Field">
		  <xsl:choose>
		  <xsl:when test="position() = 1 and $varHeaderPosition = 'HORIZONTAL'">
		    <th>
	            <xsl:for-each select="doc:Name[text()!='' and count(doc:Expr) = 0]">
	              <xsl:value-of select="."/>
		        </xsl:for-each>
	            <xsl:for-each select="doc:Name[count(doc:Expr) > 0]">
				  <xsl:for-each select="doc:Expr">
	                <xsl:evaluate xpath="." context-item="$varContext"/>
				  </xsl:for-each>
		        </xsl:for-each>
			</th>
			<td>
	            <xsl:for-each select="doc:Expr[text()!='']">
	              <xsl:evaluate xpath="." context-item="$varContext"/>
		        </xsl:for-each>
	            <xsl:for-each select="doc:DisplayBlock">
			      <xsl:apply-templates select=".">
				    <xsl:with-param name="context" select="$varContext"/>
			      </xsl:apply-templates>
		        </xsl:for-each>
			</td>
		  </xsl:when>
		  <xsl:otherwise>
		  <td>
		    <xsl:choose>
		      <xsl:when test="$varHasRowDetail = 'TRUE' and position() = $varFieldCount">
 			    <xsl:attribute name="class">
			      <xsl:value-of select="'expanded-row-content'"/>
			    </xsl:attribute>
<button class="accordion" onclick="toggleRowExpand(this)"><span class="expand-table-row" onclick="toggleRowExpandSelected(this)"/></button>
<div class="line-detail-panel">
	            <xsl:for-each select="doc:Expr[text()!='']">
	              <xsl:evaluate xpath="." context-item="$varContext"/>
		        </xsl:for-each>
	            <xsl:for-each select="doc:DisplayBlock">
			      <xsl:apply-templates select=".">
				    <xsl:with-param name="context" select="$varContext"/>
			      </xsl:apply-templates>
		        </xsl:for-each>
				<xsl:for-each select="doc:Table">
				  <xsl:apply-templates select=".">
					<xsl:with-param name="context" select="$varContext"/>
				  </xsl:apply-templates>
				</xsl:for-each>
</div>
			  </xsl:when>
			  <xsl:otherwise>
	            <xsl:for-each select="doc:Expr[text()!='']">
	              <xsl:evaluate xpath="." context-item="$varContext"/>
		        </xsl:for-each>
	            <xsl:for-each select="doc:DisplayBlock">
			      <xsl:apply-templates select=".">
				    <xsl:with-param name="context" select="$varContext"/>
			      </xsl:apply-templates>
		        </xsl:for-each>
				<xsl:for-each select="doc:Table">
				  <xsl:apply-templates select=".">
					<xsl:with-param name="context" select="$varContext"/>
				  </xsl:apply-templates>
				</xsl:for-each>
			  </xsl:otherwise>
		    </xsl:choose>
		  </td>
		  </xsl:otherwise>
		  </xsl:choose>
		</xsl:for-each>
		</tr>
		</xsl:for-each>
	 </tbody>
  </table>
</div>
	</xsl:template>

    <xsl:template match="doc:Party">
	  <xsl:param name="context"/>
	  <xsl:apply-templates select="doc:Stakeholders">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
	</xsl:template>

    <xsl:template match="doc:Stakeholders">
	  <xsl:param name="context"/>
<div class="container">
      <xsl:for-each select="doc:Primary">
	    <xsl:variable name="varContextPath" select="@block"/>
	    <xsl:variable name="varContext">
          <xsl:evaluate xpath="$varContextPath" context-item="$context"/>
	    </xsl:variable>
  <div class="w3-container">
    <b><xsl:call-template name="translate"><xsl:with-param name="keyName" select="@title"/></xsl:call-template></b>
	    <xsl:for-each select="doc:DisplayBlock | doc:Expr | doc:NewLine">
	  <xsl:apply-templates select=".">
	    <xsl:with-param name="context" select="$varContext"/>
	  </xsl:apply-templates>
		</xsl:for-each>
  </div>
      </xsl:for-each>
</div>
<div class="container">
      <xsl:for-each select="doc:Secondary">
	    <xsl:variable name="varContextPath" select="@block"/>
	    <xsl:variable name="varContext">
          <xsl:evaluate xpath="$varContextPath" context-item="$context"/>
	    </xsl:variable>
  <div class="w3-container">
    <b><xsl:call-template name="translate"><xsl:with-param name="keyName" select="@title"/></xsl:call-template></b>
	    <xsl:for-each select="doc:DisplayBlock | doc:Expr | doc:NewLine">
	  <xsl:apply-templates select=".">
	    <xsl:with-param name="context" select="$varContext"/>
	  </xsl:apply-templates>
		</xsl:for-each>
  </div>
      </xsl:for-each>
</div>
	</xsl:template>

    <xsl:template match="doc:Field">
	  <xsl:param name="context"/>
	  <xsl:variable name="varFieldName" select="doc:Name"/>
	  <xsl:variable name="varFieldValue">
	    <xsl:apply-templates select="doc:DisplayBlock | doc:Expr">
		  <xsl:with-param name="context" select="context"/>
		</xsl:apply-templates>
	  </xsl:variable>
		<!--label id="{$varFieldName}" class="w3-label"><xsl:value-of select="$varFieldName"/></label-->
		<label id="{$varFieldName}" class="w3-label">
	  <xsl:apply-templates select="doc:Name">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
		</label>
		<input class="w3-input" type="text" for="{$varFieldName}" value="{$varFieldValue}"></input>
	</xsl:template>

    <xsl:template match="doc:Name">
	  <xsl:param name="context"/>
	  <xsl:variable name="varFieldTranslate" select="upper-case(@translate)"/>
      <xsl:choose>
		<xsl:when test="$varFieldTranslate = 'TRUE'">
		  <xsl:call-template name="translate"><xsl:with-param name="keyName" select="text()"/></xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="text()"/>
		</xsl:otherwise>
      </xsl:choose>
	</xsl:template>

    <xsl:template match="doc:DisplayBlock">
	  <xsl:param name="context"/>
	  <xsl:variable name="varDisplayFormat" select="upper-case(@format)"/>
	  <xsl:variable name="varWarp" select="upper-case(@wrap)"/>
	  <xsl:variable name="varNewLine">
	    <xsl:choose>
		  <xsl:when test="$varDisplayFormat = 'SINGLELINE'">
		    <xsl:value-of select="false()"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="true()"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:variable>
	  <xsl:variable name="varExprCount" select="count(doc:Expr | doc:DisplayBlock)"/>
	  <xsl:for-each select="doc:Expr | doc:DisplayBlock | doc:NewLine">
        <xsl:variable name="varExprValue">
	    <xsl:apply-templates select=".">
		  <xsl:with-param name="context" select="$context"/>
		</xsl:apply-templates>
		</xsl:variable>
	    <xsl:choose>
		  <xsl:when test="$varExprValue/self::text() and $varWarp = 'CELLROW'">
		    <div class="w3-cell-row w3-container">
	          <xsl:value-of select="$varExprValue"/>
		    </div>
		  </xsl:when>
		  <xsl:when test="$varExprValue/self::text()">
	        <xsl:value-of select="$varExprValue"/>
		  </xsl:when>
		  <xsl:when test="count($varExprValue) > 0 and $varWarp = 'CELLROW'">
		    <div class="w3-cell-row w3-container">
	          <xsl:copy-of select="$varExprValue"/>
		    </div>
		  </xsl:when>
		  <xsl:when test="count($varExprValue) > 0">
	        <xsl:copy-of select="$varExprValue"/>
		  </xsl:when>
		</xsl:choose>
		<xsl:choose>
  		  <xsl:when test="$varNewLine = true()">
		    <xsl:text>&#xa;</xsl:text>
		  </xsl:when>
  		  <xsl:when test="position() != $varExprCount">
		    <xsl:text> </xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:for-each>
	</xsl:template>

    <xsl:template match="doc:Expr">
	  <xsl:param name="context"/>
	  <xsl:variable name="varDisplayFormat" select="upper-case(@format)"/>
	  <xsl:variable name="varEvalAs" select="upper-case(@as)"/>
	  <xsl:choose>
	    <xsl:when test="text()!= '' and $context != '' and $varEvalAs = 'TEXT' and $varDisplayFormat = 'BOLD'">
  	      <b><xsl:evaluate xpath="text()" context-item="$context" as="xs:string"/></b>
		</xsl:when>
	    <xsl:when test="text()!= '' and $context != '' and $varEvalAs = 'TEXT'">
  	      <xsl:evaluate xpath="text()" context-item="$context" as="xs:string"/>
		</xsl:when>
	    <xsl:when test="text()!= '' and $context != '' and $varDisplayFormat = 'BOLD'">
  	      <b><xsl:evaluate xpath="text()" context-item="$context"/></b>
		</xsl:when>
	    <xsl:when test="text()!= '' and $context != ''">
  	      <xsl:evaluate xpath="text()" context-item="$context"/>
		</xsl:when>
	    <xsl:when test="text()!= '' and $varDisplayFormat = 'BOLD' and $varEvalAs = 'TEXT'">
  	      <b><xsl:evaluate xpath="text()" context-item="$varDataXml" as="xs:string"/></b>
		</xsl:when>
	    <xsl:when test="text()!= '' and $varEvalAs = 'TEXT'">
  	      <xsl:evaluate xpath="text()" context-item="$varDataXml" as="xs:string"/>
		</xsl:when>
	    <xsl:when test="text()!= '' and $varDisplayFormat = 'BOLD'">
  	      <b><xsl:evaluate xpath="text()" context-item="$varDataXml"/></b>
		</xsl:when>
	    <xsl:when test="text()!= ''">
  	      <xsl:evaluate xpath="text()" context-item="$varDataXml"/>
		</xsl:when>
	  </xsl:choose>
	</xsl:template>

    <xsl:template match="doc:Note">
	  <xsl:param name="context"/>
<div class="container">
  <div class="w3-container">
    <b><xsl:call-template name="translate"><xsl:with-param name="keyName" select="'Notes'"/></xsl:call-template></b>
    <div class="w3-cell-row w3-container">
      <div class="w3-cell">
	  <xsl:apply-templates select="doc:Expr">
	    <xsl:with-param name="context" select="$context"/>
	  </xsl:apply-templates>
	  </div>
    </div>
  </div>
</div>
	</xsl:template>

    <xsl:template match="doc:NewLine">
	  <xsl:param name="context"/>
      <br/>
	</xsl:template>

<xsl:template name="fileNameFromPath">
  <xsl:param name="path" />
  <xsl:choose>
    <xsl:when test="contains($path,'/')">
      <xsl:call-template name="fileNameFromPath">
        <xsl:with-param name="path" select="substring-after($path,'/')" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>