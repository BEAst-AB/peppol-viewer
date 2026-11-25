set DATA_FILE=C:/Users/KishoreSadanandam/source/repos/BEAst-AB/peppol-viewer/aws-lambda/PeppolDocumentViewer/test/AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml
setlocal enabledelayedexpansion
set VAR=
for /f "delims=" %%A in (%DATA_FILE%) do (
    set "VAR=%%A"
)
