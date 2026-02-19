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
       uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
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
      <let name="clmessageResponse" value="tokenize('RE AP CA', '\s')"/>
      <rule context="/ubl:ApplicationResponse">
         <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T018-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T018-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T018-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T018-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T018-B00105">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T018-B00106">Element 'cac:SenderParty' MUST be provided.</assert>
         <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T018-B00107">Element 'cac:ReceiverParty' MUST be provided.</assert>
         <assert test="cac:DocumentResponse" flag="fatal" id="PEPPOL-T018-B00108">Element 'cac:DocumentResponse' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T018-B00109">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T018-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cbc:CustomizationID"/>
      <rule context="/ubl:ApplicationResponse/cbc:ProfileID">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p010:1.1'"
                 flag="fatal"
                 id="PEPPOL-T018-B00401">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p010:1.1'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cbc:ID"/>
      <rule context="/ubl:ApplicationResponse/cbc:IssueDate"/>
      <rule context="/ubl:ApplicationResponse/cbc:IssueTime"/>
      <rule context="/ubl:ApplicationResponse/cac:SenderParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-B00801">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-B00901">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T018-B00902">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:SenderParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B00802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-B01101">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-B01201">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T018-B01202">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B01102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse">
         <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-B01401">Element 'cac:Response' MUST be provided.</assert>
         <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T018-B01402">Element 'cac:DocumentReference' MUST be provided.</assert>
         <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-B01403">Element 'cac:Response' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
         <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T018-B01501">Element 'cbc:ResponseCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode">
         <assert test="(some $code in $clmessageResponse satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T018-B01601">Value MUST be part of code list 'MessageResponseCode'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B01502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T018-B01801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B01802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse">
         <assert test="cac:LineReference" flag="fatal" id="PEPPOL-T018-B02101">Element 'cac:LineReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference">
         <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T018-B02201">Element 'cbc:LineID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B02202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B02102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
         <assert test="cbc:Description" flag="fatal" id="PEPPOL-T018-B02401">Element 'cbc:Description' MUST be provided.</assert>
         <assert test="cac:Status" flag="fatal" id="PEPPOL-T018-B02402">Element 'cac:Status' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode">
         <assert test="(some $code in $clmessageResponse satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T018-B02501">Value MUST be part of code list 'MessageResponseCode'.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cac:Status">
         <assert test="cbc:StatusReasonCode" flag="fatal" id="PEPPOL-T018-B02701">Element 'cbc:StatusReasonCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cac:Status/cbc:StatusReasonCode"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cac:Status/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B02702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B02403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B01404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ApplicationResponse/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T018-B00110">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
    
      <rule context="/*">
        <assert id="PEPPOL-T018-R002" test="not(@*:schemaLocation)" flag="warning">Document SHOULD not contain schema location.
        </assert>
        
      </rule>
    
      <rule context="cbc:IssueDate">
        <assert id="PEPPOL-T018-R003"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.
        </assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse">
        <assert test="cbc:UBLVersionID" flag="fatal" id="PEPPOL-T018-R004">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T018-R005">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T018-R006">Element 'cbc:ProfileID' MUST be provided.</assert>
        <assert test="cbc:ID" flag="fatal" id="PEPPOL-T018-R007">Element 'cbc:ID' MUST be provided.</assert>
        <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T018-R008">Element 'cbc:IssueDate' MUST be provided.</assert>
        <assert test="cac:SenderParty" flag="fatal" id="PEPPOL-T018-R009">Element 'cac:SenderParty' MUST be provided.</assert>
        <assert test="cac:ReceiverParty" flag="fatal" id="PEPPOL-T018-R010">Element 'cac:ReceiverParty' MUST be provided.</assert>
        <assert test="cac:DocumentResponse" flag="fatal" id="PEPPOL-T018-R011">Element 'cac:DocumentResponse' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cbc:UBLVersionID">
        <assert test="normalize-space(text()) = '2.2'"
                 flag="fatal"
                 id="PEPPOL-T018-R012">Element 'cbc:UBLVersionID' MUST contain value '2.2'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cbc:CustomizationID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t018:1.1'"
                 flag="fatal"
                 id="PEPPOL-T018-R013">Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:prac:trns:T018:1.1'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cbc:ProfileID">
        <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p010:1.1'"
                 flag="fatal"
                 id="PEPPOL-T018-R014">Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p010:1.1'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cbc:ID"/>
      <rule context="/ubl:ApplicationResponse/cbc:IssueDate"/>
    
      <rule context="/ubl:ApplicationResponse/cbc:IssueTime">
        <assert id="PEPPOL-T018-R015"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T018-R016"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:SenderParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-R017">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-R018">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T018-R019"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:SenderParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R020">Document MUST NOT contain elements not part of the
            data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty">
        <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T018-R021">Element 'cbc:EndpointID' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID">
        <assert test="@schemeID" flag="fatal" id="PEPPOL-T018-R022">Attribute 'schemeID' MUST be present.</assert>
        <assert flag="fatal"
                 id="PEPPOL-T018-R023"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
            Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:ReceiverParty/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R024">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse">
        <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-R025">Element 'cac:Response' MUST be provided.</assert>
        <assert test="cac:DocumentReference" flag="fatal" id="PEPPOL-T018-R026">Element 'cac:DocumentReference' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response">
        <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T018-R027">Element 'cbc:ResponseCode' MUST be provided.</assert>
        <assert test="cbc:Description" flag="fatal" id="PEPPOL-T018-R028">Element 'cbc:Description' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode">
        <assert test="matches(normalize-space(.),'^(RE|AP|CA)')"
                 flag="fatal"
                 id="PEPPOL-T018-R029">
            Value MUST be part of code list 'Message Response Code'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"/>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R030">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference">
        <assert id="PEPPOL-T018-R031" flag="fatal" test="cbc:ID">Element 'cbc:ID' MUST be provided.</assert>
        <assert id="PEPPOL-T018-R032" flag="fatal" test="cbc:DocumentTypeCode">Element 'cbc:DocumentTypeCode' MUST be provided.</assert>
        <assert id="PEPPOL-T018-R033"
                 flag="fatal"
                 test="count(distinct-values(cac:DocumentReference/cbc:ID)) = count(cac:DocumentReference/cbc:ID)">Element 'cbc:ID' MUST be unique.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T018-R034"
                 flag="fatal"
                 test="matches(normalize-space(.),'urn:fdc:peppol\.eu:prac:trns:t0[0,1][0-9]:1\.1')">Value MUST be a valid transactionID.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R035">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse">
        <assert test="cac:LineReference" flag="fatal" id="PEPPOL-T018-R036">Element 'cac:LineReference' MUST be provided.</assert>
        <assert test="cac:Response" flag="fatal" id="PEPPOL-T018-R037">Element 'cac:Response' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference">
        <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T018-R038">Element 'cbc:LineID' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R039">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response">
        <assert test="cbc:ResponseCode" flag="fatal" id="PEPPOL-T018-R040">Element 'cbc:ResponseCode' MUST be provided.</assert>
        <assert test="cbc:Description" flag="fatal" id="PEPPOL-T018-R041">Element 'cbc:Description' MUST be provided.</assert>
        <assert test="cac:Status" flag="fatal" id="PEPPOL-T018-R042">Element 'cac:Status' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode">
        <assert flag="fatal"
                 id="PEPPOL-T018-R043"
                 test="matches(normalize-space(.),'^(RE|AP|CA)$')">Value MUST be part of code list 'Message Response Code'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status">
        <assert test="cbc:StatusReasonCode" flag="fatal" id="PEPPOL-T018-R044">Element 'cbc:StatusReasonCode' MUST be provided.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode">
        <assert flag="fatal"
                 id="PEPPOL-T018-R045"
                 test="matches(normalize-space(.),'^(BV|BW|SV|NF|DL|RF|WT|IR|MA|AE|PT)$')">Value MUST be part of code list 'Status Reason Code'.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R046">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description"/>
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R047">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/cac:DocumentResponse/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R048">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
    
      <rule context="/ubl:ApplicationResponse/*">
        <assert test="false()" flag="fatal" id="PEPPOL-T018-R049">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
</schema>
