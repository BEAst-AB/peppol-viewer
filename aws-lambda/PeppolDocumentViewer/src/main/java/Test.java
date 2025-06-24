import java.util.Properties;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ByteArrayInputStream;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Path;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathExpression;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import java.net.URL;
import java.net.URLConnection;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import org.apache.commons.configuration2.ex.ConfigurationException;

// javac -cp .\..\lib\*;. --release 21 Test.java
// java -cp .\..\lib\*;. Test

public class Test {
	
  static boolean verbose = true;

    public static String getXmlRootElement(String xmlString) {
        String returnString = null;

        try {
            // Check if the string is valid XML and parse it
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true); // Optional: Enable namespace awareness
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(new ByteArrayInputStream(xmlString.getBytes()));

            // Get the root element
            Element rootElement = document.getDocumentElement();
			String rootElementTagName = rootElement.getTagName();
			String rootElementNamespaceUri = rootElement.getNamespaceURI();
            returnString = "{" + rootElementNamespaceUri + "}" + rootElement.getTagName();
        } catch (Exception e) {
            System.out.println("Invalid XML: " + e.getMessage());
        }
		
		return returnString;
    }

    public static String getXmlElementValue(String xmlFileUri, String xpathExpr) {
        String returnString = null;

        try {
            // Check if the string is valid XML and parse it
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true); // Optional: Enable namespace awareness
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(xmlFileUri);

            XPathFactory xPathfactory = XPathFactory.newInstance();
            XPath xpath = xPathfactory.newXPath();
            XPathExpression expr = xpath.compile(xpathExpr);
			returnString = (String) expr.evaluate(document, XPathConstants.STRING);
        } catch (Exception e) {
            System.out.println("Invalid XML: " + e.getMessage());
        }
		
		return returnString;
    }

  public static void testProperties() {
	String connectionPropertiesFile = "../resources/peppol-viewers.properties";
	try {
		Properties connectionProperties = new Properties();
        connectionProperties.load(new FileInputStream(connectionPropertiesFile));

        if (verbose) {
		  for (Object key: connectionProperties.keySet()) {
            System.out.println(key + ": " + connectionProperties.getProperty(key.toString()));
          }
		}
		
		
	} catch (Exception ex) {
		ex.printStackTrace();
	}
  }

  public static void testProperties2() throws ConfigurationException {
    Configurations configs = new Configurations();
	String connectionPropertiesFile = "../resources/peppol-viewers.properties";
    Configuration config = configs.properties(new File(connectionPropertiesFile));
	try {
        if (verbose) {
            System.out.println("url.repo.peppol-viewer: " + config.getString("url.repo.peppol-viewer"));
            System.out.println("url.metadata: " + config.getString("url.metadata"));
            System.out.println("url.translations: " + config.getString("url.translations"));
            System.out.println("url.peppol.viewers.indexFile: " + config.getString("url.peppol.viewers.indexFile"));
		}
	} catch (Exception ex) {
		ex.printStackTrace();
	}
  }

  public static void testDates() {
      // ZoneId z = ZoneId.of( "Europe/Stockholm" );
      ZonedDateTime nowTime = ZonedDateTime.now(); // ZonedDateTime.now( z );
	  System.out.println(nowTime);
      ZonedDateTime expiryDateTime = nowTime.plusSeconds(3600);
	  DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ssVV");
      String formatted = ZonedDateTime.ofInstant(expiryDateTime.toInstant(), ZoneOffset.UTC).format(FORMATTER);
	  // System.out.println(expiryDateTime.format(DateTimeFormatter.ISO_INSTANT));
	  System.out.println(formatted);
  }

	private static String readFromInputStream(InputStream inputStream)
	  throws IOException {
		StringBuilder resultStringBuilder = new StringBuilder();
		try (BufferedReader br
		  = new BufferedReader(new InputStreamReader(inputStream))) {
			String line;
			while ((line = br.readLine()) != null) {
				resultStringBuilder.append(line).append("\n");
			}
		}
	  return resultStringBuilder.toString();
	}

  public static String readRemoteFileFileData(String urlString) throws IOException {
    URL urlObject = new URL(urlString);
    URLConnection urlConnection = urlObject.openConnection();
    InputStream inputStream = urlConnection.getInputStream();
    String data = readFromInputStream(inputStream);
    return data;
  }

  public static void testXmlParsing() throws IOException {
	  Path path = FileSystems.getDefault().getPath("AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml");
	  String content = Files.readString(path, StandardCharsets.UTF_8);
	  String rootElement = getXmlRootElement(content);
	  System.out.println("Root element: " + rootElement);
	  
	  String xpathExpr = "/Peppol/Viewers[@document=\""+ rootElement +"\"]";
	  System.out.println("Xpath expression: " + xpathExpr);
	  System.out.println("Viewer metadata: " + getXmlElementValue("C:/Users/KishoreSadanandam/source/repos/BEAst-AB/peppol-viewer/aws-lambda/PeppolDocumentViewer/src/main/resources/PeppolViewers.xml", xpathExpr));
  }

  public static void main(String[] args) throws IOException, ConfigurationException {
	  // testProperties();
	  
	  // keytool -importcert -file "C:\Users\KishoreSadanandam\Documents\Navigate\Certificates\GIT_Hub\L0 USERTrust ECC Certification Authority.crt"
	  // keytool -importcert -file "C:\Users\KishoreSadanandam\Documents\Navigate\Certificates\GIT_Hub\L1 Sectigo ECC Domain Validation Secure Server CA.crt" -alias "L1_GIT_Hub"
	  // keytool -importcert -file "C:\Users\KishoreSadanandam\Documents\Navigate\Certificates\GIT_Hub\L2 github.crt" -alias "L2_GIT_Hub"
	  // keytool -changealias -alias "mykey" -destalias "L0_GIT_Hub"
	  // String data = readRemoteFileFileData("https://raw.githubusercontent.com/BEAst-AB/dpp/refs/heads/main/aws-lambda/TickstarGalaxyGatewayTransactionHandler/src/main/resources/Providers.xml?token=GHSAT0AAAAAADDSVJDX7FXVGFRSUNCQIUH62BB7TLA");
	  
	  // String data = readRemoteFileFileData("https://raw.githubusercontent.com/BEAst-AB/peppol-viewer/refs/heads/main/metadata/peppol-viewers.xml");
	  // System.out.println("Data: " + data);
	  
	  testProperties2();
  }
}