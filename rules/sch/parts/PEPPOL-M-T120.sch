<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T120-R011" test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1')" flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T120-R002"
		  test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:despatch_advice_only:1 urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1', '\s') satisfies $p = normalize-space(.)"
		  flag="fatal">ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1' or 'urn:fdc:peppol.eu:logistics:bis:despatch_advice_only:1'.</assert>
	</rule>
	<rule context="cac:BuyerCustomerParty">
		<assert id="PEPPOL-T120-R008" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Buyer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:DeliveryCustomerParty">
		<assert id="PEPPOL-T120-R108" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Delivery Customer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:SellerSupplierParty">
		<assert id="PEPPOL-T120-R009" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Seller Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:DespatchSupplierParty">
		<assert id="PEPPOL-T120-R109" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Despatch Supplier Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:OriginatorCustomerParty">
		<assert id="PEPPOL-T120-R010" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Originator Customer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:Shipment/cac:Consignment/cac:CarrierParty">
		<assert id="PEPPOL-T120-R110" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Carrier Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:DespatchLine/cac:Item/cac:ManufacturerParty">
		<assert id="PEPPOL-T120-R111" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)" flag="fatal">A Despatch Advice Manufacturer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:EstimatedDeliveryPeriod">
		<assert id="PEPPOL-T120-R012" test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" flag="fatal">Start date must be earlier or equal to end date</assert>
		<assert id="PEPPOL-T120-R013" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)" flag="fatal">EndTime cannot be specified without StartTime</assert>
		<assert id="PEPPOL-T120-R014" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" flag="fatal">EndTime cannot be specified without EndDate</assert>
		<assert id="PEPPOL-T120-R015" test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) " flag="fatal">StartTime must be before EndTime</assert>
	</rule>
	<rule context="cac:Shipment">
		<assert id="PEPPOL-T120-R016" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &gt;= 0" flag="warning">Total transport handling unit quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T120-R017" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &lt; 0 or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)" flag="warning">Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R018" test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) or (cbc:GrossWeightMeasure/@unitCode) &gt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or (cbc:GrossWeightMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or number(cbc:GrossWeightMeasure) = sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure)" flag="warning">Shipment  gross weight measure SHALL match the gross weight of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R019" test="not(cbc:GrossVolumeMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) or (cbc:GrossVolumeMeasure/@unitCode) &gt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or (cbc:GrossVolumeMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or number(cbc:GrossVolumeMeasure) &gt;= sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure)" flag="warning">Shipment gross volume measure SHALL greater or equal of the transport handling units specified</assert>
		<assert id="PEPPOL-T120-R021" test="not(cbc:DeclaredStatisticsValueAmount) or not(//cac:GoodsItem/cbc:DeclaredStatisticsValueAmount) or number(cbc:DeclaredStatisticsValueAmount) = sum(//cac:GoodsItem/cbc:DeclaredStatisticsValueAmount)" flag="warning">Declared for statistics value amount on shipment level SHALL be equal of the sum of the declared for statistic amount for the goods item specified</assert>
		<assert id="PEPPOL-T120-R022" test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))" flag="fatal">Either ID or special terms need to be specified in Delivery terms</assert>
	</rule>
	<rule context="cac:TransportHandlingUnit/cac:GoodsItem | cac:Package/cac:GoodsItem | cac:ContainedPackage/cac:GoodsItem">
		<let name="itemId" value="normalize-space(cbc:ID)"/>
		<assert id="PEPPOL-T120-R020" test="//cac:DespatchLine[normalize-space(cbc:ID) = $itemId]" flag="fatal">Each Goods Item ID should have a corresponding Despatch Advice Line ID</assert>
	</rule>
	<rule context="cac:DespatchLine">
		<assert id="PEPPOL-T120-R003" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)" flag="fatal">Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
		<assert id="PEPPOL-T120-R004" test="(cac:Item/cbc:Name)" flag="fatal">Each Despatch Advice SHALL contain the item name</assert>
		<assert id="PEPPOL-T120-R005" test="(cbc:DeliveredQuantity)" flag="warning">Each despatch advice line SHOULD have a delivered quantity</assert>
		<assert id="PEPPOL-T120-R006" test="number(cbc:DeliveredQuantity) &gt;= 0" flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T120-R007" test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)" flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
		<assert id="PEPPOL-T120-R040" test="((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/listID = 'ZZZ') and not cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/name) or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/listID != 'ZZZ') or not cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" flag="warning">A name must be provided if the listID is "ZZZ".</assert>
	</rule>
	
	<rule context="cac:AdditionalDocumentReference">
		<assert id="PEPPOL-T120-R031" test="(cbc:DocumentTypeCode) or (cbc:DocumentType)" flag="fatal">AdditionalDocumentReference SHALL contain a Document Type Code or a Document Type. </assert>
	</rule>
	<rule context="cac:DespatchLine/cac:DocumentReference">
		<assert id="PEPPOL-T120-R032" test="(cbc:DocumentTypeCode) or (cbc:DocumentType)" flag="fatal">DocumentReference (Despatch Line) SHALL contain a Document Type Code or a Document Type. </assert>
	</rule>

</pattern>