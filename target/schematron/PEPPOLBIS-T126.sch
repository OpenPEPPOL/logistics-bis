<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Rules for Transport Status Request</title>

	  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatusRequest-2"
       prefix="ubl"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>
    
    <xsl:key name="k_lineId" match="cac:LineItem" use="cbc:ID"/>
    
    

    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod11"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCodiceIPA"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
      <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:addPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string"/>
      <param name="pari" as="xs:integer"/>
      <variable name="tappo"
                select="if (not($arg castable as xsd:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xsd:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xsd:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xsd:integer) and         (substring($arg,12,3) castable as xsd:string) and        (substring($arg,15,1) castable as xsd:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xsd:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVAseIT"
             as="xs:boolean">
      <param name="arg" as="xs:string"/>
      <variable name="paese" select="substring($arg,1,2)"/>
      <variable name="codice" select="substring($arg,3)"/>
      <sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:mod97-0208"
             as="xs:boolean">
      <param name="val"/>
      <variable name="checkdigits" select="substring($val,9,2)"/>
      <variable name="calculated_digits"
                select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
	     <param name="val"/>
	     <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>
    

    <pattern>
 
		    <rule context="//*[not(*) and not(normalize-space())]">
			      <assert id="PEPPOL-COMMON-R001" test="false()" flag="fatal">Document MUST not contain empty elements.</assert>
		    </rule> 
   
   </pattern>
    <pattern>

	     <rule context="/*">
		       <assert id="PEPPOL-COMMON-R003"
                 test="not(@*:schemaLocation)"
                 flag="warning">Document SHOULD not contain schema location.</assert>

	     </rule>

	     <rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate">
		       <assert id="PEPPOL-COMMON-R030"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
	     </rule>

	
	     <rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
		       <assert id="PEPPOL-COMMON-R040"
                 test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())"
                 flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
		       <assert id="PEPPOL-COMMON-R041"
                 test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())"
                 flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
		       <assert id="PEPPOL-COMMON-R043"
                 test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())"
                 flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
		       <assert id="PEPPOL-COMMON-R044"
                 test="u:checkCodiceIPA(normalize-space())"
                 flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
		       <assert id="PEPPOL-COMMON-R045"
                 test="u:checkCF(normalize-space())"
                 flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '9907']">
		       <assert id="PEPPOL-COMMON-R046"
                 test="u:checkCF(normalize-space())"
                 flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
		       <assert id="PEPPOL-COMMON-R047"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '9906']">
		       <assert id="PEPPOL-COMMON-R048"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
		       <assert id="PEPPOL-COMMON-R049"
                 test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'"
                 flag="warning">Swedish organization number MUST be stated in the correct format.</assert>
	     </rule>
	     <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
		       <assert id="PEPPOL-COMMON-R050"
                 test="u:abn(normalize-space())"
                 flag="warning">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
	     </rule>
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
      <let name="clConsignmentIDType" value="tokenize('GINC ZZZ', '\s')"/>
      <let name="clTransportEventTypeCode"
           value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 44 45 46 47 48 49 50 51 53 54 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 161 162 163 164 165 166 167 168 169 170 171 172 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 218 219 220 222 224 225 227 228 229 231 232 233 234 235 236 238 239 240 241 242 243 247 248 250 251 253 254 255 256 258 260 265 266 267 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 291 292 295 297 298 299 300 301 302 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 9955', '\s')"/>
      <let name="clTransportationStatusTypeCode" value="tokenize('3 4', '\s')"/>
      <let name="clTransportHandlingUnitIDType" value="tokenize('SSCC ZZZ', '\s')"/>
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
      <rule context="/ubl:TransportationStatusRequest">
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T126-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T126-B00102">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B00103">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T126-B00104">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T126-B00105">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cbc:ShippingOrderID" flag="fatal" id="PEPPOL-T126-B00106">Element 'cbc:ShippingOrderID' MUST be provided.</assert>
         <assert test="cbc:TransportationStatusTypeCode"
                 flag="fatal"
                 id="PEPPOL-T126-B00107">Element 'cbc:TransportationStatusTypeCode' MUST be provided.</assert>
         <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T126-B00108">Element 'cac:SenderParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T126-B00109">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T126-B00110">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cbc:CustomizationID"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:ProfileID"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:ID"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:IssueDate"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:IssueTime"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:ShippingOrderID"/>
      <rule context="/ubl:TransportationStatusRequest/cbc:TransportationStatusTypeCode">
         <assert test="(some $code in $clTransportationStatusTypeCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B00901">Value MUST be part of code list 'Transportation Status Type Code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T126-B01001">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T126-B01002">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T126-B01101">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B01102">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B01301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B01401">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T126-B01601">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T126-B01801">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T126-B02401">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T126-B02601">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B02701">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B02602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B01802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T126-B02801">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T126-B02802">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B03001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B03002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B02803">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T126-B03201">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T126-B03401">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B03402">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T126-B03601">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T126-B03801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B03901">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B03802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B03602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B03202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:Contact"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B04001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:SenderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B01003">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T126-B04401">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T126-B04402">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T126-B04501">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B04502">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B04701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B04801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T126-B05001">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T126-B05201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine">
         <assert test="cbc:Line" flag="fatal" id="PEPPOL-T126-B05801">Element 'cbc:Line' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T126-B06001">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B06101">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B06002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B05202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T126-B06201">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T126-B06202">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B06401">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B06402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B06203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T126-B06601">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T126-B06801">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B06802">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T126-B07001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T126-B07201">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B07301">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B07202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B07002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B06602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:Contact"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B07401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B04403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:TransportExecutionPlanDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B07801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:TransportExecutionPlanDocumentReference/cbc:ID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:TransportExecutionPlanDocumentReference/cbc:IssueDate"/>
      <rule context="/ubl:TransportationStatusRequest/cac:TransportExecutionPlanDocumentReference/cbc:IssueTime"/>
      <rule context="/ubl:TransportationStatusRequest/cac:TransportExecutionPlanDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B07802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B08201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B08301">Value MUST be part of code list 'Type of Consignment ID (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportEvent"/>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportEvent/cbc:IdentificationID"/>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportEvent/cbc:TransportEventTypeCode">
         <assert test="(some $code in $clTransportEventTypeCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T126-B08701">Value MUST be part of code list 'Transport Event Type Code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportEvent/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B08501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportHandlingUnit">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T126-B08801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportHandlingUnit/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T126-B08901">Value MUST be part of code list 'Type of Transport Handling Unit ID (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/cac:TransportHandlingUnit/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B08802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/cac:Consignment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B08202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TransportationStatusRequest/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T126-B00111">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>

	     <rule context="cbc:CustomizationID">
		       <assert id="PEPPOL-T126-R001"
                 test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transportation_status_request:1')"
                 flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:transportation_status_request:1'.</assert>
	     </rule>

	     <rule context="cbc:ProfileID">
		       <assert id="PEPPOL-T126-R002"
                 test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1')"
                 flag="fatal">ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1'.</assert>
	     </rule>

	     <rule context="ubl:TransportationStatusRequest/cbc:IssueTime">
		       <assert id="PEPPOL-T126-R018"
                 test="count(timezone-from-time(.)) &gt; 0"
                 flag="fatal"> [PEPPOL-T126-R018] IssueTime MUST include timezone information.</assert>
	     </rule>
	
	     <rule context="ubl:TransportationStatusRequest/cac:SenderParty">
		       <assert id="PEPPOL-T126-R031"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T126-R031] Party must include either a party name or a party identification.</assert>
	     </rule>
	     <rule context="ubl:TransportationStatusRequest/cac:ReceiverParty">
		       <assert id="PEPPOL-T126-R032"
                 test="cac:PartyName or cac:PartyIdentification"
                 flag="fatal"> [PEPPOL-T126-R032] Party must include either a party name or a party identification.</assert>
	     </rule>

   </pattern>    

</schema>
