<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="urn:fdc:difi.no:2017:vefa:structure-1"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:f="urn:peppol:tools:create-ubl-example"
	exclude-result-prefixes="s xs f">

	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:variable name="structure" select="/s:Structure"/>
		<xsl:variable name="rootTerm" select="normalize-space($structure/s:Document/s:Term)"/>
		<xsl:variable name="rootPrefix" select="f:term-prefix($rootTerm)"/>
		<xsl:if test="not($structure)">
			<xsl:message terminate="yes">Expected Structure-1 XML as input.</xsl:message>
		</xsl:if>
		<xsl:if test="$rootPrefix != 'ubl'">
			<xsl:message terminate="yes">This transform only supports UBL syntax files (Document/Term must use prefix 'ubl').</xsl:message>
		</xsl:if>

		<xsl:apply-templates select="$structure/s:Document" mode="emit-root"/>
	</xsl:template>

	<xsl:template match="s:Document" mode="emit-root">
		<xsl:variable name="term" select="normalize-space(s:Term)"/>
		<xsl:variable name="prefix" select="f:term-prefix($term)"/>
		<xsl:variable name="local" select="f:term-local($term)"/>
		<xsl:variable name="uri" select="f:namespace-uri-from-prefix($prefix, ../s:Namespace)"/>

		<xsl:if test="$prefix = '' or $local = '' or $uri = ''">
			<xsl:message terminate="yes">Unable to resolve root element term or namespace.</xsl:message>
		</xsl:if>

		<xsl:element name="{$prefix}:{$local}" namespace="{$uri}">
			<xsl:for-each select="../s:Namespace">
				<xsl:namespace name="{normalize-space(@prefix)}" select="normalize-space(.)"/>
			</xsl:for-each>

			<xsl:apply-templates select="s:Attribute" mode="emit-attribute"/>
			<xsl:apply-templates select="s:Element" mode="emit-element"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="s:Element" mode="emit-element">
		<xsl:variable name="term" select="normalize-space(s:Term)"/>
		<xsl:variable name="prefix" select="f:term-prefix($term)"/>
		<xsl:variable name="local" select="f:term-local($term)"/>
		<xsl:variable name="uri" select="f:namespace-uri-from-prefix($prefix, /s:Structure/s:Namespace)"/>
		<xsl:variable name="occurs" select="normalize-space((@cardinality, '1..1')[1])"/>

		<xsl:if test="contains($term, '@')">
			<xsl:message terminate="yes">Attribute-filtered term syntax is not supported in this UBL transform.</xsl:message>
		</xsl:if>
		<xsl:if test="$prefix = '' or $local = '' or $uri = ''">
			<xsl:message terminate="yes">Unable to resolve element term or namespace: <xsl:value-of select="$term"/></xsl:message>
		</xsl:if>

		<xsl:if test="not(starts-with($occurs, '0..')) or s:Value[@type = 'FIXED' or @type = 'EXAMPLE'] or s:Element">
			<xsl:element name="{$prefix}:{$local}" namespace="{$uri}">
				<xsl:apply-templates select="s:Attribute" mode="emit-attribute"/>

				<xsl:choose>
					<xsl:when test="s:Element">
						<xsl:apply-templates select="s:Element" mode="emit-element"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="f:element-value(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="s:Attribute" mode="emit-attribute">
		<xsl:variable name="term" select="normalize-space(s:Term)"/>
		<xsl:choose>
			<xsl:when test="contains($term, ':')">
				<xsl:attribute name="{$term}" namespace="{f:namespace-uri-from-prefix(f:term-prefix($term), /s:Structure/s:Namespace)}" select="f:attribute-value(.)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="{$term}" select="f:attribute-value(.)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="f:term-prefix" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:sequence select="if (contains($term, ':')) then substring-before($term, ':') else ''"/>
	</xsl:function>

	<xsl:function name="f:term-local" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:sequence select="if (contains($term, ':')) then substring-after($term, ':') else $term"/>
	</xsl:function>

	<xsl:function name="f:namespace-uri-from-prefix" as="xs:string">
		<xsl:param name="prefix" as="xs:string"/>
		<xsl:param name="namespaceNodes" as="element(s:Namespace)*"/>
		<xsl:sequence select="normalize-space(($namespaceNodes[normalize-space(@prefix) = $prefix][1], '')[1])"/>
	</xsl:function>

	<xsl:function name="f:element-value" as="xs:string">
		<xsl:param name="element" as="element(s:Element)"/>
		<xsl:variable name="fixed" select="normalize-space(($element/s:Value[@type = 'FIXED'][1], '')[1])"/>
		<xsl:variable name="example" select="normalize-space(($element/s:Value[@type = 'EXAMPLE'][1], '')[1])"/>
		<xsl:variable name="dataType" select="normalize-space(($element/s:DataType[1], '')[1])"/>
		<xsl:sequence select="
			if ($fixed != '') then $fixed
			else if ($example != '') then $example
			else f:default-value-for-datatype($dataType)
		"/>
	</xsl:function>

	<xsl:function name="f:attribute-value" as="xs:string">
		<xsl:param name="attribute" as="element(s:Attribute)"/>
		<xsl:variable name="fixed" select="normalize-space(($attribute/s:Value[@type = 'FIXED'][1], '')[1])"/>
		<xsl:variable name="example" select="normalize-space(($attribute/s:Value[@type = 'EXAMPLE'][1], '')[1])"/>
		<xsl:sequence select="
			if ($fixed != '') then $fixed
			else if ($example != '') then $example
			else 'sample'
		"/>
	</xsl:function>

	<xsl:function name="f:default-value-for-datatype" as="xs:string">
		<xsl:param name="dataType" as="xs:string"/>
		<xsl:variable name="dt" select="lower-case($dataType)"/>
		<xsl:sequence select="
			if (contains($dt, 'date')) then '2026-03-06'
			else if (contains($dt, 'time')) then '10:00:00'
			else if (contains($dt, 'identifier')) then 'ID-001'
			else if (contains($dt, 'code')) then '311'
			else if (contains($dt, 'quantity')) then '1'
			else if (contains($dt, 'amount')) then '100.00'
			else if (contains($dt, 'indicator') or contains($dt, 'boolean')) then 'true'
			else 'Example'
		"/>
	</xsl:function>

</xsl:stylesheet>
