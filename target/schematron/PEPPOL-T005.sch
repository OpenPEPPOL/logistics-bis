<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">
        
    <title>eSENS business and syntax rules for Submit Tender (TRDM090)</title>
    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:Tender-2"/>
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
           value="string('[PEPPOL-T005-S003] A Tender document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
      <rule context="ubl:Tender">
        <assert id="PEPPOL-T005-R001" flag="fatal" test="exists(cbc:UBLVersionID)">[PEPPOL-T005-R001] A Tender MUST have a syntax identifier.</assert>
        <assert id="PEPPOL-T005-R002" flag="fatal" test="cbc:UBLVersionID = '2.2'">[PEPPOL-T005-R002] UBLVersionID value MUST be '2.2'</assert>
        <assert id="PEPPOL-T005-R003"
                 flag="fatal"
                 test="exists(cbc:CustomizationID)">[PEPPOL-T005-R003] A Tender MUST have a customization identifier.</assert>
        <assert id="PEPPOL-T005-R004" flag="fatal" test="exists(cbc:ProfileID)">[PEPPOL-T005-R004] A Tender MUST have a profile identifier.</assert>
        <assert id="PEPPOL-T005-R005" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R005] A Tender MUST have an identifier.</assert>
        <assert id="PEPPOL-T005-R006" flag="fatal" test="exists(cbc:IssueTime)">[PEPPOL-T005-R006] A Tender MUST have an issue time.</assert>
        <assert id="PEPPOL-T005-R007" flag="fatal" test="exists(cbc:IssueDate)">[PEPPOL-T005-R007] A Tender MUST have an issue date.</assert>
        <assert id="PEPPOL-T005-R008" flag="fatal" test="exists(cac:TendererParty)">[PEPPOL-T005-R008] A Tender MUST identify the Tenderer Party.</assert>
        <assert id="PEPPOL-T005-R009"
                 flag="fatal"
                 test="exists(cac:ContractingParty)">[PEPPOL-T005-R009] A Tender MUST identify the Contracting Party.</assert>
      </rule>
    
      <rule context="ubl:Tender/cbc:UBLVersionID">
        <report id="PEPPOL-T005-S010" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T005-S010] UBLVersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:Tender/cbc:CustomizationID">
        <assert id="PEPPOL-T005-R010"
                 flag="fatal"
                 test="normalize-space(.) = ('urn:fdc:peppol.eu:prac:trns:t005:1.2','urn:fdc:peppol.eu:prac:trns:t005:1.3')">[PEPPOL-T005-R010] CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t005:1.2' or 'urn:fdc:peppol.eu:prac:trns:t005:1.3'</assert>
        <report id="PEPPOL-T005-S011" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T005-S011] CustomizationID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:Tender/cbc:ProfileID">
        <assert id="PEPPOL-T005-R011"
                 flag="fatal"
                 test="normalize-space(.) = ('urn:fdc:peppol.eu:prac:bis:p003:1.2','urn:fdc:peppol.eu:prac:bis:p003:1.3')">[PEPPOL-T005-R011] ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p003:1.2' or 'urn:fdc:peppol.eu:prac:bis:p003:1.3'</assert>
        <report id="PEPPOL-T005-S012" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>[PEPPOL-T005-S012] ProfileID SHOULD NOT have any attributes.</report>
      </rule>
    
      <rule context="ubl:Tender/cbc:ID">
        <assert id="PEPPOL-T005-R012" flag="warning" test="./@schemeURI">[PEPPOL-T005-R012] A Tender Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T005-R013"
                 flag="warning"
                 test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T005-R013] schemeURI for Tender Identifier MUST be 'urn:uuid'.</assert>
        <assert id="PEPPOL-T005-R014"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">[PEPPOL-T005-R014] A Tender Identifier value MUST be expressed in a UUID syntax (RFC 4122)</assert>
        <report id="PEPPOL-T005-S013"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>[PEPPOL-T005-S013] A Tender Identifier SHOULD NOT have any attributes but schemeURI</report>
      </rule>
    
      <rule context="ubl:Tender/cbc:IssueTime">
        <assert id="PEPPOL-T005-R015"
                 flag="fatal"
                 test="count(timezone-from-time(.)) &gt; 0">[PEPPOL-T005-R015] IssueTime MUST include timezone information.</assert>
        <assert id="PEPPOL-T005-R016"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">[PEPPOL-T005-R016] IssueTime MUST have a granularity of seconds</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:DocumentReference">
        <assert id="PEPPOL-T005-R017" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R017] A Document Reference MUST have an identifier</assert>
        <assert id="PEPPOL-T005-R018"
                 flag="fatal"
                 test="exists(cbc:DocumentTypeCode)">[PEPPOL-T005-R018] A Document Reference MUST have a type code</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:DocumentReference/cbc:DocumentTypeCode">
        <assert id="PEPPOL-T005-R019" flag="fatal" test="./@listID">[PEPPOL-T005-R019] DocumentTypeCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R020"
                 flag="fatal"
                 test="normalize-space(./@listID)='urn:eu:esens:cenbii:documentType'">[PEPPOL-T005-R020] listID for DocumentTypeCode MUST be 'urn:eu:esens:cenbii:documentType'.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:DocumentReference/cbc:LocaleCode">
        <assert id="PEPPOL-T005-R021" flag="fatal" test="./@listID">[PEPPOL-T005-R021] LocaleCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R022"
                 flag="fatal"
                 test="normalize-space(./@listID)='ISO639-1'">[PEPPOL-T005-R022] listID for LocaleCode MUST be 'ISO639-1'.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment">
        <assert id="PEPPOL-T005-R023" flag="fatal" test="exists(cbc:DocumentHash)">[PEPPOL-T005-R023] An Attachment MUST have a document hash</assert>
        <assert id="PEPPOL-T005-R024"
                 flag="fatal"
                 test="exists(cbc:HashAlgorithmMethod)">[PEPPOL-T005-R024] An Attachment MUST have a hash algorithm method</assert>
        <assert id="PEPPOL-T005-R025"
                 flag="fatal"
                 test="normalize-space(cbc:HashAlgorithmMethod) = 'http://www.w3.org/2001/04/xmlenc#sha256'">[PEPPOL-T005-R025] Hash Algorithm MUST be SHA-256 (http://www.w3.org/2001/04/xmlenc#sha256)</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:DocumentReference/cac:Attachment/cac:ExternalReference">
        <assert id="PEPPOL-T005-R026" flag="fatal" test="exists(cbc:URI)">[PEPPOL-T005-R026] An External Reference MUST have a URI</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TendererParty">
        <assert id="PEPPOL-T005-R027" flag="fatal" test="exists(cbc:EndpointID)">[PEPPOL-T005-R027] A Tenderer Party MUST have an endpoint identifier.</assert>
        <assert id="PEPPOL-T005-R028"
                 flag="fatal"
                 test="exists(cac:PartyIdentification)">[PEPPOL-T005-R028] A Tenderer Party MUST have a party identification.</assert>
        <assert id="PEPPOL-T005-R029" flag="fatal" test="exists(cac:PartyName)">[PEPPOL-T005-R029] A Tenderer Party MUST have a party name.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TendererParty/cbc:EndpointID">
        <assert id="PEPPOL-T005-R030" flag="fatal" test="./@schemeID">[PEPPOL-T005-R030] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R031"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T005-R031] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T005-R032" flag="fatal" test="./@schemeID">[PEPPOL-T005-R032] A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R033"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">[PEPPOL-T005-R033] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress">
        <assert id="PEPPOL-T005-R034"
                 flag="fatal"
                 test="exists(cac:Country/cbc:IdentificationCode)">[PEPPOL-T005-R034] A Tenderer Postal Address MUST have a country.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TendererParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
        <assert id="PEPPOL-T005-R035" flag="fatal" test="./@listID">[PEPPOL-T005-R035] Country IdentificationCode MUST have a list Identifier.</assert>
        <assert id="PEPPOL-T005-R036"
                 flag="fatal"
                 test="normalize-space(./@listID)='ISO3166-1:Alpha2'">[PEPPOL-T005-R036] listID for Country IdentificationCode MUST be 'ISO3166-1:Alpha2'.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TendererParty/cac:PartyLegalEntity">
        <assert id="PEPPOL-T005-R037"
                 flag="fatal"
                 test="exists(cac:RegistrationAddress/cac:Country/cbc:IdentificationCode)">[PEPPOL-T005-R037] A Tenderer Party Legal Entity MUST have a country.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:ContractingParty">
        <assert id="PEPPOL-T005-R038"
                 flag="fatal"
                 test="exists(cac:PartyIdentification)">[PEPPOL-T005-R038] A Contracting Party MUST have a party identification.</assert>
        <assert id="PEPPOL-T005-R039" flag="fatal" test="exists(cbc:EndpointID)">[PEPPOL-T005-R039] A Contracting Party MUST have an endpoint identifier.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:ContractingParty/cbc:EndpointID">
        <assert id="PEPPOL-T005-R040" flag="fatal" test="./@schemeID">[PEPPOL-T005-R040] An Endpoint Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T005-R041"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">[PEPPOL-T005-R041] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TenderedProject">
        <assert id="PEPPOL-T005-R042"
                 flag="fatal"
                 test="exists(cac:ProcurementProjectLot)">[PEPPOL-T005-R042] A Tendered Project MUST include at least one Procurement Project Lot.</assert>
      </rule>
    
      <rule context="ubl:Tender/cac:TenderedProject/cac:ProcurementProjectLot">
        <assert id="PEPPOL-T005-R043" flag="fatal" test="exists(cbc:ID)">[PEPPOL-T005-R043] A Procurement Project Lot MUST have an identifier.</assert>
      </rule>
    
      <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T006-R001">[CL-T006-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
      </rule>
    
      <rule context="cbc:DocumentTypeCode" flag="fatal">
        <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 9 13 310 311 916 ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T006-R002">[CL-T006-R002]-A document type code MUST be one of the following values: 9, 13, 310, 311, 916</assert>
      </rule>
         <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T90-R001">[CL-T90-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
        </rule>

        <rule context="cbc:DocumentTypeCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 9 13 310 311 916 ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal"
                 id="CL-T90-R003">DocumentTypeCode  must be from the code list UNCL 1001 9, 13, 310, 311 oder 916.</assert>
        </rule>
   </pattern>
</schema>
