<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fo="http://www.w3.org/1999/XSL/Format"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:nsPep="urn:fdc:difi.no:2017:vefa:structure-1"
                xmlns="urn:fdc:difi.no:2017:vefa:structure-1"
				xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
				xmlns:oraext="http://www.oracle.com/XSL/Transform/java/oracle.tip.pc.services.functions.ExtFunc"
				exclude-result-prefixes="xs fo fn xsl nsPep map array oraext">
	<xsl:param name="UblBaseUrl"/>
	<xsl:param name="UblXmlReferenceFile"/>
	<xsl:param name="UblDocBaseUrl"/>

	<!--xsl:variable name="varUblBaseUrl" select="'file:///C:/Users/Kishore/Documents/Navigate/BEAst/GIT/test/ubl-invoice-short/'"/-->
	<!--xsl:variable name="varUblBaseUrl" select="'https://raw.githubusercontent.com/OpenPEPPOL/peppol-bis-invoice-3/master/structure/syntax/'"/>
	<xsl:variable name="varUblXmlReferenceFile" select="'ubl-invoice.xml'"/>
	<xsl:variable name="varUblDocBaseUrl" select="'https://docs.peppol.eu/poacc/billing/3.0/syntax/ubl-invoice'"/>
	<xsl:variable name="varUblXml" select="document(concat($varUblBaseUrl, $varUblXmlReferenceFile))"/-->

	<xsl:variable name="varUblBaseUrl" select="$UblBaseUrl"/>
	<xsl:variable name="varUblXmlReferenceFile" select="$UblXmlReferenceFile"/>
	<xsl:variable name="varUblDocBaseUrl" select="$UblDocBaseUrl"/>
	<xsl:variable name="varUblXml" select="document(concat($varUblBaseUrl, $varUblXmlReferenceFile))"/>

	<xsl:output omit-xml-declaration="no" indent="yes" method="xml"/>

	<xsl:template match="/">
		<Structure>
			<Term>
				<xsl:value-of select="/*/processing-instruction('DocumentTerm')"/>
			</Term>
			<xsl:for-each select="/*/processing-instruction('Property')">
				<Property>
					<xsl:choose>
						<xsl:when test="substring-after(.,'key=&quot;sch:prefix&quot;') != ''">
							<xsl:attribute name="key">
								<xsl:value-of select="'sch:prefix'"/>
							</xsl:attribute>
							<xsl:value-of select="normalize-space(substring-after(.,'key=&quot;sch:prefix&quot;'))"/>
						</xsl:when>
						<xsl:when test="substring-after(.,'key=&quot;sch:identifier&quot;') != ''">
							<xsl:attribute name="key">
								<xsl:value-of select="'sch:identifier'"/>
							</xsl:attribute>
							<xsl:value-of select="normalize-space(substring-after(.,'key=&quot;sch:identifier&quot;'))"/>
						</xsl:when>
					</xsl:choose>
				</Property>
			</xsl:for-each>

			<!--Name>
				<xsl:value-of select="/*/processing-instruction('Name')"/>
			</Name-->
			<Namespace>
				<xsl:attribute name="prefix">
					<xsl:value-of select="fn:prefix-from-QName(fn:QName(fn:namespace-uri(/*/.),fn:name(/*/.)))"/>
				</xsl:attribute>
				<xsl:value-of select="/*/fn:namespace-uri()"/>
			</Namespace>
			<Namespace prefix="cac">urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2</Namespace>
			<Namespace prefix="cbc">urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2</Namespace>

			<xsl:for-each select="/*/processing-instruction('SchematronPath')">
				<Rules Type="schematron">
					<xsl:value-of select="/*/processing-instruction('SchematronPath')"/>
				</Rules>
			</xsl:for-each>
			<!--xsl:message>
				Peppol Term <xsl:value-of  select="$varUblXml/nsPep:Structure/nsPep:Term"/> Name <xsl:value-of  select="$varUblXml/nsPep:Structure/nsPep:Name"/>
			</xsl:message-->
			<Document>
				<xsl:apply-templates mode="root"/>
			</Document>
		</Structure>
	</xsl:template>

	<xsl:template match="*" mode="root">
		<Term>
			<xsl:value-of select="fn:name(.)"/>
		</Term>
		<xsl:apply-templates mode="therest"/>
	</xsl:template>

	<xsl:template name="findElement">
		<xsl:param name="paramAnscestorNodes"/>
		<xsl:param name="paramAnscestorCount"/>
		<xsl:param name="paramCurrentIndex"/>
		<xsl:param name="paramElement"/>
		<xsl:param name="paramReferenceBaseUrl"/>
		<xsl:param name="paramReferenceRelativeFile"/>
		<xsl:param name="paramPrintReferenceUrlOnly"/>
		<xsl:variable name="varTermName">
			<xsl:choose>
				<xsl:when test="contains($paramAnscestorNodes, '/')">
					<xsl:choose>
						<xsl:when test="contains(substring-after($paramAnscestorNodes, '/'), '/')">
							<xsl:value-of select="substring-before(substring-after($paramAnscestorNodes, '/'), '/')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after($paramAnscestorNodes, '/')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$paramAnscestorNodes"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="varChildrenOfAncestor">
			<xsl:choose>
				<xsl:when test="contains($paramAnscestorNodes, '/')">
					<xsl:choose>
						<xsl:when test="contains(substring-after($paramAnscestorNodes, '/'), '/')">
							<xsl:value-of select="concat('/', substring-after(substring-after($paramAnscestorNodes, '/'), '/'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="''"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--xsl:message>
			paramAnscestorNodes: "<xsl:value-of  select="$paramAnscestorNodes"/>"
			paramAnscestorCount: "<xsl:value-of  select="$paramAnscestorCount"/>"
			Current Index: "<xsl:value-of  select="$paramCurrentIndex"/>"
			Term Name: "<xsl:value-of  select="$varTermName"/>"
		</xsl:message-->
		<xsl:choose>
			<xsl:when test="$paramElement/nsPep:Element[nsPep:Term = $varTermName] != ''">
				<xsl:choose>
					<xsl:when test="$paramAnscestorCount = $paramCurrentIndex">
						<xsl:choose>
							<xsl:when test="$paramPrintReferenceUrlOnly = true()">
								<xsl:value-of select="$paramReferenceBaseUrl"/>
								<xsl:value-of select="$paramReferenceRelativeFile"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$paramElement/nsPep:Element[nsPep:Term = $varTermName]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$paramAnscestorCount > $paramCurrentIndex">
						<xsl:call-template name="findElement">
							<xsl:with-param name="paramAnscestorNodes" select="$varChildrenOfAncestor"/>
							<xsl:with-param name="paramAnscestorCount" select="$paramAnscestorCount - 1"/>
							<xsl:with-param name="paramCurrentIndex" select="$paramCurrentIndex"/>
							<xsl:with-param name="paramElement">
								<xsl:copy-of select="$paramElement/nsPep:Element[nsPep:Term = $varTermName]/nsPep:Element"/>
								<xsl:copy-of select="$paramElement/nsPep:Element[nsPep:Term = $varTermName]/nsPep:Include"/>
							</xsl:with-param>
							<xsl:with-param name="paramReferenceBaseUrl" select="$paramReferenceBaseUrl"/>
							<xsl:with-param name="paramReferenceRelativeFile" select="$paramReferenceRelativeFile"/>
							<xsl:with-param name="paramPrintReferenceUrlOnly" select="$paramPrintReferenceUrlOnly"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$paramAnscestorCount = $paramCurrentIndex and $paramElement/nsPep:Element[nsPep:Term = $varTermName] = '' and count($paramElement/nsPep:Include) = 0">
			</xsl:when>
			<xsl:when test="$paramAnscestorCount > $paramCurrentIndex and $paramElement/nsPep:Element[nsPep:Term = $varTermName] != ''">
				<xsl:call-template name="findElement">
					<xsl:with-param name="paramAnscestorNodes" select="$varChildrenOfAncestor"/>
					<xsl:with-param name="paramAnscestorCount" select="$paramAnscestorCount - 1"/>
					<xsl:with-param name="paramCurrentIndex" select="$paramCurrentIndex + 1"/>
					<xsl:with-param name="paramElement" select="$paramElement/nsPep:Element/nsPep:Element[nsPep:Term = $varTermName]"/>
					<xsl:with-param name="paramReferenceBaseUrl" select="$paramReferenceBaseUrl"/>
					<xsl:with-param name="paramReferenceRelativeFile" select="$paramReferenceRelativeFile"/>
					<xsl:with-param name="paramPrintReferenceUrlOnly" select="$paramPrintReferenceUrlOnly"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count($paramElement/nsPep:Include) > 0">
				<xsl:for-each select="$paramElement/nsPep:Include">
					<!--xsl:message>
						Included file: "<xsl:value-of  select="text()"/>"
					</xsl:message-->
					<xsl:variable name="varIncludedFileElement" select="document(concat($varUblBaseUrl,text()))"/>
					<xsl:call-template name="findElement">
						<xsl:with-param name="paramAnscestorNodes" select="$paramAnscestorNodes"/>
						<xsl:with-param name="paramAnscestorCount" select="$paramAnscestorCount"/>
						<xsl:with-param name="paramCurrentIndex" select="$paramCurrentIndex"/>
						<xsl:with-param name="paramElement" select="$varIncludedFileElement"/>
						<xsl:with-param name="paramReferenceBaseUrl">
							<xsl:call-template name="buildBaseUri">
								<xsl:with-param name="paramBaseUri" select="$paramReferenceBaseUrl"/>
								<xsl:with-param name="paramRelativeUri" select="text()"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="paramReferenceRelativeFile">
							<xsl:call-template name="buildFileName">
								<xsl:with-param name="paramBaseUri" select="$paramReferenceBaseUrl"/>
								<xsl:with-param name="paramRelativeUri" select="text()"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="paramPrintReferenceUrlOnly" select="$paramPrintReferenceUrlOnly"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildBaseUri">
		<xsl:param name="paramBaseUri"/>
		<xsl:param name="paramRelativeUri"/>
		<xsl:choose>
			<xsl:when test="contains($paramRelativeUri, '/')">
				<xsl:call-template name="buildBaseUri">
					<xsl:with-param name="paramBaseUri" select="concat($paramBaseUri, substring-before($paramRelativeUri, '/'), '/')"/>
					<xsl:with-param name="paramRelativeUri" select="substring-after($paramRelativeUri, '/')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$paramBaseUri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildFileName">
		<xsl:param name="paramBaseUri"/>
		<xsl:param name="paramRelativeUri"/>
		<xsl:choose>
			<xsl:when test="contains($paramRelativeUri, '/')">
				<xsl:call-template name="buildFileName">
					<xsl:with-param name="paramBaseUri" select="concat($paramBaseUri, substring-before($paramRelativeUri, '/'), '/')"/>
					<xsl:with-param name="paramRelativeUri" select="substring-after($paramRelativeUri, '/')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$paramRelativeUri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildDocUrl">
		<xsl:param name="paramBaseUri"/>
		<xsl:param name="paramRelativeUri"/>
		<xsl:choose>
			<xsl:when test="contains($paramRelativeUri, ':')">
				<xsl:value-of select="concat(substring-before($paramRelativeUri, ':'), '-')"/>
				<xsl:call-template name="buildDocUrl">
					<xsl:with-param name="paramBaseUri" select="$paramBaseUri"/>
					<xsl:with-param name="paramRelativeUri" select="substring-after($paramRelativeUri, ':')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$paramRelativeUri"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="therest">
		<Element>
			<xsl:variable name="varElementName" select="fn:name(.)"></xsl:variable>
			<xsl:variable name="varAnscestorNodes">
				<xsl:for-each select="ancestor-or-self::*">
					<xsl:if test="position() != 1">
						<xsl:text>/</xsl:text>
						<xsl:value-of select="fn:name(.)"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="varTopElement">
				<xsl:copy-of select="$varUblXml/nsPep:Structure/nsPep:Document/nsPep:Element"/>
				<xsl:copy-of select="$varUblXml/nsPep:Structure/nsPep:Document/nsPep:Include"/>
			</xsl:variable>
			<xsl:variable name="varUblElement">
				<xsl:call-template name="findElement">
					<xsl:with-param name="paramAnscestorNodes" select="$varAnscestorNodes"/>
					<xsl:with-param name="paramAnscestorCount" select="count(ancestor-or-self::*)-1"/>
					<xsl:with-param name="paramCurrentIndex" select="1"/>
					<xsl:with-param name="paramElement" select="$varTopElement"/>
					<xsl:with-param name="paramReferenceBaseUrl" select="$varUblBaseUrl"/>
					<xsl:with-param name="paramReferenceRelativeFile" select="$varUblXmlReferenceFile"/>
					<xsl:with-param name="paramPrintReferenceUrlOnly" select="false()"/>
				</xsl:call-template>
			</xsl:variable>
			<!--xsl:message>
				UBL Element XPath: "<xsl:value-of select="$varAnscestorNodes"/>"
				UBL Element Name: "<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Name"/>"
				UBL Element Cardinality: "<xsl:value-of select="$varUblElement/nsPep:Element/@cardinality"/>"
			</xsl:message-->
			<!--xsl:if test="./processing-instruction('Cardinality')">
				<xsl:attribute name="cardinality"><xsl:value-of select="./processing-instruction('Cardinality')"/></xsl:attribute>
			</xsl:if-->
			<xsl:choose>
				<xsl:when test="./processing-instruction('Cardinality')">
					<xsl:attribute name="cardinality">
						<xsl:value-of select="./processing-instruction('Cardinality')"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="$varUblElement/nsPep:Element/@cardinality != ''">
					<xsl:attribute name="cardinality">
						<xsl:value-of  select="$varUblElement/nsPep:Element/@cardinality"/>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<Term>
				<xsl:value-of  select="fn:name(.)"/>
			</Term>
			<xsl:choose>
				<xsl:when test="./processing-instruction('Name')">
					<Name>
						<xsl:value-of select="./processing-instruction('Name')"/>
					</Name>
				</xsl:when>
				<xsl:when test="$varUblElement/nsPep:Element/nsPep:Name != ''">
					<Name>
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Name"/>
					</Name>
				</xsl:when>
			</xsl:choose>
			<!-- Fetch description from Peppol instead of url  with prefixes for Peppol and BEAst documentation -->
			<xsl:choose>
				<xsl:when test="./processing-instruction('Description')">
					<Description>
						<xsl:text>Logistics: </xsl:text>
						<xsl:value-of select="./processing-instruction('Description')"/>
					</Description>
				</xsl:when>
				<xsl:when test="./processing-instruction('DescriptionAddFirst')">
					<Description>
						<xsl:text>Logistics: </xsl:text>
						<xsl:value-of select="./processing-instruction('DescriptionAddFirst')"/>
						<xsl:text>&#xa;Peppol: </xsl:text>
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Description"/>
					</Description>
				</xsl:when>
				<xsl:when test="./processing-instruction('DescriptionAddLast')">
					<Description>
						<xsl:text>Peppol: </xsl:text>
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Description"/>
						<xsl:text>&#xa;Logistics: </xsl:text>
						<xsl:value-of select="./processing-instruction('DescriptionAddLast')"/>
					</Description>
				</xsl:when>
				<xsl:when test="$varUblElement/nsPep:Element/nsPep:Description != ''">
					<Description>
						<xsl:text>Peppol: </xsl:text>
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Description"/>
					</Description>
				</xsl:when>
			</xsl:choose>
			<!-- Below is creation of url code for description
        <Description>
        <xsl:if test="./processing-instruction('Description')">
          <xsl:value-of select="./processing-instruction('Description')"/>
        </xsl:if>
        <xsl:value-of select="'&lt;br/>&lt;a href=&quot;'"/>
        <xsl:value-of select="$varUblDocBaseUrl"/>
        <xsl:call-template name="buildDocUrl">
          <xsl:with-param name="paramBaseUri" select="$varUblDocBaseUrl"/>
          <xsl:with-param name="paramRelativeUri" select="$varAnscestorNodes"/>
        </xsl:call-template>
        <xsl:value-of select="'&quot;>Peppol Documentation&lt;/a>'"/>
        </Description>
        -->
			<xsl:choose>
				<xsl:when test="./processing-instruction('DataType')">
					<DataType>
						<xsl:value-of select="./processing-instruction('DataType')"/>
					</DataType>
				</xsl:when>
				<xsl:when test="$varUblElement/nsPep:Element/nsPep:DataType != ''">
					<DataType>
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:DataType"/>
					</DataType>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="./processing-instruction('BusinessTerm')">
					<xsl:for-each select="./processing-instruction('BusinessTerm')">
						<Reference type="BUSINESS_TERM">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$varUblElement/nsPep:Element/nsPep:Reference[@type='BUSINESS_TERM']">
						<Reference type="BUSINESS_TERM">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<!--xsl:choose>
				<xsl:when test="./processing-instruction('Rule')">
					<xsl:for-each select="./processing-instruction('Rule')">
						<Reference type="RULE">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$varUblElement/nsPep:Element/nsPep:Reference[@type='RULE']">
						<Reference type="RULE">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose-->
			<xsl:choose>
				<xsl:when test="./processing-instruction('CodeList')">
					<xsl:for-each select="./processing-instruction('CodeList')">
						<Reference type="CODE_LIST">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$varUblElement/nsPep:Element/nsPep:Reference[@type='CODE_LIST']">
						<Reference type="CODE_LIST">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<!--Reference type="URL">
				<xsl:call-template name="findElement">
					<xsl:with-param name="paramAnscestorNodes" select="$varAnscestorNodes"/>
					<xsl:with-param name="paramAnscestorCount" select="count(ancestor-or-self::*)-1"/>
					<xsl:with-param name="paramCurrentIndex" select="1"/>
					<xsl:with-param name="paramElement" select="$varTopElement"/>
					<xsl:with-param name="paramReferenceBaseUrl" select="$varUblBaseUrl"/>
					<xsl:with-param name="paramReferenceRelativeFile" select="$varUblXmlReferenceFile"/>
					<xsl:with-param name="paramPrintReferenceUrlOnly" select="true()"/>
				</xsl:call-template>
			</Reference>
			<Reference type="DOC_URL">
				<xsl:value-of select="$varUblDocBaseUrl"/>
				<xsl:call-template name="buildDocUrl">
					<xsl:with-param name="paramBaseUri" select="$varUblDocBaseUrl"/>
					<xsl:with-param name="paramRelativeUri" select="$varAnscestorNodes"/>
				</xsl:call-template>
			</Reference>
			<Property>
				<xsl:attribute name="name">
					<xsl:value-of select="'UBL_HEADER'"/>
				</xsl:attribute>
				<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Name"/>
			</Property-->
			<xsl:variable name="varElementTextNodeValue" select="./text()[normalize-space()][1]"/>
			<xsl:choose>
				<!--xsl:when test="count(*) = 0 and ./text() != ''">
				<xsl:for-each select="./text()">
					<xsl:if test="fn:normalize-space(./text()) != ''">
					<Value type="EXAMPLE">
						<xsl:value-of select="fn:normalize-space($varElementTextNodeValue)"/>
					</Value>
					</xsl:if>
				</xsl:for-each>
			</xsl:when-->
				<xsl:when test="$varElementTextNodeValue != ''">
					<Value type="EXAMPLE">
						<xsl:value-of select="fn:normalize-space($varElementTextNodeValue)"/>
					</Value>
				</xsl:when>
				<xsl:when test="$varUblElement/nsPep:Element/nsPep:Value[@type = 'EXAMPLE'] != ''">
					<Value type="EXAMPLE">
						<xsl:value-of select="$varUblElement/nsPep:Element/nsPep:Value[@type = 'EXAMPLE']"/>
					</Value>
				</xsl:when>
			</xsl:choose>
			<xsl:for-each select="@*">
				<xsl:variable name="varAttrName" select="fn:name(.)"/>
				<xsl:variable name="varUblElementAttribute" select="$varUblElement/nsPep:Element/nsPep:Attribute[nsPep:Term = $varAttrName]"/>
				<!--xsl:message>
				<xsl:value-of select="concat($varElementName, ': ', $varAttrName)"/>: <xsl:value-of select="."/>
			</xsl:message-->
				<Attribute>
					<xsl:variable name="varAttrInstrUsage" select="concat($varAttrName,'-','usage')"/>
					<xsl:variable name="varAttrInstrName" select="concat($varAttrName,'-','Name')"/>
					<xsl:variable name="varAttrInstrDescription" select="concat($varAttrName,'-','Description')"/>
					<xsl:variable name="varAttrInstrDescriptionAddFirst" select="concat($varAttrName,'-','DescriptionAddFirst')"/>
					<xsl:variable name="varAttrInstrDescriptionAddLast" select="concat($varAttrName,'-','DescriptionAddLast')"/>
					<xsl:variable name="varAttrInstrDataType" select="concat($varAttrName,'-','DataType')"/>
					<xsl:variable name="varAttrInstrBusinessTerm" select="concat($varAttrName,'-','BusinessTerm')"/>
					<xsl:variable name="varAttrInstrRule" select="concat($varAttrName,'-','Rule')"/>
					<xsl:variable name="varAttrInstrCodeList" select="concat($varAttrName,'-','CodeList')"/>
					<xsl:variable name="varAttrInstrExample" select="concat($varAttrName,'-','Example')"/>
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrUsage]">
							<xsl:attribute name="usage">
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrUsage]"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="$varUblElementAttribute/@usage != ''">
							<xsl:attribute name="usage">
								<xsl:value-of select="$varUblElementAttribute/@usage"/>
							</xsl:attribute>
						</xsl:when>
						<!--xsl:otherwise>
							<xsl:attribute name="usage">
								<xsl:value-of select="'Optional'"/>
							</xsl:attribute>
						</xsl:otherwise-->
					</xsl:choose>
					<Term>
						<xsl:value-of  select="fn:name(.)"/>
					</Term>
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrName]">
							<Name>
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrName]"/>
							</Name>
						</xsl:when>
						<xsl:when test="$varUblElementAttribute/nsPep:Name != ''">
							<Name>
								<xsl:value-of select="$varUblElementAttribute/nsPep:Name"/>
							</Name>
						</xsl:when>
					</xsl:choose>
					<!-- Fetch description from Peppol instead of url  with prefixes for Peppol and BEAst documentation -->
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrDescription]">
							<Description>
								<xsl:text>Logistics: </xsl:text>
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrDescription]"/>
							</Description>
						</xsl:when>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrDescriptionAddFirst]">
							<Description>
								<xsl:text>Logistics: </xsl:text>
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrDescriptionAddFirst]"/>
								<xsl:text>&#xa;Peppol: </xsl:text>
								<xsl:value-of select="$varUblElementAttribute/nsPep:Description"/>
							</Description>
						</xsl:when>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrDescriptionAddLast]">
							<Description>
								<xsl:text>Peppol: </xsl:text>
								<xsl:value-of select="$varUblElementAttribute/nsPep:Description"/>
								<xsl:text>&#xa;Logistics: </xsl:text>
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrDescriptionAddLast]"/>
							</Description>
						</xsl:when>
						<xsl:when test="$varUblElementAttribute/nsPep:Description != ''">
							<Description>
								<xsl:text>Peppol: </xsl:text>
								<xsl:value-of select="$varUblElementAttribute/nsPep:Description"/>
							</Description>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrDataType]">
							<DataType>
								<xsl:value-of select="../processing-instruction()[name() = $varAttrInstrDataType]"/>
							</DataType>
						</xsl:when>
						<xsl:when test="$varUblElementAttribute/nsPep:DataType != ''">
							<DataType>
								<xsl:value-of select="$varUblElementAttribute/nsPep:DataType"/>
							</DataType>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrBusinessTerm]">
							<xsl:for-each select="../processing-instruction()[name() = $varAttrInstrBusinessTerm]">
								<Reference type="BUSINESS_TERM">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$varUblElementAttribute/nsPep:Reference[@type='BUSINESS_TERM']">
								<Reference type="BUSINESS_TERM">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<!--xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrRule]">
							<xsl:for-each select="../processing-instruction()[name() = $varAttrInstrRule]">
								<Reference type="RULE">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$varUblElementAttribute/nsPep:Reference[@type='RULE']">
								<Reference type="RULE">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose-->
					<xsl:choose>
						<xsl:when test="../processing-instruction()[name() = $varAttrInstrCodeList]">
							<xsl:for-each select="../processing-instruction()[name() = $varAttrInstrCodeList]">
								<Reference type="CODE_LIST">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$varUblElementAttribute/nsPep:Reference[@type='CODE_LIST']">
								<Reference type="CODE_LIST">
									<xsl:value-of select="."/>
								</Reference>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<!--xsl:variable name="varAttrTextValue" select="./text()[normalize-space()][1]"/-->
					<xsl:choose>
						<xsl:when test=". != ''">
							<Value type="EXAMPLE">
								<xsl:value-of select="fn:normalize-space(.)"/>
							</Value>
						</xsl:when>
						<xsl:when test="$varUblElementAttribute/nsPep:Value[@type='EXAMPLE'] != ''">
							<Value type="EXAMPLE">
								<xsl:value-of select="$varUblElementAttribute/nsPep:Value[@type='EXAMPLE']"/>
							</Value>
						</xsl:when>
					</xsl:choose>
				</Attribute>
			</xsl:for-each>
			<xsl:apply-templates select="*" mode="therest"/>
		</Element>
	</xsl:template>

	<xsl:template match="//processing-instruction()" />
</xsl:stylesheet>