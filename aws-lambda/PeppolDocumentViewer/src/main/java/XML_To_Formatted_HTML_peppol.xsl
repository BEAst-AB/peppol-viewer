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
                exclude-result-prefixes="xsi xsl xs fn sbdh ubl cac cbc doc dict">

  <xsl:param name="paramDataXml" required="yes" />
  <xsl:param name="paramLang" required="yes" />
  <xsl:param name="paramUrlRepo" required="yes" />
  <xsl:variable name="varDataXml" select="document($paramDataXml)"/>
  <xsl:variable name="varTranslationXmlFile" select="concat($paramUrlRepo, '/refs/heads/main/translations/', /doc:BusinessDocument/doc:TranslationXmlFile)"/>
  <xsl:variable name="varTranslationDefaultXmlFile" select="concat($paramUrlRepo, '/refs/heads/main/translations/dictionary.xml')"/>
  
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  <xsl:import href="Dictionary.xsl"/>

  <xsl:template match="/">
    <html lang="{$paramLang}">
      <head profile="http://www.w3.org/2005/10/profile">
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
        <meta http-equiv="Pragma" content="no-cache" />
        <meta http-equiv="Expires" content="0" />
        <title>
          <xsl:call-template name="translate">
            <xsl:with-param name="keyName" select="/doc:BusinessDocument/doc:WindowTitle"/>
          </xsl:call-template>
        </title>
        <style>
          :root {
            --bg-page: #f8fafc;
            --bg-card: #ffffff;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-muted: #64748b;
            --accent: #0284c7;
            --accent-light: #f0f9ff;
          }
          * { box-sizing: border-box; }
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-page);
            color: var(--text-primary);
            line-height: 1.5;
            margin: 0;
            padding: 24px 16px;
            font-size: 14px;
          }
          .document-wrapper {
            max-width: 1140px;
            margin: 0 auto;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            padding: 32px;
          }
          .doc-header {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid var(--text-primary);
            padding-bottom: 20px;
            margin-bottom: 28px;
            gap: 16px;
          }
          .doc-header-badge {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: var(--accent);
            margin-bottom: 4px;
          }
          .doc-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
            color: var(--text-primary);
          }
          .doc-header-id { text-align: right; }
          .doc-header-id span {
            display: block;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
          }
          .doc-header-id strong {
            font-size: 18px;
            color: var(--text-primary);
          }
          .section-block { margin-bottom: 28px; }
          .section-title {
            font-size: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-primary);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 8px;
            margin: 0 0 16px 0;
          }
          .grid-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
          }
          .info-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 16px 20px;
          }
          .info-card-title {
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 8px;
            margin: 0 0 12px 0;
          }
          .card-line {
            margin-bottom: 4px;
            color: var(--text-primary);
          }
          .card-spacer { height: 10px; }
          .kv-list {
            display: grid;
            grid-template-columns: minmax(130px, auto) 1fr;
            gap: 6px 16px;
            margin: 0;
          }
          .kv-list dt {
            color: var(--text-muted);
            font-weight: 500;
          }
          .kv-list dd {
            margin: 0;
            font-weight: 600;
            color: var(--text-primary);
          }
          .note-box {
            background-color: var(--accent-light);
            border-left: 4px solid var(--accent);
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 24px;
          }
          .note-box-title {
            font-weight: 700;
            font-size: 13px;
            margin-bottom: 4px;
            color: var(--text-primary);
          }
          .table-toolbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 8px;
          }
          .btn-expand-all {
            background-color: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-primary);
            cursor: pointer;
          }
          .btn-expand-all:hover { background-color: var(--bg-page); }
          .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 16px;
            font-size: 13.5px;
          }
          .data-table th {
            background-color: #f1f5f9;
            color: var(--text-secondary);
            font-weight: 600;
            text-align: left;
            padding: 10px 12px;
            border-bottom: 2px solid var(--border-color);
            white-space: nowrap;
          }
          .data-table td {
            padding: 10px 12px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: top;
          }
          .data-table tbody tr:hover { background-color: #f8fafc; }
          .data-table .data-table {
            margin: 8px 0 0 0;
            background: #ffffff;
            border: 1px solid var(--border-color);
          }
          .data-table .data-table th {
            width: 35%;
            background: #f8fafc;
            padding: 6px 10px;
          }
          .data-table .data-table td { padding: 6px 10px; }
          .expandable-row {
            display: grid;
            grid-template-columns: 0.5fr 2fr 1fr 1.2fr 1fr 1.2fr 1fr 1fr;
            align-items: center;
          }
          .expanded-row-content {
            grid-column: 1 / -1;
            padding: 0 !important;
            border-bottom: 1px solid var(--border-color);
          }
          .accordion {
            background-color: #f8fafc;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 6px 12px;
            width: 100%;
            border: none;
            border-top: 1px dashed var(--border-color);
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
          }
          .accordion:hover, .accordion.active {
            background-color: #f1f5f9;
            color: var(--text-primary);
          }
          .expand-table-row:before {
            content: "+";
            display: inline-block;
            width: 16px;
            font-weight: bold;
          }
          .accordion.active .expand-table-row:before,
          .expand-table-row.selected:before {
            content: "-";
          }
          .line-detail-panel {
            padding: 0 16px;
            background-color: #ffffff;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.2s ease-out;
          }
          .line-detail-panel-inner { padding: 12px 0; }
          .doc-footer {
            margin-top: 32px;
            padding-top: 16px;
            border-top: 1px solid var(--border-color);
            font-size: 12px;
            color: var(--text-muted);
          }
          .doc-footer p { margin: 2px 0; }
          @media print {
            body { background: #ffffff; padding: 0; }
            .document-wrapper { border: none; box-shadow: none; padding: 0; }
            .table-toolbar, .accordion { display: none; }
            .line-detail-panel { max-height: none !important; overflow: visible !important; }
          }
        </style>
      </head>
      <body>
        <div class="document-wrapper">
          <header class="doc-header">
            <div>
              <div class="doc-header-badge">
                <xsl:variable name="varFileName">
                  <xsl:call-template name="fileNameFromPath">
                    <xsl:with-param name="path" select="base-uri()" />
                  </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="translate">
                  <xsl:with-param name="keyName" select="$varFileName"/>
                </xsl:call-template>
              </div>
              <h1>
                <xsl:call-template name="translate">
                  <xsl:with-param name="keyName" select="/doc:BusinessDocument/doc:WindowTitle"/>
                </xsl:call-template>
              </h1>
            </div>
            <div class="doc-header-id">
              <span>Document ID</span>
              <strong>
                <xsl:evaluate xpath="/doc:BusinessDocument/doc:DocumentTitle" context-item="$varDataXml"/>
              </strong>
            </div>
          </header>

          <main>
            <xsl:apply-templates select="/doc:BusinessDocument/doc:Section">
              <xsl:with-param name="context" select="$varDataXml"/>
            </xsl:apply-templates>
          </main>

          <footer class="doc-footer">
            <xsl:for-each select="/doc:BusinessDocument/doc:Namespaces/doc:Namespace">
              <p><xsl:value-of select="@prefix"/>: <xsl:value-of select="text()"/></p>
            </xsl:for-each>
          </footer>
        </div>

        <script>
          const toggleRowExpand = (element) => {  
            element.classList.toggle("active");
            const span = element.querySelector(".expand-table-row");
            if (span) span.classList.toggle("selected");
            const lineDetailPanel = element.nextElementSibling;
            if (lineDetailPanel.style.maxHeight) {
              lineDetailPanel.style.maxHeight = null;
            } else {
              lineDetailPanel.style.maxHeight = lineDetailPanel.scrollHeight + "px";
            } 
          };

          const allRowExpandToggle = (element) => {  
            const table = element.closest('.table-wrapper').querySelector('table');
            const buttons = table.querySelectorAll('.accordion');
            const shouldExpand = Array.from(buttons).some(btn => !btn.classList.contains('active'));
            
            buttons.forEach(btn => {
              const span = btn.querySelector('.expand-table-row');
              const panel = btn.nextElementSibling;
              if (shouldExpand) {
                btn.classList.add('active');
                if (span) span.classList.add('selected');
                panel.style.maxHeight = panel.scrollHeight + "px";
              } else {
                btn.classList.remove('active');
                if (span) span.classList.remove('selected');
                panel.style.maxHeight = null;
              }
            });
          };
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="doc:Section">
    <xsl:param name="context"/>
    <div class="section-block">
      <xsl:apply-templates select="doc:Fields | doc:Note | doc:Reference | doc:Party | doc:Section">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="doc:Fields">
    <xsl:param name="context"/>
    <xsl:if test="doc:Form or doc:Key">
      <div class="grid-cards">
        <xsl:apply-templates select="doc:Form | doc:Key">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </div>
    </xsl:if>
    <xsl:apply-templates select="doc:Table">
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="doc:Form">
    <xsl:param name="context"/>
    <div class="info-card">
      <h3 class="info-card-title">
        <xsl:call-template name="translate">
          <xsl:with-param name="keyName" select="@title"/>
        </xsl:call-template>
      </h3>
      <dl class="kv-list">
        <xsl:apply-templates select="doc:Field">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </dl>
    </div>
  </xsl:template>

  <xsl:template match="doc:Key">
    <xsl:param name="context"/>
    <div class="info-card">
      <h3 class="info-card-title">Metadata</h3>
      <dl class="kv-list">
        <xsl:for-each select="doc:Field">
          <dt>
            <xsl:apply-templates select="doc:Name">
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
          </dt>
          <dd>
            <xsl:apply-templates select="doc:DisplayBlock | doc:Expr">
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
          </dd>
        </xsl:for-each>
      </dl>
    </div>
  </xsl:template>

  <xsl:template match="doc:Reference">
    <xsl:param name="context"/>
    <xsl:if test="doc:Data/doc:Field">
      <div class="info-card" style="margin-bottom: 24px;">
        <h3 class="info-card-title">References</h3>
        <dl class="kv-list">
          <xsl:for-each select="doc:Data/doc:Field">
            <xsl:variable name="varForEachPath" select="@forEach"/>
            <xsl:variable name="varNameExpr" select="doc:Name"/>
            <xsl:variable name="varValExpr" select="doc:Expr"/>
            <xsl:variable name="varRefItems">
              <xsl:evaluate xpath="$varForEachPath" context-item="$context"/>
            </xsl:variable>
            <xsl:for-each select="$varRefItems/child::*">
              <xsl:variable name="varItemCtx" select="."/>
              <dt><xsl:evaluate xpath="$varNameExpr" context-item="$varItemCtx"/></dt>
              <dd><xsl:evaluate xpath="$varValExpr" context-item="$varItemCtx"/></dd>
            </xsl:for-each>
          </xsl:for-each>
        </dl>
      </div>
    </xsl:if>
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

    <div class="table-wrapper">
      <xsl:if test="@title != ''">
        <h3 class="section-title">
          <xsl:call-template name="translate">
            <xsl:with-param name="keyName" select="@title"/>
          </xsl:call-template>
        </h3>
      </xsl:if>

      <xsl:if test="$varHasRowDetail = 'TRUE'">
        <div class="table-toolbar">
          <button type="button" class="btn-expand-all" onclick="allRowExpandToggle(this)">
            <xsl:call-template name="translate">
              <xsl:with-param name="keyName" select="'Expand or Collapse All'"/>
            </xsl:call-template>
          </button>
        </div>
      </xsl:if>

      <table class="data-table">
        <xsl:if test="$varHeaderPosition = '' or $varHeaderPosition = 'VERTICAL'">
          <thead>
            <tr>
              <xsl:if test="$varHasRowDetail = 'TRUE'">
                <xsl:attribute name="class">expandable-row</xsl:attribute>
              </xsl:if>
              <xsl:for-each select="doc:Field[doc:Name != '']">
                <th>
                  <xsl:variable name="varFieldTranslate" select="upper-case(doc:Name/@translate)"/>
                  <xsl:choose>
                    <xsl:when test="$varFieldTranslate = 'TRUE'">
                      <xsl:call-template name="translate">
                        <xsl:with-param name="keyName" select="doc:Name"/>
                      </xsl:call-template>
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
                <xsl:attribute name="class">expandable-row</xsl:attribute>
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
                          <xsl:attribute name="class">expanded-row-content</xsl:attribute>
                          <button type="button" class="accordion" onclick="toggleRowExpand(this)">
                            <span class="expand-table-row"/> Details
                          </button>
                          <div class="line-detail-panel">
                            <div class="line-detail-panel-inner">
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
    <xsl:if test="doc:Primary">
      <div class="grid-cards">
        <xsl:for-each select="doc:Primary">
          <xsl:variable name="varContextPath" select="@block"/>
          <xsl:variable name="varContext">
            <xsl:evaluate xpath="$varContextPath" context-item="$context"/>
          </xsl:variable>
          <div class="info-card">
            <h3 class="info-card-title">
              <xsl:call-template name="translate">
                <xsl:with-param name="keyName" select="@title"/>
              </xsl:call-template>
            </h3>
            <xsl:for-each select="doc:DisplayBlock | doc:Expr | doc:NewLine">
              <xsl:apply-templates select=".">
                <xsl:with-param name="context" select="$varContext"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>

    <xsl:if test="doc:Secondary">
      <div class="grid-cards">
        <xsl:for-each select="doc:Secondary">
          <xsl:variable name="varContextPath" select="@block"/>
          <xsl:variable name="varContext">
            <xsl:evaluate xpath="$varContextPath" context-item="$context"/>
          </xsl:variable>
          <div class="info-card">
            <h3 class="info-card-title">
              <xsl:call-template name="translate">
                <xsl:with-param name="keyName" select="@title"/>
              </xsl:call-template>
            </h3>
            <xsl:for-each select="doc:DisplayBlock | doc:Expr | doc:NewLine">
              <xsl:apply-templates select=".">
                <xsl:with-param name="context" select="$varContext"/>
              </xsl:apply-templates>
            </xsl:for-each>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc:Field">
    <xsl:param name="context"/>
    <dt>
      <xsl:apply-templates select="doc:Name">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </dt>
    <dd>
      <xsl:apply-templates select="doc:DisplayBlock | doc:Expr">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </dd>
  </xsl:template>

  <xsl:template match="doc:Name">
    <xsl:param name="context"/>
    <xsl:variable name="varFieldTranslate" select="upper-case(@translate)"/>
    <xsl:choose>
      <xsl:when test="$varFieldTranslate = 'TRUE'">
        <xsl:call-template name="translate">
          <xsl:with-param name="keyName" select="text()"/>
        </xsl:call-template>
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
    <xsl:variable name="varNewLine" select="$varDisplayFormat != 'SINGLELINE'"/>
    <xsl:variable name="varExprCount" select="count(doc:Expr | doc:DisplayBlock)"/>

    <xsl:for-each select="doc:Expr | doc:DisplayBlock | doc:NewLine">
      <xsl:variable name="varExprValue">
        <xsl:apply-templates select=".">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="normalize-space(string($varExprValue)) != '' and $varWarp = 'CELLROW'">
          <div class="card-line">
            <xsl:copy-of select="$varExprValue"/>
          </div>
        </xsl:when>
        <xsl:when test="count($varExprValue/node()) > 0">
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
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="doc:Expr">
    <xsl:param name="context"/>
    <xsl:variable name="varDisplayFormat" select="upper-case(@format)"/>
    <xsl:variable name="varEvalAs" select="upper-case(@as)"/>
    <xsl:variable name="varTargetCtx" select="if (count($context/node()) > 0) then $context else $varDataXml"/>

    <xsl:if test="text() != ''">
      <xsl:choose>
        <xsl:when test="$varEvalAs = 'TEXT' and $varDisplayFormat = 'BOLD'">
          <strong><xsl:evaluate xpath="text()" context-item="$varTargetCtx" as="xs:string"/></strong>
        </xsl:when>
        <xsl:when test="$varEvalAs = 'TEXT'">
          <xsl:evaluate xpath="text()" context-item="$varTargetCtx" as="xs:string"/>
        </xsl:when>
        <xsl:when test="$varDisplayFormat = 'BOLD'">
          <strong><xsl:evaluate xpath="text()" context-item="$varTargetCtx"/></strong>
        </xsl:when>
        <xsl:otherwise>
          <xsl:evaluate xpath="text()" context-item="$varTargetCtx"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc:Note">
    <xsl:param name="context"/>
    <xsl:variable name="varNoteText">
      <xsl:apply-templates select="doc:Expr">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="normalize-space($varNoteText) != ''">
      <div class="note-box">
        <div class="note-box-title">
          <xsl:call-template name="translate">
            <xsl:with-param name="keyName" select="'Notes'"/>
          </xsl:call-template>
        </div>
        <div><xsl:copy-of select="$varNoteText"/></div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc:NewLine">
    <xsl:param name="context"/>
    <div class="card-spacer"/>
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
