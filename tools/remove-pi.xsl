<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
	<xsl:strip-space elements="*"/>
	
	<!-- Remove processing instructions -->
	<xsl:template match="//processing-instruction()"/>
	
	<!-- Format XML to have end tags on the same line -->
	<xsl:template match="*">
		<xsl:param name="indent" select="''" />
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="count(child::*) = 0">
					<xsl:value-of select="normalize-space(text())" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text disable-output-escaping="yes">&#xA;</xsl:text>
					<xsl:apply-templates select="child::*">
						<xsl:with-param name="indent" select="concat($indent, '  ')" />
					</xsl:apply-templates>
					<xsl:value-of select="concat($indent, '&#xA;')" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
