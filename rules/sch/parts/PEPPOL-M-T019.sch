<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    
    <let name="syntaxError"
        value="string('A Qualification document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    
    <rule context="/ubl:TendererQualification">
        <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T019-R002">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T019-R003">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T019-R004">Element 'cbc:ProfileID' MUST be provided.</assert>
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T019-R005">Element 'cbc:ID' MUST be provided.</assert>
        <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T019-R006">Element 'cbc:ContractFolderID' MUST be provided.</assert>
        <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T019-R007">Element 'cbc:IssueDate' MUST be provided.</assert>
        <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T019-R008">Element 'cbc:IssueTime' MUST be provided.</assert>
        <assert test="cbc:VersionID" flag="fatal" id="PEPPOL-T019-R009">Element 'cbc:VersionID' MUST be provided.</assert>
        <assert test="cac:TendererPartyQualification" flag="fatal" id="PEPPOL-T019-R010">Element 'cac:TendererPartyQualification' MUST be provided.</assert>
        <assert test="cac:ContractingParty" flag="fatal" id="PEPPOL-T019-R011">Element 'cac:ContractingParty' MUST be provided.</assert>
        <assert test="cac:AdditionalDocumentReference" flag="fatal" id="PEPPOL-T019-R012">Element 'cac:AdditionalDocumentReference' MUST be provided.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:UBLVersionID">
        <assert id="PEPPOL-T019-R013" flag="fatal" test="normalize-space(.) = '2.2'">UBLVersionID value MUST be '2.2'.</assert>
        <assert id="PEPPOL-T019-R014" flag="warning" test="./@*"><value-of select="$syntaxError"/>UBLVersionID SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:CustomizationID">
        <assert id="PEPPOL-T019-R015" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t019:1.1'">CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t019:1.1'</assert>
        <assert id="PEPPOL-T019-R016" flag="warning" test="./@*"><value-of select="$syntaxError"/>CustomizationID SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:ProfileID">
        <assert id="PEPPOL-T019-R017" flag="fatal" test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p011:1.1'">ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p011:1.1'</assert>
        <assert id="PEPPOL-T019-R018" flag="warning" test="./@*"><value-of select="$syntaxError"/>ProfileID SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:ID">
        <assert id="PEPPOL-T019-R019" flag="fatal" test="./@schemeURI">A Submit Tender Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T019-R020" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">schemeURI for Submit Tender Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T019-R021" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>A Submit Tender Identifier SHOULD NOT have any attributes but schemeURI</assert>
        <assert id="PEPPOL-T019-R022" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">A Submit Tender Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:ContractFolderID">
        <assert id="PEPPOL-T019-R023" flag="warning" test="./@*"><value-of select="$syntaxError"/>ContractFolderID SHOULD NOT contain any attributes.</assert>
        <assert id="PEPPOL-T019-R024" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">The ContractFolderID MUST be expressed in a UUID syntax (RFC 4122).</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:IssueTime">
        <assert id="PEPPOL-T019-R025" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cbc:VersionID">
        <assert id="PEPPOL-T019-R026" flag="warning" test="./@*"><value-of select="$syntaxError"/>VersionID SHOULD NOT have any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference">
        <assert id="PEPPOL-T019-R027" flag="warning" test="count(./cbc:DocumentDescription) &gt; 1"><value-of select="$syntaxError"/>DocumentDescription SHOULD NOT be used more than once.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:ID">
        <assert id="PEPPOL-T019-R028" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">Identifier for a Qualification Reference document MUST be expressed in a UUID syntax (RFC 4122).</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T019-R029" flag="fatal" test="normalize-space(./@listID)='UNCL1001'">listID for DocumentTypeCode MUST be 'UNCL1001'.</assert>
        <assert id="PEPPOL-T019-R030" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>DocumentTypeCode SHOULD NOT have any attributes but listID</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:XPath">
        <assert id="PEPPOL-T019-R031" flag="warning" test="./@*"><value-of select="$syntaxError"/>XPath SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T019-R032" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">listID for LocaleCode MUST be 'ISO639-1'.</assert>
        <assert id="PEPPOL-T019-R033" flag="fatal" test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">LocalCode MUST be a valid Language Code.</assert>
        <assert id="PEPPOL-T019-R034" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>LocaleCode SHOULD NOT have any attributes but listID.</assert>
    </rule>
    
    <rule context="ubl:TenderTendererQualification/cac:AdditionalDocumentReference/cbc:VersionID">
        <assert id="PEPPOL-T019-R035" flag="warning" test="./@*"><value-of select="$syntaxError"/>VersionID SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:DocumentDescription">
        <assert id="PEPPOL-T019-R036" flag="warning" test="./@*"><value-of select="$syntaxError"/>DocumentDescription SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment">
        <assert id="PEPPOL-T019-R037" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0"><value-of select="$syntaxError"/>Attachment SHOULD NOT contain any elements but ExternalReference</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
        <assert id="PEPPOL-T019-R038" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">URI for a Qualification Reference external reference attachment MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <assert id="PEPPOL-T019-R039" flag="warning" test="./@*"><value-of select="$syntaxError"/>URI SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
        <assert id="PEPPOL-T019-R040" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</assert>
        <assert id="PEPPOL-T019-R041" flag="warning" test="./@*"><value-of select="$syntaxError"/>DocumentHash SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
        <assert id="PEPPOL-T019-R042" flag="fatal" test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</assert>
        <assert id="PEPPOL-T019-R043" flag="warning" test="./@*"><value-of select="$syntaxError"/>HashAlgorithmMethod SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
        <assert id="PEPPOL-T019-R044" flag="warning" test="./@*"><value-of select="$syntaxError"/>MimeCode SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
        <assert id="PEPPOL-T019-R045" flag="warning" test="./@*"><value-of select="$syntaxError"/>FileNAme SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description">
        <assert id="PEPPOL-T019-R046" flag="warning" test="./@*"><value-of select="$syntaxError"/>Description SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:MainQualifyingParty/cac:Party">
        <assert id="PEPPOL-T019-R047" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Qualification MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:ContractingParty">
        <assert id="PEPPOL-T019-R048" flag="warning" test="count(./*)-count(./cac:Party)=0"><value-of select="$syntaxError"/>ContractingParty SHOULD NOT contain any elements but Party.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T019-R049" flag="warning" test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0"><value-of select="$syntaxError"/>ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
        <assert id="PEPPOL-T019-R050" flag="warning" test="count(./cac:PartyName) &gt; 1"><value-of select="$syntaxError"/>ContractingParty/Party/PartyName SHOULD NOT be used more than once.</assert>
        <assert id="PEPPOL-T019-R051" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">The Contracting Authority MUST be identified by its party and endpoint identifiers.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T019-R052" flag="warning" test="count(./*)-count(./cbc:ID)= 0"><value-of select="$syntaxError"/>ProcurementProjectLot SHOULD NOT contain any elements but ID</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:ProcurementProjectLot/cbc:ID">
        <assert id="PEPPOL-T019-R053" flag="warning" test="./@*"><value-of select="$syntaxError"/>Procurement Project Lot Identifier SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T019-R054" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T019-R055" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <assert id="PEPPOL-T019-R056" flag="warning" test="./@*[not(name()='schemeID')]"><value-of select="$syntaxError"/>cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</assert>
    </rule>
    
    <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T019-R057" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="cbc:Name">
        <assert id="PEPPOL-T019-R058" flag="warning" test="./@*"><value-of select="$syntaxError"/>Name SHOULD NOT contain any attributes.</assert>
    </rule>
    
    <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:MainQualifyingParty/cac:PostalAddress
        | ubl:TendererQualification/cac:TendererPartyQualification/cac:AdditionalQualifyingParty/cac:Party/cac:PostalAddress">
        <assert id="PEPPOL-T019-R059" flag="warning" test="count(./*)-count(./cbc:StreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0"><value-of select="$syntaxError"/>PostalAddress SHOULD NOT contain any elements but StreetName, CityName, PostalZone, CountrySubentity, Country</assert>
    </rule>
    
    <rule context="cbc:StreetName">
        <assert id="PEPPOL-T019-R060" flag="warning" test="./@*"><value-of select="$syntaxError"/>StreetName SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cbc:CityName">
        <assert id="PEPPOL-T019-R061" flag="warning" test="./@*"><value-of select="$syntaxError"/>CityName SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cbc:PostalZone">
        <assert id="PEPPOL-T019-R062" flag="warning" test="./@*"><value-of select="$syntaxError"/>PostalZone SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cbc:CountrySubentity">
        <assert id="PEPPOL-T019-R063" flag="warning" test="./@*"><value-of select="$syntaxError"/>CountrySubentity SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cac:Country">
        <assert id="PEPPOL-T019-R064" flag="warning" test="count(./*)-count(./cbc:IdentificationCode)=0"><value-of select="$syntaxError"/>Country SHOULD NOT contain any elements but IdentificationCode.</assert>
    </rule>
    
    <rule context="cac:Country/cbc:IdentificationCode">
        <assert id="PEPPOL-T019-R065" flag="warning" test="./@*[not(name()='listID')]"><value-of select="$syntaxError"/>Country Identification Code SHOULD NOT contain any attributes but listID</assert>
        <assert id="PEPPOL-T019-R066" flag="fatal" test="normalize-space(./@listID)='ISO3166-1:Alpha2'">listID for IdentificationCode MUST be 'ISO3166-1:Alpha2'.</assert>
    </rule>
    
    <rule context="cac:PartyLegalEntity/cbc:CompanyLegalForm">
        <assert id="PEPPOL-T019-R067" flag="warning" test="./@*"><value-of select="$syntaxError"/>CompanyLegalForm SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cac:Contact">
        <assert id="PEPPOL-T019-R068" flag="warning" test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0"><value-of select="$syntaxError"/>Contact SHOULD NOT contain any elements but Telephone, Telefax, ElectronicMail, Name.</assert>
    </rule>
    
    <rule context="cbc:Telephone">
        <assert id="PEPPOL-T019-R069" flag="warning" test="./@*"><value-of select="$syntaxError"/>Telephone SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cbc:Telefax">
        <assert id="PEPPOL-T019-R070" flag="warning" test="./@*"><value-of select="$syntaxError"/>Telefax SHOULD NOT contain any attributes</assert>
    </rule>
    
    <rule context="cbc:ElectronicMail">
        <assert id="PEPPOL-T019-R071" flag="warning" test="./@*"><value-of select="$syntaxError"/>ElectronicMail SHOULD NOT contain any attributes</assert>
    </rule>
	<rule context="*">
            <assert id="PEPPOL-T019-R001" flag="fatal" test="not(normalize-space(.) = '' and not(*))">A Qualification document MUST NOT contain empty elements.
            </assert>
        </rule>
</pattern>
