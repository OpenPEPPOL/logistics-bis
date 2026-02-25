<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">
        
    <title>eSENS business and syntax rules for Invitation to Tender (Tansaction 88)</title>

    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CallForTenders-2"/>
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
      <let name="clprocedureType"
           value="tokenize('1 2 3 C 4 6 T V 8 9 Z A', '\s')"/>
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240 0244', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244', '\s')"/>
      <let name="cldocType" value="tokenize('PRO REQ 916', '\s')"/>
      <let name="cldocStatus" value="tokenize('NR RWOS RWAS RWQS', '\s')"/>
      <let name="cltendererRole" value="tokenize('MT SC CL CM JV SME OTH', '\s')"/>
      <let name="claddCond" value="tokenize('WOS WAS WQS', '\s')"/>
      <let name="clcontractType" value="tokenize('1 2 3 4 5', '\s')"/>
      <let name="clprocurementType" value="tokenize('1 2 4 5 6 9 Z', '\s')"/>
      <let name="clsubmissionMethod"
           value="tokenize('POSTAL ELECTRONIC ANY', '\s')"/>
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
      <rule context="/ubl:CallForTenders">
         <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T024-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T024-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T024-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T024-B00105">Element 'cbc:ContractFolderID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T024-B00106">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T024-B00107">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cbc:VersionID" flag="fatal" id="PEPPOL-T024-B00108">Element 'cbc:VersionID' MUST be provided.</assert>
         <assert test="cac:ContractingParty" flag="fatal" id="PEPPOL-T024-B00109">Element 'cac:ContractingParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T024-B00110">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="cac:TenderingTerms" flag="fatal" id="PEPPOL-T024-B00111">Element 'cac:TenderingTerms' MUST be provided.</assert>
         <assert test="cac:TenderingProcess" flag="fatal" id="PEPPOL-T024-B00112">Element 'cac:TenderingProcess' MUST be provided.</assert>
         <assert test="cac:ProcurementProject" flag="fatal" id="PEPPOL-T024-B00113">Element 'cac:ProcurementProject' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T024-B00114">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T024-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cbc:CustomizationID">
         <assert test="normalize-space(text()) = '&#xA;                urn:fdc:peppol.eu:prac:trns:t024:1.0&#xA;            '"
                 flag="fatal"
                 id="PEPPOL-T024-B00301">Element 'cbc:CustomizationID' MUST contain value '
                urn:fdc:peppol.eu:prac:trns:t024:1.0
            '.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p013:1.0'"
                 flag="fatal"
                 id="PEPPOL-T024-B00401">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p013:1.0'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T024-B00501">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T024-B00502">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cbc:ContractFolderID"/>
      <rule context="/ubl:CallForTenders/cbc:IssueDate"/>
      <rule context="/ubl:CallForTenders/cbc:IssueTime"/>
      <rule context="/ubl:CallForTenders/cbc:VersionID"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B01101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:IssueDate"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
         <assert test="(some $code in $cldocType satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B01401">Value MUST be part of code list 'documentTypeCode'.</assert>
         <assert test="not(@listID) or @listID = 'urn:eu:esens:cenbii:documentType'"
                 flag="fatal"
                 id="PEPPOL-T024-B01402">Attribute 'listID' MUST contain value 'urn:eu:esens:cenbii:documentType'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B01403">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode">
         <assert test="not(@listID) or @listID = 'ISO639-1'"
                 flag="fatal"
                 id="PEPPOL-T024-B01601">Attribute 'listID' MUST contain value 'ISO639-1'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B01602">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode">
         <assert test="(some $code in $cldocStatus satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B01901">Value MUST be part of code list 'documentStatusCode'.</assert>
         <assert test="not(@listID) or @listID = 'urn:eu:esens:cenbii:documentStatusType'"
                 flag="fatal"
                 id="PEPPOL-T024-B01902">Attribute 'listID' MUST contain value 'urn:eu:esens:cenbii:documentStatusType'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B01903">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment">
         <assert test="cac:ExternalReference" flag="fatal" id="PEPPOL-T024-B02201">Element 'cac:ExternalReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName"/>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B02301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B02202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B01102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T024-B02701">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T024-B02801">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T024-B02802">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B02901">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T024-B02902">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B03101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B03201">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T024-B03202">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T024-B03401">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cac:RegistrationAddress" flag="fatal" id="PEPPOL-T024-B03601">Element 'cac:RegistrationAddress' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T024-B03701">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T024-B03801">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B03901">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
         <assert test="not(@listID) or @listID = 'ISO3166'"
                 flag="fatal"
                 id="PEPPOL-T024-B03902">Attribute 'listID' MUST contain value 'ISO3166'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B03903">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B03802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B03702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B03602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B02803">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ContractingParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B02702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T024-B04101">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cbc:IndustryClassificationCode"
                 flag="fatal"
                 id="PEPPOL-T024-B04102">Element 'cbc:IndustryClassificationCode' MUST be provided.</assert>
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T024-B04103">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B04201">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cbc:IndustryClassificationCode">
         <assert test="(some $code in $cltendererRole satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B04401">Value MUST be part of code list 'Economic Operator Role Codes'.</assert>
         <assert test="not(@listID) or @listID = 'tendererRole'"
                 flag="fatal"
                 id="PEPPOL-T024-B04402">Attribute 'listID' MUST contain value 'tendererRole'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B04403">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B04601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B04701">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T024-B04702">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T024-B04901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T024-B05701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B05801">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B05802">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B05702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B05101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyLegalForm"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T024-B06301">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B06401">Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B06402">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B06302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B06201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B06001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact/cbc:Telefax"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B06601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B04104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms">
         <assert test="cbc:VariantConstraintIndicator"
                 flag="fatal"
                 id="PEPPOL-T024-B07101">Element 'cbc:VariantConstraintIndicator' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity"/>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator"/>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cbc:Note"/>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions">
         <assert test="(some $code in $claddCond satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B07501">Value MUST be part of code list 'additionalConditionsCode'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B07601">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentDescription" flag="fatal" id="PEPPOL-T024-B07602">Element 'cbc:DocumentDescription' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID"/>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription"/>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B07603">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B07901">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T024-B08001">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T024-B08002">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B07902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T024-B08201">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B08301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T024-B08302">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B08202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingTerms/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B07102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess">
         <assert test="cbc:ProcedureCode" flag="fatal" id="PEPPOL-T024-B08501">Element 'cbc:ProcedureCode' MUST be provided.</assert>
         <assert test="cac:TenderSubmissionDeadlinePeriod"
                 flag="fatal"
                 id="PEPPOL-T024-B08502">Element 'cac:TenderSubmissionDeadlinePeriod' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode">
         <assert test="(some $code in $clprocedureType satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B08601">Value MUST be part of code list 'procedureTypeCode'.</assert>
         <assert test="not(@listID) or @listID = 'PR_PROC'"
                 flag="fatal"
                 id="PEPPOL-T024-B08602">Attribute 'listID' MUST contain value 'PR_PROC'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B08603">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode">
         <assert test="(some $code in $clcontractType satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B08801">Value MUST be part of code list 'contractTypeCode'.</assert>
         <assert test="not(@listID) or @listID = 'CONTRACT_TYPE'"
                 flag="fatal"
                 id="PEPPOL-T024-B08802">Attribute 'listID' MUST contain value 'CONTRACT_TYPE'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B08803">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode">
         <assert test="(some $code in $clsubmissionMethod satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B09001">Value MUST be part of code list 'SubmissionMethodCode'.</assert>
         <assert test="not(@listID) or @listID = 'BII_SUBMISSION'"
                 flag="fatal"
                 id="PEPPOL-T024-B09002">Attribute 'listID' MUST contain value 'BII_SUBMISSION'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B09003">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod">
         <assert test="cbc:EndDate" flag="fatal" id="PEPPOL-T024-B09201">Element 'cbc:EndDate' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod/cbc:EndDate"/>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod/cbc:EndTime"/>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B09202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod">
         <assert test="cbc:EndDate" flag="fatal" id="PEPPOL-T024-B09501">Element 'cbc:EndDate' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod/cbc:EndDate"/>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod/cbc:EndTime"/>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B09502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:TenderingProcess/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B08503">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T024-B09801">Element 'cbc:Name' MUST be provided.</assert>
         <assert test="cbc:Description" flag="fatal" id="PEPPOL-T024-B09802">Element 'cbc:Description' MUST be provided.</assert>
         <assert test="cbc:ProcurementTypeCode" flag="fatal" id="PEPPOL-T024-B09803">Element 'cbc:ProcurementTypeCode' MUST be provided.</assert>
         <assert test="cac:MainCommodityClassification"
                 flag="fatal"
                 id="PEPPOL-T024-B09804">Element 'cac:MainCommodityClassification' MUST be provided.</assert>
         <assert test="cac:RealizedLocation" flag="fatal" id="PEPPOL-T024-B09805">Element 'cac:RealizedLocation' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cbc:Name"/>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cbc:Description"/>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode">
         <assert test="(some $code in $clprocurementType satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T024-B10101">Value MUST be part of code list 'procurementTypeCode'.</assert>
         <assert test="not(@listID) or @listID = 'PROJECT_TYPE'"
                 flag="fatal"
                 id="PEPPOL-T024-B10102">Attribute 'listID' MUST contain value 'PROJECT_TYPE'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B10103">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification">
         <assert test="cbc:ItemClassificationCode"
                 flag="fatal"
                 id="PEPPOL-T024-B10301">Element 'cbc:ItemClassificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification/cbc:ItemClassificationCode">
         <assert test="not(@listID) or @listID = 'CPV'"
                 flag="fatal"
                 id="PEPPOL-T024-B10401">Attribute 'listID' MUST contain value 'CPV'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B10402">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B10302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification">
         <assert test="cbc:ItemClassificationCode"
                 flag="fatal"
                 id="PEPPOL-T024-B10601">Element 'cbc:ItemClassificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification/cbc:ItemClassificationCode">
         <assert test="not(@listID) or @listID = 'CPV'"
                 flag="fatal"
                 id="PEPPOL-T024-B10701">Attribute 'listID' MUST contain value 'CPV'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T024-B10702">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B10602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B10901">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID">
         <assert test="not(@schemeID) or @schemeID = 'NUTS'"
                 flag="fatal"
                 id="PEPPOL-T024-B11001">Attribute 'schemeID' MUST contain value 'NUTS'</assert>
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T024-B11002">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B10902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProject/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B09806">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T024-B11201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID"/>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T024-B11401">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject/cbc:Name"/>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B11402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/cac:ProcurementProjectLot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B11202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:CallForTenders/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T024-B00115">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
    
      <let name="syntaxError"
           value="string('[PEPPOL-T024-S003] A Call For Tenders document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
      <rule context="ubl:CallForTenders">
        <report id="PEPPOL-T024-S301" flag="warning" test="(ext:UBLExtensions)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S301] UBLExtensions SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S305"
                 flag="warning"
                 test="(cbc:ProfileExecutionID)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S305] ProfileExecutionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S307" flag="warning" test="(cbc:CopyIndicator)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S307] CopyIndicator SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S308" flag="warning" test="(cbc:UUID)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S308] UUID SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R001" flag="fatal" test="exists(cbc:UBLVersionID)">[PEPPOL-T024-R001] A Call For Tenders MUST have a syntax identifier.</assert>
        <report id="PEPPOL-T024-S310" flag="warning" test="(cbc:ApprovalDate)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S310] ApprovalDate SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R007" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T024-R007] A Call For Tenders MUST have an issue time.</assert>
        <assert id="PEPPOL-T024-R024"
                 flag="fatal"
                 test="count(distinct-values(cac:AdditionalDocumentReference/cbc:ID)) = count(cac:AdditionalDocumentReference/cbc:ID)">[PEPPOL-T024-R024] Additional Document Reference Identifiers MUST be unique.</assert>
        <assert id="PEPPOL-T024-R029"
                 flag="fatal"
                 test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[PEPPOL-T024-R029] Lot identifiers MUST be unique.</assert>
        <report id="PEPPOL-T024-S311" flag="warning" test="(cbc:Note)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S311] Note SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-R038" flag="fatal" test="(cbc:VersionID)">[PEPPOL-T024-R038] A Call For Tenders MUST have a version identifier</assert>
        <report id="PEPPOL-T024-S313" flag="warning" test="(cbc:PreviousVersionID)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S313] PreviousVersionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S314"
                 flag="warning"
                 test="(cac:LegalDocumentReference)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S314] LegalDocumentReference SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S315"
                 flag="warning"
                 test="(cac:TechnicalDocumentReference)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S315] TechnicalDocumentReference SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S331" flag="warning" test="(cac:Signature)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S331] Signature SHOULD NOT be used.</report>
        <report id="PEPPOL-T024-S332"
                 flag="warning"
                 test="count(cac:ContractingParty) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S332] ContractingParty SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S345"
                 flag="warning"
                 test="(cac:OriginatorCustomerParty)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S345] OriginatorCustomerParty SHOULD NOT be used.</report>
        <assert id="PEPPOL-T024-S347" flag="warning" test="(cac:TenderingTerms)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S347] TenderingTerms SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S368" flag="warning" test="(cac:TenderingProcess)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S368] TenderingProcess SHOULD be used.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:UBLVersionID">
        
        <assert id="PEPPOL-T024-R040"
                 flag="fatal"
                 test="normalize-space(.) = '2.2'">[PEPPOL-T024-R040] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T024-S302" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:CustomizationID">
        <assert id="PEPPOL-T024-R002"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t004:1.2'">[PEPPOL-T024-R002] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t004:1.2'</assert>
        <report id="PEPPOL-T024-S303" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S303] CustomizationID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:ProfileID">
        <assert id="PEPPOL-T024-R003"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p002:1.2'">[PEPPOL-T024-R003] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p002:1.2'</assert>
        <report id="PEPPOL-T024-S304" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S304] ProfileID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:ID">
        <assert id="PEPPOL-T024-R004" flag="warning" test="./@schemeURI">[PEPPOL-T024-R004] A Call For Tenders Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T024-R005"
                 flag="warning"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T024-R005] schemeURI for Call For Tenders Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T024-R006"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T024-R006] A Call For Tenders Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T024-S306"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S306] A Call For Tenders Identifier SHOULD NOT have any attributes but schemeURI</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:ContractFolderID">
        <report id="PEPPOL-T024-S309" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S309] ContractFolderID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:IssueTime">
        <assert id="PEPPOL-T024-R008"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T024-R008] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T024-R009"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T024-R009] IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cbc:VersionID">
        <report id="PEPPOL-T024-S312" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S312] VersionID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='REQ']">
        <assert id="PEPPOL-T024-S317"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentTypeCode)-count(./cbc:DocumentStatusCode)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S317] AdditionalDocumentReference for a Document with DocumentTypeCode='REQ' SHOULD NOT contain any elements but ID, DocumentTypeCode, DocumentStatusCode</assert>
        <assert id="PEPPOL-T024-R023"
                 flag="fatal"
                 test="normalize-space(./cbc:DocumentStatusCode) !='NR'">[PEPPOL-T024-R023] DocumentStatusCode 'NR' is NOT valid for an AdditionalDocumentReference with DocumentType 'REQ'</assert>
        <report id="PEPPOL-T024-S326"
                 flag="warning"
                 test="count(./cbc:DocumentDescription) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S326] DocumentDescription SHOULD NOT be used more than once when DocumentTypeCode = 'REQ'.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']">
        <assert id="PEPPOL-T024-R036" flag="fatal" test="(./cac:Attachment)">[PEPPOL-T024-R036] A Provided Document Reference MUST reference the provided document.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference[normalize-space(./cbc:DocumentTypeCode)='PRO']/cbc:DocumentDescription">
        <assert id="PEPPOL-T024-R030"
                 flag="fatal"
                 test="/ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID = normalize-space(.)">[PEPPOL-T024-R030] DocumentDescription MUST be a valid Procurement Project Lot Identifier"/&gt;</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference">
        <assert id="PEPPOL-T024-S316"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)-count(./cbc:IssueDate)-count(./cbc:DocumentTypeCode)-count(./cbc:LocaleCode)-count(./cbc:VersionID)-count(./cbc:DocumentStatusCode)-count(./cbc:DocumentDescription)-count(./cac:Attachment)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S316] AdditionalDocumentReference SHOULD NOT contain any elements but ID, IssueDate, DocumentTypeCode, LocaleCode, VersionID, DocumentStatusCode, DocumentDescription, Attachment.</assert>
        <assert id="PEPPOL-T024-S318"
                 flag="warning"
                 test="(./cbc:DocumentTypeCode)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S318] DocumentTypeCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S323"
                 flag="warning"
                 test="(./cbc:DocumentStatusCode)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S323] DocumentStatusCode SHOULD be used.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:ID">
        <report id="PEPPOL-T024-S319" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S319] Additional Document Reference Identifier SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T024-R017" flag="fatal" test="./@listID">[PEPPOL-T024-R017] DocumentTypeCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R018"
                 flag="fatal"
                 test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">[PEPPOL-T024-R018] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</assert>
        <assert id="PEPPOL-T024-R019"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(PRO|REQ|916)$')">[PEPPOL-T024-R019] DocumentTypeCode MUST be one of 'PRO' or 'REQ' or '916'.</assert>
        <report id="PEPPOL-T024-S320"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S320] DocumentTypeCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T024-R014" flag="fatal" test="./@listID">[PEPPOL-T024-R014] LocaleCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R015"
                 flag="fatal"
                 test="normalize-space(./@listID)='ISO639-1'">[PEPPOL-T024-R015] listID for LocaleCode MUST be 'ISO639-1'.</assert>
        <assert id="PEPPOL-T024-R016"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">[PEPPOL-T024-R016] LocalCode MUST be a valid Language Code.</assert>
        <report id="PEPPOL-T024-S321"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S321] LocaleCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:VersionID">
        <report id="PEPPOL-T024-S322" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S322] Additional Document Reference VersionIdentifier SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentStatusCode">
        <assert id="PEPPOL-T024-R020" flag="fatal" test="./@listID">[PEPPOL-T024-R020] DocumentStatusCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T024-R021"
                 flag="fatal"
                 test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentStatusType'">[PEPPOL-T024-R021] listID for DocumentStatusCode MUST be 'urn:eu:esens:cenbii:documentStatusType'.</assert>
        <assert id="PEPPOL-T024-R022"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(NR|RWOS|RWAS|RWQS)$')">[PEPPOL-T024-R022] DocumentStatusCode MUST be one of NR,RWOS, RWAS ,RWQS</assert>
        <report id="PEPPOL-T024-S324"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S324] DocumentStatusCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cbc:DocumentDescription">
        <report id="PEPPOL-T024-S325" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S325] DocumentDescription SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment">
        <assert id="PEPPOL-T024-S328"
                 flag="warning"
                 test="count(./*)-count(./cac:ExternalReference)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S328] Attachment SHOULD NOT contain any element but ExternalReference</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
        <assert id="PEPPOL-T024-S329"
                 flag="warning"
                 test="count(./*)-count(./cbc:URI)-count(./cbc:MimeCode)-count(./cbc:FileName)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S329] ExternalReference SHOULD NOT contain any element but URI, MimeCode, FileName</assert>
        <assert id="PEPPOL-T024-R035"
                 flag="fatal"
                 test="(./cbc:URI) or (./cbc:FileName)">[PEPPOL-T024-R035] ExternalReference MUST include either URI or FileName</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
        <report id="PEPPOL-T024-S330" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S330] URI SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
        <report id="PEPPOL-T024-S395" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S395] MimeCode SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
        <report id="PEPPOL-T024-S396" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S396] FileName SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty">
        <assert id="PEPPOL-T024-S333"
                 flag="warning"
                 test="count(./*)-count(./cac:Party)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S333] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T024-S334"
                 flag="warning"
                 test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S334] A ContractingParty/cac:Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
        <assert id="PEPPOL-T024-S336"
                 flag="warning"
                 test="count(./cac:PartyIdentification) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S336] PartyIdentification SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T024-S338"
                 flag="warning"
                 test="count(./cac:PartyName) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S338] PartyName SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S340"
                 flag="warning"
                 test="count(./cac:PartyLegalEntity) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S340] PartyLegalEntity SHOULD NOT be used more than once.</report>
        <assert id="PEPPOL-T024-R034"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T024-R034] A Call for Tenders MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ReceiverParty">
        <assert id="PEPPOL-T024-S500"
                 flag="warning"
                 test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)-count(./cac:PartyLegalEntity)= 0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S334] A cac:ReceivingParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName, PartyLegalEntity</assert>
        <assert id="PEPPOL-T024-S501"
                 flag="warning"
                 test="count(./cac:PartyIdentification) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-500] PartyIdentification SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T024-S502"
                 flag="warning"
                 test="count(./cac:PartyName) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S501] PartyName SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T024-S503"
                 flag="warning"
                 test="count(./cac:PartyLegalEntity) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S502] PartyLegalEntity SHOULD NOT be used more than once.</report>
        <assert id="PEPPOL-T024-R534"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T024-R534] A Call for Tenders MUST identify the Economic Operator / Receiving Party by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="cbc:EndpointID">
        <assert id="PEPPOL-T024-R012" flag="fatal" test="./@schemeID">[PEPPOL-T024-R012] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T024-R013"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T024-R013] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T024-S335"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S335] EndpointID SHOULD NOT have any further attributes but schemeID</report>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T024-R010" flag="fatal" test="./@schemeID">[PEPPOL-T024-R010] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T024-R011"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T024-R011] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T024-S337"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S337] cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
      </rule>
    
      <rule context="cbc:Name">
        <report id="PEPPOL-T024-S339" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S339] Name SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="cbc:IndustryClassificationCode">
        <assert id="PEPPOL-T024-R041" flags="fatal" test="./@listID">[PEPPOL-T024-R041] The Codelist used to define the receiver's economic operator role in this tender MUST be named by using the attribute listID and the ID has to be /"tendererRole/".</assert>
        <assert id="PEPPOL-T024-S360"
                 flag="warning"
                 test="not(./@*[not(name()='listID')])">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S360] cbc:IndustryClassificationCode SHOULD NOT have any further attributes but listID</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity">
        <assert id="PEPPOL-T024-S341"
                 flag="warning"
                 test="count(./*)-count(./cac:RegistrationAddress)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S341] PartyLegalEntity SHOULD NOT contain any elements but cac:RegistrationAddress.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
        <assert id="PEPPOL-T024-S342"
                 flag="warning"
                 test="count(./*)-count(./cac:Country)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S342] RegistrationAddress SHOULD NOT contain any elements but cac:Country.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
        <assert id="PEPPOL-T024-S343"
                 flag="warning"
                 test="count(./*)-count(./cbc:IdentificationCode)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S343] Country SHOULD NOT contain any elements but IdentificationCode.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ContractingParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
        <report id="PEPPOL-T024-S344"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S344] IdentificationCode SHOULD NOT have any attributes but listID,</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms">
        <assert id="PEPPOL-T024-S348"
                 flag="warning"
                 test="count(./*)-count(./cbc:MaximumVariantQuantity)-count(./cbc:VariantConstraintIndicator)-count(./cbc:Note)-count(./cbc:AdditionalConditions)-count(./cac:ProcurementLegislationDocumentReference)-count(./cac:CallForTendersDocumentReference)-count(./cac:TenderRecipientParty)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S348] TenderingTerms SHOULD NOT contain any element but MaximumVariantQuantity, VariantConstraintIndicator, Note, AdditionalConditions, ProcurementLegislationDocumentReference, CallForTendersDocumentReference, TenderRecipientParty.</assert>
        <assert id="PEPPOL-T024-S353"
                 flag="warning"
                 test="(./cbc:VariantConstraintIndicator)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S353] VariantConstraintIndicator SHOULD be used.</assert>
        <report id="PEPPOL-T024-S354" flag="warning" test="count(./cbc:Note) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S354] Note SHOULD NOT be used more than once</report>
        <report id="PEPPOL-T024-S358"
                 flag="warning"
                 test="count(./cbc:AdditionalConditions) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S358] AdditionalConditions SHOULD NOT be used more than once</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity">
        <assert id="PEPPOL-T024-S349"
                 flag="warning"
                 test="matches(normalize-space(.),'^\d+$')">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S349] MaximumVariantQuantity SHOULD be expressed as an integer value.</assert>
        <report id="PEPPOL-T024-S350" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S350] MaximumVariantQuantity SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='false']">
        <assert id="PEPPOL-T024-S351"
                 flag="warning"
                 test="count(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)=0 or normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)='0'">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S351] MaximumVariantQuantity SHOULD NOT be used or MUST be equal to 0 when VariantConstraintIndicator is set to false.</assert>
      </rule>
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:VariantConstraintIndicator[normalize-space(.)='true']">
        <assert id="PEPPOL-T024-R032"
                 flag="fatal"
                 test="number(normalize-space(/ubl:CallForTenders/cac:TenderingTerms/cbc:MaximumVariantQuantity)) &gt; 0">[PEPPOL-T024-R032] MaximumVariantQuantity MUST be greater than 0 when VariantConstraintIndicator is set to true.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:Note">
        <assert id="PEPPOL-T024-S355"
                 flag="warning"
                 test="matches(normalize-space(.),'^\d+$')">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S355] Note SHOULD be expressed as an integer value when used.</assert>
        <report id="PEPPOL-T024-S357" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S357] Note SHOULD NOT contain any attributes.</report>
        <assert id="PEPPOL-T024-R031"
                 flag="fatal"
                 test="normalize-space(/ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode)='POSTAL'">[PEPPOL-T024-R031] Note MUST only be used when Submission Method Code equals to POSTAL</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cbc:AdditionalConditions">
        <assert id="PEPPOL-T024-R033"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(WOS|WAS|WQS)$')">[PEPPOL-T024-R033] AdditionalConditions value MUST be one of 'WOS', 'WAS, 'WQS'.</assert>
        <assert id="PEPPOL-T024-S360" flag="warning" test="not(./@*)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S360] AdditionalConditions SHOULD NOT contain any attributes.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference">
        <assert id="PEPPOL-T024-S361"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)-count(./cbc:DocumentDescription)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S361] ProcurementLegislationDocumentReference SHOULD NOT contain any elements but ID, DocumentDescription.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:ID">
        <report id="PEPPOL-T024-S362" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S362] ProcurementLegislationDocumentReference Identifier SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:ProcurementLegislationDocumentReference/cbc:DocumentDescription">
        <report id="PEPPOL-T024-S363" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S363] ProcurementLegislationDocumentReference DocumentDescription SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference">
        <assert id="PEPPOL-T024-S364"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S364] CallForTendersDocumentReference SHOULD NOT contain any elements but ID</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:CallForTendersDocumentReference/cbc:ID">
        <assert id="PEPPOL-T024-R025" flag="fatal" test="./@schemeURI">[PEPPOL-T024-R025] A Call For Tenders Document Reference Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T024-R026"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T024-R026] schemeURI for Call For Tenders Document Reference Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T024-R027"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T024-R027] A Call For Tenders Document Reference Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T024-S365"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S365] A Call For Tenders Document Reference Identifier SHOULD NOT have any attributes but schemeURI</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingTerms/cac:TenderRecipientParty">
        <assert id="PEPPOL-T024-S367"
                 flag="warning"
                 test="count(./*)-count(./cbc:EndpointID)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S367] TenderRecipientParty SHOULD NOT contain any elements but EndpointID</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess">
        <assert id="PEPPOL-T024-S369"
                 flag="warning"
                 test="count(./*)-count(./cbc:ProcedureCode)-count(./cbc:ContractingSystemCode)-count(./cbc:SubmissionMethodCode)-count(./cac:TenderSubmissionDeadlinePeriod)-count(./cac:ParticipationRequestReceptionPeriod)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S369] TenderingProcess SHOULD NOT contain any elements but ProcedureCode, ContractingSystemCode, SubmissionMethodCode, TenderSubmissionDeadlinePeriod, ParticipationRequestReceptionPeriod.</assert>
        <assert id="PEPPOL-T024-S370" flag="warning" test="(./cbc:ProcedureCode)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S370] ProcedureCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S373"
                 flag="warning"
                 test="(./cac:TenderSubmissionDeadlinePeriod)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S373] TenderSubmissionDeadlinePeriod SHOULD be used.</assert>
        <assert id="PEPPOL-T024-R037"
                 flag="fatal"
                 test="(cbc:ProcedureCode = '1' and not(exists(cac:ParticipationRequestReceptionPeriod))) or (cbc:ProcedureCode!='1')">[PEPPOL-T024-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ProcedureCode">
        <report id="PEPPOL-T024-S371"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S371] ProcedureCode SHOULD NOT have any attributes but listID.</report>
        <assert id="PEPPOL-T024-R037"
                 flag="fatal"
                 test="(cbc:ProcedureCode = '1' and not(exists(cac:ParticipationRequestReceptionPeriod))) or (cbc:ProcedureCode!='1')">[PEPPOL-T024-R037] Participation Request Reception Period MUST not be given for proceduretypes without participation contest.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:ContractingSystemCode">
        <report id="PEPPOL-T024-S397"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S397] ContractingSystemCode SHOULD NOT have any attributes but listID.</report>
        <assert id="PEPPOL-T024-R039"
                 flag="fatal"
                 test="not (cbc:ContractingSystemCode in ('1', '2', '3'))">[PEPPOL-T024-R039] A Call For Tender is only allowed to use une of the following ContractSystemCodes: 'Public Contract', 'Establishment of a Framework agreement' or 'Setting up a Dynamic Purchasing System'.</assert>        
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess/cbc:SubmissionMethodCode">
        <report id="PEPPOL-T024-S372"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S372] SubmissionMethodCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:TenderSubmissionDeadlinePeriod">
        <assert id="PEPPOL-T024-S374"
                 flag="warning"
                 test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S374] TenderSubmissionDeadlinePeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
        <assert id="PEPPOL-T024-S375" flag="warning" test="(./cbc:EndDate)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S375] TenderSubmissionDeadlinePeriod EndDate SHOULD be used.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:TenderingProcess/cac:ParticipationRequestReceptionPeriod">
        <assert id="PEPPOL-T024-S376"
                 flag="warning"
                 test="count(./*)-count(./cbc:EndDate)-count(./cbc:EndTime)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S376] ParticipationRequestReceptionPeriod SHOULD NOT contain any elements but EndDate and EndTime.</assert>
        
      </rule>
    
      <rule context="cbc:EndTime">
        <assert id="PEPPOL-T024-R028"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T024-R028] EndTime MUST include timezone information.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject">
        <assert id="PEPPOL-T024-S378"
                 flag="warning"
                 test="count(./*)-count(./cbc:Name)-count(./cbc:Description)-count(./cbc:ProcurementTypeCode)-count(./cac:MainCommodityClassification)-count(./cac:AdditionalCommodityClassification)-count(./cac:RealizedLocation)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S378] ProcurementProject SHOULD NOT contain any elements but Name, Description, ProcurementTypeCode, MainCommodityClassification, AdditionalCommodityClassification, RealizedLocation.</assert>
        <assert id="PEPPOL-T024-S379" flag="warning" test="count(./cbc:Name) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S379] ProcurementProject Name SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S380"
                 flag="warning"
                 test="count(./cbc:Description) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S380] ProcurementProject Description SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S382"
                 flag="warning"
                 test="(./cbc:ProcurementTypeCode)">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S382] ProcurementTypeCode SHOULD be used.</assert>
        <assert id="PEPPOL-T024-S384"
                 flag="warning"
                 test="count(./cac:MainCommodityClassification) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S384] ProcurementProject MainCommodityClassification SHOULD be used exactly once.</assert>
        <assert id="PEPPOL-T024-S388"
                 flag="warning"
                 test="count(./cac:RealizedLocation) &gt; 0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S388] ProcurementProject RealizedLocation SHOULD be used at least once.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:Description">
        <report id="PEPPOL-T024-S381" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S381] ProcurementProject Description SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cbc:ProcurementTypeCode">
        <report id="PEPPOL-T024-S383"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S383] ProcurementTypeCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:MainCommodityClassification">
        <assert id="PEPPOL-T024-S385"
                 flag="warning"
                 test="count(./*)-count(./cbc:ItemClassificationCode)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S385] MainCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:AdditionalCommodityClassification">
        <assert id="PEPPOL-T024-S386"
                 flag="warning"
                 test="count(./*)-count(./cbc:ItemClassificationCode)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S386] AdditionalCommodityClassification SHOULD NOT contain any elements but ItemClassificationCode.</assert>
      </rule>
    
      <rule context="cbc:ItemClassificationCode">
        <report id="PEPPOL-T024-S387"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S387] ItemClassificationCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation">
        <assert id="PEPPOL-T024-S389"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S389] RealizedLocation SHOULD NOT contain any elements but ID.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProject/cac:RealizedLocation/cbc:ID">
        <report id="PEPPOL-T024-S390"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S390] cac:RealizedLocation/cbc:ID SHOULD NOT have any attributes but schemeID.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T024-S391"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)-count(./cac:ProcurementProject)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S391] ProcurementProjectLot SHOULD NOT contain any elements but ID, ProcurementProject.</assert>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cbc:ID">
        <report id="PEPPOL-T024-S392" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S392] ProcurementProjectLot Identifier SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:CallForTenders/cac:ProcurementProjectLot/cac:ProcurementProject">
        <assert id="PEPPOL-T024-S393"
                 flag="warning"
                 test="count(./*)-count(./cbc:Name)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S393] ProcurementProjectLot ProcurementProject SHOULD NOT contain any elements but Name.</assert>
        <assert id="PEPPOL-T024-S394" flag="warning" test="count(./cbc:Name) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T024-S394] ProcurementProjectLot ProcurementProject Name SHOULD   be used exactly once.</assert>
      </rule>
    
      <rule context="cbc:ProcedureCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' comp-dial comp-tend innovation neg-w-call neg-wo-call open oth-mult oth-single restricted ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T83-R001">[CL-T83-R001]-A procedure type MUST be one of the following:  comp-dial, comp-tend, innovation, neg-w-call, neg-wo-call, open, oth-mult, oth-single, restricted</assert>
      </rule>
    
      <rule context="cbc:ProcurementTypeCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 4 5 6 9 Z ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T83-R002">[CL-T83-R002]-A procurement project type MUST be one of the following: 1, 2, 4, 5, 6, 9, Z</assert>
      </rule>
    
      <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T83-R005">[CL-T83-R005]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
      </rule>
   </pattern>

</schema>
