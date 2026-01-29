set SAXON_HOME=C:\Users\KishoreSadanandam\Documents\SaxonHE12-3J
set CLASSPATH=%SAXON_HOME%\lib\jline-2.14.6.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2-data.jar;%SAXON_HOME%\saxon-he-12.3.jar

set XSL_FILE=".\perplexity.xsl"
set XML_META_FILE=".\..\metadata\ada-perplexity.xml"
REM set CURRENT_DIR=%~dp0
set XML_FILE_NAME=AdvancedDespatchAdvice__Example_UseCase_08_Waste
set IN_XML_FILE=./%XML_FILE_NAME%.xml
set OUT_XML_FILE=%XML_FILE_NAME%_output.html

java -cp %CLASSPATH% net.sf.saxon.Transform -s:%XML_META_FILE% -xsl:%XSL_FILE% -o:%OUT_XML_FILE% paramDataXml=%IN_XML_FILE% paramLang=sv paramUrlRepo=https://raw.githubusercontent.com/BEAst-AB/peppol-viewer
