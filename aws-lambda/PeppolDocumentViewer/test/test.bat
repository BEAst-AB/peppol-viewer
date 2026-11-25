REM set SAXON_HOME=C:\Users\KishoreSadanandam\Documents\SaxonHE12-5J
REM set CLASSPATH=%SAXON_HOME%\lib\jline-2.14.6.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2-data.jar;%SAXON_HOME%\saxon-he-12.5.jar

set SAXON_HOME=C:\Users\KishoreSadanandam\Documents\SaxonHE12-3J
set CLASSPATH=%SAXON_HOME%\lib\jline-2.14.6.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2.jar;%SAXON_HOME%\lib\xmlresolver-5.2.2-data.jar;%SAXON_HOME%\saxon-he-12.3.jar

REM set XSL_FILE="remove-pi.xsl"

REM set XSL_FILE="example.xsl"
REM set XML_FILE="C:\Users\KishoreSadanandam\Documents\Navigate\BEAst\test\output_saxon\ubl-advanced-despatch-advice-syntax.xml"
REM set OUT_XML_FILE=ubl-advanced-despatch-advice-example.xml
REM java -cp %CLASSPATH% net.sf.saxon.Transform -s:%XML_FILE% -xsl:%XSL_FILE% -o:output_saxon/%OUT_XML_FILE% 

set XSL_FILE="..\src\main\java\XML_To_Formatted_HTML.xsl"
REM set XML_FILE="AdvancedDespatchAdvice_html_meta.xml"
set XML_FILE="https://raw.githubusercontent.com/BEAst-AB/peppol-viewer/refs/heads/main/metadata/advanced-despatch-advice-html-meta.xml"
REM set XML_FILE="..\..\..\metadata\advanced-despatch-advice-html-meta.xml"
set OUT_XML_FILE=ADA_Ex_UC_06.html
set CURRENT_DIR=%~dp0
REM echo CURRENT_DIR is %CURRENT_DIR%
REM set DATA_FILE=C:/Users/KishoreSadanandam/source/repos/BEAst-AB/peppol-viewer/aws-lambda/PeppolDocumentViewer/test/AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml
set DATA_FILE=../../../test/ADA_Ex_UC_06_Input.xml
REM setlocal enabledelayedexpansion
REM set DATA_FILE_CONTENT=
REM for /f "delims=" %%A in (%DATA_FILE%) do (
REM     set "DATA_FILE_CONTENT=%%A"
REM )
java -cp %CLASSPATH% net.sf.saxon.Transform -s:%XML_FILE% -xsl:%XSL_FILE% -o:output/%OUT_XML_FILE% paramDataXml=%DATA_FILE% paramLang=sv paramUrlRepo=https://raw.githubusercontent.com/BEAst-AB/peppol-viewer
