<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T128-R001"
			test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1')"
			flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T128-R002"
			test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1')"
			flag="fatal">ProfileID SHALL have the value urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1.</assert>
	</rule>
	
	<rule context="cac:ReceiptLine">
		<assert id="PEPPOL-T128-R003" test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID) or not(cac:Item)" flag="fatal">Each item in a Receipt Advice line SHALL be identifiable by either "item seller's identifier" or "item standard identifier"</assert>
		<assert id="PEPPOL-T128-R004" test="((cbc:RejectedQuantity) and (cbc:RejectActionCode)) or not(cbc:RejectedQuantity)" flag="fatal">A Reject Action Code SHALL be provided if the receipt line contains a rejected quantity</assert>
		<assert id="PEPPOL-T128-R005" test="((cbc:RejectedQuantity) and (cbc:RejectReasonCode)) or not(cbc:RejectedQuantity)" flag="fatal">A Reject Reason Code SHALL be provided if the receipt line contains a rejected quantity</assert>
		<assert id="PEPPOL-T128-R006" test="((cbc:RejectedQuantity) and (cbc:RejectReason)) or not(cbc:RejectedQuantity)" flag="fatal">A Reject Reason SHALL be provided if the receipt line contains a rejected quantity</assert>
		<assert id="PEPPOL-T128-R007" test="((cbc:ShortQuantity) and (cbc:ShortageActionCode)) or not(cbc:ShortQuantity)" flag="fatal">A Shortage Action Code SHALL be provided if the receipt line contains a shortage quantity</assert>
	</rule>
	
	<rule context="cac:BuyerCustomerParty">
		<assert id="PEPPOL-T128-R008" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Receipt Advice Buyer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:DeliveryCustomerParty">
		<assert id="PEPPOL-T128-R108" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Receipt Advice Delivery Customer Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:DespatchSupplierParty">
		<assert id="PEPPOL-T128-R109" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Receipt Advice Despatch Supplier Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:SellerSupplierParty">
		<assert id="PEPPOL-T128-R009" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal">A Receipt Advice Seller Party SHALL contain the name or an identifier</assert>
	</rule>
	<rule context="cac:Shipment/cac:Consignment/cac:CarrierParty">
		<assert id="PEPPOL-T128-R110" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)" flag="fatal">A Receipt Advice Carrier Party SHALL contain the name or an identifier</assert>
	</rule>

	<rule context="cac:Shipment/cac:Delivery/cac:RequestedDeliveryPeriod">
		<assert id="PEPPOL-T128-R012" test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" flag="fatal">Start date must be earlier or equal to end date</assert>
		<assert id="PEPPOL-T128-R013" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)" flag="fatal">EndTime cannot be specified without StartTime</assert>
		<assert id="PEPPOL-T128-R014" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" flag="fatal">EndTime cannot be specified without EndDate</assert>
		<assert id="PEPPOL-T128-R015" test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) " flag="fatal">StartTime must be before EndTime</assert>
	</rule>
	<rule context="cac:Shipment">
		<assert id="PEPPOL-T128-R022" test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))" flag="fatal">Either ID or special terms need to be specified in Delivery terms</assert>
	</rule>
	<rule context="cbc:ReceiptAdviceTypeCode">
		<assert id="PEPPOL-T128-R023" test="((normalize-space(.) = 'D') and not(//cac:Shipment/cbc:ID) and (//cac:DespatchDocumentReference/cbc:DocumentStatusCode)) or ((normalize-space(.) = 'S') and (//cac:Shipment/cbc:ID) )" flag="fatal">When ReceiptAdvice is a response to Advanced Despatch Advice (D), it MUST contain a Status on the Referred Despatch Advice but it MUST NOT contain any Shipment group. When it is a response to a recived shipment/service (S), it SHALL include the Shipment group but MUST NOT contain any Status on the Referred Despatch Advice. </assert>
	</rule>
	<rule context="cac:Shipment/cac:Consignment/cac:Status">
		<assert id="PEPPOL-T128-R025" test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReasonCode)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReasonCode))" flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason code SHALL be provided. </assert>
		<assert id="PEPPOL-T128-R026" test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReason)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReason)) " flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason (text) SHALL be provided. </assert>
	</rule>
	<rule context="cac:Shipment/cac:TransportHandlingUnit/cac:Status">
		<assert id="PEPPOL-T128-R027" test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReasonCode)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReasonCode))" flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason code SHALL be provided. </assert>
		<assert id="PEPPOL-T128-R028" test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReason)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReason)) " flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason (text) SHALL be provided. </assert>
	</rule>
	<rule context="cac:AdditionalDocumentReference">
		<assert id="PEPPOL-T128-R031" test="(cbc:DocumentTypeCode) or (cbc:DocumentType)" flag="fatal">AdditionalDocumentReference SHALL contain a Document Type Code or a Document Type. </assert>
	</rule>
</pattern>



