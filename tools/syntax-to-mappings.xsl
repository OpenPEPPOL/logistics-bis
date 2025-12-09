<xsl:stylesheet   version="3.0"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:str="urn:fdc:difi.no:2017:vefa:structure-1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">

	<xsl:output method="xml" indent="yes"/>


	<xsl:template match="/">
		<Workbook>
			<Styles>
				<Style ss:ID="Default" ss:Name="Normal">
					<Alignment ss:Vertical="Bottom"/>
					<Borders/>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
					<Interior/>
					<NumberFormat/>
					<Protection/>
				</Style>
				<Style ss:ID="s24" ss:Name="Heading 3">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"
                            ss:Color="#8EA9DB"/>
					</Borders>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#339966"
                        ss:Bold="1"/>
				</Style>
				<Style ss:ID="s63" ss:Parent="s24">
					<Borders>
						<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"
                            ss:Color="#8EA9DB"/>
					</Borders>
					<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#333333"
                        ss:Bold="1"/>
					<Interior/>
				</Style>
			</Styles>
			<Worksheet ss:Name="Sheet1">
				<Table>
					<Column ss:Width="30"/>
					<Column ss:Width="200"/>
					<Column ss:Width="200"/>
					<Column ss:Width="200"/>
					<Column ss:Width="200"/>
					<Column ss:Width="200"/>
					<Column ss:Width="30"/>
					<Row>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Card</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Term</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Name</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Description</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Example</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">XPath</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Node Level</Data>
						</Cell>
						<Cell  ss:StyleID="s63">
							<Data ss:Type="String">Sequence</Data>
						</Cell>
					</Row>
					<Row>
						<Cell>
							<Data ss:Type="String">
								<xsl:text>1..1</xsl:text>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">
								<xsl:value-of select="//str:Document/str:Term"/>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String"/>
						</Cell>
						<Cell>
							<Data ss:Type="String"/>
						</Cell>
						<Cell>
							<Data ss:Type="String"/>
						</Cell>
						<Cell>
							<Data ss:Type="String">
								<xsl:text>/</xsl:text>
								<xsl:value-of select="//str:Document/str:Term"/>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:value-of select="0"/>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="Number">
								<xsl:value-of select="0"/>
							</Data>
						</Cell>
					</Row>
					<xsl:for-each select="//str:Element | //str:Attribute">
						<Row>
							<Cell>
								<!-- Card -->
								<Data ss:Type="String">
									<xsl:choose>
										<xsl:when test="(name(.) = 'Element')">			
									<!-- Default card is 1..1 -->
										<xsl:value-of select="if (@cardinality) then @cardinality else '1..1'"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="if (@usage) then substring(@usage,1,1) else 'M'"/>
										</xsl:otherwise>
									</xsl:choose>
										
								</Data>
							</Cell>
							<Cell>
								<!-- Term -->
								<Data ss:Type="String">
									<xsl:for-each select="ancestor-or-self::*">
										<xsl:if test="position() &lt; last() - 1">
											<xsl:text>&#8226;&#160;&#160;</xsl:text>
										</xsl:if>
									</xsl:for-each>
									<!-- Add @ if an attribute -->
									<xsl:value-of select="if (name(.) = 'Attribute') then concat('@', str:Term) else str:Term"/>
								</Data>
							</Cell>
							<Cell>
								<Data ss:Type="String">
									<xsl:value-of select="str:Name"/>
								</Data>
							</Cell>
							<Cell>
								<Data ss:Type="String">
									<xsl:value-of select="normalize-space(str:Description)"/>
								</Data>
							</Cell>
							<Cell>
								<Data ss:Type="String">
									<xsl:value-of select="str:Value[@type = 'EXAMPLE']"/>
								</Data>
							</Cell>
							<Cell>
								<Data ss:Type="String">
									<xsl:for-each select="ancestor-or-self::*">
										<xsl:if test="position() != 1">
											<xsl:text>/</xsl:text>
											<xsl:value-of select="str:Term"/>
										</xsl:if>
									</xsl:for-each>
								</Data>
							</Cell>
							<Cell>
								<Data ss:Type="Number">
									<xsl:value-of select="count(ancestor-or-self::*) - 2"/>
								</Data>
							</Cell>
							<Cell>
								<!-- Sequence -->
								<Data ss:Type="Number">
									<xsl:value-of select="position()*100"/>
								</Data>
							</Cell>
						</Row>
					</xsl:for-each>
				</Table>
			</Worksheet>
		</Workbook>
	</xsl:template>
</xsl:stylesheet>