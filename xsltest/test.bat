REM set SAXON_HOME=C:\Users\KishoreSadanandam\Documents\SaxonHE12-3J
REM set CLASSPATH=%SAXON_HOME%\lib\jline-2.14.6.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2-data.jar;%SAXON_HOME%\saxon-he-12.3.jar
set SAXON_HOME=C:\Users\KishoreSadanandam\Documents\SaxonHE12-5J
set CLASSPATH=%SAXON_HOME%\lib\jline-2.14.6.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2-data.jar;%SAXON_HOME%\saxon-he-12.5.jar

REM set CURRENT_DIR=%~dp0

REM set XSL_FILE=".\perplexity.xsl"
REM set XML_META_FILE=".\..\metadata\ada-perplexity.xml"
REM set XML_FILE_NAME=AdvancedDespatchAdvice_Example_Full
REM set IN_XML_FILE=./%XML_FILE_NAME%.xml
REM set OUT_XML_FILE=%XML_FILE_NAME%_output.html

REM set XSL_FILE=".\XML_To_Formatted_HTML_peppol.xsl"
REM set XML_META_FILE=".\..\metadata\advanced-despatch-advice-html-meta.xml"
REM set XML_FILE_NAME=AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material
REM set IN_XML_FILE=./%XML_FILE_NAME%.xml
REM set OUT_XML_FILE=%XML_FILE_NAME%_output.html

set XSL_FILE="./XML_To_Formatted_HTML_peppol.xsl"
set XML_META_FILE=".\..\metadata\catalogue-html-meta.xml"
set XML_FILE_NAME=catalogue-wo-response-use-case-1
set IN_XML_FILE="../../beast-supply/rules/examples/Cataloge wo response use cases/%XML_FILE_NAME%.xml"
set OUT_XML_FILE=%XML_FILE_NAME%_output.html

java -cp %CLASSPATH% net.sf.saxon.Transform -s:%XML_META_FILE% -xsl:%XSL_FILE% -o:%OUT_XML_FILE% paramDataXml=%IN_XML_FILE% paramLang=sv paramUrlRepo=https://raw.githubusercontent.com/BEAst-AB/peppol-viewer
