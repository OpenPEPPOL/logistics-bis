<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="urn:fdc:difi.no:2017:vefa:structure-1"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:f="urn:peppol:tools:create-ebxml-example"
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
		<xsl:if test="$rootPrefix = 'ubl'">
			<xsl:message terminate="yes">Use create-ubl-example-from-syntax.xsl for UBL syntax files.</xsl:message>
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
			<xsl:if test="exists(/s:Structure//s:Attribute[normalize-space(s:Term) = ('xlink', 'xlink:href')])">
				<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			</xsl:if>

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
		<xsl:variable name="predicateAttributeName" select="f:predicate-attribute-name($term)"/>
		<xsl:variable name="predicateAttributeValue" select="f:predicate-attribute-value($term)"/>

		<xsl:if test="$prefix = '' or $local = '' or $uri = ''">
			<xsl:message terminate="yes">Unable to resolve element term or namespace: <xsl:value-of select="$term"/></xsl:message>
		</xsl:if>

		<xsl:if test="not(starts-with($occurs, '0..')) or s:Value[@type = 'FIXED' or @type = 'EXAMPLE'] or s:Element">
			<xsl:element name="{$prefix}:{$local}" namespace="{$uri}">
				<xsl:apply-templates select="s:Attribute" mode="emit-attribute"/>
				<xsl:if test="$local = 'Element' and empty(s:Attribute[normalize-space(s:Term) = 'xsi:type']) and parent::s:Element[normalize-space(s:Term) = 'rim:SlotValue'][s:Attribute[normalize-space(s:Term) = 'xsi:type']/s:Value[normalize-space(.) = 'rim:CollectionValueType']]">
					<xsl:attribute name="xsi:type" namespace="http://www.w3.org/2001/XMLSchema-instance" select="'rim:StringValueType'"/>
				</xsl:if>
				<xsl:if test="$predicateAttributeName != '' and empty(s:Attribute[normalize-space(s:Term) = $predicateAttributeName])">
					<xsl:attribute name="{$predicateAttributeName}" select="$predicateAttributeValue"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="s:Element">
						<xsl:apply-templates select="s:Element" mode="emit-element"/>
					</xsl:when>
					<xsl:when test="s:Value or s:DataType or parent::s:Element[normalize-space(s:Term) = 'rim:SlotValue']">
						<xsl:value-of select="f:element-value(.)"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="s:Attribute" mode="emit-attribute">
		<xsl:variable name="term" select="normalize-space(s:Term)"/>
		<xsl:variable name="value" select="f:attribute-value(.)"/>
		<xsl:choose>
			<xsl:when test="$term = 'xlink'">
				<xsl:attribute name="xlink" select="$value"/>
				<xsl:attribute name="xlink:href" namespace="http://www.w3.org/1999/xlink" select="$value"/>
			</xsl:when>
			<xsl:when test="contains($term, ':')">
				<xsl:attribute name="{$term}" namespace="{f:namespace-uri-from-prefix(f:term-prefix($term), /s:Structure/s:Namespace)}" select="$value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="{$term}" select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="f:term-prefix" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:variable name="baseTerm" select="f:base-term($term)"/>
		<xsl:sequence select="if (contains($baseTerm, ':')) then substring-before($baseTerm, ':') else ''"/>
	</xsl:function>

	<xsl:function name="f:term-local" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:variable name="baseTerm" select="f:base-term($term)"/>
		<xsl:sequence select="if (contains($baseTerm, ':')) then substring-after($baseTerm, ':') else $baseTerm"/>
	</xsl:function>

	<xsl:function name="f:base-term" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:sequence select="normalize-space(if (contains($term, '[')) then substring-before($term, '[') else $term)"/>
	</xsl:function>

	<xsl:function name="f:predicate-attribute-name" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:sequence select="
			if (contains($term, '[@') and contains($term, '='))
			then substring-before(substring-after($term, '[@'), '=')
			else ''
		"/>
	</xsl:function>

	<xsl:function name="f:predicate-attribute-value" as="xs:string">
		<xsl:param name="term" as="xs:string"/>
		<xsl:variable name="raw" select="
			if (contains($term, '[@') and contains($term, '='))
			then substring-before(substring-after($term, '='), ']')
			else ''
		"/>
		<xsl:sequence select="replace(replace($raw, '^''', ''), '''$', '')"/>
	</xsl:function>

	<xsl:function name="f:namespace-uri-from-prefix" as="xs:string">
		<xsl:param name="prefix" as="xs:string"/>
		<xsl:param name="namespaceNodes" as="element(s:Namespace)*"/>
		<xsl:sequence select="
			if ($prefix = 'xlink')
			then 'http://www.w3.org/1999/xlink'
			else normalize-space(($namespaceNodes[normalize-space(@prefix) = $prefix][1], '')[1])
		"/>
	</xsl:function>

	<xsl:function name="f:element-value" as="xs:string">
		<xsl:param name="element" as="element(s:Element)"/>
		<xsl:variable name="fixed" select="normalize-space(($element/s:Value[@type = 'FIXED'][1], '')[1])"/>
		<xsl:variable name="example" select="normalize-space(($element/s:Value[@type = 'EXAMPLE'][1], '')[1])"/>
		<xsl:variable name="default" select="normalize-space(($element/s:Value[@type = 'DEFAULT'][1], '')[1])"/>
		<xsl:variable name="slotName" select="f:slot-name($element)"/>
		<xsl:variable name="dataType" select="normalize-space((
			$element/s:DataType[1],
			$element/parent::s:Element[normalize-space(s:Term) = 'rim:SlotValue']/s:Attribute[normalize-space(s:Term) = 'xsi:type']/s:Value[1],
			''
		)[1])"/>
		<xsl:sequence select="
			if ($fixed != '') then $fixed
			else if ($slotName = 'eFormsVersion') then 'eforms-sdk-1.2'
			else if ($slotName = 'UBLDocumentSchema') then 'CN'
			else if ($slotName = 'ProcedureLegalBasis') then '32014L0023'
			else if ($example != '') then f:normalize-example($example, $element)
			else if ($default != '') then $default
			else f:default-value-for-datatype($dataType)
		"/>
	</xsl:function>

	<xsl:function name="f:slot-name" as="xs:string">
		<xsl:param name="element" as="element(s:Element)"/>
		<xsl:sequence select="normalize-space((
			$element/ancestor::s:Element[starts-with(normalize-space(s:Term), 'rim:Slot')][1]/s:Attribute[normalize-space(s:Term) = 'name']/s:Value[@type = 'FIXED'][1],
			''
		)[1])"/>
	</xsl:function>

	<xsl:function name="f:attribute-value" as="xs:string">
		<xsl:param name="attribute" as="element(s:Attribute)"/>
		<xsl:variable name="term" select="normalize-space($attribute/s:Term)"/>
		<xsl:variable name="fixed" select="normalize-space(($attribute/s:Value[@type = 'FIXED'][1], '')[1])"/>
		<xsl:variable name="example" select="normalize-space(($attribute/s:Value[@type = 'EXAMPLE'][1], '')[1])"/>
		<xsl:variable name="default" select="normalize-space(($attribute/s:Value[@type = 'DEFAULT'][1], '')[1])"/>
		<xsl:variable name="linkedIdAttribute" select="($attribute/ancestor::s:Element[s:Attribute[normalize-space(s:Term) = 'id']][1]/s:Attribute[normalize-space(s:Term) = 'id'][1], $attribute)[1]"/>
		<xsl:sequence select="
			if ($fixed != '') then $fixed
			else if ($example != '') then $example
			else if ($default != '') then $default
			else if ($term = ('id', 'lid', 'requestId')) then f:uuid-for-node($attribute)
			else if ($term = ('xlink', 'xlink:href')) then concat('./', f:uuid-for-node($linkedIdAttribute), '.eform.xml')
			else 'sample'
		"/>
	</xsl:function>

	<xsl:function name="f:normalize-example" as="xs:string">
		<xsl:param name="value" as="xs:string"/>
		<xsl:param name="context" as="element()"/>
		<xsl:variable name="codeList" select="upper-case(normalize-space(($context/s:Reference[@type = 'CODE_LIST'][1], '')[1]))"/>
		<xsl:sequence select="
			if ($codeList = ('EAS', 'ICD') and contains($value, ':'))
			then substring-before($value, ':')
			else $value
		"/>
	</xsl:function>

	<xsl:function name="f:default-value-for-datatype" as="xs:string">
		<xsl:param name="dataType" as="xs:string"/>
		<xsl:variable name="dt" select="lower-case($dataType)"/>
		<xsl:sequence select="
			if (contains($dt, 'datetime')) then '2026-03-06T10:00:00Z'
			else if (contains($dt, 'date')) then '2026-03-06'
			else if (contains($dt, 'time')) then '10:00:00'
			else if (contains($dt, 'integer')) then '1'
			else if (contains($dt, 'identifier')) then 'ID-001'
			else if (contains($dt, 'code')) then 'CODE'
			else if (contains($dt, 'quantity')) then '1'
			else if (contains($dt, 'amount')) then '100.00'
			else if (contains($dt, 'indicator') or contains($dt, 'boolean')) then 'true'
			else 'Example'
		"/>
	</xsl:function>

	<xsl:function name="f:uuid-for-node" as="xs:string">
		<xsl:param name="node" as="node()?"/>
		<xsl:variable name="index" select="if ($node) then count($node/preceding::*) + 1 else 1"/>
		<xsl:sequence select="
			concat(
				format-integer($index mod 100000000, '00000000'),
				'-',
				format-integer($index mod 10000, '0000'),
				'-4000-8000-',
				format-integer($index mod 1000000000000, '000000000000')
			)
		"/>
	</xsl:function>

</xsl:stylesheet>