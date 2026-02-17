<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <rule context="*">
        <report id="PEPPOL-T003-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[PEPPOL-T003-S002] A Tender Status Inquiry document MUST NOT contain empty elements.</report>
    </rule>
        
    <let name="syntaxError" value="string('[PEPPOL-T003-S003] A Tender Status Inquiry document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    <rule context="ubl:TenderStatusRequest">
        <assert id="PEPPOL-T003-R024" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T003-R024] A Tender Status Inquiry MUST have a syntax identifier.</assert>
        <assert id="PEPPOL-T003-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T003-R001] A Tender Status Inquiry MUST have a specification (customization) identifier.</assert>
        <assert id="PEPPOL-T003-R002" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T003-R002] A Tender Status Inquiry MUST have a business process (profile) identifier.</assert>
        <assert id="PEPPOL-T003-R003" flag="fatal" test="(cbc:ID)">[PEPPOL-T003-R003] A Tender Status Inquiry MUST have a Tender Status Inquiry identifier.</assert>
        <assert id="PEPPOL-T003-R004" flag="fatal" test="(cbc:ContractFolderID)">[PEPPOL-T003-R004] A Tender Status Inquiry MUST have a reference number.</assert>
        <assert id="PEPPOL-T003-R005" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T003-R005] A Tender Status Inquiry MUST have an issue date.</assert>
        <assert id="PEPPOL-T003-R015" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T003-R015] A Tender Status Inquiry MUST have an issue time.</assert>
        <assert id="PEPPOL-T003-R022" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[PEPPOL-T003-R022] Lot identifiers MUST be unique.</assert>
        <report id="PEPPOL-T003-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[PEPPOL-T003-S301] UBLExtensions SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[PEPPOL-T003-S305] ProfileExecutionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T003-S307] CopyIndicator SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[PEPPOL-T003-S308] UUID SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S310" flag="warning" test="(cbc:ContractName)"><value-of select="$syntaxError"/>[PEPPOL-T003-S310] ContractName SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S311" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[PEPPOL-T003-S311] Note SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S312" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[PEPPOL-T003-S312] Signature SHOULD NOT be used.</report>
        <assert id="PEPPOL-T003-S313" flag="warning" test="count(cac:ContractingParty) = 1"><value-of select="$syntaxError"/>[PEPPOL-T003-S313] ContractingParty SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T003-S321" flag="warning" test="(cac:ProcurementProject)"><value-of select="$syntaxError"/>[PEPPOL-T003-S321] ProcurementProject SHOULD NOT be used.</report>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cbc:UBLVersionID">
        <assert id="PEPPOL-T003-R023" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T003-R023] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T003-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
    </rule>
    
     <rule context="ubl:TenderStatusRequest/cbc:CustomizationID">
         <assert id="PEPPOL-T003-R010" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t003:1.2'">[PEPPOL-T003-R010] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t003:1.2'</assert>
        <report id="PEPPOL-T003-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S303] CustomizationID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cbc:ProfileID">
        <assert id="PEPPOL-T003-R011" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p002:1.2'">[PEPPOL-T003-R011] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p002:1.2'</assert>
        <report id="PEPPOL-T003-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S304] ProfileID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cbc:ID">
        <assert id="PEPPOL-T003-R012" flag="fatal" test="./@schemeURI">[PEPPOL-T003-R012] A Tender Status Inquiry Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T003-R013" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T003-R013] schemeURI for Tender Status Inquiry Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T003-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T003-S306] ID SHOULD NOT have any further attributes but schemeURI</report>
        <assert id="PEPPOL-T003-R014" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T003-R014] A Tender Status Inquiry Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cbc:ContractFolderID">
        <report id="PEPPOL-T003-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S309] ContractFolderID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cbc:IssueTime">
        <assert id="PEPPOL-T003-R016" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T003-R016] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T003-R017" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T003-R017] IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cac:ContractingParty">
        <assert id="PEPPOL-T003-S314" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[PEPPOL-T003-S314] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty">
        <assert id="PEPPOL-T003-S324" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[PEPPOL-T003-S324] EconomicOperatorParty SHOULD NOT contain any elements but cac:Party.</assert>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T003-R007" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T003-R007] A Tender Status Inquiry MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
    </rule>

    <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party">
        <assert id="PEPPOL-T003-R008" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T003-R008] A Tender Status Inquiry MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
        <assert id="PEPPOL-T003-R009" flag="warning" test="(./cac:PartyName)">[PEPPOL-T003-R009] A Tender Status Inquiry MUST include the name of the Economic Operator.</assert>
    </rule>
    
    <rule context="cac:Party">
        <assert id="PEPPOL-T003-S315" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[PEPPOL-T003-S315] Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
        <report id="PEPPOL-T003-S317" flag="warning" test="count(./cac:PartyIdentification) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T003-S317] PartyIdentification SHOULD NOT be used more than once</report>
        <report id="PEPPOL-T003-S319" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T003-S319] PartyName SHOULD NOT be used more than once</report>
    </rule>    
    
    <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T003-R020" flag="fatal" test="./@schemeID">[PEPPOL-T003-R020] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T003-R021" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T003-R021] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T003-S316" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T003-S316] EndpointID SHOULD NOT have any attributes but schemeID</report>
    </rule>
    
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T003-R018" flag="fatal" test="./@schemeID">[PEPPOL-T003-R018] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T003-R019" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\\d)|(1\\d{2})|(20\\d)|(21[0-3])))$')">[PEPPOL-T003-R019] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T003-S318" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T003-S318] cac:PartyIdentification/cbc:ID SHOULD NOT have any attributes but schemeID</report>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T003-S322" flag="warning" test="count(./*)-count(./cbc:ID)= 0"><value-of select="$syntaxError"/>[PEPPOL-T003-S322] ProcurementProjectLot SHOULD NOT contain any elements but cbc:ID</assert>
    </rule>
    
    <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot/cbc:ID">
        <report id="PEPPOL-T003-S323" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S323] cac:ProcurementProjectLot/cbc:ID SHOULD NOT have any attributes</report>
    </rule>
    
    <rule context="cbc:Name">
        <report id="PEPPOL-T003-S320" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T003-S320] cbc:Name SHOULD NOT have any attributes</report>
    </rule>

</pattern>
