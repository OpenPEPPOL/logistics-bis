<?xml version="1.0" encoding="UTF-8"?>    
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T120-R011" test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1')" flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1'.</assert>
	</rule>
	<rule context="cac:BuyerCustomerParty">
		<assert id="PEPPOL-T120-R008" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:SellerSupplierParty">
		<assert id="PEPPOL-T120-R009" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A despatch advice seller party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:OriginatorCustomerParty">
		<assert id="PEPPOL-T120-R010" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A despatch advice originator customer party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:EstimatedDeliveryPeriod">
		<assert id="PEPPOL-T120-R012" test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" flag="fatal">Start date must be earlier or equal to end date</assert>
		<assert id="PEPPOL-T120-R013" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)" flag="fatal">EndTime cannot be specified without StartTime</assert>
		<assert id="PEPPOL-T120-R014" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" flag="fatal">EndTime cannot be specified without EndDate</assert>
		<assert id="PEPPOL-T120-R015" test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) " flag="fatal">StartTime must be before EndTime</assert>
	</rule>
	<rule context="cac:Shipment">
		<assert id="PEPPOL-T120-R016" test="not(cbc:TotalTransportHandlingUnitQuantity) or (cbc:TotalTransportHandlingUnitQuantity) &gt;= 0" flag="warning">Total transport handling unit quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T120-R017" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &lt; 0 or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)" flag="warning">Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R018" test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) or number(cbc:GrossWeightMeasure) = sum(cac:TransportHandlingUnit/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure)" flag="warning">Shipment  gross weight measure SHALL match the gross weight of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R019" test="not(cbc:GrossVolumenMeasure) or number(cbc:GrossVolumenMeasure) &gt;= sum(cac:TransportHandlingUnit/cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure)" flag="warning">Shipment gross volume measure SHALL greater or equal of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R021" test="not(cbc:DeclaredStatisticsValueAmount) or not(//cac:GoodsItem/cbc:DeclaredStatisticsValueAmount) or number(cbc:DeclaredStatisticsValueAmount) = sum(//cac:GoodsItem/cbc:DeclaredStatisticsValueAmount)" flag="warning">Shipment gross volume measure SHALL greater or equal of the transport handling units specified</assert>
	</rule>
	
	<rule context="cac:GoodsItem">
		<let name="itemId" value="cbc:ID"/>
		<assert id="PEPPOL-T120-R020" test="//cac:DespatchLine[cbc:ID = $itemId] != ''" flag="fatal">Each Goods Item ID should have a corresponding Despatch Advice Line ID</assert>
	</rule>
	
	<rule context="cac:DespatchLine">
		<assert id="PEPPOL-T120-R003" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)" flag="fatal">Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
		<assert id="PEPPOL-T120-R004" test="(cac:Item/cbc:Name)" flag="fatal">Each Despatch Advice SHALL contain the item name</assert>
		<assert id="PEPPOL-T120-R005" test="(cbc:DeliveredQuantity)" flag="warning">Each despatch advice line SHOULD have a delivered quantity</assert>
		<assert id="PEPPOL-T120-R006" test="number(cbc:DeliveredQuantity) &gt;= 0" flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T120-R007" test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)" flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
	</rule>
</pattern>
