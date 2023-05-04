<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T128-R001"
		  test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1')"
		  flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T128-R002"
				test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:receipt_advice_only:1 urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1', '\s') satisfies $p = normalize-space(.)"
				flag="fatal">A Receipt Advice transaction SHALL use profile urn:fdc:peppol.eu:logistics:bis:receipt_advice_only:1 OR urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1.</assert>
	</rule>
</pattern>

