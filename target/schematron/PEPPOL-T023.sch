<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">
        
    <title>PEPPOL business and syntax rules for QualificationResponse</title>
    <ns prefix="cbc"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ext"
       uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl"
       uri="urn:oasis:names:specification:ubl:schema:xsd:TendererQualificationResponse-2"/>
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
           value="string('A QualificationResponse document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>
    
      <rule context="/ubl:TendererQualificationResponse">
        <assert id="PEPPOL-T023-R002" test="cbc:UBLVersionID" flag="fatal">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R003" test="cbc:CustomizationID" flag="fatal">Element 'cbc:CustomizationID' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R004" test="cbc:ProfileID" flag="fatal">Element 'cbc:ProfileID' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R005" test="cbc:ID" flag="fatal">Element 'cbc:ID' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R006" test="cbc:ContractFolderID" flag="fatal">Element 'cbc:ContractFolderID' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R007" test="cbc:IssueDate" flag="fatal">Element 'cbc:IssueDate' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R008" test="cbc:IssueTime" flag="fatal">Element 'cbc:IssueTime' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R009" test="cac:SenderParty" flag="fatal">Element 'cac:SenderParty' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R010" test="cac:ReceiverParty" flag="fatal">Element 'cac:ReceiverParty' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R011"
                 flag="fatal"
                 test="cac:ResolutionDocumentReference">Element 'cac:ResolutionDocumentReference' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R012"
                 flag="fatal"
                 test="cac:QualificationResolution">Element 'cac:QualificationResolution' MUST be provided.</assert>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cbc:UBLVersionID">
        <assert id="PEPPOL-T023-R013"
                 flag="fatal"
                 test="normalize-space(.) = '2.2'">UBLVersionID value MUST be '2.2'.</assert>
        <report id="PEPPOL-T023-R014" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>UBLVersionID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cbc:CustomizationID">
        <assert id="PEPPOL-T023-R015"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t023:1.0'">CustomizationID value MUST be 'urn:fdc:peppol.eu:prac:trns:t023:1.0'</assert>
        <report id="PEPPOL-T023-R016" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>CustomizationID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cbc:ProfileID">
        <assert id="PEPPOL-T023-R017"
                 flag="fatal"
                 test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p012:1.0'">ProfileID value MUST be 'urn:fdc:peppol.eu:prac:bis:p012:1.0'</assert>
        <report id="PEPPOL-T023-R018" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>ProfileID SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cbc:ID">
        <assert id="PEPPOL-T023-R019" flag="fatal" test="./@schemeURI">A Qualification Response Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T023-R020"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">schemeURI for Qualification Response Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T023-R021"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>A Qualification Response Identifier SHOULD NOT have any attributes but schemeURI</report>
        <assert id="PEPPOL-T023-R022"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">A Qualification Response Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cbc:ContractFolderID">
        <report id="PEPPOL-T023-R023" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>ContractFolderID SHOULD NOT contain any attributes.</report>
        <assert id="PEPPOL-T023-R024"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">The ContractFolderID MUST be expressed in a UUID syntax (RFC 4122).</assert>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cbc:IssueTime">
        <assert id="PEPPOL-T023-R025"
                 flag="fatal"
                 test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">IssueTime MUST have a granularity of seconds</assert>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cac:SenderParty">
        <assert id="PEPPOL-T023-R026"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Qualification Response MUST identify the Contracting Authority as SenderParty by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cac:ReceiverParty">
        <assert id="PEPPOL-T023-R027"
                 flag="fatal"
                 test="(./cac:PartyIdentification) and (./cbc:EndpointID)">A Qualification Response MUST identify the Economic Operator as ReceiverParty by its party and endpoint identifiers.</assert>
      </rule>
    
      <rule context="cac:PartyIdentification/cbc:ID">
        <assert id="PEPPOL-T023-R028" flag="fatal" test="./@schemeID">A Party Identifier MUST have a scheme identifier attribute.</assert>
        <assert id="PEPPOL-T023-R029"
                 flag="fatal"
                 test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers".</assert>
        <report id="PEPPOL-T023-R030"
                 flag="warning"
                 test="./@*[not(name()='schemeID')]">
            <value-of select="$syntaxError"/>PartyIdentifier SHOULD NOT have any further attributes but schemeID</report>
      </rule>
    
      <rule context="cbc:Name">
        <report id="PEPPOL-T023-R031" flag="warning" test="./@*">
            <value-of select="$syntaxError"/>Name SHOULD NOT contain any attributes.</report>
      </rule>
    
      <rule context="ubl:TendererQualificationResponse/cac:SenderParty | ubl:TendererQualificationResponse/cac:ReceiverParty">
        <assert id="PEPPOL-T023-R032"
                 flag="warning"
                 test="count(./*)-count(./cac:PartyIdentification)-count(./cbc:EndpointID)-count(./cac:PartyName)= 0">
            <value-of select="$syntaxError"/> SenderParty or ReceiverParty SHOULD NOT contain any elements but EndpointID, PartyIdentification, PartyName</assert>
        <assert id="PEPPOL-T023-R033"
                 flag="warning"
                 test="count(./cac:PartyIdentification) = 1">
            <value-of select="$syntaxError"/>PartyIdentification SHOULD be used exactly once.</assert>
        <report id="PEPPOL-T023-R034"
                 flag="warning"
                 test="count(./cac:PartyName) &gt; 1">
            <value-of select="$syntaxError"/>PartyName SHOULD NOT be used more than once.</report>
        <report id="PEPPOL-T023-R043"
                 flag="warning"
                 test="count(./cbc:PartyName) &lt; 1">
            <value-of select="$syntaxError"/>PartyName SHOULD be given.</report>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cac:ResolutionDocumentReference/cbc:ID">
        <assert id="PEPPOL-T023-R035" flag="fatal" test="./@schemeURI">A Response Document Reference Identifier MUST have a schemeURI attribute.</assert>
        <assert id="PEPPOL-T023-R036"
                 flag="fatal"
                 test="normalize-space(./@schemeURI)='urn:uuid'">schemeURI for Response Document Reference Identifier MUST be 'urn:uuid'.</assert>
        <report id="PEPPOL-T023-R037"
                 flag="warning"
                 test="./@*[not(name()='schemeURI')]">
            <value-of select="$syntaxError"/>A Response Document Reference Identifier SHOULD NOT have any attributes but schemeURI</report>
        <assert id="PEPPOL-T023-R038"
                 flag="fatal"
                 test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">A Response Document Reference Identifier MUST be expressed in a UUID syntax (RFC 4122)</assert>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cac:QualificationResolution">
        <assert id="PEPPOL-T023-R039" flag="fatal" test="cbc:AdmissionCode">Element 'cbc:AdmissionCode' MUST be provided.</assert>
        <assert id="PEPPOL-T023-R040" flag="fatal" test="cbc:ResolutionDate">Element 'cbc:ResolutionDate' MUST be provided.</assert>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cac:QualificationResolution/cbc:Resolution">
        <assert id="PEPPOL-T023-R042"
                 flag="fatal"
                 test="(../cbc:AdmissionCode = 'false' and not(cbc:Resolution))">Qualification Resolution Element with cbc:AdmissionCode 'false'  has to have at least one Resolution element.</assert>
      </rule>
      <rule context="ubl:TendererQualificationResponse/cac:QualificationResolution/cac:ProcurementProjectLot">
        <report id="PEPPOL-T023-R044"
                 flag="warning"
                 test="(not(cac:ProcurementProjectLot))">If a Qualification Response Resolution has to be expressed for more than one lot in a procurement, the appropriate lot identifier SHOULD be named.</report>
      </rule>
   </pattern>
</schema>
