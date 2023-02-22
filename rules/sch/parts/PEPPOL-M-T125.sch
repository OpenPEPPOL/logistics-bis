<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T125-R001"
		  test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:waybill:1')"
		  flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:waybill:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T125-R002"
		   test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:waybill_only:1')"
		  flag="fatal">ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:waybill_only:1'.</assert>
	</rule>
</pattern>

