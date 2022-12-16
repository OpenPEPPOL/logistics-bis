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
			<assert id="PEPPOL-T120-R013" test="not(cbc:StartTime) or (cbc:StartTime) and (cbc:StartDate)" flag="fatal">Starttime cannot be specified without StartDate</assert>
			<assert id="PEPPOL-T120-R014" test="not(cbc:StartTime) or (cbc:StartTime) and (cbc:EndTime)" flag="fatal">Starttime cannot be specified without EndTime</assert>
			<assert id="PEPPOL-T120-R015" test="not(cbc:StartTime) or not(cbc:EndTime) or translate(cbc:StartDate,'-','') &gt; translate(cbc:EndDate,'-','') or translate(cbc:StartTime,':','') &lt; translate(cbc:EndTime,':','')" flag="fatal">StartTime must be before EndTime</assert>
		</rule>
		<rule context="cac:Shipment">
			<assert id="Peppol-T120-R016" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &gt;= 0" flag="fatal">Total transport handling unit quantity SHALL not be negative</assert>
			<assert id="Peppol-T120-R017" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)" flag="warning">Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</assert>
			<assert id="Peppol-T120-R018" test="not(cbc:GrossWeightMeasure) or number(cbc:GrossWeightMeasure) = sum(cac:TransportHandlingUnit/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure)" flag="warning">Shipment  gross weight measure SHALL match the gross weight of the transport handling units specified</assert>
			<assert id="Peppol-T120-R019" test="not(cbc:GrossVolumenMeasure) or number(cbc:GrossVolumenMeasure) &gt;= sum(cac:TransportHandlingUnit/cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure)" flag="warning">Shipment gross volume measure SHALL greater or equal of the transport handling units specified</assert>
		</rule>
		
		<rule context="cac:TransportHandlingUnit">
			<assert id="Peppol-T120-R020" test="not(cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) 
												or not(cac:Package/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure|cac:GoodsItem/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) 
												or (cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) = sum(cac:Package/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) + sum(cac:GoodsItem/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure)" 
			flag="warning">Total transport handling unit Grossweight measure SHALL match the grossweight of packages specified</assert>
			
			<assert id="Peppol-T120-R021" test="not(cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure) 
												or not (cac:Package/cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure) 
												or (cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure) &gt;= sum(cac:Package/cac:MeasurementDimension[cbc:AttributeID = 'AAW']/cbc:Measure)" flag="warning">Total transport handling unit Gross volumen measure SHALL be less or equal to the gross Volumen of packages specified</assert>
		</rule>
		
		<rule context="cac:Package">
			<assert id="Peppol-T120-R022" test="not(cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) or (cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) = sum(cac:ContainingPackage/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure) + sum(cac:GoodsItem/cac:MeasurementDimension[cbc:AttributeID = 'AAB']/cbc:Measure)" flag="warning">Grossweight of Package measure SHALL match the grossweight of containing packages and goods items specified if the weight of these is defined</assert>
		</rule>
		
		<rule context="cac:DespatchLine">
			<assert id="PEPPOL-T120-R003" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)" flag="fatal">Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
			<assert id="PEPPOL-T120-R004" test="(cac:Item/cbc:Name)" flag="fatal">Each Despatch Advice SHALL contain the item name</assert>
			<assert id="PEPPOL-T120-R005" test="(cbc:DeliveredQuantity)" flag="warning">Each despatch advice line SHOULD have a delivered quantity</assert>
			<assert id="PEPPOL-T120-R006" test="number(cbc:DeliveredQuantity) &gt;= 0" flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
			<assert id="PEPPOL-T120-R007" test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)" flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
		</rule>
	</pattern>
