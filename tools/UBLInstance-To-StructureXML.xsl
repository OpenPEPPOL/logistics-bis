<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:synstr="urn:fdc:difi.no:2017:vefa:structure-1"
	xmlns="urn:fdc:difi.no:2017:vefa:structure-1"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl fn synstr xs">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="varOverrideSample"/>
	<xsl:variable name="varOverrideSampleXml" select="document($varOverrideSample)"/>
	<xsl:variable name="varTermNs" select="/synstr:Structure/synstr:Namespace"/>
	<xsl:variable name="varDocumentTerm" select="/synstr:Structure/synstr:Document/synstr:Term"/>
	<xsl:variable name="varDocumentTermNsPrefix" select="substring-before($varDocumentTerm, ':')"/>
	<xsl:variable name="varDocumentTermNs" select="translate($varTermNs[@prefix=$varDocumentTermNsPrefix],'&quot;','')"/>
	<xsl:variable name="varDocumentTermQname" select="replace( $varDocumentTerm, concat($varDocumentTermNsPrefix, ':'), concat('Q{', $varDocumentTermNs, '}') )"/>
	<xsl:template match="comment()|processing-instruction()|/">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="synstr:Namespace">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="translate(.,'&quot;','')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="synstr:Element">

		<xsl:param name="paramIncludedFile"/>
		<xsl:param name="paramXpathContext"/>

		<!--xsl:if test="contains($paramXpathContext, 'StandardItemIdentification')"-->
		<!--xsl:if test="contains($paramIncludedFile, 'additional-docs.xml')">
		  <xsl:message>
			<xsl:value-of select="$paramIncludedFile"/>: <xsl:value-of select="$paramXpathContext"/>
		  </xsl:message>
		</xsl:if-->
		<xsl:variable name="varDocXPath2">
			<xsl:choose>
				<xsl:when test="$paramIncludedFile != ''">
					<xsl:variable name="xpathTerm" select="synstr:Term"/>
					<xsl:variable name="xpathTermNsPrefix" select="substring-before(synstr:Term, ':')"/>
					<xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/>
					<xsl:value-of select="concat($paramXpathContext, '/', replace( $xpathTerm, concat($xpathTermNsPrefix, ':'), concat('Q{', $xpathTermNs, '}') ))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="ancestor-or-self::*">
						<xsl:choose>
							<xsl:when test="fn:name(.)='Structure'">
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>/</xsl:text>
								<xsl:variable name="xpathTerm" select="synstr:Term"/>
								<xsl:variable name="xpathTermNsPrefix" select="substring-before(synstr:Term, ':')"/>
								<!--Added translate function to solve bug with invoice raw XML from Peppol primary source file-->
								<xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/>
								<!--xsl:variable name="xpathTermNs" select="$varTermNs[@prefix=$xpathTermNsPrefix]"/-->
								<xsl:value-of select="replace( $xpathTerm, concat($xpathTermNsPrefix, ':'), concat('Q{', $xpathTermNs, '}') )"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--xsl:if test="contains($paramIncludedFile, 'additional-docs.xml')">
		  <xsl:message>
			varDocXPath2: <xsl:value-of select="$varDocXPath2"/>
		  </xsl:message>
		</xsl:if-->
		<xsl:variable name="varOverrideNode">
			<xsl:evaluate xpath="$varDocXPath2" context-item="$varOverrideSampleXml"/>
		</xsl:variable>
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="synstr:Term"/>
			<xsl:apply-templates select="synstr:Name"/>
			<xsl:variable name="varOverrideNode_Description" select="$varOverrideNode/child::*/processing-instruction('Description')"/>
			<xsl:variable name="varOverrideNode_DescriptionAddFirst" select="$varOverrideNode/child::*/processing-instruction('DescriptionAddFirst')"/>
			<xsl:variable name="varOverrideNode_DescriptionAddLast" select="$varOverrideNode/child::*/processing-instruction('DescriptionAddLast')"/>
			<xsl:variable name="varOverrideNode_DataType" select="$varOverrideNode/child::*/processing-instruction('DataType')"/>
			<xsl:variable name="varOverrideNode_BusinessTerm" select="$varOverrideNode/child::*/processing-instruction('BusinessTerm')"/>
			<xsl:variable name="varOverrideNode_Rule" select="$varOverrideNode/child::*/processing-instruction('Rule')"/>
			<xsl:variable name="varOverrideNode_CodeList" select="$varOverrideNode/child::*/processing-instruction('CodeList')"/>
			<xsl:variable name="varOverrideNode_ValueType" select="$varOverrideNode/child::*/processing-instruction('ValueType')"/>
			<xsl:variable name="varOverrideNode_Value" select="$varOverrideNode/child::*/child::text()[1]"/>
			<!--xsl:if test="$varDocXPath = '/ubl:Order/cac:AdditionalDocumentReference/cbc:ID' or $varDocXPath = '/ubl:Order/cac:AdditionalDocumentReference'">
			  <xsl:message>
			  XPath: <xsl:value-of select="$varDocXPath"/>
			  Value: <xsl:value-of select="$varOverrideNode_Value"/>
			  </xsl:message>
            </xsl:if-->
			<!--xsl:if test="(contains($varDocXPath2, 'AccountingCustomerParty') and contains($varDocXPath2, 'EndpointID')) or (contains($varDocXPath2, 'CardAccount'))">
  			  <xsl:message>
			  Param Included File: <xsl:value-of select="$paramIncludedFile"/>
			  Param Context XPath: <xsl:value-of select="$paramXpathContext"/>
			  XPath: <xsl:value-of select="$varDocXPath2"/>
			  Value: <xsl:value-of select="$varOverrideNode_Value"/>
	  		  </xsl:message>
            </xsl:if-->
			<xsl:choose>
				<xsl:when test="$varOverrideNode_Description!='' and not(empty($varOverrideNode_Description))">
					<Description>
						<xsl:value-of select="normalize-space($varOverrideNode_Description)"/>
					</Description>
				</xsl:when>
				<xsl:when test="$varOverrideNode_DescriptionAddFirst!='' and not(empty($varOverrideNode_DescriptionAddFirst))">
					<Description>BEAst: <xsl:value-of select="normalize-space($varOverrideNode_DescriptionAddFirst)"/>
						<xsl:if test="synstr:Description != ''">
							<xsl:value-of select="concat('&#xa;', ' Peppol: ', normalize-space(synstr:Description))"/>
						</xsl:if>
					</Description>
				</xsl:when>
				<xsl:when test="$varOverrideNode_DescriptionAddLast!='' and not(empty($varOverrideNode_DescriptionAddLast))">
					<Description>
						<xsl:if test="synstr:Description != ''">
							<xsl:value-of select="concat('Peppol: ', normalize-space(synstr:Description), '&#xa;', ' BEAst: ')"/>
						</xsl:if>
						<xsl:value-of select="normalize-space($varOverrideNode_DescriptionAddLast)"/>
					</Description>
				</xsl:when>
				<xsl:otherwise>
					<Description>
						<xsl:apply-templates select="normalize-space(synstr:Description)"/>
					</Description>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$varOverrideNode_DataType!='' and not(empty($varOverrideNode_DataType))">
					<DataType>
						<xsl:value-of select="$varOverrideNode_DataType"/>
					</DataType>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="synstr:DataType"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Process Business Term -->
			<xsl:choose>
				<xsl:when test="$varOverrideNode_BusinessTerm!='' and not(empty($varOverrideNode_BusinessTerm))">
					<xsl:for-each select="$varOverrideNode_BusinessTerm">
						<Reference type="BUSINESS_TERM">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="synstr:Reference[@type='BUSINESS_TERM']"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Process Rule -->
			<xsl:choose>
				<xsl:when test="$varOverrideNode_Rule!='' and not(empty($varOverrideNode_Rule))">
					<xsl:for-each select="$varOverrideNode_Rule">
						<Reference type="RULE">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="synstr:Reference[@type='RULE']"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Process Code List -->
			<xsl:choose>
				<xsl:when test="$varOverrideNode_CodeList!='' and not(empty($varOverrideNode_CodeList))">
					<xsl:for-each select="$varOverrideNode_CodeList">
						<Reference type="CODE_LIST">
							<xsl:value-of select="."/>
						</Reference>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="synstr:Reference[@type='CODE_LIST']"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Process Attribute -->
			<xsl:apply-templates select="synstr:Attribute">
				<xsl:with-param name="paramOverrideNode" select="$varOverrideNode"/>
			</xsl:apply-templates>
			<!-- Process Value -->
			<xsl:choose>
				<xsl:when test="empty(synstr:Value) and normalize-space($varOverrideNode_Value)!=''">
					<Value>
						<xsl:choose>
							<xsl:when test="$varOverrideNode_ValueType!=''">
								<xsl:attribute name="type">
									<xsl:value-of select="normalize-space($varOverrideNode_ValueType)"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="synstr:Value/@type!=''">
								<xsl:attribute name="type">
									<xsl:value-of select="synstr:Value/@type"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="type">
									<xsl:value-of select="'EXAMPLE'"/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="normalize-space($varOverrideNode_Value)"/>
					</Value>
				</xsl:when>
				<xsl:otherwise>

					<xsl:apply-templates select="synstr:Value">
						<xsl:with-param name="paramOverrideNode" select="$varOverrideNode"/>
					</xsl:apply-templates>

				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="child::synstr:Include|child::synstr:Element">
				<xsl:with-param name="paramIncludedFile" select="$paramIncludedFile"/>
				<xsl:with-param name="paramXpathContext" select="$varDocXPath2"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<!-- Process Include files for Invoice  -->
	<xsl:template match="synstr:Include">

		<xsl:param name="paramIncludedFile"/>
		<xsl:param name="paramXpathContext"/>
		<!--xsl:variable name="varIncludedFile" select="."/-->
		<xsl:variable name="varIncludedFile">
			<xsl:choose>
				<xsl:when test="$paramIncludedFile != ''">
					<xsl:value-of select="$paramIncludedFile"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="varDocXPathContext">
			<!--xsl:if test="$paramXpathContext != ''">

			<xsl:variable name="xpathTerm" select="synstr:Term"/>
			<xsl:variable name="xpathTermNsPrefix" select="substring-before(synstr:Term, ':')"/>
			<xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/>
			<xsl:value-of select="concat($paramXpathContext, '/', replace( $xpathTerm, concat($xpathTermNsPrefix, ':'), concat('Q{', $xpathTermNs, '}') ))"/>
		  </xsl:if-->
			<xsl:for-each select="ancestor::*">

				<xsl:choose>
					<xsl:when test="fn:name(.)='Structure'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>/</xsl:text>
						<xsl:variable name="xpathTerm" select="synstr:Term"/>
						<xsl:variable name="xpathTermNsPrefix" select="substring-before(synstr:Term, ':')"/>
						<!--Added translate function to solve bug with invoice raw XML from Peppol primary source file-->
						<xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/>
						<!--xsl:variable name="xpathTermNs" select="$varTermNs[@prefix=$xpathTermNsPrefix]"/-->
						<xsl:value-of select="replace( $xpathTerm, concat($xpathTermNsPrefix, ':'), concat('Q{', $xpathTermNs, '}') )"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:variable>
		<!--xsl:if test="contains($varIncludedFile, 'additional-docs.xml')">
		  <xsl:message>
			Inside Include: <xsl:value-of select="$paramIncludedFile"/>: <xsl:value-of select="$paramXpathContext"/>: <xsl:value-of select="$varDocXPathContext"/>
		  </xsl:message>
		</xsl:if-->

		<xsl:variable name="varIncludeXml" select="document(.)"/>
		<xsl:apply-templates select="$varIncludeXml/synstr:Element">
			<xsl:with-param name="paramIncludedFile" select="$varIncludedFile"/>
			<xsl:with-param name="paramXpathContext" select="$varDocXPathContext"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Template for Attribute -->
	<xsl:template match="synstr:Attribute">
		<xsl:param name="paramOverrideNode"/>
		<Attribute>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="child::*">
				<xsl:choose>
					<!-- Process Description  -->
					<xsl:when test="fn:name(.)='Description'">
						<xsl:apply-templates select=".">
							<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
						</xsl:apply-templates>
					</xsl:when>
					<!-- Process Value  -->
					<xsl:when test="fn:name(.)='Value'">
						<xsl:apply-templates select=".">
							<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
						</xsl:apply-templates>
					</xsl:when>
					<!-- Process other elements -->
					<xsl:otherwise>
						<xsl:apply-templates select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!-- Additional logic for empty Description -->
			<xsl:if test="empty(synstr:Description)">
				<xsl:variable name="varParentName" select="local-name(parent::*)"/>
				<xsl:variable name="varParentTermName" select="../../synstr:Term"/>
				<xsl:variable name="varTermName" select="../synstr:Term"/>
				<xsl:variable name="varAttrTermName" select="synstr:Term"/>
				<xsl:call-template name="mapDescription">
					<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
					<xsl:with-param name="varParentName" select="'Attribute'"/>
					<xsl:with-param name="varParentTermName" select="$varTermName"/>
					<xsl:with-param name="varTermName" select="$varAttrTermName"/>
				</xsl:call-template>
			</xsl:if>

			<!-- Additional logic for empty Value -->
			<xsl:if test="empty(synstr:Value)">
				<xsl:variable name="varParentName" select="local-name(parent::*)"/>
				<xsl:variable name="varParentTermName" select="../../synstr:Term"/>
				<xsl:variable name="varTermName" select="../synstr:Term"/>
				<xsl:variable name="varAttrTermName" select="synstr:Term"/>
				<xsl:call-template name="mapValue">
					<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
					<xsl:with-param name="varParentName" select="'Attribute'"/>
					<xsl:with-param name="varParentTermName" select="$varTermName"/>
					<xsl:with-param name="varTermName" select="$varAttrTermName"/>
				</xsl:call-template>
			</xsl:if>
		</Attribute>
	</xsl:template>
	<!-- Template for Description -->
	<xsl:template match="synstr:Description">
		<xsl:param name="paramOverrideNode"/>
		<xsl:variable name="varParentName" select="local-name(parent::*)"/>
		<xsl:variable name="varParentTermName" select="../../synstr:Term"/>
		<xsl:variable name="varTermName" select="../synstr:Term"/>
		<!--xsl:if test="../../synstr:Name = 'Item classification code'">
		<xsl:message>
		  paramOverrideNode: <xsl:copy-of select="$paramOverrideNode"/>
		  Parent: <xsl:value-of select="$varParentName"/>
		  Term: <xsl:value-of select="$varTermName"/>
		  Parent Term: <xsl:value-of select="$varParentTermName"/>
		</xsl:message>
      </xsl:if-->
		<xsl:call-template name="mapDescription">
			<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
			<xsl:with-param name="varParentName" select="$varParentName"/>
			<xsl:with-param name="varParentTermName" select="$varParentTermName"/>
			<xsl:with-param name="varTermName" select="$varTermName"/>
			<xsl:with-param name="varDescription" select="text()"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template for Value -->
	<xsl:template match="synstr:Value">
		<xsl:param name="paramOverrideNode"/>
		<xsl:variable name="varParentName" select="local-name(parent::*)"/>
		<xsl:variable name="varParentTermName" select="../../synstr:Term"/>
		<xsl:variable name="varTermName" select="../synstr:Term"/>
		<!--xsl:if test="../../synstr:Name = 'STANDARD ITEM IDENTIFICATION'">
		<xsl:message>
		  paramOverrideNode: <xsl:copy-of select="$paramOverrideNode"/>
		  Parent: <xsl:value-of select="$varParentName"/>
		  Term: <xsl:value-of select="$varTermName"/>
		  Parent Term: <xsl:value-of select="$varParentTermName"/>
		</xsl:message>
      </xsl:if-->
		<xsl:call-template name="mapValue">
			<xsl:with-param name="paramOverrideNode" select="$paramOverrideNode"/>
			<xsl:with-param name="varParentName" select="$varParentName"/>
			<xsl:with-param name="varParentTermName" select="$varParentTermName"/>
			<xsl:with-param name="varTermName" select="$varTermName"/>
		</xsl:call-template>
	</xsl:template>
	<!-- Template for all other elements -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="mapDescription">
		<xsl:param name="paramOverrideNode"/>
		<xsl:param name="varParentName"/>
		<xsl:param name="varParentTermName"/>
		<xsl:param name="varTermName"/>
		<xsl:param name="varDescription"/>
		<xsl:if test="$varParentName = 'Attribute'">
			<xsl:variable name="varOverrideNode_Description" select="$paramOverrideNode/child::*/processing-instruction()[name() = concat($varTermName, '-Description')]"/>
			<xsl:variable name="varOverrideNode_DescriptionAddFirst" select="$paramOverrideNode/child::*/processing-instruction()[name() = concat($varTermName, '-DescriptionAddFirst')]"/>
			<xsl:variable name="varOverrideNode_DescriptionAddLast" select="$paramOverrideNode/child::*/processing-instruction()[name() = concat($varTermName, '-DescriptionAddLast')]"/>
			<!--xsl:if test="../../synstr:Name = 'Item classification code'">
	   	  <xsl:message>
		    Parent: <xsl:value-of select="$varParentName"/>
		    Term: <xsl:value-of select="$varTermName"/>
		    Parent Term: <xsl:value-of select="$varParentTermName"/>
		    Peppol Descripion: <xsl:value-of select="$varOverrideNode_Description"/>
		    Peppol Descripion First: <xsl:value-of select="$varOverrideNode_DescriptionAddFirst"/>
		    Peppol Descripion Last: <xsl:value-of select="$varOverrideNode_DescriptionAddLast"/>
		  </xsl:message>
        </xsl:if-->
			<xsl:choose>
				<xsl:when test="$varOverrideNode_Description!='' and not(empty($varOverrideNode_Description))">
					<Description>
						<xsl:value-of select="normalize-space($varOverrideNode_Description)"/>
					</Description>
				</xsl:when>
				<xsl:when test="$varOverrideNode_DescriptionAddFirst!='' and not(empty($varOverrideNode_DescriptionAddFirst))">
					<Description>BEAst: <xsl:value-of select="normalize-space($varOverrideNode_DescriptionAddFirst)"/>
						<xsl:if test="$varDescription != ''">
							<xsl:value-of select="concat('&#xa;', ' Peppol: ', normalize-space($varDescription))"/>
						</xsl:if>
					</Description>
				</xsl:when>
				<xsl:when test="$varOverrideNode_DescriptionAddLast!='' and not(empty($varOverrideNode_DescriptionAddLast))">
					<Description>
						<xsl:if test="$varDescription != ''">
							<xsl:value-of select="concat('Peppol: ', normalize-space($varDescription), '&#xa;', ' BEAst: ')"/>
						</xsl:if>
						<xsl:value-of select="normalize-space($varOverrideNode_DescriptionAddLast)"/>
					</Description>
				</xsl:when>
				<xsl:when test="$varDescription!='' and not(empty($varDescription))">
					<Description>
						<xsl:apply-templates select="normalize-space($varDescription)"/>
					</Description>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mapValue">
		<xsl:param name="paramOverrideNode"/>
		<xsl:param name="varParentName"/>
		<xsl:param name="varParentTermName"/>
		<xsl:param name="varTermName"/>
		<!--xsl:variable name="varParentName" select="local-name(parent::*)"/>
	  <xsl:variable name="varParentTermName" select="../../synstr:Term"/>
	  <xsl:variable name="varTermName" select="../synstr:Term"/-->
		<!--xsl:if test="../../synstr:Name = 'STANDARD ITEM IDENTIFICATION'">
		<xsl:message>
		  paramOverrideNode: <xsl:copy-of select="$paramOverrideNode"/>
		  Parent: <xsl:value-of select="$varParentName"/>
		  Term: <xsl:value-of select="$varTermName"/>
		  Parent Term: <xsl:value-of select="$varParentTermName"/>
		</xsl:message>
      </xsl:if-->
		<xsl:choose>
			<xsl:when test="$paramOverrideNode">
				<xsl:variable name="varOverrideNode_ValueType" select="$paramOverrideNode/child::*/processing-instruction('ValueType')"/>
				<xsl:variable name="varOverrideNode_Value">
					<xsl:choose>
						<xsl:when test="$varParentName = 'Attribute'">
							<xsl:variable name="varAttributeNameXPath">
								<xsl:variable name="xpathTerm" select="concat('/', $varParentTermName, '/@', $varTermName)"/>
								<xsl:variable name="xpathTermNsPrefix" select="substring-before($varParentTermName, ':')"/>
								<!--Added translate function to solve bug with invoice raw XML from Peppol primary source file-->
								<xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/>
								<!--xsl:variable name="xpathTermNs" select="translate($varTermNs[@prefix=$xpathTermNsPrefix],'&quot;','')"/-->
								<xsl:value-of select="replace( $xpathTerm, concat($xpathTermNsPrefix, ':'), concat('Q{', $xpathTermNs, '}') )"/>
							</xsl:variable>
							<xsl:if test="$varAttributeNameXPath != ''">
								<xsl:variable name="varAttributeValue" as="xs:string?">
									<xsl:evaluate xpath="$varAttributeNameXPath" context-item="$paramOverrideNode"/>
								</xsl:variable>
								<!--xsl:if test="../../synstr:Name = 'STANDARD ITEM IDENTIFICATION'">
					  <xsl:message>
 					    varAttributeNameXPath: <xsl:value-of select="$varAttributeNameXPath"/>
					    varAttributeValue: <xsl:value-of select="$varAttributeValue"/>
					  </xsl:message>
					</xsl:if-->
								<xsl:value-of select="$varAttributeValue"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$paramOverrideNode/child::*/child::text()[1]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<Value>
					<xsl:choose>
						<xsl:when test="$varOverrideNode_ValueType!=''">
							<xsl:attribute name="type">
								<xsl:value-of select="normalize-space($varOverrideNode_ValueType)"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="@type!=''">
							<xsl:attribute name="type">
								<xsl:value-of select="@type"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type">
								<xsl:value-of select="'EXAMPLE'"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="normalize-space($varOverrideNode_Value)!=''">
							<xsl:value-of select="normalize-space($varOverrideNode_Value)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</Value>
			</xsl:when>
			<xsl:when test="normalize-space($paramOverrideNode) != ''">
				<xsl:value-of select="normalize-space($paramOverrideNode)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>