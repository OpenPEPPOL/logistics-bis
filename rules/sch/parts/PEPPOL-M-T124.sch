<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T124-R001" 
				test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1')" flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T124-R002" 
				test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1') or starts-with(normalize-space(.), 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1')"
				flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1' or 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1'.</assert>
	</rule>
</pattern>

