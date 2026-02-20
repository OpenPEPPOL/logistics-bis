<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>PEPPOL business and syntax rules for notice publication response</title>

    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:AwardedNotification-2"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:gln"
             as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:slack"
             as="xs:boolean">
      <param name="exp" as="xs:decimal"/>
      <param name="val" as="xs:decimal"/>
      <param name="slack" as="xs:decimal"/>
      <sequence select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
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
      <sequence select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
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
                select="if (not($arg castable as xs:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
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
      <sequence select="number($checkdigits) = number($calculated_digits)"/>
  </function>
    <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
      <param name="val"/>
      <sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>       
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkSEOrgnr"
             as="xs:boolean">
	
	     <param name="number" as="xs:string"/>
	     <choose>
		
		       <when test="not(matches($number, '^\d+$'))">
			         <sequence select="false()"/>
		       </when>
		       <otherwise>
			
			         <variable name="mainPart" select="substring($number, 1, 9)"/>
			         <variable name="checkDigit" select="substring($number, 10, 1)"/>
			         <variable name="sum" as="xs:integer">
			            <sequence select="xs:integer(sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      ))"/>
			         </variable>
			         <variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10"/>
			         <sequence select="$calculatedCheckDigit = number($checkDigit)"/>
		       </otherwise>
	     </choose>
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
      <rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']">
         <assert id="PEPPOL-COMMON-R042"
                 test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)                or               (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)"
                 flag="fatal">Danish organization number (CVR) MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']">
         <assert id="PEPPOL-COMMON-R052"
                 test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)"
                 flag="warning">Danish chamber of commerce number (P) MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']">
         <assert id="PEPPOL-COMMON-R053"
                 test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)"
                 flag="warning">Danish ERSTORG number (SE) MUST be stated in the correct format.</assert>
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
    
      <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
         <assert id="PEPPOL-COMMON-R049"
                 test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())"
                 flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
         <assert id="PEPPOL-COMMON-R050"
                 test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())"
                 flag="fatal">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
      </rule>
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240 0244', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244', '\s')"/>
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
      <let name="clawardCode" value="tokenize('unaward award', '\s')"/>
      <rule context="/ubl:AwardingNotification">
         <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T017-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T017-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T017-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T017-B00105">Element 'cbc:ContractFolderID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T017-B00106">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T017-B00107">Element 'cac:SenderParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T017-B00108">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="cac:MinutesDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T017-B00109">Element 'cac:MinutesDocumentReference' MUST be provided.</assert>
         <assert test="cac:TenderResult" flag="fatal" id="PEPPOL-T017-B00110">Element 'cac:TenderResult' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T017-B00111">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T017-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cbc:CustomizationID">
         <assert test="normalize-space(text()) = '&#xA;                urn:fdc:peppol.eu:prac:trns:t017:1.1&#xA;            '"
                 flag="fatal"
                 id="PEPPOL-T017-B00301">Element 'cbc:CustomizationID' MUST contain value '
                urn:fdc:peppol.eu:prac:trns:t017:1.1
            '.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p009:1.1'"
                 flag="fatal"
                 id="PEPPOL-T017-B00401">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p009:1.1'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T017-B00501">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T017-B00502">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cbc:ContractFolderID"/>
      <rule context="/ubl:AwardingNotification/cbc:IssueDate"/>
      <rule context="/ubl:AwardingNotification/cbc:IssueTime"/>
      <rule context="/ubl:AwardingNotification/cbc:Note"/>
      <rule context="/ubl:AwardingNotification/cac:SenderParty">
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T017-B01101">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/cbc:EndpointID">
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T017-B01201">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/cac:PartyIdentification"/>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T017-B01501">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/cac:PartyName"/>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:AwardingNotification/cac:SenderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B01102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty">
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T017-B01901">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T017-B02001">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T017-B02002">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-B02201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T017-B02301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T017-B02302">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T017-B02501">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:AwardingNotification/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B01902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:MinutesDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-B02701">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentStatusCode" flag="fatal" id="PEPPOL-T017-B02702">Element 'cbc:DocumentStatusCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:MinutesDocumentReference/cbc:ID"/>
      <rule context="/ubl:AwardingNotification/cac:MinutesDocumentReference/cbc:DocumentStatusCode">
         <assert test="(some $code in $clawardCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T017-B02901">Value MUST be part of code list 'awardCode'.</assert>
         <assert test="not(@listID) or @listID = 'awardCode'"
                 flag="fatal"
                 id="PEPPOL-T017-B02902">Attribute 'listID' MUST contain value 'awardCode'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T017-B02903">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:MinutesDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B02703">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult">
         <assert test="cbc:TenderResultCode" flag="fatal" id="PEPPOL-T017-B03101">Element 'cbc:TenderResultCode' MUST be provided.</assert>
         <assert test="cbc:AwardDate" flag="fatal" id="PEPPOL-T017-B03102">Element 'cbc:AwardDate' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cbc:TenderResultCode">
         <assert test="not(@listID) or @listID = 'http://publications.europa.eu/resource/authority/winner-selection-status'"
                 flag="fatal"
                 id="PEPPOL-T017-B03201">Attribute 'listID' MUST contain value 'http://publications.europa.eu/resource/authority/winner-selection-status'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T017-B03202">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cbc:AwardDate"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cbc:AwardTime"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cbc:StartDate"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-B03801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cbc:ID"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment">
         <assert test="cac:ExternalReference" flag="fatal" id="PEPPOL-T017-B04001">Element 'cac:ExternalReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert test="cbc:URI" flag="fatal" id="PEPPOL-T017-B04101">Element 'cbc:URI' MUST be provided.</assert>
         <assert test="cbc:MimeCode" flag="fatal" id="PEPPOL-T017-B04102">Element 'cbc:MimeCode' MUST be provided.</assert>
         <assert test="cbc:FileName" flag="fatal" id="PEPPOL-T017-B04103">Element 'cbc:FileName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/cac:ExternalReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B04104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B04002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/cac:ContractDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B03802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:Contract/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B03701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:AwardedTenderedProject"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-B04601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot/cbc:ID"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:AwardedTenderedProject/cac:ProcurementProjectLot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B04602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:AwardedTenderedProject/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B04501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty">
         <assert test="cbc:Rank" flag="fatal" id="PEPPOL-T017-B04801">Element 'cbc:Rank' MUST be provided.</assert>
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T017-B04802">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cbc:Rank"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T017-B05101">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T017-B05601">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
         <assert test="not(@listID) or @listID = 'ISO3166'"
                 flag="fatal"
                 id="PEPPOL-T017-B05602">Attribute 'listID' MUST contain value 'ISO3166'</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B05501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B05401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B05301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/cac:WinningParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B05001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/cac:TenderResult/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B03103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:AwardingNotification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T017-B00112">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
    
      <rule context="cbc:IssueDate">
        <assert id="PEPPOL-T017-R002"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
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
        <assert test="cac:MinutesDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T017-R014">Element 'cac:MinutesDocumentReference' MUST be provided.</assert>
        <assert test="cac:TenderResult" flag="fatal" id="PEPPOL-T017-R015">Element 'cac:TenderResult' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:UBLVersionID">
        <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T017-R016">Element 'cbc:UBLVersionID' MUST contain value '2.2.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t017:1.1'"
                 flag="fatal"
                 id="PEPPOL-T017-R017">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t017:1.1'.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:ProfileID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p009:1.1'"
                 flag="fatal"
                 id="PEPPOL-T017-R018">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p009:1.1'.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:ID">
        <assert flag="fatal"
                 id="PEPPOL-T017-R019"
                 test="matches(normalize-space(./@schemeURI),'^(urn:uuid)')">Value for schemeURI MUST be part urn:uuid.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R020"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ID MUST be expressed in UUID Syntax.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:ContractFolderID">
        <assert flag="fatal"
                 id="PEPPOL-T017-R021"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ContractFolderID MUST be expressed in UUID Syntax.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:IssueDate"/>
    
      <rule context="/ubl:AwardedNotification/cbc:IssueTime">
        <assert id="PEPPOL-T017-R022"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T017-R023"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cbc:Note"/>
    
      <rule context="/ubl:AwardedNotification/cac:SenderParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T017-R024">Element 'cbc:EndpointID' MUST be provided.</assert>
        <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T017-R025">Element 'cbc:PartyIdentification' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:SenderParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T017-R026">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R027"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R028">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:SenderParty/cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T017-R029" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T017-R030"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
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
        <assert flag="fatal"
                 id="PEPPOL-T017-R038"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyIdentification">
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T017-R039">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T017-R040" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T017-R041"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
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
        <assert flag="fatal"
                 id="PEPPOL-T017-R048"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">ID MUST be expressed in UUID Syntax.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference/cbc:DocumentStatusCode">
        <assert flag="fatal" id="PEPPOL-T017-R049" test="@listID">Attribute 'listID' MUST be present</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R050"
                 test="matches(normalize-space(./@listID),'^(awardCode)')">Value MUST be awardCode.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R051"
                 test="matches(normalize-space(.),'^(award|unaward)')">Value of DocumentStatusCode must be from codelist awardCode.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:MinutesDocumentReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T017-R052">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:TenderResult">
        <assert test="cbc:TenderResultCode" flag="fatal" id="PEPPOL-T017-R053">Element 'cbc:TenderResultCode' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:TenderResultCode">
        <assert flag="fatal" id="PEPPOL-T017-R054" test="@listID">Attribute 'listID' MUST be present</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R055"
                 test="matches(normalize-space(./@listID),'^(http://publications.europa.eu/resource/authority/winner-selection-status)')">Value MUST be http://publications.europa.eu/resource/authority/winner-selection-status.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R056"
                 test="matches(normalize-space(.),'^(selec-w|clos-nw|open-nw)')">Value of TenderResultCode must be from codelist WinnerSelectionStatus.</assert>
      </rule>
    
      <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:AwardDate"/>
    
      <rule context="/ubl:AwardedNotification/cac:TenderResult/cbc:AwardTime">
        <assert id="PEPPOL-T017-R057"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">IssueTimeAwardTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T017-R058"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
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
        <assert flag="fatal"
                 id="PEPPOL-T017-R071"
                 test="matches(normalize-space(./@listID),'^(ISO3166-1:Alpha2)')">Value MUST be ISO3166-1:Alpha2.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T017-R072"
                 test="matches(normalize-space(.),'^(A(D|E|F|G|I|L|M|N|O|R|S|T|Q|U|W|X|Z)|B(A|B|D|E|F|G|H|I|J|L|M|N|O|R|S|T|V|W|Y|Z)|C(A|C|D|F|G|H|I|K|L|M|N|O|R|U|V|X|Y|Z)|D(E|J|K|M|O|Z)|E(C|E|G|H|R|S|T)|F(I|J|K|M|O|R)|G(A|B|D|E|F|G|H|I|L|M|N|P|Q|R|S|T|U|W|Y)|H(K|M|N|R|T|U)|I(D|E|Q|L|M|N|O|R|S|T)|J(E|M|O|P)|K(E|G|H|I|M|N|P|R|W|Y|Z)|L(A|B|C|I|K|R|S|T|U|V|Y)|M(A|C|D|E|F|G|H|K|L|M|N|O|Q|P|R|S|T|U|V|W|X|Y|Z)|N(A|C|E|F|G|I|L|O|P|R|U|Z)|OM|P(A|E|F|G|H|K|L|M|N|R|S|T|W|Y)|QA|R(E|O|S|U|W)|S(A|B|C|D|E|G|H|I|J|K|L|M|N|O|R|T|V|Y|Z)|T(C|D|F|G|H|J|K|L|M|N|O|R|T|V|W|Z)|U(A|G|M|S|Y|Z)|V(A|C|E|G|I|N|U)|W(F|S)|Y(E|T)|Z(A|M|W))$')">Value of TenderResultCode must be from codelist WinnerSelectionStatus.</assert>
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

</schema>
