<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>eSENS business and syntax rules for Tender Status Request</title>
    
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
       prefix="ext"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:TenderStatusRequest-2"
       prefix="ubl"/>
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
      <rule context="/ubl:TenderStatusRequest">
         <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T003-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T003-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T003-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T003-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T003-B00105">Element 'cbc:ContractFolderID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T003-B00106">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T003-B00107">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cac:ContractingParty" flag="fatal" id="PEPPOL-T003-B00108">Element 'cac:ContractingParty' MUST be provided.</assert>
         <assert test="cac:EconomicOperatorParty"
                 flag="fatal"
                 id="PEPPOL-T003-B00109">Element 'cac:EconomicOperatorParty' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T003-B00110">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T003-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cbc:CustomizationID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t003:1.2'"
                 flag="fatal"
                 id="PEPPOL-T003-B00301">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t003:1.2'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p002:1.2'"
                 flag="fatal"
                 id="PEPPOL-T003-B00401">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p002:1.2'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T003-B00501">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T003-B00502">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cbc:ContractFolderID"/>
      <rule context="/ubl:TenderStatusRequest/cbc:IssueDate"/>
      <rule context="/ubl:TenderStatusRequest/cbc:IssueTime"/>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T003-B01001">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T003-B01101">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T003-B01102">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T003-B01201">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T003-B01202">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T003-B01401">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T003-B01501">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T003-B01502">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T003-B01701">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B01103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ContractingParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B01002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T003-B01901">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T003-B02001">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T003-B02002">Element 'cac:PartyIdentification' MUST be provided.</assert>
         <assert test="cac:PartyName" flag="fatal" id="PEPPOL-T003-B02003">Element 'cac:PartyName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T003-B02101">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T003-B02102">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T003-B02301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T003-B02401">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T003-B02402">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T003-B02601">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B02004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:EconomicOperatorParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B01902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ProcurementProjectLot">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T003-B02801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/cac:ProcurementProjectLot/cbc:ID"/>
      <rule context="/ubl:TenderStatusRequest/cac:ProcurementProjectLot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B02802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderStatusRequest/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T003-B00111">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
    
      <rule context="*">
        <report id="PEPPOL-T003-S002"
                 flag="fatal"
                 test="normalize-space(.) = '' and not(*)">[PEPPOL-T003-S002] A Tender Status Inquiry document MUST NOT contain empty elements.</report>
      </rule>
        
      <let name="syntaxError"
           value="string('[PEPPOL-T003-S003] A Tender Status Inquiry document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
      <rule context="ubl:TenderStatusRequest">
        <assert id="PEPPOL-T003-R024" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T003-R024] A Tender Status Inquiry MUST have a syntax identifier.</assert>
        <assert id="PEPPOL-T003-R001" flag="fatal" test="(cbc:CustomizationID)">[PEPPOL-T003-R001] A Tender Status Inquiry MUST have a specification (customization) identifier.</assert>
        <assert id="PEPPOL-T003-R002" flag="fatal" test="(cbc:ProfileID)">[PEPPOL-T003-R002] A Tender Status Inquiry MUST have a business process (profile) identifier.</assert>
        <assert id="PEPPOL-T003-R003" flag="fatal" test="(cbc:ID)">[PEPPOL-T003-R003] A Tender Status Inquiry MUST have a Tender Status Inquiry identifier.</assert>
        <assert id="PEPPOL-T003-R004" flag="fatal" test="(cbc:ContractFolderID)">[PEPPOL-T003-R004] A Tender Status Inquiry MUST have a reference number.</assert>
        <assert id="PEPPOL-T003-R005" flag="fatal" test="(cbc:IssueDate)">[PEPPOL-T003-R005] A Tender Status Inquiry MUST have an issue date.</assert>
        <assert id="PEPPOL-T003-R015" flag="fatal" test="(cbc:IssueTime)">[PEPPOL-T003-R015] A Tender Status Inquiry MUST have an issue time.</assert>
        <assert id="PEPPOL-T003-R022"
                 flag="fatal"
                 test="count(distinct-values(cac:ProcurementProjectLot/cbc:ID)) = count(cac:ProcurementProjectLot/cbc:ID)">[PEPPOL-T003-R022] Lot identifiers MUST be unique.</assert>
        <report id="PEPPOL-T003-S301" flag="warning" test="(ext:UBLExtensions)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S301] UBLExtensions SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S305"
                 flag="warning"
                 test="(cbc:ProfileExectuionID)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S305] ProfileExecutionID SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S307" flag="warning" test="(cbc:CopyIndicator)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S307] CopyIndicator SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S308" flag="warning" test="(cbc:UUID)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S308] UUID SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S310" flag="warning" test="(cbc:ContractName)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S310] ContractName SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S311" flag="warning" test="(cbc:Note)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S311] Note SHOULD NOT be used.</report>
        <report id="PEPPOL-T003-S312" flag="warning" test="(cac:Signature)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S312] Signature SHOULD NOT be used.</report>
        <assert id="PEPPOL-T003-S313"
                 flag="warning"
                 test="count(cac:ContractingParty) = 1">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S313] ContractingParty SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T003-S321"
                 flag="warning"
                 test="(cac:ProcurementProject)">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S321] ProcurementProject SHOULD NOT be used.</report>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cbc:UBLVersionID">
        <assert id="PEPPOL-T003-R023"
                 flag="fatal"
                 test="normalize-space(.) = '2.2'">[PEPPOL-T003-R023] UBLVersionID value MUST be '2.2'</assert>
        <report id="PEPPOL-T003-S302" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S302] UBLVersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
     <rule context="ubl:TenderStatusRequest/cbc:CustomizationID">
         <assert id="PEPPOL-T003-R010"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t003:1.2'">[PEPPOL-T003-R010] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t003:1.2'</assert>
        <report id="PEPPOL-T003-S303" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S303] CustomizationID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cbc:ProfileID">
        <assert id="PEPPOL-T003-R011"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p002:1.2'">[PEPPOL-T003-R011] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p002:1.2'</assert>
        <report id="PEPPOL-T003-S304" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S304] ProfileID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cbc:ID">
        <assert id="PEPPOL-T003-R012" flag="fatal" test="./@schemeURI">[PEPPOL-T003-R012] A Tender Status Inquiry Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T003-R013"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T003-R013] schemeURI for Tender Status Inquiry Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T003-S306"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S306] ID SHOULD NOT have any further attributes but schemeURI</report>
        <assert id="PEPPOL-T003-R014"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T003-R014] A Tender Status Inquiry Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cbc:ContractFolderID">
        <report id="PEPPOL-T003-S309" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S309] ContractFolderID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cbc:IssueTime">
        <assert id="PEPPOL-T003-R016"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T003-R016] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T003-R017"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T003-R017] IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cac:ContractingParty">
        <assert id="PEPPOL-T003-S314"
                 flag="warning"
                 test="count(./*)-count(./cac:Party)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S314] ContractingParty SHOULD NOT contain any elements but cac:Party.</assert>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty">
        <assert id="PEPPOL-T003-S324"
                 flag="warning"
                 test="count(./*)-count(./cac:Party)=0">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S324] EconomicOperatorParty SHOULD NOT contain any elements but cac:Party.</assert>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T003-R007"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T003-R007] A Tender Status Inquiry MUST identify the Contracting Body by its party and endpoint identifiers.</assert>
      </rule>

      <rule context="ubl:TenderStatusRequest/cac:EconomicOperatorParty/cac:Party">
        <assert id="PEPPOL-T003-R008"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">[PEPPOL-T003-R008] A Tender Status Inquiry MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
        <assert id="PEPPOL-T003-R009" flag="warning" test="(./cac:PartyName)">[PEPPOL-T003-R009] A Tender Status Inquiry MUST include the name of the Economic Operator.</assert>
      </rule>
    
      <rule context="cac:Party">
        <assert id="PEPPOL-T003-S315"
                 flag="warning"
                 test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S315] Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
        <report id="PEPPOL-T003-S317"
                 flag="warning"
                 test="count(./cac:PartyIdentification) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S317] PartyIdentification SHOULD NOT be used more than once</report>
        <report id="PEPPOL-T003-S319"
                 flag="warning"
                 test="count(./cac:PartyName) &gt; 1">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S319] PartyName SHOULD NOT be used more than once</report>
      </rule>    
    
      <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T003-R020" flag="fatal" test="./@schemeID">[PEPPOL-T003-R020] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T003-R021"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T003-R021] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T003-S316"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S316] EndpointID SHOULD NOT have any attributes but schemeID</report>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T003-R018" flag="fatal" test="./@schemeID">[PEPPOL-T003-R018] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T003-R019"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\\d)|(1\\d{2})|(20\\d)|(21[0-3])))$')">[PEPPOL-T003-R019] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T003-S318"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S318] cac:PartyIdentification/cbc:ID SHOULD NOT have any attributes but schemeID</report>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T003-S322"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)= 0">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S322] ProcurementProjectLot SHOULD NOT contain any elements but cbc:ID</assert>
      </rule>
    
      <rule context="ubl:TenderStatusRequest/cac:ProcurementProjectLot/cbc:ID">
        <report id="PEPPOL-T003-S323" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S323] cac:ProcurementProjectLot/cbc:ID SHOULD NOT have any attributes</report>
      </rule>
    
      <rule context="cbc:Name">
        <report id="PEPPOL-T003-S320" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T003-S320] cbc:Name SHOULD NOT have any attributes</report>
      </rule>

   </pattern>

</schema>
