<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T127-R001"
		  test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transportation_status:1')"
		  flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:transportation_status:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T127-R002"
		  test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1 urn:fdc:peppol.eu:logistics:bis:transportation_status_only:1', '\s') satisfies $p = normalize-space(.)"
		  flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1' or 'urn:fdc:peppol.eu:logistics:bis:transportation_status_only:1'.</assert>
	</rule>
</pattern>

