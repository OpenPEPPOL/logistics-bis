<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
    <pattern>
        <rule context="*">
            <report id="PEPPOL-T002-S002" flag="fatal" test="normalize-space(.) = '' and not(*)" >[PEPPOL-T002-S002] An Expression of Interest Confirmation document MUST NOT contain empty elements.</report>
        </rule>
    </pattern>
    
    <pattern>
        <let name="syntaxError" value="string('[PEPPOL-T002-S003] An Expression of Interest Confirmation SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
        <rule context="ubl:ExpressionOfInterestResponse">
            <assert id="PEPPOL-T002-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T002-R001] An Expression of Interest Confirmation MUST have a customization identifier</assert>
            <assert id="PEPPOL-T002-R003" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T002-R003] An Expression of Interest Confirmation MUST have a profile identifier</assert>
            <assert id="PEPPOL-T002-R005" flag="fatal" test="(cbc:ID)">[PEPPOL-T002-R005] An Expression of Interest Confirmation MUST have an Expression of Interest Confirmation Identifier.</assert>
            <assert id="PEPPOL-T002-R009" flag="fatal" test="(cbc:ContractFolderID)">[PEPPOL-T002-R009] An Expression of Interest Confirmation MUST have a ContractFolderID.</assert>
            <assert id="PEPPOL-T002-R010" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T002-R010] An Expression of Interest Confirmation MUST have an issue date</assert>
            <assert id="PEPPOL-T002-R011" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T002-R011] An Expression of Interest Confirmation MUST have an issue time</assert>
            <assert id="PEPPOL-T002-R023" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLotReference/cbc:ID)) = count(cac:ProcurementProjectLotReference/cbc:ID)">[PEPPOL-T002-R023] Lot identifiers MUST be unique.</assert>
            <assert id="PEPPOL-T002-R024" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T002-R024] An Expression of Interest Confirmation MUST have a syntax identifier.</assert>
            <report id="PEPPOL-T002-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[PEPPOL-T002-S301] UBLExtensions SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of select="$syntaxError"/>[PEPPOL-T002-S305] ProfileExecutionID SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T002-S307] CopyIndicator SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[PEPPOL-T002-S308] UUID SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S310" flag="warning" test="(cbc:ContractName)"><value-of select="$syntaxError"/>[PEPPOL-T002-S310] ContractName SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S312" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[PEPPOL-T002-S312] Note SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S313" flag="warning" test="count(cac:ExpressionOfInterestDocumentReference) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T002-S313] Expression of Interest Document Reference SHOULD NOT be used more than once.</report>
            <report id="PEPPOL-T002-S320" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[PEPPOL-T002-S320] Signature SHOULD NOT be used.</report>
            <report id="PEPPOL-T002-S331" flag="warning" test="count(cac:ContractingParty) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T002-S331] ContractingParty SHOULD NOT be used more than once.</report>
            <report id="PEPPOL-T002-S329" flag="warning" test="(cac:ProcurementProject)"><value-of select="$syntaxError"/>[PEPPOL-T002-S329] ProcurementProject SHOULD NOT be used.</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cbc:UBLVersionID">
            <assert id="PEPPOL-T002-R029" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T002-R029] UBLVersionID value MUST be '2.2'</assert>
            <report id="PEPPOL-T002-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
        </rule>
                
        <rule context="ubl:ExpressionOfInterestResponse/cbc:CustomizationID">
            <assert id="PEPPOL-T002-R002" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t002:1.2'">[PEPPOL-T002-R002] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t002:1.2'</assert>
            <report id="PEPPOL-T002-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S303] CustomizationID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cbc:ProfileID">
            <assert id="PEPPOL-T002-R004" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p001:1.2'">[PEPPOL-T002-R004] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p001:1.2'</assert>
            <report id="PEPPOL-T002-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S304] ProfileID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cbc:ID">
            <assert id="PEPPOL-T002-R006" flag="fatal" test="./@schemeURI">[PEPPOL-T002-R006] An Expression of Interest Confirmation Identifier MUST have a schemeURI attribute.</assert>
            <assert id="PEPPOL-T002-R007" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T002-R007] schemeURI for Expression of Interest Confirmation Identifier MUST be 'urn:uuid'.</assert>
            <report id="PEPPOL-T002-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T002-S306] ID SHOULD NOT have any further attributes but schemeURI</report>
            <assert id="PEPPOL-T002-R008" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T002-R008] Expression of Interest Confirmation Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cbc:ContractFolderID">
            <report id="PEPPOL-T002-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S309] ContractFolderID SHOULD NOT have any attributes.</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cbc:IssueTime">
            <assert id="PEPPOL-T002-R012" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T002-R012] IssueTime MUST include timezone information.</assert>
            <assert id="PEPPOL-T002-R013" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T002-R013] IssueTime MUST have a granularity of seconds</assert>
        </rule>

        <rule context="ubl:ExpressionOfInterestResponse/cbc:TenderLanguageLocaleCode">
            <assert id="PEPPOL-T002-R018" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">[PEPPOL-T002-R018] TenderLanguageLocalCode MUST be a valid Language Code.</assert>
            <assert id="PEPPOL-T002-R019" flag="fatal" test="./@listID">[PEPPOL-T002-R019] TenderLanguageLocalCode MUST have a list identifier attribute.</assert>
            <assert id="PEPPOL-T002-R020" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">[PEPPOL-T002-R020] listID for TenderLanguageLocaleCode MUST be 'ISO639-1'.</assert>
            <report id="PEPPOL-T002-S311" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T002-S311] TenderLanguageLocaleCode SHOULD NOT have any further attributes but listID</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference">
            <assert id="PEPPOL-T002-S314" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[PEPPOL-T002-S314] Expression of Interest Document Reference SHOULD NOT contain any other elements but ID.</assert>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cac:ExpressionOfInterestDocumentReference/cbc:ID">
            <assert id="PEPPOL-T002-R025" flag="fatal" test="./@schemeURI">[PEPPOL-T002-R025] An Expression of Interest Document Reference Identifier MUST have a schemeURI attribute.</assert>
            <assert id="PEPPOL-T002-R026" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T002-R026] schemeURI for Expression of Interest Document Reference Identifier SHOULD be 'urn:uuid'.</assert>
            <assert id="PEPPOL-T002-R027" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T002-R027] Expression of Interest Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
            <report id="PEPPOL-T002-S318" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T002-S318] Expression of Interest Document Reference Identifier SHOULD NOT have any further attributes but schemeURI</report>
            <report id="PEPPOL-T002-R028" flag="fatal" test="normalize-space(.) = normalize-space(/ubl:ExpressionOfInterestResponse/cbc:ID)">[PEPPOL-T002-R028] Expression of Interest Document Reference Identifier MUSTS NOT be identical to the Expression of Interest Confirmation Identifier</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty">
            <report id="PEPPOL-T002-S321" flag="warning" test="(cac:EconomicOperatorRole)"><value-of select="$syntaxError"/>[PEPPOL-T002-S321] EconomicOperatorRole SHOULD NOT be used.</report>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cac:EconomicOperatorParty/cac:Party">
            <assert id="PEPPOL-T002-S322" flag="warning" test="count(./*)-count(./cbc:EndpointID)-count(./cac:PartyIdentification)= 0"><value-of select="$syntaxError"/>[PEPPOL-T002-S322] An EconomicOperatorParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification</assert>
            <assert id="PEPPOL-T002-R015" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T002-R015] An Expression of Interest Confirmation MUST identify the Economic Operator by its party identifier and its endpoint identifier.</assert>
        </rule>

        <rule context="ubl:ExpressionOfInterestResponse/cac:ContractingParty">
            <assert id="PEPPOL-T002-S323" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[PEPPOL-T002-S323] ContractingParty MUST NOT contain any other elements but cac:Party.</assert>
        </rule>
        
        <rule context="ubl:ExpressionOfInterestResponse/cac:ContractingParty/cac:Party">
            <assert id="PEPPOL-T002-S324" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>[PEPPOL-T002-S324] A ContractingParty/cac:Party element SHOULD NOT contain any other elements but EndpointID, PartyIdentification, PartyName</assert>
            <assert id="PEPPOL-T002-R014" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T002-R014] An Expression of Interest Confirmation MUST identify the Contracting Body by its party identifier and its endpoint identifier.</assert>
        </rule>    

        <rule context="cac:Party">
            <report id="PEPPOL-T002-S325" flag="warning" test="count(./cac:PartyIdentification) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T002-S325] PartyIdentification SHOULD NOT be used more than once</report>
            <report id="PEPPOL-T002-S326" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T002-S326] PartyName SHOULD NOT be used more than once</report>
        </rule>
        
        <rule context="cac:Party/cbc:EndpointID">
            <assert id="PEPPOL-T002-R021" flag="fatal" test="./@schemeID">[PEPPOL-T002-R021] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T002-R022" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T002-R022] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T002-S328" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T002-S328] EndpointID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="PEPPOL-T002-R016" flag="fatal" test="./@schemeID">[PEPPOL-T002-R016] A Party Identifier MUST have a scheme identifier attribute.</assert>
            <assert id="PEPPOL-T002-R017" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T002-R017] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
            <report id="PEPPOL-T002-S332" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T002-S332] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
        </rule>
        
        <rule context="cbc:Name">
            <report id="PEPPOL-T002-S327" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S327] cbc:Name SHOULD NOT have any further attributes</report>
        </rule>

        <rule context="cac:ProcurementProjectLotReference/cbc:ID">
            <report id="PEPPOL-T002-S330" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T002-S330] cac:ProcurementProjectLotReference/cbc:ID SHOULD NOT have any further attributes</report>
        </rule>
    </pattern>
