<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>eSENS business and syntax rules for Tender Withdrawal Receipt Notification (TRDM045)</title>

    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:TenderReceipt-2"/>
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
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244', '\s')"/>
      <rule context="/ubl:TenderReceipt">
         <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T014-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T014-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T014-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T014-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:ContractFolderID" flag="fatal" id="PEPPOL-T014-B00105">Element 'cbc:ContractFolderID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T014-B00106">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T014-B00107">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cbc:RegisteredDate" flag="fatal" id="PEPPOL-T014-B00108">Element 'cbc:RegisteredDate' MUST be provided.</assert>
         <assert test="cbc:RegisteredTime" flag="fatal" id="PEPPOL-T014-B00109">Element 'cbc:RegisteredTime' MUST be provided.</assert>
         <assert test="cac:TenderDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T014-B00110">Element 'cac:TenderDocumentReference' MUST be provided.</assert>
         <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T014-B00111">Element 'cac:SenderParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T014-B00112">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T014-B00113">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T014-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:UBLVersionID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:CustomizationID">
         <assert test="normalize-space(text()) = '&#xA;                urn:fdc:peppol.eu:prac:trns:t014:1.1&#xA;            '"
                 flag="fatal"
                 id="PEPPOL-T014-B00301">Element 'cbc:CustomizationID' MUST contain value '
                urn:fdc:peppol.eu:prac:trns:t014:1.1
            '.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:CustomizationID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p007:1.1'"
                 flag="fatal"
                 id="PEPPOL-T014-B00401">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p007:1.1'.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:ProfileID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T014-B00501">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T014-B00502">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:ID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00503">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:ContractFolderID"/>
      <rule context="/ubl:TenderReceipt/cbc:ContractFolderID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:IssueDate"/>
      <rule context="/ubl:TenderReceipt/cbc:IssueDate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:IssueTime"/>
      <rule context="/ubl:TenderReceipt/cbc:IssueTime/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:RegisteredDate"/>
      <rule context="/ubl:TenderReceipt/cbc:RegisteredDate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cbc:RegisteredTime"/>
      <rule context="/ubl:TenderReceipt/cbc:RegisteredTime/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T014-B01201">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:DocumentTypeCode" flag="fatal" id="PEPPOL-T014-B01202">Element 'cbc:DocumentTypeCode' MUST be provided.</assert>
         <assert test="cac:Attachment" flag="fatal" id="PEPPOL-T014-B01203">Element 'cac:Attachment' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cbc:ID">
         <assert test="not(@schemeURI) or @schemeURI = 'urn:uuid'"
                 flag="fatal"
                 id="PEPPOL-T014-B01301">Attribute 'schemeURI' MUST contain value 'urn:uuid'</assert>
         <assert test="@schemeURI" flag="fatal" id="PEPPOL-T014-B01302">Attribute 'schemeURI' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cbc:ID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01303">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cbc:DocumentTypeCode">
         <assert test="normalize-space(text()) = '13 or 310'"
                 flag="fatal"
                 id="PEPPOL-T014-B01501">Element 'cbc:DocumentTypeCode' MUST contain value '13 or 310'.</assert>
         <assert test="not(@listID) or @listID = 'UNCL1001'"
                 flag="fatal"
                 id="PEPPOL-T014-B01502">Attribute 'listID' MUST contain value 'UNCL1001'</assert>
         <assert test="@listID" flag="fatal" id="PEPPOL-T014-B01503">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cbc:DocumentTypeCode/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment">
         <assert test="cac:External Reference" flag="fatal" id="PEPPOL-T014-B01701">Element 'cac:External Reference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference"/>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference/cbc:Document Hash"/>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference/cbc:Document Hash/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference/cbc:HashAlgorithmMethod">
         <assert test="normalize-space(text()) = 'http://www.w3.org/2001/04/xmlenc#sha256'"
                 flag="fatal"
                 id="PEPPOL-T014-B02001">Element 'cbc:HashAlgorithmMethod' MUST contain value 'http://www.w3.org/2001/04/xmlenc#sha256'.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference/cbc:HashAlgorithmMethod/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:External Reference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T014-B02101">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T014-B02201">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty/cbc:EndpointID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:TenderDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B01204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty"/>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cbc:EndpointID"/>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cbc:EndpointID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyIdentification"/>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T014-B02801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyIdentification/cbc:ID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyName"/>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyName/cbc:Name/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/cac:PartyName/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:SenderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B02401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty">
         <assert test="cac:PartyIdentification" flag="fatal" id="PEPPOL-T014-B03201">Element 'cac:PartyIdentification' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T014-B03301">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cbc:EndpointID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T014-B03501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T014-B03601">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T014-B03602">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyIdentification/cbc:ID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03603">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T014-B03801">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyName/cbc:Name/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/cac:PartyName/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B03202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:TenderReceipt/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T014-B00114">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
    
      <let name="syntaxError"
           value="string('[PEPPOL-T45-S003] A Tender Withdrawal Receipt Notification document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    
      <rule context="ubl:TenderReceipt">
        <assert id="PEPPOL-T014-R001" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T014-R001] A Tender Withdrawal
            Receipt Notification MUST have a syntax identifier.
        </assert>
        <assert id="PEPPOL-T014-S301" flag="warning" test="not(ext:UBLExtensions)">
            [PEPPOL-T014-S301] UBLExtensions SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S305"
                 flag="warning"
                 test="not(cbc:ProfileExectuionID)">[PEPPOL-T014-S305] ProfileExecutionID SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S307" flag="warning" test="not(cbc:CopyIndicator)">
            [PEPPOL-T014-S307] CopyIndicator SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S308" flag="warning" test="not(cbc:UUID)">
            [PEPPOL-T014-S308] UUID SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S310" flag="warning" test="not(cbc:ConctractName)">[PEPPOL-T014-S310] ContractName SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S312" flag="warning" test="not(cbc:Note)">
            [PEPPOL-T014-S312] Note SHOULD NOT be used.
        </assert>
        <assert id="PEPPOL-T014-S313"
                 flag="warning"
                 test="3 &gt; count(cac:TenderDocumentReference)">[PEPPOL-T014-S313] TenderDocumentReference SHOULD NOT be used more than twice.
        </assert>
        <assert id="PEPPOL-T014-S322" flag="warning" test="not(cac:Signature)">
            [PEPPOL-T014-S322] Signature SHOULD NOT be used.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:UBLVersionID">
        <assert id="PEPPOL-T014-R019"
                 flag="fatal"
                 test="normalize-space(.) = '2.2'">[PEPPOL-T014-R019] UBLVersionID
            value MUST be '2.2'
        </assert>
        <assert id="PEPPOL-T014-S302" flag="warning" test="not(./@*)">[PEPPOL-T014-S302]
            UBLVersionID SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:CustomizationID">
        <assert id="PEPPOL-T014-R002"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t014:1.1'">
            [PEPPOL-T014-R002] CustomizationID value MUST be
            'urn:fdc:peppol.eu:prac:trns:t014:1.1'
        </assert>
        <assert id="PEPPOL-T014-S303" flag="warning" test="not(./@*)">[PEPPOL-T014-S303]
            CustomizationID SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:ProfileID">
        <assert id="PEPPOL-T014-R003"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p007:1.1'">[PEPPOL-T014-R003] ProfileID
            value MUST be 'urn:fdc:peppol.eu:prac:bis:p007:1.1'
        </assert>
        <assert id="PEPPOL-T014-S304" flag="warning" test="not(./@*)">[PEPPOL-T014-S304]
            ProfileID SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:ID">
        <assert id="PEPPOL-T014-R004" flag="fatal" test="./@schemeURI">[PEPPOL-T014-R004] A Tender Withdrawal Receipt
            Notification Identifier MUST have a schemeURI attribute.
        </assert>
        <assert id="PEPPOL-T014-R005"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T014-R005]
            schemeURI for Tender Withdrawal Receipt Notification Identifier MUST be 'urn:uuid'.
        </assert>
        <assert id="PEPPOL-T014-S306"
                 flag="warning"
                 test="./@*[name()='schemeURI']">[PEPPOL-T014-S306] A Tender Withdrawal Receipt Notification Identifier SHOULD NOT have
            any attributes but schemeURI
        </assert>
        <assert id="PEPPOL-T014-R006"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
            [PEPPOL-T014-R006] A Tender Withdrawal Receipt Notification Identifier MUST be expressed in a UUID syntax (RFC 4122)
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:ContractFolderID">
        <assert id="PEPPOL-T014-S309" flag="warning" test="not(./@*)">[PEPPOL-T014-S309]
            ContractFolderID SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:IssueTime">
        <assert id="PEPPOL-T014-R007"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
            [PEPPOL-T014-R007] IssueTime MUST have a granularity of seconds
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cbc:RegisteredTime">
        <assert id="PEPPOL-T014-R012"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
            [PEPPOL-T014-R012] Reception of tender withdrawal time MUST have a granularity of seconds.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference">
        <assert id="PEPPOL-T014-S314"
                 flag="warning"
                 test="count(./*) - count(./cbc:ID) - count(./cbc:DocumentTypeCode) - count(./cac:Attachment) - count(./cac:IssuerParty) = 0">
            [PEPPOL-T014-S314] TenderDocumentReference SHOULD NOT contain any
            elements but ID, DocumentTypeCode, Attachment, IssuerParty.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:ID">
        <assert id="PEPPOL-T014-R013"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
            [PEPPOL-T014-R013] The document reference Identifier MUST reference the Tender ID expressed in a UUID
            syntax (RFC 4122)
        </assert>
        <assert id="PEPPOL-T014-R014" flag="fatal" test="./@schemeURI">[PEPPOL-T014-R004] A Tender Document Reference Identifier MUST have a schemeURI attribute.
        </assert>
        <assert id="PEPPOL-T014-R015"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T014-R005]
            schemeURI for Tender Document Reference Identifier MUST be 'urn:uuid'.
        </assert>
        <assert id="PEPPOL-T014-S315"
                 flag="warning"
                 test="./@*[name()='schemeURI']">[PEPPOL-T014-S306] A Tender Document Reference Identifier SHOULD NOT have
            any attributes but schemeURI
        </assert>
        <assert id="PEPPOL-T014-R016"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
            [PEPPOL-T014-R006] A Tender Document Reference Identifier MUST be expressed in a UUID syntax (RFC 4122)
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T014-R017"
                 flag="fatal"
                 test="(normalize-space(.)='13') or (normalize-space(.)='310')">[PEPPOL-T014-R014] The document type code for the document reference (the received tender) MUST be '310' or '13' if you refer to a REM evidence.
        </assert>
        <assert id="PEPPOL-T014-R023"
                 flag="fatal"
                 test="normalize-space(./@listID)='UNCL1001'">[PEPPOL-T014-R023]
            listID for Document Type Code MUST be 'UNCL1001'.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment">
        <assert id="PEPPOL-T014-S316"
                 flag="warning"
                 test="count(./*)-count(./cac:ExternalReference)=0">[PEPPOL-T014-S316] Attachment SHOULD NOT contain any elements but
            ExternalReference
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference">
        <assert id="PEPPOL-T014-S317"
                 flag="warning"
                 test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)=0">[PEPPOL-T014-S317] Attachment/ExternalReference SHOULD NOT contain any
            elements but DocumentHash, HashAlgorithmMethod
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
        <assert id="PEPPOL-T014-R018"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">
            [PEPPOL-T014-R015] DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)
        </assert>
        <assert id="PEPPOL-T014-S318" flag="warning" test="not(./@*)">[PEPPOL-T014-S318]
            DocumentHash SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
        <assert id="PEPPOL-T014-R022"
                 flag="fatal"
                 test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">[PEPPOL-T014-R016]
            HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'
        </assert>
        <assert id="PEPPOL-T014-S319" flag="warning" test="not(./@*)">[PEPPOL-T014-S319]
            HashAlgorithmMethod SHOULD NOT contain any attributes.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty">
        <assert id="PEPPOL-T014-S320"
                 flag="warning"
                 test="count(./*)-count(./cbc:EndpointID)=0">[PEPPOL-T014-S320] IssuerParty SHOULD NOT contain any elements but EndpointID.
        </assert>
      </rule>
    
      <rule context="cbc:EndpointID">
        <assert id="PEPPOL-T014-R010" flag="fatal" test="./@schemeID">[PEPPOL-T014-R010] An Endpoint Identifier MUST
            have a scheme identifier attribute.
        </assert>
        <assert id="PEPPOL-T014-R011"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            [PEPPOL-T014-R011] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers
            described in the "PEPPOL Policy for using Identifiers".
        </assert>
        <assert id="PEPPOL-T014-S321" flag="warning" test="./@*[name()='schemeID']">[PEPPOL-T014-S321] EndpointID SHOULD NOT have any attributes but schemeID
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:SenderParty">
        <assert id="PEPPOL-T014-R020"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
            [PEPPOL-T014-R017] A Tender Withdrawal Receipt Notification MUST identify the Contracting Authority by its party and
            endpoint identifiers.
        </assert>
      </rule>
    
      <rule context="ubl:TenderReceipt/cac:ReceiverParty">
        <assert id="PEPPOL-T014-R021"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
            [PEPPOL-T014-R018] A Tender Withdrawal Receipt Notification MUST identify the Economic Operator by its party and
            endpoint identifiers.
        </assert>
      </rule>
    
    
      <rule context="ubl:TenderReceipt/cac:SenderParty | ubl:TenderReceipt/cac:ReceiverParty">
        <assert id="PEPPOL-T014-S323"
                 flag="warning"
                 test="count(./*) - count(./cac:PartyIdentification) - count(./cbc:EndpointID) - count(./cac:PartyName) = 0">
            [PEPPOL-T014-S323] ContractingParty Party SHOULD NOT contain any
            elements but EndpointID, PartyIdentification, PartyName
        </assert>
        <assert id="PEPPOL-T014-S324"
                 flag="warning"
                 test="count(./cac:PartyIdentification) = 1">[PEPPOL-T014-S324] PartyIdentification SHOULD be used exactly once.
        </assert>
        <assert id="PEPPOL-T014-S326"
                 flag="warning"
                 test="2 &gt; count(./cac:PartyName)">[PEPPOL-T014-S326] PartyName SHOULD NOT be used more than once.
        </assert>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T014-R008" flag="fatal" test="./@schemeID">[PEPPOL-T014-R008] A Party Identifier MUST have
            a scheme identifier attribute.
        </assert>
        <assert id="PEPPOL-T014-R009"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">
            [PEPPOL-T014-R009] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described
            in the "PEPPOL Policy for using Identifiers".
        </assert>
        <assert id="PEPPOL-T014-S325" flag="warning" test="./@*[name()='schemeID']">[PEPPOL-T014-S325] PartyIdentifier SHOULD NOT have any further attributes but
            schemeID
        </assert>
      </rule>
    
      <rule context="cbc:Name">
        <assert id="PEPPOL-T014-S327" flag="warning" test="not(./@*)">[PEPPOL-T014-S327]
            Name SHOULD NOT contain any attributes.
        </assert>
      </rule>
   </pattern>
</schema>
