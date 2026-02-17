<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <title>eSENS business and syntax rules for Expression of Interest Response</title>
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ExpressionOfInterestResponse-2"/>
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
    <include href="../../target/generated/T002-basic.sch"/> 
    <include href="parts/PEPPOL-M-T002.sch"/>

</schema>
