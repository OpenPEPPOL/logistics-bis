<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T128-R001"
		  test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1')"
		  flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T128-R002"
		   test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:transport_receipt_advice_only:1')"
		  flag="fatal">Specification identifier SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:receipt_advice_only:1'.</assert>
	</rule>
</pattern>

