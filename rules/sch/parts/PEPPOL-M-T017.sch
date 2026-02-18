<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <rule context="cbc:IssueDate">
        <assert id="PEPPOL-T017-R002" test="(string(.) castable as xs:date) and (string-length(.) = 10)" flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification">
        <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T017-R003">Element 'cbc:UBLVersionID' MUST be provided.</assert>
        <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T017-R004">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T017-R005">Element 'cbc:ProfileID' MUST be provided.</assert>
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R006">Element 'cbc:ID' MUST be provided.</assert>
        <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T017-R007">Element 'cbc:ContractFolderID' MUST be provided.</assert>
        <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T017-R009">Element 'cbc:IssueDate' MUST be provided.</assert>
        <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T017-R010">Element 'cbc:IssueTime' MUST be provided.</assert>
        <assert test="cbc:Note" flag="fatal" id="PEPPOL-T017-R011">Element 'cbc:Note' MUST be provided.</assert>
        <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T017-R012">Element 'cac:SenderParty' MUST be provided.</assert>
        <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T017-R013">Element 'cac:ReceiverParty' MUST be provided.</assert>
        <assert test="cac:MinutesDocumentReference" flag="fatal" id="PEPPOL-T017-R014">Element 'cac:MinutesDocumentReference' MUST be provided.</assert>
        <assert test="cac:TenderResult" flag="fatal" id="PEPPOL-T017-R015">Element 'cac:TenderResult' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:UBLVersionID">
        <assert test="normalize-space(text()) = '2.2'" flag="fatal" id="PEPPOL-T017-R016">Element 'cbc:UBLVersionID' MUST contain value '2.2.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t017:1.1'"
                flag="fatal" id="PEPPOL-T017-R017">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t017:1.1'.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:ProfileID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p009:1.1'" flag="fatal" id="PEPPOL-T017-R018">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p009:1.1'.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:ID">
        <assert flag="fatal" id="PEPPOL-T017-R019" test="matches(normalize-space(./@schemeURI),'^(urn:uuid)')">Value for schemeURI MUST be part urn:uuid.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R020"  test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ID MUST be expressed in UUID Syntax.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:ContractFolderID">
        <assert flag="fatal" id="PEPPOL-T017-R021"  test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ContractFolderID MUST be expressed in UUID Syntax.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:IssueDate"/>
    
    <rule context="/ubl:AwardedNotification/cbc:IssueTime">
        <assert id="PEPPOL-T017-R022" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T017-R023" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cbc:Note"/>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T017-R024">Element 'cbc:EndpointID' MUST be provided.</assert>
        <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T017-R025">Element 'cbc:PartyIdentification' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T017-R026">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R027" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R028">Element 'cbc:ID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T017-R029" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T017-R030" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyIdentification/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R031">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyName">
        <assert test="cbc:Name" flag="fatal" id="PEPPOL-T017-R032">Element 'cbc:Name' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyName/cbc:Name"/>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyName/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R033">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:SenderParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R034">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T017-R035">Element 'cbc:EndpointID' MUST be provided.</assert>
        <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T017-R036">Element 'cbc:PartyIdentification' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T017-R037">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R038" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R039">Element 'cbc:ID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T017-R040" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T017-R041" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyIdentification/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R042">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyName">
        <assert test="cbc:Name" flag="fatal" id="PEPPOL-T017-R043">Element 'cbc:Name' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyName/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R044">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:ReceiverParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R045">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R046">Element 'cbc:ID' MUST be provided.</assert>
        <assert test="cbc:DocumentStatusCode" flag="fatal" id="PEPPOL-T017-R047">Element 'cbc:DocumentStatusCode' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference/cbc:ID">
        <assert flag="fatal" id="PEPPOL-T017-R048"  test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ID MUST be expressed in UUID Syntax.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference/cbc:DocumentStatusCode">
        <assert flag="fatal" id="PEPPOL-T017-R049" test="@listID">Attribute 'listID' MUST be present</assert>
        <assert flag="fatal" id="PEPPOL-T017-R050" test="matches(normalize-space(./@listID),'^(awardCode)')">Value MUST be awardCode.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R051" test="matches(normalize-space(.),'^(award|unaward)')">Value of DocumentStatusCode must be from codelist awardCode.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R052">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult">
        <assert test="cbc:TenderResultCode" flag="fatal" id="PEPPOL-T017-R053">Element 'cbc:TenderResultCode' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:TenderResultCode">
        <assert flag="fatal" id="PEPPOL-T017-R054" test="@listID">Attribute 'listID' MUST be present</assert>
        <assert flag="fatal" id="PEPPOL-T017-R055" test="matches(normalize-space(./@listID),'^(http://publications.europa.eu/resource/authority/winner-selection-status)')">Value MUST be http://publications.europa.eu/resource/authority/winner-selection-status.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R056" test="matches(normalize-space(.),'^(selec-w|clos-nw|open-nw)')">Value of TenderResultCode must be from codelist WinnerSelectionStatus.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:AwardDate"/>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:AwardTime">
        <assert id="PEPPOL-T017-R057" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">IssueTimeAwardTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T017-R058" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:StartDate"/>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R059">Element 'cac:ID' MUST be provided.</assert>
        <assert test="cac:Attachment" flag="fatal" id="PEPPOL-T017-R060">Element 'cac:Attachment' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference">
        <assert flag="fatal" id="PEPPOL-T017-R061" test="cbc:URI">Element 'cbc:URI' MUST be provided.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R062" test="cbc:MimeCode">Element 'cbc:URI' MUST be provided.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R075" test="cbc:FileName">Element 'cbc:FileName' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:Contract/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R063">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R064">Element 'cac:ID' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot/cbc:ID"/>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R065">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:AwardedTenderedProject/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R066">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:WinningParty">
        <assert test="cbc:Rank" flag="fatal" id="PEPPOL-T017-R067">Element 'cbc:Rank' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyName">
        <assert test="cbc:Name" flag="fatal" id="PEPPOL-T017-R068">Element 'cbc:Name' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
        <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T017-R069">Element 'cbc:IdentificationCode' MUST be provided.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
        <assert flag="fatal" id="PEPPOL-T017-R070" test="@listID">Attribute 'listID' MUST be present</assert>
        <assert flag="fatal" id="PEPPOL-T017-R071" test="matches(normalize-space(./@listID),'^(ISO3166-1:Alpha2)')">Value MUST be ISO3166-1:Alpha2.</assert>
        <assert flag="fatal" id="PEPPOL-T017-R072" test="matches(normalize-space(.),'^(A(D|E|F|G|I|L|M|N|O|R|S|T|Q|U|W|X|Z)|B(A|B|D|E|F|G|H|I|J|L|M|N|O|R|S|T|V|W|Y|Z)|C(A|C|D|F|G|H|I|K|L|M|N|O|R|U|V|X|Y|Z)|D(E|J|K|M|O|Z)|E(C|E|G|H|R|S|T)|F(I|J|K|M|O|R)|G(A|B|D|E|F|G|H|I|L|M|N|P|Q|R|S|T|U|W|Y)|H(K|M|N|R|T|U)|I(D|E|Q|L|M|N|O|R|S|T)|J(E|M|O|P)|K(E|G|H|I|M|N|P|R|W|Y|Z)|L(A|B|C|I|K|R|S|T|U|V|Y)|M(A|C|D|E|F|G|H|K|L|M|N|O|Q|P|R|S|T|U|V|W|X|Y|Z)|N(A|C|E|F|G|I|L|O|P|R|U|Z)|OM|P(A|E|F|G|H|K|L|M|N|R|S|T|W|Y)|QA|R(E|O|S|U|W)|S(A|B|C|D|E|G|H|I|J|K|L|M|N|O|R|T|V|Y|Z)|T(C|D|F|G|H|J|K|L|M|N|O|R|T|V|W|Z)|U(A|G|M|S|Y|Z)|V(A|C|E|G|I|N|U)|W(F|S)|Y(E|T)|Z(A|M|W))$')">Value of TenderResultCode must be from codelist WinnerSelectionStatus.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:Contract"/>
    <rule context="/ubl:AwardedNotification/cac:TenderResult/cac:AwardedTenderedProject"/>
    
    <rule context="/ubl:AwardedNotification/cac:TenderResult/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R073">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
    <rule context="/ubl:AwardedNotification/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R074">Document MUST NOT contain elements not part of the data model.</assert>
    </rule>
    
</pattern>

