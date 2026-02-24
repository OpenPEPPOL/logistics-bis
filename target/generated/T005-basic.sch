<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
    <let name="clISO3166"
        value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')" />
    <let name="cleas"
        value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240 0244', '\s')" />
    <let name="clICD"
        value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244', '\s')" />
    <rule context="/ubl:Tender">
        <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T005-B00101">Element
            'cbc:UBLVersionID' MUST be provided.</assert>
        <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T005-B00102">Element
            'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T005-B00103">Element 'cbc:ProfileID'
            MUST be provided.</assert>
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T005-B00104">Element 'cbc:ID' MUST be
            provided.</assert>
        <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T005-B00105">Element
            'cbc:ContractFolderID' MUST be provided.</assert>
        <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T005-B00106">Element 'cbc:IssueDate'
            MUST be provided.</assert>
        <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T005-B00107">Element 'cbc:IssueTime'
            MUST be provided.</assert>
        <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T005-B00108">Element
            'cac:DocumentReference' MUST be provided.</assert>
        <assert test="cac:TendererParty" flag="fatal" id="PEPPOL-T005-B00109">Element
            'cac:TendererParty' MUST be provided.</assert>
        <assert test="cac:ContractingParty" flag="fatal" id="PEPPOL-T005-B00110">Element
            'cac:ContractingParty' MUST be provided.</assert>
        <assert test="cac:TenderedProject" flag="fatal" id="PEPPOL-T005-B00111">Element
            'cac:TenderedProject' MUST be provided.</assert>
        <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T005-B00112">Document MUST not
            contain schema location.</assert>
    </rule>
    <rule context="/ubl:Tender/cbc:UBLVersionID">
        <assert test="normalize-space(text()) = '2.2'" flag="fatal" id="PEPPOL-T005-B00201">Element
            'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
    </rule>
    <rule context="/ubl:Tender/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t005:1.2'" flag="fatal"
            id="PEPPOL-T005-B00301">Element 'cbc:CustomizationID' MUST contain value
            'urn:fdc:peppol.eu:prac:trns:t005:1.2'.</assert>
    </rule>
    <rule context="/ubl:Tender/cbc:ProfileID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p003:1.2'" flag="fatal"
            id="PEPPOL-T005-B00401">Element 'cbc:ProfileID' MUST contain value
            'urn:fdc:peppol.eu:prac:bis:p003:1.2'.</assert>
    </rule>
    <rule context="/ubl:Tender/cbc:ID">
        <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'" flag="fatal"
            id="PEPPOL-T005-B00501">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
        <assert test="@schemeURI" flag="fatal" id="PEPPOL-T005-B00502">Attribute 'schemeURI' MUST be
            present.</assert>
    </rule>
    <rule context="/ubl:Tender/cbc:ContractFolderID" />
    <rule context="/ubl:Tender/cbc:IssueDate" />
    <rule context="/ubl:Tender/cbc:IssueTime" />
    <rule context="/ubl:Tender/cac:DocumentReference">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T005-B01001">Element 'cbc:ID' MUST be
            provided.</assert>
        <assert test="cbc:DocumentTypeCode" flag="fatal" id="PEPPOL-T005-B01002">Element
            'cbc:DocumentTypeCode' MUST be provided.</assert>
        <assert test="cbc:DocumentDescription" flag="fatal" id="PEPPOL-T005-B01003">Element
            'cbc:DocumentDescription' MUST be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cbc:ID" />
    <rule context="/ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode">
        <assert test="not(@listID) or @listID = 'UNCL1001'" flag="fatal" id="PEPPOL-T005-B01201">Attribute
            'listID' MUST contain value 'UNCL1001'</assert>
        <assert test="@listID" flag="fatal" id="PEPPOL-T005-B01202">Attribute 'listID' MUST be
            present.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cbc:LocaleCode">
        <assert test="not(@listID) or @listID = 'ISO639-1'" flag="fatal" id="PEPPOL-T005-B01401">Attribute
            'listID' MUST contain value 'ISO639-1'</assert>
        <assert test="@listID" flag="fatal" id="PEPPOL-T005-B01402">Attribute 'listID' MUST be
            present.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cbc:VersionID" />
    <rule context="/ubl:Tender/cac:DocumentReference/cbc:DocumentDescription" />
    <rule context="/ubl:Tender/cac:DocumentReference/cac:Attachment">
        <assert test="cac:ExternalReference" flag="fatal" id="PEPPOL-T005-B01801">Element
            'cac:ExternalReference' MUST be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference">
        <assert test="cbc:DocumentHash" flag="fatal" id="PEPPOL-T005-B01901">Element
            'cbc:DocumentHash' MUST be provided.</assert>
        <assert test="cbc:HashAlgorithmMethod" flag="fatal" id="PEPPOL-T005-B01902">Element
            'cbc:HashAlgorithmMethod' MUST be provided.</assert>
        <assert test="cbc:FileName" flag="fatal" id="PEPPOL-T005-B01903">Element 'cbc:FileName' MUST
            be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <rule
        context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash" />
    <rule
        context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
        <assert test="normalize-space(text()) = 'http://www.w3.org/2001/04/xmlenc#sha256'"
            flag="fatal" id="PEPPOL-T005-B02201">Element 'cbc:HashAlgorithmMethod' MUST contain
            value 'http://www.w3.org/2001/04/xmlenc#sha256'.</assert>
    </rule>
    <rule
        context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode" />
    <rule
        context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName" />
    <rule context="/ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B01904">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/cac:Attachment/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B01802">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:DocumentReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B01004">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T005-B02501">Element 'cbc:EndpointID'
            MUST be provided.</assert>
        <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T005-B02502">Element
            'cac:PartyIdentification' MUST be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T005-B02601">Attribute 'schemeID' MUST be
            present.</assert>
        <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
            flag="fatal" id="PEPPOL-T005-B02602">Value MUST be part of code list 'Electronic Address
            Scheme (EAS)'.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T005-B02801">Element 'cbc:ID' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyIdentification/cbc:ID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T005-B02901">Attribute 'schemeID' MUST be
            present.</assert>
        <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
            flag="fatal" id="PEPPOL-T005-B02902">Value MUST be part of code list 'ISO 6523 ICD
            list'.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyName">
        <assert test="cbc:Name" flag="fatal" id="PEPPOL-T005-B03101">Element 'cbc:Name' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyName/cbc:Name" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cbc:StreetName" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cbc:CityName" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cbc:PostalZone" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cbc:CountrySubentity" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cac:Country">
        <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T005-B03901">Element
            'cbc:IdentificationCode' MUST be provided.</assert>
    </rule>
    <rule
        context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
        <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
            flag="fatal" id="PEPPOL-T005-B04001">Value MUST be part of code list 'ISO 3166-1:Alpha2
            Country codes'.</assert>
        <assert test="@listID" flag="fatal" id="PEPPOL-T005-B04002">Attribute 'listID' MUST be
            present.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/cac:Country/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B03902">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PostalAddress/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B03301">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cbc:CompanyLegalForm" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cac:RegistrationAddress" />
    <rule
        context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
        <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T005-B04501">Element
            'cbc:IdentificationCode' MUST be provided.</assert>
    </rule>
    <rule
        context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
        <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
            flag="fatal" id="PEPPOL-T005-B04601">Value MUST be part of code list 'ISO 3166-1:Alpha2
            Country codes'.</assert>
        <assert test="@listID" flag="fatal" id="PEPPOL-T005-B04602">Attribute 'listID' MUST be
            present.</assert>
    </rule>
    <rule
        context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B04502">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B04401">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:PartyLegalEntity/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B04201">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact/cbc:Name" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact/cbc:Telephone" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact/cbc:Telefax" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact/cbc:ElectronicMail" />
    <rule context="/ubl:Tender/cac:TendererParty/cac:Contact/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B04801">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TendererParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B02503">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty">
        <assert test="cac:Party" flag="fatal" id="PEPPOL-T005-B05301">Element 'cac:Party' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T005-B05401">Element 'cbc:EndpointID'
            MUST be provided.</assert>
        <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T005-B05402">Element
            'cac:PartyIdentification' MUST be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T005-B05501">Attribute 'schemeID' MUST be
            present.</assert>
        <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
            flag="fatal" id="PEPPOL-T005-B05502">Value MUST be part of code list 'Electronic Address
            Scheme (EAS)'.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T005-B05701">Element 'cbc:ID' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/cac:PartyIdentification/cbc:ID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T005-B05801">Attribute 'schemeID' MUST be
            present.</assert>
        <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
            flag="fatal" id="PEPPOL-T005-B05802">Value MUST be part of code list 'ISO 6523 ICD
            list'.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/cac:PartyName">
        <assert test="cbc:Name" flag="fatal" id="PEPPOL-T005-B06001">Element 'cbc:Name' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/cac:PartyName/cbc:Name" />
    <rule context="/ubl:Tender/cac:ContractingParty/cac:Party/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B05403">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:ContractingParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B05302">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TenderedProject">
        <assert test="cac:ProcurementProjectLot" flag="fatal" id="PEPPOL-T005-B06201">Element
            'cac:ProcurementProjectLot' MUST be provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T005-B06301">Element 'cbc:ID' MUST be
            provided.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/cbc:ID" />
    <rule context="/ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B06302">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/cac:TenderedProject/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B06202">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
    <rule context="/ubl:Tender/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T005-B00113">Document MUST NOT contain
            elements not part of the data model.</assert>
    </rule>
</pattern>