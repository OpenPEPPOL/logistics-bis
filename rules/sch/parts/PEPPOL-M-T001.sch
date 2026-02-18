<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
    <let name="syntaxError"
        value="string('[PEPPOL-T001-S003] An Expression of Interest SHOULD only consist of elements and attributes described in the syntax mapping. - ')"/>
    <rule context="ubl:ExpressionOfInterestRequest">
        <assert id="PEPPOL-T001-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T001-R001]
            An Expression of Interest MUST have a customization identifier</assert>
        <assert id="PEPPOL-T001-R003" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T001-R003] An
            Expression of Interest MUST have a profile identifier</assert>
        <assert id="PEPPOL-T001-R005" flag="fatal" test="(cbc:ID)">[PEPPOL-T001-R005] An
            Expression of Interest MUST have an Expression of Interest identifier.</assert>
        <assert id="PEPPOL-T001-R009" flag="fatal" test="(cbc:ContractFolderID)"
            >[PEPPOL-T001-R009] An Expression of Interest MUST have a ContractFolderID</assert>
        <assert id="PEPPOL-T001-R010" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T001-R010] An
            Expression of Interest MUST have an issue date</assert>
        <assert id="PEPPOL-T001-R011" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T001-R011] An
            Expression of Interest MUST have an issue date</assert>
        <assert id="PEPPOL-T001-R029" flag="fatal"
            test="count(distinct-values(cac:ProcurementProjectLotReference/cbc:ID)) = count(cac:ProcurementProjectLotReference/cbc:ID)"
            >[PEPPOL-T001-R029] Lot identifiers MUST be unique.</assert>
        <assert id="PEPPOL-T001-R034" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T001-R034] An Expression of Interestx' MUST have a syntax identifier.</assert>
        
        <report id="PEPPOL-T001-S301" flag="warning" test="(ext:UBLExtensions)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S301] UBLExtensions SHOULD NOT be
            used.</report>
        
        
        <report id="PEPPOL-T001-S305" flag="warning" test="(cbc:ProfileExectuionID)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S305] ProfileExecutionID SHOULD NOT be
            used.</report>
        <report id="PEPPOL-T001-S307" flag="warning" test="(cbc:CopyIndicator)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S307] CopyIndicator SHOULD NOT be
            used.</report>
        <report id="PEPPOL-T001-S308" flag="warning" test="(cbc:UUID)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S308] UUID SHOULD NOT be used.</report>
        <report id="PEPPOL-T001-S310" flag="warning" test="(cbc:ContractName)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S310] ContractName SHOULD NOT be
            used.</report>
        <report id="PEPPOL-T001-S312" flag="warning" test="(cbc:Note)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S312] Note SHOULD NOT be used.</report>
        <report id="PEPPOL-T001-S313" flag="warning" test="(cac:ValidityPeriod)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S313] ValidityPeriod SHOULD NOT be
            used.</report>
        <report id="PEPPOL-T001-S314" flag="warning" test="(cac:DocumentReference)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S314] DocumentReference SHOULD NOT be
            used.</report>
        <report id="PEPPOL-T001-S315" flag="warning" test="(cac:Signature)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S315] Signature SHOULD NOT be used.</report>
        <report id="PEPPOL-T001-S343" flag="warning" test="count(cac:ContractingParty) &gt; 1"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S343] ContractingParty SHOULD NOT
            be used more than once.</report>
        <report id="PEPPOL-T001-S344" flag="warning" test="(cac:ProcurementProject)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S344] ProcurementProject SHOULD NOT be
            used.</report>
    </rule>
    
    <rule context="ubl:ExpressionOfInterestRequest/cbc:UBLVersionID">
        <assert id="PEPPOL-T001-R033" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T001-R033] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T001-S302" flag="warning" test="./@*"><value-of select="$syntaxError"/>[PEPPOL-T001-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:CustomizationID">
        <assert id="PEPPOL-T001-R002" flag="fatal"
            test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t001:1.2'"
            >[PEPPOL-T001-R002] CustomizationID value MUST be
            'urn:fdc:peppol.eu:prac:trns:t001:1.2'</assert>
        <report id="PEPPOL-T001-S303" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S303] CustomizationID SHOULD NOT contain any attributes.</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:ProfileID">
        <assert id="PEPPOL-T001-R004" flag="fatal"
            test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p001:1.2'"
            >[PEPPOL-T001-R004] ProfileID value MUST be
            'urn:fdc:peppol.eu:prac:bis:p001:1.2'</assert>
        <report id="PEPPOL-T001-S304" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S304] ProfileID SHOULD NOT contain any attributes.</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:ID">
        <assert id="PEPPOL-T001-R006" flag="fatal" test="./@schemeURI">[PEPPOL-T001-R006] An
            Expression of Interest Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T001-R007" flag="fatal"
            test="normalize-space(./@schemeURI) = 'urn:uuid'">[PEPPOL-T001-R007] schemeURI for
            Expression of Interest Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T001-S306" flag="warning" test="./@*[not(name() = 'schemeURI')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S306] ID SHOULD NOT have any
            attributes but schemeURI</report>
        <assert id="PEPPOL-T001-R008" flag="fatal"
            test="matches(normalize-space(.), '^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')"
            >[PEPPOL-T001-R008] Expression of Interest Identifier value MUST be expressed in a
            UUID syntax (RFC 4122)</assert>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:ContractFolderID">
        <report id="PEPPOL-T001-S309" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S309] ContractFolderID SHOULD NOT contain any attributes.</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:IssueTime">
        <assert id="PEPPOL-T001-R012" flag="fatal" test="count(timezone-from-time(.)) &gt; 0"
            >[PEPPOL-T001-R012] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T001-R030" flag="fatal"
            test="matches(normalize-space(.), '^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')"
            >[PEPPOL-T001-R030] IssueTime MUST have a granularity of seconds</assert>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cbc:PreferredLanguageLocaleCode">
        <assert id="PEPPOL-T001-R021" flag="fatal"
            test="matches(normalize-space(.), '^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')"
            >[PEPPOL-T001-R021] PreferredLanguageLocalCode MUST be a valid Language
            Code.</assert>
        <assert id="PEPPOL-T001-R022" flag="fatal" test="./@listID">[PEPPOL-T001-R022]
            PreferredLanguageLocalCode MUST have a list identifier attribute.</assert>
        <assert id="PEPPOL-T001-R023" flag="fatal" test="normalize-space(./@listID) = 'ISO639-1'"
            >[PEPPOL-T001-R023] listID for PreferredLanguageLocaleCode MUST be
            'ISO639-1'.</assert>
        <report id="PEPPOL-T001-S311" flag="warning" test="./@*[not(name() = 'listID')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S311] PreferredLanguageLocaleCode
            SHOULD NOT contain any attributes but listID</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cac:EconomicOperatorParty">
        <report id="PEPPOL-T001-S316" flag="warning" test="(cac:EconomicOperatorRole)"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S316] EconomicOperatorRole SHOULD NOT be
            used.</report>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cac:ContractingParty">
        <assert id="PEPPOL-T001-S342" flag="warning" test="count(./*) - count(./cac:Party) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S342] ContractingParty SHOULD NOT
            contain any elements but cac:Party.</assert>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cac:EconomicOperatorParty/cac:Party">
        <assert id="PEPPOL-T001-S317" flag="warning"
            test="count(./*) - count(./cbc:EndpointID) - count(./cbc:IndustryClassificationCode) - count(./cac:PartyIdentification) - count(./cac:PartyName) - count(cac:PostalAddress) - count(cac:PartyLegalEntity) - count(cac:Contact) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S317] An
            EconomicOperatorParty/cac:Party element SHOULD NOT contain any elements but
            EndpointID, IndustryClassificationCode, PartyIdentification, PartyName,
            PostalAddress, PartyLegalEntity, Contact</assert>
        <assert id="PEPPOL-T001-R014" flag="fatal"
            test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T001-R014] An
            Expression of Interest MUST identify the Economic Operator by its party identifier
            and its endpoint identifier.</assert>
        <assert id="PEPPOL-T001-R017" flag="warning" test="(./cac:PartyName)">[PEPPOL-T001-R017]
            An Expression of Interest SHOULD include the name of the Economic Operator</assert>
        <assert id="PEPPOL-T001-R031" flag="fatal" test="(cac:Contact)">[PEPPOL-T001-R031] An
            Expression of Interest MUST include Economic Operator Contact information.</assert>
    </rule>
    <rule context="ubl:ExpressionOfInterestRequest/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T001-S318" flag="warning"
            test="count(./*) - count(./cac:PartyIdentification) - count(./cbc:EndpointID) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S318] A ContractingParty/cac:Party
            element SHOULD NOT contain any element but EndpointID, PartyIdentification</assert>
        <assert id="PEPPOL-T001-R013" flag="fatal"
            test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T001-R013] An
            Expression of Interest MUST identify the Contracting Body by its party identifier
            and its endpoint identifier.</assert>
    </rule>
    <rule context="cac:Party">
        <assert id="PEPPOL-T001-S323" flag="warning" test="count(./cac:PartyIdentification) = 1"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S323] PartyIdentification SHOULD
            NOT be used more than once</assert>
        <report id="PEPPOL-T001-S324" flag="warning" test="count(./cac:PartyName) &gt; 1"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S324] PartyName SHOULD NOT be used
            more than once</report>
        <report id="PEPPOL-T001-S326" flag="warning" test="count(./cac:PartyLegalEntity) &gt; 1"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S326] PartyLegalEntity SHOULD NOT
            be used more than once</report>
    </rule>
    <rule context="cbc:Name">
        <report id="PEPPOL-T001-S325" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S325] cbc:Name SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T001-R024" flag="fatal" test="./@schemeID">[PEPPOL-T001-R024] An
            Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <report id="PEPPOL-T001-S319" flag="warning" test="./@*[not(name() = 'schemeID')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S319] EndpointID SHOULD NOT
            contain any attributes but schemeID</report>
        <assert id="PEPPOL-T001-R025" flag="fatal"
            test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')"
            >[PEPPOL-T001-R025] An Endpoint Identifier Scheme MUST be from the list of PEPPOL
            Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    <rule context="cac:Party/cbc:IndustryClassificationCode">
        <assert id="PEPPOL-T001-R026" flag="fatal"
            test="matches(normalize-space(.), '^(MT|SC|CL|CM|JV|SME|OTH)$')">[PEPPOL-T001-R026]
            IndustryClassification must describe the Tenderer Role using a valid code from the
            according Codelist.</assert>
        <assert id="PEPPOL-T001-R027" flag="fatal" test="./@listID">[PEPPOL-T001-R027]
            IndustryClassificationCode MUST have a list identifier attribute.</assert>
        <assert id="PEPPOL-T001-R028" flag="fatal"
            test="normalize-space(./@listID) = 'TendererRole'">[PEPPOL-T001-R028] listID for
            IndustryClassificationCode MUST be 'TendererRole'.</assert>
        <report id="PEPPOL-T001-S322" flag="warning" test="./@*[not(name() = 'listID')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S322] IndustryClassificationCode
            SHOULD NOT contain any attributes but listID</report>
    </rule>
    <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T001-R015" flag="fatal" test="./@schemeID">[PEPPOL-T001-R015] A Party
            Identifier MUST have a scheme identifier attribute.</assert>
        <report id="PEPPOL-T001-S327" flag="warning" test="./@*[not(name() = 'schemeID')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S327]
            cac:PartyIdentification/cbc:ID SHOULD NOT contain any attributes but
            schemeID</report>
        <assert id="PEPPOL-T001-R016" flag="fatal"
            test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')"
            >[PEPPOL-T001-R016] A Party Identifier Scheme MUST be from the list of PEPPOL Party
            Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
    </rule>
    <rule context="cac:PostalAddress">
        <assert id="PEPPOL-T001-S328" flag="warning"
            test="count(./*) - count(./cbc:StreetName) - count(./cbc:AdditionalStreetName) - count(./cbc:CityName) - count(./cbc:PostalZone) - count(cbc:CountrySubentity) - count(cac:Country) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S328] PostalAddress SHOULD NOT
            contain any elements but StreetName, AdditionalStreetName, CityName, PostalZone,
            CountrySubentity, Country</assert>
    </rule>
    <rule context="cbc:StreetName">
        <report id="PEPPOL-T001-S329" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S329] cbc:StreetName SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cbc:AdditionalStreetName">
        <report id="PEPPOL-T001-S330" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S330] cbc:AdditionalStreetName SHOULD NOT contain any
            attributes</report>
    </rule>
    <rule context="cbc:CityName">
        <report id="PEPPOL-T001-S331" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S331] cbc:CityName SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cbc:PostalZone">
        <report id="PEPPOL-T001-S332" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S332] cbc:PostalZone SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cbc:CountrySubentity">
        <report id="PEPPOL-T001-S333" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S333] cbc:CountrySubentity SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cac:Country">
        <assert id="PEPPOL-T001-S334" flag="warning"
            test="count(./*) - count(./cbc:IdentificationCode) = 0"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S334] cac:Country SHOULD NOT contain any
            elements but IdentificationCode.</assert>
    </rule>
    <rule context="cac:Country/cbc:IdentificationCode">
        <assert id="PEPPOL-T001-R018" flag="fatal"
            test="matches(normalize-space(.), '^(AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BL|BJ|BM|BN|BO|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CU|CV|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|ST|SV|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)$')"
            >[PEPPOL-T001-R018] A Country Identification Code must be a correct value of the
            ISO3166-1:Alpha2 Codelist of Countries.</assert>
        <assert id="PEPPOL-T001-R019" flag="fatal" test="./@listID">[PEPPOL-T001-R019]
            Country/IdentificationCode MUST have a list identifier attribute.</assert>
        <assert id="PEPPOL-T001-R020" flag="fatal"
            test="normalize-space(./@listID) = 'ISO3166-1:Alpha2'">[PEPPOL-T001-R020] List
            identifier for country code must be "ISO3166-1:Alpha2".</assert>
        <report id="PEPPOL-T001-S335" flag="warning" test="./@*[not(name() = 'listID')]"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S335] Country/IdentificationCode
            SHOULD NOT contain any attributes but listID</report>
    </rule>
    <rule context="cac:PartyLegalEntity">
        <assert id="PEPPOL-T001-S336" flag="warning"
            test="count(./*) - count(./cac:RegistrationAddress) = 0"><value-of
                select="$syntaxError"/>[PEPPOL-T001-S336] cac:PartyLegalEntity SHOULD NOT contain
            any elements but RegistrationAddress.</assert>
    </rule>
    <rule context="cac:PartyLegalEntity/cac:RegistrationAddress">
        <assert id="PEPPOL-T001-S337" flag="warning" test="count(./*) - count(./cac:Country) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S337] cac:RegistrationAddress
            SHOULD NOT contain any elements but Country.</assert>
    </rule>
    <rule context="cac:Contact">
        <assert id="PEPPOL-T001-S338" flag="warning"
            test="count(./*) - count(./cbc:Telephone) - count(./cbc:Telefax) - count(./cbc:ElectronicMail) - count(./cbc:Name) = 0"
            ><value-of select="$syntaxError"/>[PEPPOL-T001-S338] Contact SHOULD NOT contain
            any elements but Telephone, Telefax, ElectronicMail, Name</assert>
        <assert id="PEPPOL-T001-R032" flag="fatal"
            test="(./cbc:Name) and ((./cbc:Telephone) or (./cbc:Telefax) or (./cbc:ElectronicMail))"
            >[PEPPOL-T001-R032] Contact Information MUST include Contact Name and either one of
            Telephone, Telefax or ElectronicMail</assert>
    </rule>
    <rule context="cbc:Telephone">
        <report id="PEPPOL-T001-S339" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S339] cbc:Telephone SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cbc:Telefax">
        <report id="PEPPOL-T001-S340" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S340] cbc:Telefax SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cbc:ElectronicMail">
        <report id="PEPPOL-T001-S341" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S341] cbc:ElectronicMail SHOULD NOT contain any attributes</report>
    </rule>
    <rule context="cac:ProcurementProjectLotReference/cbc:ID">
        <report id="PEPPOL-T001-S345" flag="warning" test="./@*"><value-of select="$syntaxError"
                />[PEPPOL-T001-S345] cac:ProcurementProjectLotReference/cbc:ID SHOULD NOT contain any
            attributes</report>
    </rule>
</pattern>
