package beast.peppol.viewer.lambda.handler;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;

import java.util.Properties;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.io.File;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.PrintWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Path;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathExpression;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.Xslt30Transformer;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XdmAtomicValue;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.fileupload.MultipartStream;

// javac -cp .\lib\*;. --release 21 beast\peppol\viewer\lambda\handler\PeppolDocumentViewer.java
// java -cp .\lib\*;. beast.peppol.viewer.lambda.handler.PeppolDocumentViewer

public class PeppolDocumentViewer implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse>{

  public static String handleTransformRequest(String xslFile, String sourceXmlData, String dataXmlFile, String language, String urlRepo) throws TransformerException {
      TransformerFactory tf = TransformerFactory.newInstance();
      Templates t = tf.newTemplates(new StreamSource(new File(xslFile)));
	  Transformer trx = t.newTransformer();
	  trx.setParameter("paramDataXml", dataXmlFile);
	  trx.setParameter("paramLang", language);
	  trx.setParameter("paramUrlRepo", urlRepo);
      StringWriter writer = new StringWriter();
      trx.transform( new StreamSource(new StringReader(sourceXmlData)), new StreamResult(writer));
      return writer.toString();
	  // return "<StandardBusinessDocument xmlns=\"http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader\"/>";
  }

  public static String handleSaxonTransformRequest(String xslFile, String sourceXmlData, String dataXmlFile, String language, String urlRepo) throws SaxonApiException {
	  Processor PROCESSOR = new Processor(false);
	  XsltExecutable stylesheet = PROCESSOR.newXsltCompiler().compile(new StreamSource(new File(xslFile)));
	  Xslt30Transformer transformer = stylesheet.load30();
	  // Map<QName, XdmValue> params = Collections.singletonMap(new QName("paramDataXml"), new XdmAtomicValue(dataXmlFile));
	  Map<QName, XdmValue> params = new HashMap<QName, XdmValue>();
	  params.put(new QName("paramDataXml"), new XdmAtomicValue(dataXmlFile));
	  params.put(new QName("paramLang"), new XdmAtomicValue(language));
	  params.put(new QName("paramUrlRepo"), new XdmAtomicValue(urlRepo));
	  transformer.setStylesheetParameters(params);
	  ByteArrayOutputStream baos = new ByteArrayOutputStream();
      Serializer output = PROCESSOR.newSerializer(baos);
	  transformer.transform( new StreamSource(new StringReader(sourceXmlData)), output);
	  // return "<StandardBusinessDocument xmlns=\"http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader\"/>";
      return baos.toString();
  }
  
  public static String handleMultipartRequest(LambdaLogger logger, Map<String, String> headersMap, String body) {
	try {
	    byte[] bI = Base64.decodeBase64(body.getBytes());
        String contentType = headersMap.get("content-type");

        String[] boundaryArray = contentType.split("=");
		byte[] boundary = boundaryArray[1].getBytes();
		
		ByteArrayInputStream content = new ByteArrayInputStream(bI);
		MultipartStream multipartStream = new MultipartStream(content, boundary, bI.length, null);
		
		boolean nextPart = multipartStream.skipPreamble();
		
		while (nextPart) {
            String header = multipartStream.readHeaders();
			logger.log("Headers:");
            logger.log(header);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            multipartStream.readBodyData(out);
			logger.log("Body:");
			logger.log(out.toString( java.nio.charset.StandardCharsets.UTF_8 ));
            //Get the next part, if any
            nextPart = multipartStream.readBoundary();
        }				
	} catch(Exception ex) {
		StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        ex.printStackTrace(pw);
		return sw.toString();
	}
	return "";
  }

	public static Properties loadProperties(LambdaLogger logger, String propertiesFile, boolean verbose) throws FileNotFoundException, IOException {
		Properties properties = new Properties();
        properties.load(new FileInputStream(propertiesFile));
		return properties;
	}

    public static String getXmlRootElement(LambdaLogger logger, String xmlString) {
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
        } catch (Exception ex) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			ex.printStackTrace(pw);
			String stackTrace = sw.toString();
			logger.log(stackTrace);
        }
		
		return returnString;
    }

    public static String getXmlElementValue(LambdaLogger logger, String xmlFileUri, String xpathExpr) {
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
        } catch (Exception ex) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			ex.printStackTrace(pw);
			String stackTrace = sw.toString();
			logger.log(stackTrace);
        }
		
		return returnString;
    }
	
	public static String processPeppolDocument(LambdaLogger logger, Map<String, String> requestHeaders, String requestBody, Properties properties, boolean verbose) {
      String responseData = null;
	  try {
        // String requestContentType = requestHeaders.get("Content-Type");
	    // if ("application/json".equals(requestContentType) && requestBody != null) {
	    if (requestBody != null) {
			String language = requestHeaders.get("Language");
			if (language == null)
		      language = "en";
            String rootElement = getXmlRootElement(logger, requestBody);
            logger.log("Root element: " + rootElement);

            String xpathExpr = "/Peppol/Viewers[@document=\""+ rootElement +"\"]";
            logger.log("Xpath expression: " + xpathExpr);
            String viewerMetadataFile = getXmlElementValue(logger, properties.getProperty("url.peppol.viewers.indexFile"), xpathExpr);
            logger.log("Viewer metadata: " + viewerMetadataFile);

            responseData = handleTransformRequest("XML_To_Formatted_HTML.xsl", viewerMetadataFile, requestBody, language, properties.getProperty("url.repo.peppol-viewer"));
        }
      } catch(Exception ex) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        ex.printStackTrace(pw);
        String stackTrace = sw.toString();
        logger.log(stackTrace);
      }
	  return responseData;
	}

  @Override
  public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context)
  {
    LambdaLogger logger = context.getLogger();
    // logger.log("EVENT TYPE: " + event.getClass().toString());
    logger.log("Request Event: " + event);
    logger.log("Request Context: " + context);
    logger.log("Headers: " + event.getHeaders());
    logger.log("Body: " + event.getBody());
	// String requestContentType = event.getHeaders().get("Content-Type");
    // logger.log("Request Content-Type: " + requestContentType);
	boolean verbose = true;
	String responseBody = null;
    try {
      Properties properties = loadProperties(logger, "peppol-viewers.properties", verbose); 
	  logger.log("Properties: " + properties);
      responseBody = processPeppolDocument(logger, event.getHeaders(), event.getBody(), properties, verbose);
    } catch(Exception ex) {
      StringWriter sw = new StringWriter();
      PrintWriter pw = new PrintWriter(sw);
      ex.printStackTrace(pw);
      String stackTrace = sw.toString();
      logger.log(stackTrace);
    }
    APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
    response.setIsBase64Encoded(false);
    response.setStatusCode(200);
    HashMap<String, String> headers = new HashMap<String, String>();
    headers.put("Content-Type", "text/html");
    response.setHeaders(headers);
    response.setBody(responseBody);
    return response;
  }
  
  public static void main(String[] args) throws TransformerException, IOException, SaxonApiException {
	  Path path = FileSystems.getDefault().getPath("AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml");
	  String content = Files.readString(path, StandardCharsets.UTF_8);
	  System.out.println(handleTransformRequest("XML_To_Formatted_HTML.xsl", "AdvancedDespatchAdvice_html_meta.xml", content, "sv", "https://github.com/BEAst-AB/peppol-viewer"));
	  // System.out.println(PeppolDocumentViewer.handleRequest("XML_To_Formatted_HTML.xsl", "AdvancedDespatchAdvice_html_meta.xml", "AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml", "sv"));
  }
}