<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
        <rule context="//*[not(*) and not(normalize-space())]">
            <assert id="PEPPOL-T016-R001" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
        </rule>
    </pattern>
    <pattern>
        <rule context="/*">
            <assert id="PEPPOL-T016-R002"
                    test="not(@*:schemaLocation)"
                    flag="warning">Document SHOULD not contain schema location.
            </assert>

        </rule>

        <rule context="cbc:IssueDate">
            <assert id="PEPPOL-T016-R003"
                    test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                    flag="fatal">A date must be formatted YYYY-MM-DD.
            </assert>
        </rule>

    </pattern>

    <pattern>

        <rule context="/ubl:ApplicationResponse">
            <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T016-R004">Element 'cbc:CustomizationID' MUST be provided.</assert>
            <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T016-R005">Element 'cbc:ProfileID' MUST be provided.</assert>
            <assert test="cbc:ID" flag="fatal" id="PEPPOL-T016-R006">Element 'cbc:ID' MUST be provided.</assert>
            <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T016-R007">Element 'cbc:IssueDate' MUST be provided.</assert>
            <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T016-R008">Element 'cac:SenderParty' MUST be provided.</assert>
            <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T016-R009">Element 'cac:ReceiverParty' MUST be provided.</assert>
            <assert test="cac:DocumentResponse" flag="fatal" id="PEPPOL-T016-R010">Element 'cac:DocumentResponse' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t016:1.2'"
                flag="fatal" id="PEPPOL-T016-R011">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t016:1.2'.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cbc:ProfileID">
            <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p008:1.2'"
                    flag="fatal" id="PEPPOL-T016-R012">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p008:1.2'.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cbc:ID"/>
        <rule context="/ubl:ApplicationResponse/cbc:IssueDate"/>

        <rule context="/ubl:ApplicationResponse/cbc:IssueTime">
            <assert id="PEPPOL-T016-R013" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">IssueTime MUST include timezone information.</assert>
            <assert id="PEPPOL-T016-R014" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:SenderParty">
            <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T016-R015">Element 'cbc:EndpointID' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID">
            <assert test="@schemeID" flag="fatal" id="PEPPOL-T016-R016">Attribute 'schemeID' MUST be present.</assert>
            <assert flag="fatal" id="PEPPOL-T016-R017" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
                Value MUST be part of code list 'Electronic Address Scheme (EAS)'.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:SenderParty/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R018">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:ReceiverParty">
            <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T016-R019">Element 'cbc:EndpointID' MUST be
                provided.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID">
            <assert test="@schemeID" flag="fatal" id="PEPPOL-T016-R020">Attribute 'schemeID' MUST be present.</assert>
            <assert flag="fatal" id="PEPPOL-T016-R021" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
                Value MUST be part of code list 'Electronic Address Scheme (EAS)'.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R022">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse">
            <assert test="cac:Response" flag="fatal" id="PEPPOL-T016-R023">Element 'cac:Response' MUST be provided.
            </assert>
            <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T016-R024">Element 'cac:DocumentReference' MUST
                be provided.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
            <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T016-R025">Element 'cbc:ResponseCode' MUST be
                provided.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
            <assert test="cac:Status" flag="fatal" id="PEPPOL-T016-R026">Element 'cac:Status' MUST be
                provided.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode">
            <assert test="matches(normalize-space(.),'^(RE|AP|CA|PU)')" flag="fatal" id="PEPPOL-T016-R027">
                Value MUST be part of code list 'Notification Response type code (UNCL4343 Subset)'.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:EffectiveDate"/>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:EffectiveTime">
            <assert id="PEPPOL-T016-R028" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">EffectiveTime MUST include timezone information.</assert>
            <assert id="PEPPOL-T016-R029" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">EffectiveTime MUST have a granularity of seconds</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cac:Status">
            <assert test="cbc:ConditionCode" flag="fatal" id="PEPPOL-T016-R030">Element 'cbc:ConditionCode' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cac:Status/cbc:ConditionCode">
            <assert test="matches(normalize-space(.),'^(TST|FCST|EFF)')" flag="fatal" id="PEPPOL-T016-R031">Value MUST be part of code list 'Publication Condition Code'.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R032">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
            <assert id="PEPPOL-T016-R033" flag="fatal" test="cbc:ID">Element 'cbc:ID' MUST be provided.</assert>
            <assert id="PEPPOL-T016-R034" flag="fatal" test="count(cbc:UUID) = count(cbc:VersionID)">Element 'cbc:UUID' MUST be provided with cbc:VersionID.</assert>
            <assert id="PEPPOL-T016-R035" flag="fatal" test="count(cbc:UUID) = count(cbc:DocumentTypeCode)">Element 'cbc:UUID' MUST be provided with cbc:DocumentTypeCode.</assert>
            <assert id="PEPPOL-T016-R037" flag="fatal" test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">Element 'cbc:ID' MUST be unique.</assert>
            <assert id="PEPPOL-T016-R038" flag="fatal" test="count(distinct-values(cac:DocumentReference/cbc:UUID)) = count(cac:DocumentReference/cbc:UUID)">Element 'cbc:UUID' MUST be unique.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode">
            <assert id="PEPPOL-T016-R039" flag="fatal" test="matches(normalize-space(.),'^(CN|CAN|PIN)$')">Value MUST be part of code list 'UBLDocumentSchema'.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID">
                <assert id="PEPPOL-T016-R040" flag="fatal"  test="matches(normalize-space(.),'^[0-9]{1,2}$')">Value MUST be consecutive numbers made of 2 digits.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:UUID"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R041">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse">
            <assert test="cac:LineReference" flag="fatal" id="PEPPOL-T016-R042">Element 'cac:LineReference' MUST be
                provided.
            </assert>
            <assert test="cac:Response" flag="fatal" id="PEPPOL-T016-R043">Element 'cac:Response' MUST be provided.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference">
            <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T016-R044">Element 'cbc:LineID' MUST be provided.</assert>
            <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T016-R045">Element 'cac:DocumentReference' MUST be provided.</assert>
        </rule>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cac:DocumentReference">
            <assert test="cbc:ID" flag="fatal" id="PEPPOL-T016-R046">Element 'cbc:ID' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cac:DocumentReference/cbc:ID"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R047">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response">
            <assert test="cbc:Description" flag="fatal" id="PEPPOL-T016-R048">Element 'cbc:Description' MUST be provided.</assert>
            <assert test="cac:Status" flag="fatal" id="PEPPOL-T016-R049">Element 'cac:Status' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode">
                <assert flag="fatal" id="PEPPOL-T016-R050" test="matches(normalize-space(.),'^(RE|AP|CA)$')">Value MUST be part of code list 'Notification Response type code (UNCL4343 Subset)'.
                    The Value 'PU' for 'published' from code list 'Notification Response type code (UNCL4343 Subset)' is not allowed.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status">
            <assert test="cbc:StatusReasonCode" flag="fatal" id="PEPPOL-T016-R051">Element 'cbc:StatusReasonCode' MUST be provided.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode">
            <assert flag="fatal" id="PEPPOL-T016-R052" test="matches(normalize-space(.),'^(BV|SV|BW)$')">Value MUST be part of code list 'Status Reason Code Subset'.</assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R053">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description"/>
        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R054">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R055">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>

        <rule context="/ubl:ApplicationResponse/cbc:UBLVersionID"/>

        <rule context="/ubl:ApplicationResponse/*">
            <assert test="false()" flag="fatal" id="PEPPOL-T016-R056">Document MUST NOT contain elements not part of the
                data model.
            </assert>
        </rule>
    </pattern>

