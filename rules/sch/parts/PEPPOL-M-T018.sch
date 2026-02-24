<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <rule context="/*">
        <assert id="PEPPOL-T018-R002"
            test="not(@*:schemaLocation)"
            flag="warning">Document SHOULD not contain schema location.
        </assert>
        
    </rule>
    
    <rule context="cbc:IssueDate">
        <assert id="PEPPOL-T018-R003"
            test="(string(.) castable as xs:date) and (string-length(.) = 10)"
            flag="fatal">A date must be formatted YYYY-MM-DD.
        </assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse">
        <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T018-R004">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T018-R005">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T018-R006">Element 'cbc:ProfileID' MUST be provided.</assert>
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T018-R007">Element 'cbc:ID' MUST be provided.</assert>
        <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T018-R008">Element 'cbc:IssueDate' MUST be provided.</assert>
        <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T018-R009">Element 'cac:SenderParty' MUST be provided.</assert>
        <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T018-R010">Element 'cac:ReceiverParty' MUST be provided.</assert>
        <assert test="cac:DocumentResponse" flag="fatal" id="PEPPOL-T018-R011">Element 'cac:DocumentResponse' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cbc:UBLVersionID">
        <assert test="normalize-space(text()) = '2.2'"
                flag="fatal" id="PEPPOL-T018-R012">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t018:1.1'"
                flag="fatal" id="PEPPOL-T018-R013">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:T018:1.1'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cbc:ProfileID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p010:1.1'"
                flag="fatal" id="PEPPOL-T018-R014">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p010:1.1'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cbc:ID"/>
    <rule context="/ubl:ApplicationResponse/cbc:IssueDate"/>
    
    <rule context="/ubl:ApplicationResponse/cbc:IssueTime">
        <assert id="PEPPOL-T018-R015" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T018-R016" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:SenderParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-R017">Element 'cbc:EndpointID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-R018">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal" id="PEPPOL-T018-R019" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:SenderParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R020">Document MUST NOT contain elements not part of the
            data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:ReceiverParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-R021">Element 'cbc:EndpointID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-R022">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal" id="PEPPOL-T018-R023" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R024">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse">
        <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-R025">Element 'cac:Response' MUST be provided.</assert>
        <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T018-R026">Element 'cac:DocumentReference' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
        <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T018-R027">Element 'cbc:ResponseCode' MUST be provided.</assert>
        <assert test="cbc:Description" flag="fatal" id="PEPPOL-T018-R028">Element 'cbc:Description' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode">
        <assert test="matches(normalize-space(.),'^(RE|AP|CA)')" flag="fatal" id="PEPPOL-T018-R029">
            Value MUST be part of code list 'Message Response Code'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"/>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R030">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
        <assert id="PEPPOL-T018-R031" flag="fatal" test="cbc:ID">Element 'cbc:ID' MUST be provided.</assert>
        <assert id="PEPPOL-T018-R032" flag="fatal" test="cbc:DocumentTypeCode">Element 'cbc:DocumentTypeCode' MUST be provided.</assert>
        <assert id="PEPPOL-T018-R033" flag="fatal" test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">Element 'cbc:ID' MUST be unique.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T018-R034" flag="fatal" test="matches(normalize-space(.),'urn:fdc:peppol\.eu:prac:trns:t0[0,1][0-9]:1\.1')">Value MUST be a valid transactionID.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"/>
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R035">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse">
        <assert test="cac:LineReference" flag="fatal" id="PEPPOL-T018-R036">Element 'cac:LineReference' MUST be provided.</assert>
        <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-R037">Element 'cac:Response' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference">
        <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T018-R038">Element 'cbc:LineID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID"/>
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R039">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response">
        <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T018-R040">Element 'cbc:ResponseCode' MUST be provided.</assert>
        <assert test="cbc:Description" flag="fatal" id="PEPPOL-T018-R041">Element 'cbc:Description' MUST be provided.</assert>
        <assert test="cac:Status" flag="fatal" id="PEPPOL-T018-R042">Element 'cac:Status' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode">
        <assert flag="fatal" id="PEPPOL-T018-R043" test="matches(normalize-space(.),'^(RE|AP|CA)$')">Value MUST be part of code list 'Message Response Code'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status">
        <assert test="cbc:StatusReasonCode" flag="fatal" id="PEPPOL-T018-R044">Element 'cbc:StatusReasonCode' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode">
        <assert flag="fatal" id="PEPPOL-T018-R045" test="matches(normalize-space(.),'^(BV|BW|SV|NF|DL|RF|WT|IR|MA|AE|PT)$')">Value MUST be part of code list 'Status Reason Code'.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R046">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description"/>
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R047">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R048">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:ApplicationResponse/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R049">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
	<rule context="//*[not(*) and not(normalize-space())]">
            <assert id="PEPPOL-T018-R001" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
        </rule>
</pattern>