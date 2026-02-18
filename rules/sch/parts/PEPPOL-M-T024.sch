<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <let name="syntaxError" value="string('[PEPPOL-T024-S003] A Call For Tenders document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    <rule context="ubl:CallForTenders">
        <report id="PEPPOL-T024-S301" flag="warning" test="(ext:UBLExtensions)"><value-of select="$syntaxError"/>[PEPPOL-T024-S301] UBLExtensions SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S305" flag="warning" test="(cbc:ProfileExecutionID)"><value-of select="$syntaxError"/>[PEPPOL-T024-S305] ProfileExecutionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T024-S307] CopyIndicator SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S308" flag="warning" test="(cbc:UUID)"><value-of select="$syntaxError"/>[PEPPOL-T024-S308] UUID SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R001" flag="fatal" test="exists(cbc:UBLVersionID)">[PEPPOL-T024-R001] A Call For Tenders MUST have a syntax identifier.</assert>
        <report id="PEPPOL-T024-S310" flag="warning" test="(cbc:ApprovalDate)"><value-of select="$syntaxError"/>[PEPPOL-T024-S310] ApprovalDate SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R007" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T024-R007] A Call For Tenders MUST have an issue time.</assert>
        <assert id="PEPPOL-T024-R024" flag="fatal" test="count(distinct-values(cac:AdditionalDocumentReference/cbc:ID)) = count(cac:AdditionalDocumentReference/cbc:ID)">[PEPPOL-T024-R024] Additional Document Reference Identifiers MUST be unique.</assert>
        <assert id="PEPPOL-T024-R029" flag="fatal" test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[PEPPOL-T024-R029] Lot identifiers MUST be unique.</assert>
        <report id="PEPPOL-T024-S311" flag="warning" test="(cbc:Note)"><value-of select="$syntaxError"/>[PEPPOL-T024-S311] Note SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R038" flag="fatal" test="(cbc:VersionID)">[PEPPOL-T024-R038] A Call For Tenders MUST have a version identifier</assert>
        <report id="PEPPOL-T024-S313" flag="warning" test="(cbc:PreviousVersionID)"><value-of select="$syntaxError"/>[PEPPOL-T024-S313] PreviousVersionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S314" flag="warning" test="(cac:LegalDocumentReference)"><value-of select="$syntaxError"/>[PEPPOL-T024-S314] LegalDocumentReference SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S315" flag="warning" test="(cac:TechnicalDocumentReference)"><value-of select="$syntaxError"/>[PEPPOL-T024-S315] TechnicalDocumentReference SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S331" flag="warning" test="(cac:Signature)"><value-of select="$syntaxError"/>[PEPPOL-T024-S331] Signature SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S332" flag="warning" test="count(cac:ContractingParty) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S332] ContractingParty SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S345" flag="warning" test="(cac:OriginatorCustomerParty)"><value-of select="$syntaxError"/>[PEPPOL-T024-S345] OriginatorCustomerParty SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-S347" flag="warning" test="(cac:TenderingTerms)"><value-of select="$syntaxError"/>[PEPPOL-T024-S347] TenderingTerms SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S368" flag="warning" test="(cac:TenderingProcess)"><value-of select="$syntaxError"/>[PEPPOL-T024-S368] TenderingProcess SHOULD be used.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:UBLVersionID">
        
        <assert id="PEPPOL-T024-R040" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T024-R040] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T024-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:CustomizationID">
        <assert id="PEPPOL-T024-R002" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t004:1.2'">[PEPPOL-T024-R002] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t004:1.2'</assert>
        <report id="PEPPOL-T024-S303" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S303] CustomizationID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:ProfileID">
        <assert id="PEPPOL-T024-R003" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p002:1.2'">[PEPPOL-T024-R003] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p002:1.2'</assert>
        <report id="PEPPOL-T024-S304" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S304] ProfileID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:ID">
        <assert id="PEPPOL-T024-R004" flag="warning" test="./@schemeURI">[PEPPOL-T024-R004] A Call For Tenders Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T024-R005" flag="warning" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T024-R005] schemeURI for Call For Tenders Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T024-R006" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T024-R006] A Call For Tenders Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T024-S306" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S306] A Call For Tenders Identifier SHOULD NOT have any attributes but schemeURI</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:ContractFolderID">
        <report id="PEPPOL-T024-S309" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S309] ContractFolderID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:IssueTime">
        <assert id="PEPPOL-T024-R008" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T024-R008] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T024-R009" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T024-R009] IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cbc:VersionID">
        <report id="PEPPOL-T024-S312" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S312] VersionID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='REQ']">
        <assert id="PEPPOL-T024-S317" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:DocumentStatusCode)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S317] AdditionalDocumentReference for a Document with DocumentTypeCode='REQ' SHOULD NOT contain any elements but ID, DocumentTypeCode, DocumentStatusCode</assert>
        <assert id="PEPPOL-T024-R023" flag="fatal" test="normalize-space(./cbc:DocumentStatusCode) !='NR'">[PEPPOL-T024-R023] DocumentStatusCode 'NR' is NOT valid for an AdditionalDocumentReference with DocumentType 'REQ'</assert>
        <report id="PEPPOL-T024-S326" flag="warning" test="count(./cbc:DocumentDescription) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S326] DocumentDescription SHOULD NOT be used more than once when DocumentTypeCode = 'REQ'.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']">
        <assert id="PEPPOL-T024-R036" flag="fatal" test="(./cac:Attachment)">[PEPPOL-T024-R036] A Provided Document Reference MUST reference the provided document.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']/cbc:DocumentDescription">
        <assert id="PEPPOL-T024-R030" flag="fatal" test="/ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID = normalize-space(.)">[PEPPOL-T024-R030] DocumentDescription MUST be a valid Procurement Project Lot Identifier"/></assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference">
        <assert id="PEPPOL-T024-S316" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:IssueDate)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentStatusCode)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S316] AdditionalDocumentReference SHOULD NOT contain any elements but ID, IssueDate, DocumentTypeCode, LocaleCode, VersionID, DocumentStatusCode, DocumentDescription, Attachment.</assert>
        <assert id="PEPPOL-T024-S318" flag="warning" test="(./cbc:DocumentTypeCode)"><value-of select="$syntaxError"/>[PEPPOL-T024-S318] DocumentTypeCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S323" flag="warning" test="(./cbc:DocumentStatusCode)"><value-of select="$syntaxError"/>[PEPPOL-T024-S323] DocumentStatusCode SHOULD be used.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID">
        <report id="PEPPOL-T024-S319" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S319] Additional Document Reference Identifier SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T024-R017" flag="fatal" test="./@listID">[PEPPOL-T024-R017] DocumentTypeCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R018" flag="fatal" test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">[PEPPOL-T024-R018] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</assert>
        <assert id="PEPPOL-T024-R019" flag="fatal" test="matches(normalize-space(.),'^(PRO|REQ|916)$')">[PEPPOL-T024-R019] DocumentTypeCode MUST be one of 'PRO' or 'REQ' or '916'.</assert>
        <report id="PEPPOL-T024-S320" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S320] DocumentTypeCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T024-R014" flag="fatal" test="./@listID">[PEPPOL-T024-R014] LocaleCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R015" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">[PEPPOL-T024-R015] listID for LocaleCode MUST be 'ISO639-1'.</assert>
        <assert id="PEPPOL-T024-R016" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">[PEPPOL-T024-R016] LocalCode MUST be a valid Language Code.</assert>
        <report id="PEPPOL-T024-S321" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S321] LocaleCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID">
        <report id="PEPPOL-T024-S322" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S322] Additional Document Reference VersionIdentifier SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode">
        <assert id="PEPPOL-T024-R020" flag="fatal" test="./@listID">[PEPPOL-T024-R020] DocumentStatusCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R021" flag="fatal" test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentStatusType'">[PEPPOL-T024-R021] listID for DocumentStatusCode MUST be 'urn:eu:esens:cenbii:documentStatusType'.</assert>
        <assert id="PEPPOL-T024-R022" flag="fatal" test="matches(normalize-space(.),'^(NR|RWOS|RWAS|RWQS)$')">[PEPPOL-T024-R022] DocumentStatusCode MUST be one of NR,RWOS, RWAS ,RWQS</assert>
        <report id="PEPPOL-T024-S324" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S324] DocumentStatusCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription">
        <report id="PEPPOL-T024-S325" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S325] DocumentDescription SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment">
        <assert id="PEPPOL-T024-S328" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S328] Attachment SHOULD NOT contain any element but ExternalReference</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
        <assert id="PEPPOL-T024-S329" flag="warning" test="count(./*)-count(./cbc:URI)-count(./cbc:MimeCode)-count(./cbc:FileName)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S329] ExternalReference SHOULD NOT contain any element but URI, MimeCode, FileName</assert>
        <assert id="PEPPOL-T024-R035" flag="fatal" test="(./cbc:URI) or (./cbc:FileName)">[PEPPOL-T024-R035] ExternalReference MUST include either URI or FileName</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
        <report id="PEPPOL-T024-S330" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S330] URI SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
        <report id="PEPPOL-T024-S395" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S395] MimeCode SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
        <report id="PEPPOL-T024-S396" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S396] FileName SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty">
        <assert id="PEPPOL-T024-S333" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S333] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T024-S334" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0"><value-of select="$syntaxError"/>[PEPPOL-T024-S334] A ContractingParty/cac:Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
        <assert id="PEPPOL-T024-S336" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S336] PartyIdentification SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T024-S338" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S338] PartyName SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S340" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S340] PartyLegalEntity SHOULD NOT be used more than once.</report>
        <assert id="PEPPOL-T024-R034" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T024-R034] A Call for Tenders MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ReceiverParty">
        <assert id="PEPPOL-T024-S500" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0"><value-of select="$syntaxError"/>[PEPPOL-T024-S334] A cac:ReceivingParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
        <assert id="PEPPOL-T024-S501" flag="warning" test="count(./cac:PartyIdentification) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-500] PartyIdentification SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T024-S502" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S501] PartyName SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S503" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S502] PartyLegalEntity SHOULD NOT be used more than once.</report>
        <assert id="PEPPOL-T024-R534" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T024-R534] A Call for Tenders MUST identify the Economic Operator / Receiving Party by its party and endpoint identifiers.</assert>
    </rule>
    
    <rule context="cbc:EndpointID">
        <assert id="PEPPOL-T024-R012" flag="fatal" test="./@schemeID">[PEPPOL-T024-R012] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T024-R013" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T024-R013] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T024-S335" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S335] EndpointID SHOULD NOT have any further attributes but schemeID</report>
    </rule>
    
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T024-R010" flag="fatal" test="./@schemeID">[PEPPOL-T024-R010] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T024-R011" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T024-R011] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T024-S337" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S337] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
    </rule>
    
    <rule context="cbc:Name">
        <report id="PEPPOL-T024-S339" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S339] Name SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="cbc:IndustryClassificationCode">
        <assert id="PEPPOL-T024-R041" flags="fatal" test="./@listID">[PEPPOL-T024-R041] The Codelist used to define the receiver's economic operator role in this tender MUST be named by using the attribute listID and the ID has to be /"tendererRole/".</assert>
        <report id="PEPPOL-T024-S360" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S360] cbc:IndustryClassificationCode SHOULD NOT have any further attributes but listID</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity">
        <assert id="PEPPOL-T024-S341" flag="warning" test="count(./*)-count(./cac:RegistrationAddress)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S341] PartyLegalEntity SHOULD NOT contain any elements but cac:RegistrationAddress.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
        <assert id="PEPPOL-T024-S342" flag="warning" test="count(./*)-count(./cac:Country)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S342] RegistrationAddress SHOULD NOT contain any elements but cac:Country.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
        <assert id="PEPPOL-T024-S343" flag="warning" test="count(./*)-count(./cbc:IdentificationCode)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S343] Country SHOULD NOT contain any elements but IdentificationCode.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
        <report id="PEPPOL-T024-S344" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S344] IdentificationCode SHOULD NOT have any attributes but listID,</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms">
        <assert id="PEPPOL-T024-S348" flag="warning" test="count(./*)-count(./cbc:MaximumVariantQuantity)-count(./cbc:VariantConstraintIndicator)-count(./cbc:Note)-count(./cbc:AdditionalConditions)-count(./cac:ProcurementLegislationDocumentReference)-count(./cac:CallForTendersDocumentReference)-count(./cac:TenderRecipientParty)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S348] TenderingTerms SHOULD NOT contain any element but MaximumVariantQuantity, VariantConstraintIndicator, Note, AdditionalConditions, ProcurementLegislationDocumentReference, CallForTendersDocumentReference, TenderRecipientParty.</assert>
        <assert id="PEPPOL-T024-S353" flag="warning" test="(./cbc:VariantConstraintIndicator)"><value-of select="$syntaxError"/>[PEPPOL-T024-S353] VariantConstraintIndicator SHOULD be used.</assert>
        <report id="PEPPOL-T024-S354" flag="warning" test="count(./cbc:Note) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S354] Note SHOULD NOT be used more than once</report>
        <report id="PEPPOL-T024-S358" flag="warning" test="count(./cbc:AdditionalConditions) &gt; 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S358] AdditionalConditions SHOULD NOT be used more than once</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity">
        <assert id="PEPPOL-T024-S349" flag="warning" test="matches(normalize-space(.),'^\d+$')"><value-of select="$syntaxError"/>[PEPPOL-T024-S349] MaximumVariantQuantity SHOULD be expressed as an integer value.</assert>
        <report id="PEPPOL-T024-S350" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S350] MaximumVariantQuantity SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='false']">
        <assert id="PEPPOL-T024-S351" flag="warning" test="count(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)=0 or normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)='0'"><value-of select="$syntaxError"/>[PEPPOL-T024-S351] MaximumVariantQuantity SHOULD NOT be used or MUST be equal to 0 when VariantConstraintIndicator is set to false.</assert>
    </rule>
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='true']">
        <assert id="PEPPOL-T024-R032" flag="fatal" test="number(normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)) &gt; 0">[PEPPOL-T024-R032] MaximumVariantQuantity MUST be greater than 0 when VariantConstraintIndicator is set to true.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:Note">
        <assert id="PEPPOL-T024-S355" flag="warning" test="matches(normalize-space(.),'^\d+$')"><value-of select="$syntaxError"/>[PEPPOL-T024-S355] Note SHOULD be expressed as an integer value when used.</assert>
        <report id="PEPPOL-T024-S357" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S357] Note SHOULD NOT contain any attributes.</report>
        <assert id="PEPPOL-T024-R031" flag="fatal" test="normalize-space(/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode)='POSTAL'">[PEPPOL-T024-R031] Note MUST only be used when Submission Method Code equals to POSTAL</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions">
        <assert id="PEPPOL-T024-R033" flag="fatal" test="matches(normalize-space(.),'^(WOS|WAS|WQS)$')">[PEPPOL-T024-R033] AdditionalConditions value MUST be one of 'WOS', 'WAS, 'WQS'.</assert>
        <report id="PEPPOL-T024-S360" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S360] AdditionalConditions SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference">
        <assert id="PEPPOL-T024-S361" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentDescription)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S361] ProcurementLegislationDocumentReference SHOULD NOT contain any elements but ID, DocumentDescription.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID">
        <report id="PEPPOL-T024-S362" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S362] ProcurementLegislationDocumentReference Identifier SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription">
        <report id="PEPPOL-T024-S363" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S363] ProcurementLegislationDocumentReference DocumentDescription SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference">
        <assert id="PEPPOL-T024-S364" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S364] CallForTendersDocumentReference SHOULD NOT contain any elements but ID</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID">
        <assert id="PEPPOL-T024-R025" flag="fatal" test="./@schemeURI">[PEPPOL-T024-R025] A Call For Tenders Document Reference Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T024-R026" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T024-R026] schemeURI for Call For Tenders Document Reference Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T024-R027" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T024-R027] A Call For Tenders Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T024-S365" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S365] A Call For Tenders Document Reference Identifier SHOULD NOT have any attributes but schemeURI</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty">
        <assert id="PEPPOL-T024-S367" flag="warning" test="count(./*)-count(./cbc:EndpointID)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S367] TenderRecipientParty SHOULD NOT contain any elements but EndpointID</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess">
        <assert id="PEPPOL-T024-S369" flag="warning" test="count(./*)-count(./cbc:ProcedureCode)-count(./cbc:ContractingSystemCode)-count(./cbc:SubmissionMethodCode)-count(./cac:TenderSubmissionDeadlinePeriod)-count(./cac:ParticipationRequestReceptionPeriod)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S369] TenderingProcess SHOULD NOT contain any elements but ProcedureCode, ContractingSystemCode, SubmissionMethodCode, TenderSubmissionDeadlinePeriod, ParticipationRequestReceptionPeriod.</assert>
        <assert id="PEPPOL-T024-S370" flag="warning" test="(./cbc:ProcedureCode)"><value-of select="$syntaxError"/>[PEPPOL-T024-S370] ProcedureCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S373" flag="warning" test="(./cac:TenderSubmissionDeadlinePeriod)"><value-of select="$syntaxError"/>[PEPPOL-T024-S373] TenderSubmissionDeadlinePeriod SHOULD be used.</assert>
        <assert id="PEPPOL-T024-R037" flag="fatal" test="(cbc:ProcedureCode = '1' and not(exists(cac:ParticipationRequestReceptionPeriod))) or (cbc:ProcedureCode!='1')">[PEPPOL-T024-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode">
        <report id="PEPPOL-T024-S371" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S371] ProcedureCode SHOULD NOT have any attributes but listID.</report>
        <assert id="PEPPOL-T024-R037" flag="fatal" test="(cbc:ProcedureCode = '1' and not(exists(cac:ParticipationRequestReceptionPeriod))) or (cbc:ProcedureCode!='1')">[PEPPOL-T024-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode">
        <report id="PEPPOL-T024-S397" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S397] ContractingSystemCode SHOULD NOT have any attributes but listID.</report>
        <assert id="PEPPOL-T024-R039" flag="fatal" test="not (cbc:ContractingSystemCode in ('1', '2', '3')">[PEPPOL-T024-R039] A Call For Tender is only allowed to use une of the following ContractSystemCodes: 'Public Contract', 'Establishment of a Framework agreement' or 'Setting up a Dynamic Purchasing System'.</assert>        </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode">
        <report id="PEPPOL-T024-S372" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S372] SubmissionMethodCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod">
        <assert id="PEPPOL-T024-S374" flag="warning" test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S374] TenderSubmissionDeadlinePeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
        <assert id="PEPPOL-T024-S375" flag="warning" test="(./cbc:EndDate)"><value-of select="$syntaxError"/>[PEPPOL-T024-S375] TenderSubmissionDeadlinePeriod EndDate SHOULD be used.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod">
        <assert id="PEPPOL-T024-S376" flag="warning" test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S376] ParticipationRequestReceptionPeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
        <!--<assert id="PEPPOL-T024-S377" flag="warning" test="(./cbc:EndDate)"><value-of select="$syntaxError"/>[PEPPOL-T024-S377] ParticipationRequestReceptionPeriod EndDate SHOULD be used.</assert>
        -->
    </rule>
    
    <rule context="cbc:EndTime">
        <assert id="PEPPOL-T024-R028" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T024-R028] EndTime MUST include timezone information.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject">
        <assert id="PEPPOL-T024-S378" flag="warning" test="count(./*)-count(./cbc:Name)-count(./cbc:Description)-count(./cbc:ProcurementTypeCode)-count(./cac:MainCommodityClassification)-count(./cac:AdditionalCommodityClassification)-count(./cac:RealizedLocation)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S378] ProcurementProject SHOULD NOT contain any elements but Name, Description, ProcurementTypeCode, MainCommodityClassification, AdditionalCommodityClassification, RealizedLocation.</assert>
        <assert id="PEPPOL-T024-S379" flag="warning" test="count(./cbc:Name) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S379] ProcurementProject Name SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S380" flag="warning" test="count(./cbc:Description) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S380] ProcurementProject Description SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S382" flag="warning" test="(./cbc:ProcurementTypeCode)"><value-of select="$syntaxError"/>[PEPPOL-T024-S382] ProcurementTypeCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S384" flag="warning" test="count(./cac:MainCommodityClassification) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S384] ProcurementProject MainCommodityClassification SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S388" flag="warning" test="count(./cac:RealizedLocation) &gt; 0"><value-of select="$syntaxError"/>[PEPPOL-T024-S388] ProcurementProject RealizedLocation SHOULD be used at least once.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:Description">
        <report id="PEPPOL-T024-S381" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S381] ProcurementProject Description SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode">
        <report id="PEPPOL-T024-S383" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S383] ProcurementTypeCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification">
        <assert id="PEPPOL-T024-S385" flag="warning" test="count(./*)-count(./cbc:ItemClassificationCode)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S385] MainCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification">
        <assert id="PEPPOL-T024-S386" flag="warning" test="count(./*)-count(./cbc:ItemClassificationCode)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S386] AdditionalCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
    </rule>
    
    <rule context="cbc:ItemClassificationCode">
        <report id="PEPPOL-T024-S387" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S387] ItemClassificationCode SHOULD NOT have any attributes but listID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation">
        <assert id="PEPPOL-T024-S389" flag="warning" test="count(./*)-count(./cbc:ID)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S389] RealizedLocation SHOULD NOT contain any elements but ID.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID">
        <report id="PEPPOL-T024-S390" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>[PEPPOL-T024-S390] cac:RealizedLocation/cbc:ID SHOULD NOT have any attributes but schemeID.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T024-S391" flag="warning" test="count(./*)-count(./cbc:ID)-count(./cac:ProcurementProject)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S391] ProcurementProjectLot SHOULD NOT contain any elements but ID, ProcurementProject.</assert>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID">
        <report id="PEPPOL-T024-S392" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T024-S392] ProcurementProjectLot Identifier SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject">
        <assert id="PEPPOL-T024-S393" flag="warning" test="count(./*)-count(./cbc:Name)=0"><value-of select="$syntaxError"/>[PEPPOL-T024-S393] ProcurementProjectLot ProcurementProject SHOULD NOT contain any elements but Name.</assert>
        <assert id="PEPPOL-T024-S394" flag="warning" test="count(./cbc:Name) = 1"><value-of select="$syntaxError"/>[PEPPOL-T024-S394] ProcurementProjectLot ProcurementProject Name SHOULD   be used exactly once.</assert>
    </rule>
    
    <rule context="cbc:ProcedureCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' comp-dial comp-tend innovation neg-w-call neg-wo-call open oth-mult oth-single restricted ',concat(' ',normalize-space(.),' ') ) ) )"
                flag="fatal" id="CL-T83-R001">[CL-T83-R001]-A procedure type MUST be one of the following:  comp-dial, comp-tend, innovation, neg-w-call, neg-wo-call, open, oth-mult, oth-single, restricted</assert>
    </rule>
    
    <rule context="cbc:ProcurementTypeCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 4 5 6 9 Z ',concat(' ',normalize-space(.),' ') ) ) )"
                flag="fatal" id="CL-T83-R002">[CL-T83-R002]-A procurement project type MUST be one of the following: 1, 2, 4, 5, 6, 9, Z</assert>
    </rule>
    
    <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                flag="fatal" id="CL-T83-R005">[CL-T83-R005]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
    </rule>
</pattern>
