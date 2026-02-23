<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    <let name="syntaxError" value="string('[PEPPOL-T005-S003] A Tender document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    <rule context="ubl:Tender">
        <assert id="PEPPOL-T005-R001" flag="fatal" test="exists(cbc:UBLVersionID)">[PEPPOL-T005-R001] A Tender MUST have a syntax identifier.</assert>
        <assert id="PEPPOL-T005-R002" flag="fatal" test="cbc:UBLVersionID = '2.2'">[PEPPOL-T005-R002] UBLVersionID value MUST be '2.2'</assert>
        <assert id="PEPPOL-T005-R003" flag="fatal" test="exists(cbc:CustomizationID)">[PEPPOL-T005-R003] A Tender MUST have a customization identifier.</assert>
        <assert id="PEPPOL-T005-R004" flag="fatal" test="exists(cbc:ProfileID)">[PEPPOL-T005-R004] A Tender MUST have a profile identifier.</assert>
        <assert id="PEPPOL-T005-R005" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R005] A Tender MUST have an identifier.</assert>
        <assert id="PEPPOL-T005-R006" flag="fatal" test="exists(cbc:IssueTime)">[PEPPOL-T005-R006] A Tender MUST have an issue time.</assert>
        <assert id="PEPPOL-T005-R007" flag="fatal" test="exists(cbc:IssueDate)">[PEPPOL-T005-R007] A Tender MUST have an issue date.</assert>
        <assert id="PEPPOL-T005-R008" flag="fatal" test="exists(cac:TendererParty)">[PEPPOL-T005-R008] A Tender MUST identify the Tenderer Party.</assert>
        <assert id="PEPPOL-T005-R009" flag="fatal" test="exists(cac:ContractingParty)">[PEPPOL-T005-R009] A Tender MUST identify the Contracting Party.</assert>
    </rule>
    
    <rule context="ubl:Tender/cbc:UBLVersionID">
        <report id="PEPPOL-T005-S010" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T005-S010] UBLVersionID SHOULD NOT contain any attributes.</report>
    </rule>
    
    <rule context="ubl:Tender/cbc:CustomizationID">
        <assert id="PEPPOL-T005-R010" flag="fatal" test="normalize-space(.) = ('urn:fdc:peppol.eu:prac:trns:t005:1.2','urn:fdc:peppol.eu:prac:trns:t005:1.3')">[PEPPOL-T005-R010] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t005:1.2' or 'urn:fdc:peppol.eu:prac:trns:t005:1.3'</assert>
        <report id="PEPPOL-T005-S011" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T005-S011] CustomizationID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:Tender/cbc:ProfileID">
        <assert id="PEPPOL-T005-R011" flag="fatal" test="normalize-space(.) = ('urn:fdc:peppol.eu:prac:bis:p003:1.2','urn:fdc:peppol.eu:prac:bis:p003:1.3')">[PEPPOL-T005-R011] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p003:1.2' or 'urn:fdc:peppol.eu:prac:bis:p003:1.3'</assert>
        <report id="PEPPOL-T005-S012" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T005-S012] ProfileID SHOULD NOT have any attributes.</report>
    </rule>
    
    <rule context="ubl:Tender/cbc:ID">
        <assert id="PEPPOL-T005-R012" flag="warning" test="./@schemeURI">[PEPPOL-T005-R012] A Tender Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T005-R013" flag="warning" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T005-R013] schemeURI for Tender Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T005-R014" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T005-R014] A Tender Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T005-S013" flag="warning" test="./@*[not(name()='schemeURI')]"><value-of select="$syntaxError"/>[PEPPOL-T005-S013] A Tender Identifier SHOULD NOT have any attributes but schemeURI</report>
    </rule>
    
    <rule context="ubl:Tender/cbc:IssueTime">
        <assert id="PEPPOL-T005-R015" flag="fatal" test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T005-R015] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T005-R016" flag="fatal" test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T005-R016] IssueTime MUST have a granularity of seconds</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:DocumentReference">
        <assert id="PEPPOL-T005-R017" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R017] A Document Reference MUST have an identifier</assert>
        <assert id="PEPPOL-T005-R018" flag="fatal" test="exists(cbc:DocumentTypeCode)">[PEPPOL-T005-R018] A Document Reference MUST have a type code</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T005-R019" flag="fatal" test="./@listID">[PEPPOL-T005-R019] DocumentTypeCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R020" flag="fatal" test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">[PEPPOL-T005-R020] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:DocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T005-R021" flag="fatal" test="./@listID">[PEPPOL-T005-R021] LocaleCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R022" flag="fatal" test="normalize-space(./@listID)='ISO639-1'">[PEPPOL-T005-R022] listID for LocaleCode MUST be 'ISO639-1'.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment">
        <assert id="PEPPOL-T005-R023" flag="fatal" test="exists(cbc:DocumentHash)">[PEPPOL-T005-R023] An Attachment MUST have a document hash</assert>
        <assert id="PEPPOL-T005-R024" flag="fatal" test="exists(cbc:HashAlgorithmMethod)">[PEPPOL-T005-R024] An Attachment MUST have a hash algorithm method</assert>
        <assert id="PEPPOL-T005-R025" flag="fatal" test="normalize-space(cbc:HashAlgorithmMethod) = 'http://www.w3.org/2001/04/xmlenc#sha256'">[PEPPOL-T005-R025] Hash Algorithm MUST be SHA-256 (http://www.w3.org/2001/04/xmlenc#sha256)</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference">
        <assert id="PEPPOL-T005-R026" flag="fatal" test="exists(cbc:URI)">[PEPPOL-T005-R026] An External Reference MUST have a URI</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TendererParty">
        <assert id="PEPPOL-T005-R027" flag="fatal" test="exists(cbc:EndpointID)">[PEPPOL-T005-R027] A Tenderer Party MUST have an endpoint identifier.</assert>
        <assert id="PEPPOL-T005-R028" flag="fatal" test="exists(cac:PartyIdentification)">[PEPPOL-T005-R028] A Tenderer Party MUST have a party identification.</assert>
        <assert id="PEPPOL-T005-R029" flag="fatal" test="exists(cac:PartyName)">[PEPPOL-T005-R029] A Tenderer Party MUST have a party name.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TendererParty/cbc:EndpointID">
        <assert id="PEPPOL-T005-R030" flag="fatal" test="./@schemeID">[PEPPOL-T005-R030] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R031" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T005-R031] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T005-R032" flag="fatal" test="./@schemeID">[PEPPOL-T005-R032] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R033" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T005-R033] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress">
        <assert id="PEPPOL-T005-R034" flag="fatal" test="exists(cac:Country/cbc:IdentificationCode)">[PEPPOL-T005-R034] A Tenderer Postal Address MUST have a country.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
        <assert id="PEPPOL-T005-R035" flag="fatal" test="./@listID">[PEPPOL-T005-R035] Country IdentificationCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R036" flag="fatal" test="normalize-space(./@listID)='ISO3166-1:Alpha2'">[PEPPOL-T005-R036] listID for Country IdentificationCode MUST be 'ISO3166-1:Alpha2'.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TendererParty/cac:PartyLegalEntity">
        <assert id="PEPPOL-T005-R037" flag="fatal" test="exists(cac:RegistrationAddress/cac:Country/cbc:IdentificationCode)">[PEPPOL-T005-R037] A Tenderer Party Legal Entity MUST have a country.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:ContractingParty">
        <assert id="PEPPOL-T005-R038" flag="fatal" test="exists(cac:PartyIdentification)">[PEPPOL-T005-R038] A Contracting Party MUST have a party identification.</assert>
        <assert id="PEPPOL-T005-R039" flag="fatal" test="exists(cbc:EndpointID)">[PEPPOL-T005-R039] A Contracting Party MUST have an endpoint identifier.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:ContractingParty/cbc:EndpointID">
        <assert id="PEPPOL-T005-R040" flag="fatal" test="./@schemeID">[PEPPOL-T005-R040] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R041" flag="fatal" test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T005-R041] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TenderedProject">
        <assert id="PEPPOL-T005-R042" flag="fatal" test="exists(cac:ProcurementProjectLot)">[PEPPOL-T005-R042] A Tendered Project MUST include at least one Procurement Project Lot.</assert>
    </rule>
    
    <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T005-R043" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R043] A Procurement Project Lot MUST have an identifier.</assert>
    </rule>
    
    <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                flag="fatal" id="CL-T006-R001">[CL-T006-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
    </rule>
    
    <rule context="cbc:DocumentTypeCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 9 13 310 311 916 ',concat(' ',normalize-space(.),' ') ) ) )"
                flag="fatal" id="CL-T006-R002">[CL-T006-R002]-A document type code MUST be one of the following values: 9, 13, 310, 311, 916</assert>
    </rule>
</pattern>


