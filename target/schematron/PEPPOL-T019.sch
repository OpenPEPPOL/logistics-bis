<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>eSENS business and syntax rules for Qualification</title>

    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:TendererQualification-2"/>
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
    
    <pattern>
    
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
        <assert test="cac:TendererPartyQualification"
                 flag="fatal"
                 id="PEPPOL-T019-R010">Element 'cac:TendererPartyQualification' MUST be provided.</assert>
        <assert test="cac:ContractingParty" flag="fatal" id="PEPPOL-T019-R011">Element 'cac:ContractingParty' MUST be provided.</assert>
        <assert test="cac:AdditionalDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T019-R012">Element 'cac:AdditionalDocumentReference' MUST be provided.</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:UBLVersionID">
        <assert id="PEPPOL-T019-R013"
                 flag="fatal"
                 test="normalize-space(.) = '2.2'">UBLVersionID value MUST be '2.2'.</assert>
        <report id="PEPPOL-T019-R014" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>UBLVersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:CustomizationID">
        <assert id="PEPPOL-T019-R015"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t019:1.1'">CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t019:1.1'</assert>
        <report id="PEPPOL-T019-R016" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>CustomizationID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:ProfileID">
        <assert id="PEPPOL-T019-R017"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p011:1.1'">ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p011:1.1'</assert>
        <report id="PEPPOL-T019-R018" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>ProfileID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:ID">
        <assert id="PEPPOL-T019-R019" flag="fatal" test="./@schemeURI">A Submit Tender Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T019-R020"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">schemeURI for Submit Tender Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T019-R021"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>A Submit Tender Identifier SHOULD NOT have any attributes but schemeURI</report>
        <assert id="PEPPOL-T019-R022"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">A Submit Tender Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:ContractFolderID">
        <report id="PEPPOL-T019-R023" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>ContractFolderID SHOULD NOT contain any attributes.</report>
        <assert id="PEPPOL-T019-R024"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">The ContractFolderID MUST be expressed in a UUID syntax (RFC 4122).</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:IssueTime">
        <assert id="PEPPOL-T019-R025"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cbc:VersionID">
        <report id="PEPPOL-T019-R026" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>VersionID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference">
        <report id="PEPPOL-T019-R027"
                 flag="warning"
                 test="count(./cbc:DocumentDescription) &gt; 1">
            <value-of select="$syntaxError"/>DocumentDescription SHOULD NOT be used more than once.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:ID">
        <assert id="PEPPOL-T019-R028"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">Identifier for a Qualification Reference document MUST be expressed in a UUID syntax (RFC 4122).</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T019-R029"
                 flag="fatal"
                 test="normalize-space(./@listID)='UNCL1001'">listID for DocumentTypeCode MUST be 'UNCL1001'.</assert>
        <report id="PEPPOL-T019-R030"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>DocumentTypeCode SHOULD NOT have any attributes but listID</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:XPath">
        <report id="PEPPOL-T019-R031" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>XPath SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T019-R032"
                 flag="fatal"
                 test="normalize-space(./@listID)='ISO639-1'">listID for LocaleCode MUST be 'ISO639-1'.</assert>
        <assert id="PEPPOL-T019-R033"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(aa|AA|ab|AB|ae|AE|af|AF|ak|AK|am|AM|an|AN|ar|AR|as|AS|av|AV|ay|AY|az|AZ|ba|BA|be|BE|bg|BG|bh|BH|bi|BI|bm|BM|bn|BN|bo|BO|br|BR|bs|BS|ca|CA|ce|CE|ch|CH|co|CO|cr|CR|cs|CS|cu|CU|cv|CV|cy|CY|da|DA|de|DE|dv|DV|dz|DZ|ee|EE|el|EL|en|EN|eo|EO|es|ES|et|ET|eu|EU|fa|FA|ff|FF|fi|FI|fj|FJ|fo|FO|fr|FR|fy|FY|ga|GA|gd|GD|gl|GL|gn|GN|gu|GU|gv|GV|ha|HA|he|HE|hi|HI|ho|HO|hr|HR|ht|HT|hu|HU|hy|HY|hz|HZ|ia|IA|id|ID|ie|IE|ig|IG|ii|II|ik|IK|io|IO|is|IS|it|IT|iu|IU|ja|JA|jv|JV|ka|KA|kg|KG|ki|KI|kj|KJ|kk|KK|kl|KL|km|KM|kn|KN|ko|KO|kr|KR|ks|KS|ku|KU|kv|KV|kw|KW|ky|KY|la|LA|lb|LB|lg|LG|li|LI|ln|LN|lo|LO|lt|LT|lu|LU|lv|LV|mg|MG|mh|MH|mi|MI|mk|MK|ml|ML|mn|MN|mo|MO|mr|MR|ms|MS|mt|MT|my|MY|na|NA|nb|NB|nd|ND|ne|NE|ng|NG|nl|NL|nn|NN|no|NO|nr|NR|nv|NV|ny|NY|oc|OC|oj|OJ|om|OM|or|OR|os|OS|pa|PA|pi|PI|pl|PL|ps|PS|pt|PT|qu|QU|rm|RM|rn|RN|ro|RO|ru|RU|rw|RW|sa|SA|sc|SC|sd|SD|se|SE|sg|SG|si|SI|sk|SK|sl|SL|sm|SM|sn|SN|so|SO|sq|SQ|sr|SR|ss|SS|st|ST|su|SU|sv|SV|sw|SW|ta|TA|te|TE|tg|TG|th|TH|ti|TI|tk|TK|tl|TL|tn|TN|to|TO|tr|TR|ts|TS|tt|TT|tw|TW|ty|TY|ug|UG|uk|UK|ur|UR|uz|UZ|ve|VE|vi|VI|vo|VO|wa|WA|wo|WO|xh|XH|yi|YI|yo|YO|za|ZA|zh|ZH|zu|ZU)$')">LocalCode MUST be a valid Language Code.</assert>
        <report id="PEPPOL-T019-R034"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>LocaleCode SHOULD NOT have any attributes but listID.</report>
      </rule>
    
      <rule context="ubl:TenderTendererQualification/cac:AdditionalDocumentReference/cbc:VersionID">
        <report id="PEPPOL-T019-R035" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>VersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cbc:DocumentDescription">
        <report id="PEPPOL-T019-R036" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>DocumentDescription SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment">
        <assert id="PEPPOL-T019-R037"
                 flag="warning"
                 test="count(./*)-count(./cac:ExternalReference)=0">
            <value-of select="$syntaxError"/>Attachment SHOULD NOT contain any elements but ExternalReference</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI">
        <assert id="PEPPOL-T019-R038"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">URI for a Qualification Reference external reference attachment MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T019-R039" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>URI SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
        <assert id="PEPPOL-T019-R040"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)</assert>
        <report id="PEPPOL-T019-R041" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>DocumentHash SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
        <assert id="PEPPOL-T019-R042"
                 flag="fatal"
                 test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'</assert>
        <report id="PEPPOL-T019-R043" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>HashAlgorithmMethod SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:MimeCode">
        <report id="PEPPOL-T019-R044" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>MimeCode SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:FileName">
        <report id="PEPPOL-T019-R045" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>FileNAme SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:Description">
        <report id="PEPPOL-T019-R046" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Description SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:MainQualifyingParty/cac:Party">
        <assert id="PEPPOL-T019-R047"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Qualification MUST identify the Economic Operator by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:ContractingParty">
        <assert id="PEPPOL-T019-R048"
                 flag="warning"
                 test="count(./*)-count(./cac:Party)=0">
            <value-of select="$syntaxError"/>ContractingParty SHOULD NOT contain any elements but Party.</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:ContractingParty/cac:Party">
        <assert id="PEPPOL-T019-R049"
                 flag="warning"
                 test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0">
            <value-of select="$syntaxError"/>ContractingParty Party SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
        <report id="PEPPOL-T019-R050"
                 flag="warning"
                 test="count(./cac:PartyName) &gt; 1">
            <value-of select="$syntaxError"/>ContractingParty/Party/PartyName SHOULD NOT be used more than once.</report>
        <assert id="PEPPOL-T019-R051"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">The Contracting Authority MUST be identified by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T019-R052"
                 flag="warning"
                 test="count(./*)-count(./cbc:ID)= 0">
            <value-of select="$syntaxError"/>ProcurementProjectLot SHOULD NOT contain any elements but ID</assert>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:ProcurementProjectLot/cbc:ID">
        <report id="PEPPOL-T019-R053" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Procurement Project Lot Identifier SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T019-R054" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T019-R055"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T019-R056"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>cac:PartyIdentification/cbc:ID SHOULD NOT have any further attributes but schemeID</report>
      </rule>
    
      <rule context="cac:Party/cbc:EndpointID">
        <assert id="PEPPOL-T019-R057"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
      </rule>
    
      <rule context="cbc:Name">
        <report id="PEPPOL-T019-R058" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Name SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualification/cac:TendererPartyQualification/cac:MainQualifyingParty/cac:PostalAddress         | ubl:TendererQualification/cac:TendererPartyQualification/cac:AdditionalQualifyingParty/cac:Party/cac:PostalAddress">
        <assert id="PEPPOL-T019-R059"
                 flag="warning"
                 test="count(./*)-count(./cbc:StreetName)-count(./cbc:CityName)-count(./cbc:PostalZone)-count(./cbc:CountrySubentity)-count(./cac:Country)=0">
            <value-of select="$syntaxError"/>PostalAddress SHOULD NOT contain any elements but StreetName, CityName, PostalZone, CountrySubentity, Country</assert>
      </rule>
    
      <rule context="cbc:StreetName">
        <report id="PEPPOL-T019-R060" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>StreetName SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cbc:CityName">
        <report id="PEPPOL-T019-R061" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>CityName SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cbc:PostalZone">
        <report id="PEPPOL-T019-R062" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>PostalZone SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cbc:CountrySubentity">
        <report id="PEPPOL-T019-R063" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>CountrySubentity SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cac:Country">
        <assert id="PEPPOL-T019-R064"
                 flag="warning"
                 test="count(./*)-count(./cbc:IdentificationCode)=0">
            <value-of select="$syntaxError"/>Country SHOULD NOT contain any elements but IdentificationCode.</assert>
      </rule>
    
      <rule context="cac:Country/cbc:IdentificationCode">
        <report id="PEPPOL-T019-R065"
                 flag="warning"
                 test="./@*[not(name()='listID')]">
            <value-of select="$syntaxError"/>Country Identification Code SHOULD NOT contain any attributes but listID</report>
        <assert id="PEPPOL-T019-R066"
                 flag="fatal"
                 test="normalize-space(./@listID)='ISO3166-1:Alpha2'">listID for IdentificationCode MUST be 'ISO3166-1:Alpha2'.</assert>
      </rule>
    
      <rule context="cac:PartyLegalEntity/cbc:CompanyLegalForm">
        <report id="PEPPOL-T019-R067" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>CompanyLegalForm SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cac:Contact">
        <assert id="PEPPOL-T019-R068"
                 flag="warning"
                 test="count(./*)-count(./cbc:Telephone)-count(./cbc:Telefax)-count(./cbc:ElectronicMail)-count(./cbc:Name)= 0">
            <value-of select="$syntaxError"/>Contact SHOULD NOT contain any elements but Telephone, Telefax, ElectronicMail, Name.</assert>
      </rule>
    
      <rule context="cbc:Telephone">
        <report id="PEPPOL-T019-R069" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Telephone SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cbc:Telefax">
        <report id="PEPPOL-T019-R070" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Telefax SHOULD NOT contain any attributes</report>
      </rule>
    
      <rule context="cbc:ElectronicMail">
        <report id="PEPPOL-T019-R071" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>ElectronicMail SHOULD NOT contain any attributes</report>
      </rule>
   </pattern>
</schema>
