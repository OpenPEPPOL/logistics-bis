<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso" queryBinding="xslt2">
        
    <title>eSENS business and syntax rules for search notice request</title>

    <ns prefix="rim" uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0"/>
    <ns prefix="query" uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0"/>
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    <!-- Functions -->
    <xi:include href="parts/function/gln.xml"/>
    <xi:include href="parts/function/slack.xml"/>
    <xi:include href="parts/function/mod11.xml"/>
	<xi:include href="parts/function/checkCodiceIPA.xml"/>
	<xi:include href="parts/function/addPIVA.xml"/>
	<xi:include href="parts/function/checkCF.xml"/>
	<xi:include href="parts/function/checkCF16.xml"/>
	<xi:include href="parts/function/checkPIVA.xml"/>
	<xi:include href="parts/function/checkPIVAseIT.xml"/>
	<xi:include href="parts/function/mod97-0208.xml"/>
    <xi:include href="parts/function/abn.xml"/>       
	<xi:include href="parts/function/checkSEOrgnr.xml"/>

    <!-- Rules -->
    <include href="parts/common/empty-elements.sch"/>
    <include href="parts/common/rules.sch"/>
    <include href="../../target/generated/T012-basic.sch"/>
    <include href="parts/PEPPOL-M-T012.sch"/>
</schema>

