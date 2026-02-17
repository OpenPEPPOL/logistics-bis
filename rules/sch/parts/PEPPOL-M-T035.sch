<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
<!-- PEPPOL-M-T035: Pre-Award Catalogue Request Business Rules -->
    <pattern>
        <rule context="*">
            <report id="PEPPOL-T035-S002" flag="fatal" test="normalize-space(.) = '' and not(*)"
                >[PEPPOL-T035-S002] A Catalogue Request document MUST NOT contain empty
                elements.</report>
        </rule>
    </pattern>
    <pattern>
        <let name="syntaxError"
            value="string('[PEPPOL-T035-S003] A Catalogue Request SHOULD only consist of elements and attributes described in the syntax mapping. - ')"/>
        <rule context="ubl:CatalogueRequest">
            <assert id="PEPPOL-T035-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T035-R001]
                A Catalogue Request MUST have a customization identifier</assert>
            <assert id="PEPPOL-T035-R002" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T035-R002] A
                Catalogue Request MUST have a profile identifier</assert>
            <assert id="PEPPOL-T035-R003" flag="fatal" test="(cbc:ID)">[PEPPOL-T035-R003] A
                Catalogue Request MUST have a Catalogue Request identifier.</assert>
            <assert id="PEPPOL-T035-R004" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T035-R004] A
                Catalogue Request MUST have an issue date</assert>
            <assert id="PEPPOL-T035-R005" flag="fatal" test="(cac:ProviderParty)">[PEPPOL-T035-R005] A
                Catalogue Request MUST have a provider party</assert>
            <assert id="PEPPOL-T035-R006" flag="fatal" test="(cac:ReceiverParty)">[PEPPOL-T035-R006] A
                Catalogue Request MUST have a receiver party</assert>
            
            <report id="PEPPOL-T035-S301" flag="warning" test="(ext:UBLExtensions)"><value-of
                    select="$syntaxError"/>[PEPPOL-T035-S301] UBLExtensions SHOULD NOT be
                used.</report>
            <report id="PEPPOL-T035-S302" flag="warning" test="(cbc:UBLVersionID)"><value-of
                    select="$syntaxError"/>[PEPPOL-T035-S302] UBLVersionID SHOULD NOT be
                used.</report>
            <report id="PEPPOL-T035-S303" flag="warning" test="(cbc:ProfileExecutionID)"><value-of
                    select="$syntaxError"/>[PEPPOL-T035-S303] ProfileExecutionID SHOULD NOT be
                used.</report>
            <report id="PEPPOL-T035-S304" flag="warning" test="(cbc:UUID)"><value-of
                    select="$syntaxError"/>[PEPPOL-T035-S304] UUID SHOULD NOT be used.</report>
        </rule>
    </pattern>
    <pattern>
        <rule context="cac:ProviderParty">
            <assert id="PEPPOL-T035-R007" flag="fatal" test="(cbc:EndpointID)">[PEPPOL-T035-R007]
                A Provider party MUST have an endpoint identifier</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="cac:ReceiverParty">
            <assert id="PEPPOL-T035-R008" flag="fatal" test="(cbc:EndpointID)">[PEPPOL-T035-R008]
                A Receiver party MUST have an endpoint identifier</assert>
        </rule>
    </pattern></schema>