<?xml version="1.0" encoding="UTF-8"?>    
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
			<assert id="PEPPOL-T120-R011" 
					test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1')"
					flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:advanced_despatch_advice:1'.</assert>
	</rule>
		
	<rule context="cac:BuyerCustomerParty">
		<assert id="PEPPOL-T120-R008"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice buyer party SHALL contain the name or an identifier</assert>
	</rule>
	
	<rule context="cac:SellerSupplierParty">
		<assert id="PEPPOL-T120-R009"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice seller party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:OriginatorCustomerParty">
		<assert id="PEPPOL-T120-R010"
			test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
			flag="fatal">A despatch advice originator customer party SHALL contain the name or an identifier</assert>
	</rule>

	<rule context="cac:EstimatedDeliveryPeriod">
		<assert id="PEPPOL-T120-R012"
			test="(cbc:StartDate) &gt; (cbc:EndDate)"
			flag="fatal">Start date must be earlier or equal to end date</assert>
	</rule>
	
	<rule context="cac:DespatchLine">
		<assert id="PEPPOL-T120-R003"
				test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID)"
				flag="fatal" >Each item in a Despatch Advice line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
		<assert id="PEPPOL-T120-R004"
				test="(cac:Item/cbc:Name)"
				flag="fatal" >Each Despatch Advice SHALL contain the item name</assert>
		<assert id="PEPPOL-T120-R005"
				test="(cbc:DeliveredQuantity)"
				flag="warning" >Each despatch advice line SHOULD have a delivered quantity</assert>
		<assert id="PEPPOL-T120-R006"
				test="number(cbc:DeliveredQuantity) &gt;= 0"
				flag="fatal">Each despatch advice line delivered quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T120-R007"
				test="((cbc:OutstandingQuantity) and (cbc:OutstandingReason)) or not(cbc:OutstandingQuantity)"
				flag="warning">An outstanding quantity reason SHOULD be provided if the despatch line contains an outstanding quantity</assert>
	</rule>


</pattern>
