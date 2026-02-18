<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <let name="syntaxError" value="string('[PEPPOL-T022-S003] An Unsubscribe from Procedure Confirmation SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    <rule context="ubl:UnsubscribeFromProcedureResponse">
        <assert id="PEPPOL-T022-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T022-R001] An Unsubscribe from Procedure Confirmation MUST have a customization identifier</assert>
        <assert id="PEPPOL-T022-R003" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T022-R003] An Unsubscribe from Procedure Confirmation MUST have a profile identifier</assert>
        <assert id="PEPPOL-T022-R005" flag="fatal" test="(cbc:ID)">[PEPPOL-T022-R005] An Unsubscribe from Procedure Confirmation MUST have an Unsubscribe from Procedure Confirmation Identifier.</assert>
        <assert id="PEPPOL-T022-R009" flag="fatal" test="(cbc:ContractFolderID)">[PEPPOL-T022-R009] An Unsubscribe from Procedure Confirmation MUST have a ContractFolderID.</assert>
        <assert id="PEPPOL-T022-R010" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T022-R010] An Unsubscribe from Procedure Confirmation MUST have an issue date</assert>
        <assert id="PEPPOL-T022-R011" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T022-R011] An Unsubscribe from Procedure Confirmation MUST have an issue time</assert>
        <assert id="PEPPOL-T022-R023" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLotReference/cbc:ID)) = count(cac:ProcurementProjectLotReference/cbc:ID)">[PEPPOL-T022-R023] Lot identifiers MUST be unique.</assert>
        <assert id="PEPPOL-T022-R024" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T022-R024] An Unsubscribe from Procedure Confirmation MUST have a syntax identifier.</assert>
        <report id="PEPPOL-T022-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[PEPPOL-T022-S301] UBLExtensions SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[PEPPOL-T022-S305] ProfileExecutionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T022-S307] CopyIndicator SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[PEPPOL-T022-S308] UUID SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S310" flag="warning" test="(cbc:ContractName)"><value-of select="$syntaxError"/>[PEPPOL-T022-S310] ContractName SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S312" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[PEPPOL-T022-S312] Note SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S313" flag="warning" test="count(cac:UnsubscribeFromProcedureResponse) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T022-S313] Unsubscribe from Procedure Document Reference SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T022-S320" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[PEPPOL-T022-S320] Signature SHOULD NOT be used.</report>
        <report id="PEPPOL-T022-S331" flag="warning" test="count(cac:ContractingParty) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T022-S331] ContractingParty SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T022-S329" flag="warning" test="(cac:ProcurementProject)"><value-of select="$syntaxError"/>[PEPPOL-T022-S329] ProcurementProject SHOULD NOT be used.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:UBLVersionID">
        <assert id="PEPPOL-T022-R029" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T022-R029] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T022-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:CustomizationID">
        <assert id="PEPPOL-T022-R002" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t022:1.2'">[PEPPOL-T022-R002] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t022:1.2'</assert>
        <report id="PEPPOL-T022-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S303] CustomizationID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:ProfileID">
        <assert id="PEPPOL-T022-R004" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p001:1.2'">[PEPPOL-T022-R004] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p001:1.2'</assert>
        <report id="PEPPOL-T022-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S304] ProfileID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:ID">
        <assert id="PEPPOL-T022-R006" flag="fatal" test="./@schemeURI">[PEPPOL-T022-R006] An Unsubscribe from Procedure Confirmation Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T022-R007" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T022-R007] schemeURI for Unsubscribe from Procedure Confirmation Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T022-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T022-S306] ID SHOULD NOT have any further attributes but schemeURI</report>
        <assert id="PEPPOL-T022-R008" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T022-R008] Unsubscribe from Procedure Confirmation Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:ContractFolderID">
        <report id="PEPPOL-T022-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S309] ContractFolderID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cbc:IssueTime">
        <assert id="PEPPOL-T022-R012" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T022-R012] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T022-R013" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T022-R013] IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:UnsubscribeToProcedureDocumentReference">
        <assert id="PEPPOL-T022-S314" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[PEPPOL-T022-S314] Unsubscribe from Procedure Document Reference SHOULD NOT contain any other elements but ID.</assert>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:UnsubscribeToProcedureDocumentReference/cbc:ID">
        <assert id="PEPPOL-T022-R025" flag="fatal" test="./@schemeURI">[PEPPOL-T022-R025] An Unsubscribe from Procedure Document Reference Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T022-R026" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T022-R026] schemeURI for Unsubscribe from Procedure Document Reference Identifier SHOULD be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T022-R027" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T022-R027] Unsubscribe from Procedure Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T022-S318" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T022-S318] Unsubscribe from Procedure Document Reference Identifier SHOULD NOT have any further attributes but schemeURI</report>
        <report id="PEPPOL-T022-R028" flag="fatal" test="normalize-space(.) = normalize-space(/ubl:UnsubscribeFromProcedureResponse/cbc:ID)">[PEPPOL-T022-R028] Unsubscribe from Procedure Document Reference Identifier MUSTS NOT be identical to the Unsubscribe from Procedure Confirmation Identifier</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:EconomicOperatorParty">
        <report id="PEPPOL-T022-S321" flag="warning" test="(cac:EconomicOperatorRole)"><value-of select="$syntaxError"/>[PEPPOL-T022-S321] EconomicOperatorRole SHOULD NOT be used.</report>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:EconomicOperatorParty/cac:Party">
        <assert id="PEPPOL-T022-S322" flag="warning" test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)= 0"><value-of select="$syntaxError"/>[PEPPOL-T022-S322] An EconomicOperatorParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification</assert>
        <assert id="PEPPOL-T022-R015" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T022-R015] An Unsubscribe from Procedure Confirmation MUST identify the Economic Operator by its party identifier and its endpoint identifier.</assert>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:ContractingParty">
        <assert id="PEPPOL-T022-S323" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[PEPPOL-T022-S323] ContractingParty MUST NOT contain any other elements but cac:Party.</assert>
    </rule>
    
    <rule context="ubl:UnsubscribeFromProcedureResponse/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T022-S324" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[PEPPOL-T022-S324] A ContractingParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification, PartyName</assert>
        <assert id="PEPPOL-T022-R014" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T022-R014] An Unsubscribe from Procedure Confirmation MUST identify the Contracting Body by its party identifier and its endpoint identifier.</assert>
    </rule>    
    
    <rule context="cac:Party">
        <report id="PEPPOL-T022-S325" flag="warning" test="count(./cac:PartyIdentification) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T022-S325] PartyIdentification SHOULD NOT be used more than once</report>
        <report id="PEPPOL-T022-S326" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T022-S326] PartyName SHOULD NOT be used more than once</report>
    </rule>
    
    <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T022-R021" flag="fatal" test="./@schemeID">[PEPPOL-T022-R021] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T022-R022" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T022-R022] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T022-S328" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T022-S328] EndpointID SHOULD NOT have any further attributes but schemeID</report>
    </rule>
    
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T022-R016" flag="fatal" test="./@schemeID">[PEPPOL-T022-R016] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T022-R017" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T022-R017] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T022-S332" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T022-S332] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
    </rule>
    
    <rule context="cbc:Name">
        <report id="PEPPOL-T022-S327" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S327] cbc:Name SHOULD NOT have any further attributes</report>
    </rule>
    
    <rule context="cac:ProcurementProjectLotReference/cbc:ID">
        <report id="PEPPOL-T022-S330" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T022-S330] cac:ProcurementProjectLotReference/cbc:ID SHOULD NOT have any further attributes</report>
    </rule>
</pattern>
