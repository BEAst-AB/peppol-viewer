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
	<xsl:param name="paramUrlRepo" required="yes" />
	<xsl:variable name="varDataXml" select="document($paramDataXml)"/>
	<xsl:variable name="varTranslationDefaultXmlFile" select="concat($paramUrlRepo, &quot;/refs/heads/main/translations/&quot;, 'dictionary.xml')"/>
	<xsl:variable name="varTranslationXmlFile" select="$varTranslationDefaultXmlFile"/>

	<xsl:output method="html" indent="yes"/>

	<xsl:import href="Dictionary.xsl"/>

	<xsl:template match="/">
<html>
<head profile="http://www.w3.org/2005/10/profile">
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3pro.css"/>
<title>Unknown document or not supported</title>
<style>
{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #D3D3D3;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.error-container {
    text-align: center;
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
    font-size: 5rem;
    color: #ff5733;
}

p {
    font-size: 1.5rem;
    color: #333;
    margin-bottom: 20px;
}

a {
    text-decoration: none;
    background-color: #ff5733;
    color: #fff;
    padding: 10px 20px;
    border-radius: 3px;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

a:hover {
    background-color: #e6482e;
}
</style>
</head>
<body>
    <div class="error-container">
        <h1> 404 </h1>
        <p>
            Oops! The document you're
            looking for is not supported or unknown.
        </p>
		<div>
		  <table class="w3-table w3-striped w3-bordered w3-border">
            <caption>List of supported document and their customizations</caption>
			<th>
			  <tr>
			    <td>Customization ID</td>
			    <td>Metadata URL</td>
			  </tr>
            </th>
            <tb>
		    <xsl:for-each select="$varDataXml/Peppol/Viewers">
			  <tr>
			    <td><xsl:value-of select="@CustomizationID"/></td>
			    <td><xsl:value-of select="."/></td>
			  </tr>
			</xsl:for-each>
            </tb>
		  </table>
		</div>
    </div>
</body>
</html>
	</xsl:template>

</xsl:stylesheet>