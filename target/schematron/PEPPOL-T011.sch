<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>eSENS business and syntax rules for search notice request</title>

    <ns prefix="rim" uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0"/>
    <ns prefix="query" uri="urn:oasis:names:tc:ebxml-regrep:xsd:query:4.0"/>
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns prefix="u" uri="utils"/>

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
      <let name="cllegalBasis"
           value="tokenize('32014L0023 32009L0081 32014L0024 32014L0025 32018R1046 32007R1370', '\s')"/>
      <rule context="/query:QueryRequest">
         <assert test="rim:Slot@name=SpecificationIdentification"
                 flag="fatal"
                 id="PEPPOL-T011-B00101">Element 'rim:Slot@name=SpecificationIdentification' MUST be provided.</assert>
         <assert test="rim:Slot@name=BusinessProcessTypeIdentifier"
                 flag="fatal"
                 id="PEPPOL-T011-B00102">Element 'rim:Slot@name=BusinessProcessTypeIdentifier' MUST be provided.</assert>
         <assert test="rim:Slot@name=IssueDateTime"
                 flag="fatal"
                 id="PEPPOL-T011-B00103">Element 'rim:Slot@name=IssueDateTime' MUST be provided.</assert>
         <assert test="rim:Slot@name=SenderElectronicAddress"
                 flag="fatal"
                 id="PEPPOL-T011-B00104">Element 'rim:Slot@name=SenderElectronicAddress' MUST be provided.</assert>
         <assert test="rim:Slot@name=ReceiverElectronicAddress"
                 flag="fatal"
                 id="PEPPOL-T011-B00105">Element 'rim:Slot@name=ReceiverElectronicAddress' MUST be provided.</assert>
         <assert test="query:ResponseOption" flag="fatal" id="PEPPOL-T011-B00106">Element 'query:ResponseOption' MUST be provided.</assert>
         <assert test="query:Query" flag="fatal" id="PEPPOL-T011-B00107">Element 'query:Query' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T011-B00108">Document MUST not contain schema location.</assert>
         <assert test="@id" flag="fatal" id="PEPPOL-T011-B00109">Attribute 'id' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B00501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SpecificationIdentification'"
                 flag="fatal"
                 id="PEPPOL-T011-B00502">Attribute 'name' MUST contain value 'SpecificationIdentification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B00503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B00701">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B00702">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B00703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t011:1.2'"
                 flag="fatal"
                 id="PEPPOL-T011-B00901">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t011:1.2'.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B00902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B00704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SpecificationIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B00504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B01001">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BusinessProcessTypeIdentifier'"
                 flag="fatal"
                 id="PEPPOL-T011-B01002">Attribute 'name' MUST contain value 'BusinessProcessTypeIdentifier'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B01003">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B01201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B01202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B01203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p006:1.2'"
                 flag="fatal"
                 id="PEPPOL-T011-B01401">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p006:1.2'.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=BusinessProcessTypeIdentifier/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B01501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'IssueDateTime'"
                 flag="fatal"
                 id="PEPPOL-T011-B01502">Attribute 'name' MUST contain value 'IssueDateTime'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B01503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B01701">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B01702">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B01703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=IssueDateTime/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B01504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B02001">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SenderElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T011-B02002">Attribute 'name' MUST contain value 'SenderElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B02003">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'eas'"
                 flag="fatal"
                 id="PEPPOL-T011-B02004">Attribute 'type' MUST contain value 'eas'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B02005">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B02301">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B02302">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B02303">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/rim:Value">
         <assert test="(some $code in $cleas satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T011-B02501">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B02502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B02304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=SenderElectronicAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B02006">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B02601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ReceiverElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T011-B02602">Attribute 'name' MUST contain value 'ReceiverElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B02603">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'eas'"
                 flag="fatal"
                 id="PEPPOL-T011-B02604">Attribute 'type' MUST contain value 'eas'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B02605">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B02901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B02902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B02903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/rim:Value">
         <assert test="(some $code in $cleas satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T011-B03101">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B03102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B02904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/rim:Slot@name=ReceiverElectronicAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B02606">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:ResponseOption">
         <assert test="not(@returnType) or @returnType = 'LeafClassWithRepositoryItem'"
                 flag="fatal"
                 id="PEPPOL-T011-B03201">Attribute 'returnType' MUST contain value 'LeafClassWithRepositoryItem'</assert>
         <assert test="@returnType" flag="fatal" id="PEPPOL-T011-B03202">Attribute 'returnType' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:ResponseOption/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B03203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query">
         <assert test="not(@queryDefinition) or @queryDefinition = 'SearchNotice'"
                 flag="fatal"
                 id="PEPPOL-T011-B03401">Attribute 'queryDefinition' MUST contain value 'SearchNotice'</assert>
         <assert test="@queryDefinition" flag="fatal" id="PEPPOL-T011-B03402">Attribute 'queryDefinition' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B03601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Keywords'"
                 flag="fatal"
                 id="PEPPOL-T011-B03602">Attribute 'name' MUST contain value 'Keywords'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B03603">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B03801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B03802">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B03803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B03804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Keywords/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B03604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B04101">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'FormType'"
                 flag="fatal"
                 id="PEPPOL-T011-B04102">Attribute 'name' MUST contain value 'FormType'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B04103">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/form-type'"
                 flag="fatal"
                 id="PEPPOL-T011-B04104">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/form-type'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B04105">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B04401">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B04402">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B04403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B04601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B04602">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B04603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=FormType/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04106">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B04901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'NoticeType'"
                 flag="fatal"
                 id="PEPPOL-T011-B04902">Attribute 'name' MUST contain value 'NoticeType'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B04903">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/notice-type'"
                 flag="fatal"
                 id="PEPPOL-T011-B04904">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/notice-type'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B04905">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B05201">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B05202">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B05203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B05401">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B05402">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B05403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B05601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B05404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B05204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeType/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B04906">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B05701">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Classification'"
                 flag="fatal"
                 id="PEPPOL-T011-B05702">Attribute 'name' MUST contain value 'Classification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B05703">Attribute 'name' MUST be present.</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B05704">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B06001">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B06002">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B06003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B06201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B06202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B06203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B06401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B06204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B06004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=Classification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B05705">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B06501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ContractNature'"
                 flag="fatal"
                 id="PEPPOL-T011-B06502">Attribute 'name' MUST contain value 'ContractNature'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B06503">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/contract-nature'"
                 flag="fatal"
                 id="PEPPOL-T011-B06504">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/contract-nature'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B06505">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B06801">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B06802">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B06803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B07001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B07002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B07003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B07201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B07004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B06804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ContractNature/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B06506">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B07301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'PlaceOfPerformance'"
                 flag="fatal"
                 id="PEPPOL-T011-B07302">Attribute 'name' MUST contain value 'PlaceOfPerformance'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B07303">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/nuts'"
                 flag="fatal"
                 id="PEPPOL-T011-B07304">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/nuts'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B07305">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B07601">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B07602">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B07603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B07801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B07802">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B07803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B07804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B07604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PlaceOfPerformance/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B07306">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue">
         <assert test="not(@name) or @name = 'EstimatedValue'"
                 flag="fatal"
                 id="PEPPOL-T011-B08101">Attribute 'name' MUST contain value 'EstimatedValue'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B08102">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B08301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Minimum'"
                 flag="fatal"
                 id="PEPPOL-T011-B08302">Attribute 'name' MUST contain value 'Minimum'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B08303">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B08501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:IntegerValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B08502">Attribute 'xsi:type' MUST contain value 'rim:IntegerValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B08503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Minimum/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B08801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Maximum'"
                 flag="fatal"
                 id="PEPPOL-T011-B08802">Attribute 'name' MUST contain value 'Maximum'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B08803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B09001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:IntegerValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B09002">Attribute 'xsi:type' MUST contain value 'rim:IntegerValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B09003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B09201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B09004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Maximum/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B09301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Currency'"
                 flag="fatal"
                 id="PEPPOL-T011-B09302">Attribute 'name' MUST contain value 'Currency'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B09303">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/currency'"
                 flag="fatal"
                 id="PEPPOL-T011-B09304">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/currency'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B09305">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B09601">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B09602">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B09603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B09801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B09802">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B09803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B09804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B09604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/rim:Slot@name=Currency/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B09306">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=EstimatedValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B08103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B10101">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ProcedureType'"
                 flag="fatal"
                 id="PEPPOL-T011-B10102">Attribute 'name' MUST contain value 'ProcedureType'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B10103">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/procurement-procedure-type&#xA;                    '"
                 flag="fatal"
                 id="PEPPOL-T011-B10104">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/procurement-procedure-type
                    '</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B10105">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B10401">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B10402">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B10403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B10601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B10602">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B10603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureType/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10106">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B10901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SubmissionLanguage'"
                 flag="fatal"
                 id="PEPPOL-T011-B10902">Attribute 'name' MUST contain value 'SubmissionLanguage'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B10903">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/language'"
                 flag="fatal"
                 id="PEPPOL-T011-B10904">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/language'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B10905">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B11201">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B11202">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B11203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B11401">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B11402">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B11403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B11601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B11404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B11204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SubmissionLanguage/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B10906">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate">
         <assert test="rim:Slot@name=StartDate" flag="fatal" id="PEPPOL-T011-B11701">Element 'rim:Slot@name=StartDate' MUST be provided.</assert>
         <assert test="rim:Slot@name=EndDate" flag="fatal" id="PEPPOL-T011-B11702">Element 'rim:Slot@name=EndDate' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'PublicationDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B11703">Attribute 'name' MUST contain value 'PublicationDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B11704">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B11901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'StartDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B11902">Attribute 'name' MUST contain value 'StartDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B11903">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B12101">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B12102">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B12103">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12301">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=StartDate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B11904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B12401">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'EndDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B12402">Attribute 'name' MUST contain value 'EndDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B12403">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B12601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B12602">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B12603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/rim:Slot@name=EndDate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=PublicationDate/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B11705">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders">
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B12901">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B12902">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'DeadlineReceiptTenders'"
                 flag="fatal"
                 id="PEPPOL-T011-B12903">Attribute 'name' MUST contain value 'DeadlineReceiptTenders'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B12904">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B13101">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'StartDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B13102">Attribute 'name' MUST contain value 'StartDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B13103">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B13301">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B13302">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B13303">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B13501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B13304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B13104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B13601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'EndDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B13602">Attribute 'name' MUST contain value 'EndDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B13603">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B13801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B13802">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B13803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B13804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B13604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptTenders/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B12905">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline">
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B14101">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B14102">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'AdditionalInformationDeadline'"
                 flag="fatal"
                 id="PEPPOL-T011-B14103">Attribute 'name' MUST contain value 'AdditionalInformationDeadline'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B14104">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B14301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'StartDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B14302">Attribute 'name' MUST contain value 'StartDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B14303">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B14501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B14502">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B14503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B14801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'EndDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B14802">Attribute 'name' MUST contain value 'EndDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B14803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B15001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B15002">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B15003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AdditionalInformationDeadline/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B14105">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests">
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B15301">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="rim:Slot" flag="fatal" id="PEPPOL-T011-B15302">Element 'rim:Slot' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'DeadlineReceiptRequests'"
                 flag="fatal"
                 id="PEPPOL-T011-B15303">Attribute 'name' MUST contain value 'DeadlineReceiptRequests'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B15304">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B15501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'StartDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B15502">Attribute 'name' MUST contain value 'StartDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B15503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B15701">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B15702">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B15703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B16001">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'EndDate'"
                 flag="fatal"
                 id="PEPPOL-T011-B16002">Attribute 'name' MUST contain value 'EndDate'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B16003">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B16201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B16202">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B16203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/rim:Slot/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=DeadlineReceiptRequests/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B15305">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B16501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'NoticeIdentifier'"
                 flag="fatal"
                 id="PEPPOL-T011-B16502">Attribute 'name' MUST contain value 'NoticeIdentifier'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B16503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B16701">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B16702">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B16703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B16901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B16902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B16903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=NoticeIdentifier/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B16504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B17201">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ProcedureIdentifier'"
                 flag="fatal"
                 id="PEPPOL-T011-B17202">Attribute 'name' MUST contain value 'ProcedureIdentifier'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B17203">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B17401">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B17402">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B17403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B17601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B17602">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B17603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureIdentifier/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis">
         <assert test="(some $code in $cllegalBasis satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T011-B17901">Value MUST be part of code list 'legalBasisCode'.</assert>
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B17902">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ProcedureLegalBasis'"
                 flag="fatal"
                 id="PEPPOL-T011-B17903">Attribute 'name' MUST contain value 'ProcedureLegalBasis'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B17904">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/legal-basis'"
                 flag="fatal"
                 id="PEPPOL-T011-B17905">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/legal-basis'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B17906">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B18201">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B18202">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B18203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B18401">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B18402">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B18403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B18601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B18404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B18204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=ProcedureLegalBasis/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B17907">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B18701">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ReservedParticipation'"
                 flag="fatal"
                 id="PEPPOL-T011-B18702">Attribute 'name' MUST contain value 'ReservedParticipation'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B18703">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/reserved-procurement'"
                 flag="fatal"
                 id="PEPPOL-T011-B18704">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/reserved-procurement'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B18705">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B19001">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B19002">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B19003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B19201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B19202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B19203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:slot@name=ReservedParticipation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B18706">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B19501">Element 'rim:SlotValue' MUST be provided.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B19601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:BooleanValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B19602">Attribute 'xsi:type' MUST contain value 'rim:BooleanValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B19603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=SuitableForSMEs/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B19901">Element 'rim:SlotValue' MUST be provided.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B20001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B20002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B20003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B20201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B20004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=WinnerEconomicOperatorName/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B19902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B20301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'AwardCriterionType'"
                 flag="fatal"
                 id="PEPPOL-T011-B20302">Attribute 'name' MUST contain value 'AwardCriterionType'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B20303">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/award-criterion-type'"
                 flag="fatal"
                 id="PEPPOL-T011-B20304">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/award-criterion-type'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B20305">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B20601">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B20602">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B20603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B20801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@type) or @type = 'xsi:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B20802">Attribute 'type' MUST contain value 'xsi:StringValueType'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B20803">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B20804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B20604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=AwardCriterionType/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B20306">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation">
         <assert test="not(@name) or @name = 'BuyerInformation'"
                 flag="fatal"
                 id="PEPPOL-T011-B21101">Attribute 'name' MUST contain value 'BuyerInformation'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B21102">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B21301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'Name'"
                 flag="fatal"
                 id="PEPPOL-T011-B21302">Attribute 'name' MUST contain value 'Name'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B21303">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B21501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B21502">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B21503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=Name/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B21801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'OrganisationNumber'"
                 flag="fatal"
                 id="PEPPOL-T011-B21802">Attribute 'name' MUST contain value 'OrganisationNumber'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B21803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B22001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B22002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B22003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganisationNumber/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B22301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'City'"
                 flag="fatal"
                 id="PEPPOL-T011-B22302">Attribute 'name' MUST contain value 'City'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B22303">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B22501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B22502">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B22503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22701">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=City/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B22801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'PostCode'"
                 flag="fatal"
                 id="PEPPOL-T011-B22802">Attribute 'name' MUST contain value 'PostCode'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B22803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B23001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B23002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B23003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B23201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B23004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=PostCode/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B22804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B23301">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'OrganizationCountrySubdivision'"
                 flag="fatal"
                 id="PEPPOL-T011-B23302">Attribute 'name' MUST contain value 'OrganizationCountrySubdivision'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B23303">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/nuts'"
                 flag="fatal"
                 id="PEPPOL-T011-B23304">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/nuts'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B23305">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B23601">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B23602">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B23603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B23801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B23802">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B23803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B23804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B23604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=OrganizationCountrySubdivision/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B23306">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B24101">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'CountryCode'"
                 flag="fatal"
                 id="PEPPOL-T011-B24102">Attribute 'name' MUST contain value 'CountryCode'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B24103">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/country'"
                 flag="fatal"
                 id="PEPPOL-T011-B24104">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/country'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B24105">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B24401">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B24402">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B24403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B24601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B24602">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B24603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=CountryCode/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24106">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B24901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'LegalType'"
                 flag="fatal"
                 id="PEPPOL-T011-B24902">Attribute 'name' MUST contain value 'LegalType'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T011-B24903">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/buyer-legal-type'"
                 flag="fatal"
                 id="PEPPOL-T011-B24904">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/buyer-legal-type'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B24905">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B25201">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B25202">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B25203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B25401">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B25402">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B25403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B25601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B25404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B25204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=LegalType/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B24906">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T011-B25701">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@MainActivity) or @MainActivity = 'MainActivity'"
                 flag="fatal"
                 id="PEPPOL-T011-B25702">Attribute 'MainActivity' MUST contain value 'MainActivity'</assert>
         <assert test="@MainActivity" flag="fatal" id="PEPPOL-T011-B25703">Attribute 'MainActivity' MUST be present.</assert>
         <assert test="not(@type) or @type = 'http://publications.europa.eu/resource/authority/main-activity'"
                 flag="fatal"
                 id="PEPPOL-T011-B25704">Attribute 'type' MUST contain value 'http://publications.europa.eu/resource/authority/main-activity'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T011-B25705">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T011-B26001">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B26002">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B26003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T011-B26201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T011-B26202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T011-B26203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B26401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B26204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B26004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/rim:Slot@name=MainActivity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B25706">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/rim:Slot@name=BuyerInformation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B21103">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/query:Query/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B03403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryRequest/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T011-B00110">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>
      <rule context="query:QueryRequest">
        <assert id="PEPPOL-T011-R001"
                 flag="fatal"
                 test="matches(normalize-space(./@id), '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')">QueryRequest Identifier value MUST be expressed in a UUID syntax (RFC 4122).</assert>
        <assert id="PEPPOL-T011-R002"
                 flag="fatal"
                 test="count(rim:Slot[@name='SpecificationIdentification']) = 1">There MUST be exactly 1 SpecificationIdentification.</assert>
        <assert id="PEPPOL-T011-R003"
                 flag="fatal"
                 test="count(rim:Slot[@name='BusinessProcessTypeIdentifier']) = 1">There MUST be exactly 1 BusinessProcessTypeIdentifier.</assert>
        <assert id="PEPPOL-T011-R004"
                 flag="fatal"
                 test="count(rim:Slot[@name='IssueDateTime']) = 1">There MUST be exactly 1 IssueDateTime.</assert>
        <assert id="PEPPOL-T011-R005"
                 flag="fatal"
                 test="count(rim:Slot[@name='SenderElectronicAddress']) = 1">There MUST be exactly 1 SenderElectronicAddress.</assert>
        <assert id="PEPPOL-T011-R006"
                 flag="fatal"
                 test="count(rim:Slot[@name='ReceiverElectronicAddress']) = 1">There MUST be exactly 1 ReceiverElectronicAddress.</assert>
        <assert id="PEPPOL-T011-R007" flag="fatal" test="query:ResponseOption">A Search Notice Request MUST have a ResponseOption.</assert>
        <assert id="PEPPOL-T011-R008"
                 flag="fatal"
                 test="query:ResponseOption[@returnType='LeafClassWithRepositoryItem']">The returnType of ResponseOption MUST be "LeafClassWithRepositoryItem".</assert>
        <assert id="PEPPOL-T011-R009"
                 flag="fatal"
                 test="query:Query[@queryDefinition='SearchNotice']">A Search Notice Request MUST have a Query with a queryDefinition set to 'SearchNotice'.</assert>
      </rule>
    
      <rule context="query:QueryRequest/rim:Slot[@name='SpecificationIdentification']">
        <assert id="PEPPOL-T011-R011"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), 'urn:fdc:peppol.eu:prac:trns:t011:1.1')]">SpecificationIdentification value MUST be 'urn:fdc:peppol.eu:prac:trns:t011:1.1'.</assert>
      </rule>
    
      <rule context="query:QueryRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']">
        <assert id="PEPPOL-T011-R012"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:bis:p006:1.1']">BusinessProcessTypeIdentifier value MUST be 'urn:fdc:peppol.eu:prac:bis:p006:1.1'.</assert>
      </rule>
    
      <rule context="query:QueryRequest/rim:Slot[@name='SenderElectronicAddress'] | query:QueryRequest/rim:Slot[@name='ReceiverElectronicAddress']">
        <assert id="PEPPOL-T011-R013"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers" followed by a ":".</assert>
        <assert id="PEPPOL-T011-R081" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be "EAS".</assert>
      </rule>
    
      <rule context="         query:QueryRequest/rim:Slot[@name='SpecificationIdentification']         | query:QueryRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']         | query:QueryRequest/rim:Slot[@name='SenderElectronicAddress']         | query:QueryRequest/rim:Slot[@name='ReceiverElectronicAddress']         | query:QueryRequest/query:Query/rim:Slot[@name='Keywords']         | query:QueryRequest/query:Query/rim:Slot[@name='WinnerEconomicOperatorName']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='Name']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganisationNumber']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='City']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='PostCode']             ">
        <assert id="PEPPOL-T011-R010"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']">This SlotValue MUST have a xsi:type rim:StringValueType.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query">
        <assert id="PEPPOL-T011-R014"
                 flag="fatal"
                 test="count(rim:Slot[@name='Keywords']) &lt; 2">A rim:Slot Keywords can only be used once.</assert>
        <assert id="PEPPOL-T011-R015"
                 flag="fatal"
                 test="count(rim:Slot[@name='FormType']) &lt; 2">A rim:Slot FormType can only be used once.</assert>
        <assert id="PEPPOL-T011-R016"
                 flag="fatal"
                 test="count(rim:Slot[@name='NoticeType']) &lt; 2">A rim:Slot NoticeType can only be used once.</assert>
        <assert id="PEPPOL-T011-R017"
                 flag="fatal"
                 test="count(rim:Slot[@name='Classification']) &lt; 3">A rim:Slot Classification can only be used twice.</assert>
        <assert id="PEPPOL-T011-R018"
                 flag="fatal"
                 test="count(rim:Slot[@name='ContractNature']) &lt; 2">A rim:Slot ContractNature can only be used once.</assert>
        <assert id="PEPPOL-T011-R019"
                 flag="fatal"
                 test="count(rim:Slot[@name='PlaceOfPerformance']) &lt; 2">A rim:Slot PlaceOfPerformance can only be used once.</assert>
        <assert id="PEPPOL-T011-R020"
                 flag="fatal"
                 test="count(rim:Slot[@name='EstimatedValue']) &lt; 2">A rim:Slot EstimatedValue can only be used once.</assert>
        <assert id="PEPPOL-T011-R021"
                 flag="fatal"
                 test="count(rim:Slot[@name='ProcedureType']) &lt; 2">A rim:Slot ProcedureType can only be used once.</assert>
        <assert id="PEPPOL-T011-R022"
                 flag="fatal"
                 test="count(rim:Slot[@name='SubmissionLanguage']) &lt; 2">A rim:Slot SubmissionLanguage can only be used once.</assert>
        <assert id="PEPPOL-T011-R023"
                 flag="fatal"
                 test="count(rim:Slot[@name='PublicationDate']) &lt; 2">A rim:Slot PublicationDate can only be used once.</assert>
        <assert id="PEPPOL-T011-R024"
                 flag="fatal"
                 test="count(rim:Slot[@name='DeadlineReceiptTenders']) &lt; 2">A rim:Slot DeadlineReceiptTenders can only be used once.</assert>
        <assert id="PEPPOL-T011-R025"
                 flag="fatal"
                 test="count(rim:Slot[@name='AdditionalInformationDeadline']) &lt; 2">A rim:Slot AdditionalInformationDeadline can only be used once.</assert>
        <assert id="PEPPOL-T011-R026"
                 flag="fatal"
                 test="count(rim:Slot[@name='DeadlineReceiptRequests']) &lt; 2">A rim:Slot DeadlineReceiptRequests can only be used once.</assert>
        <assert id="PEPPOL-T011-R027"
                 flag="fatal"
                 test="count(rim:Slot[@name='NoticeIdentifier']) &lt; 2">A rim:Slot NoticeIdentifier can only be used once.</assert>
        <assert id="PEPPOL-T011-R028"
                 flag="fatal"
                 test="count(rim:Slot[@name='ProcedureIdentifier']) &lt; 2">A rim:Slot ProcedureIdentifier can only be used once.</assert>
        <assert id="PEPPOL-T011-R029"
                 flag="fatal"
                 test="count(rim:Slot[@name='ProcedureLegalBasis']) &lt; 2">A rim:Slot ProcedureLegalBasis can only be used once.</assert>
        <assert id="PEPPOL-T011-R030"
                 flag="fatal"
                 test="count(rim:Slot[@name='ReservedParticipation']) &lt; 2">A rim:Slot ReservedParticipation can only be used once.</assert>
        <assert id="PEPPOL-T011-R031"
                 flag="fatal"
                 test="count(rim:Slot[@name='SuitableForSMEs']) &lt; 2">A rim:Slot SuitableForSMEs can only be used once.</assert>
        <assert id="PEPPOL-T011-R032"
                 flag="fatal"
                 test="count(rim:Slot[@name='WinnerEconomicOperatorName']) &lt; 2">A rim:Slot WinnerEconomicOperatorName can only be used once.</assert>
        <assert id="PEPPOL-T011-R033"
                 flag="fatal"
                 test="count(rim:Slot[@name='AwardCriterionType']) &lt; 2">A rim:Slot AwardCriterionType can only be used once.</assert>
      </rule>
    
      <rule context="         query:QueryRequest/query:Query/rim:Slot[@name='FormType']         | query:QueryRequest/query:Query/rim:Slot[@name='NoticeType']         | query:QueryRequest/query:Query/rim:Slot[@name='Classification']         | query:QueryRequest/query:Query/rim:Slot[@name='ContractNature']         | query:QueryRequest/query:Query/rim:Slot[@name='PlaceOfPerformance']         | query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']         | query:QueryRequest/query:Query/rim:Slot[@name='ProcedureType']         | query:QueryRequest/query:Query/rim:Slot[@name='SubmissionLanguage']         | query:QueryRequest/query:Query/rim:Slot[@name='ReservedParticipation']         | query:QueryRequest/query:Query/rim:Slot[@name='AwardCriterionType']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganizationCountrySubdivision']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='CountryCode']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='LegalType']         | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='MainActivity']             ">
        <assert id="PEPPOL-T011-R034"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:CollectionValueType']">rim:SlotValue MUST be of type rim:CollectionValueType.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='FormType']">
        <assert id="PEPPOL-T011-R035"
                 flag="fatal"
                 test="@type = 'http://publications.europa.eu/resource/authority/form-type'">A Form Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/form-type".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='NoticeType']">
        <assert id="PEPPOL-T011-R036"
                 flag="fatal"
                 test="@type = 'http://publications.europa.eu/resource/authority/notice-type'">A Notice Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/notice-type".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='Classification']">
        <assert id="PEPPOL-T011-R037"
                 flag="fatal"
                 test="normalize-space(./@type) = 'http://publications.europa.eu/resource/authority/cpv/cpv' or normalize-space(./@type) = 'http://publications.europa.eu/resource/authority/cpv/cpvsuppl'">The Type for Classification MUST be "http://publications.europa.eu/resource/authority/cpv/cpv" or "http://publications.europa.eu/resource/authority/cpv/cpvsuppl".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ContractNature']">
        <assert id="PEPPOL-T011-R038"
                 flag="fatal"
                 test="@type = 'http://publications.europa.eu/resource/authority/contract-nature'">A Contract Nature MUST have a type of the value of "http://publications.europa.eu/resource/authority/contract-nature".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='PlaceOfPerformance']">
        <assert id="PEPPOL-T011-R039"
                 flag="fatal"
                 test="@type = 'http://publications.europa.eu/resource/authority/nuts'">The Place Of Performance MUST have a type of the value of "http://publications.europa.eu/resource/authority/nuts".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']">
        <assert id="PEPPOL-T011-R040" flag="fatal" test="count(rim:Slot) &gt; 0">At least one element for Estimated Value MUST be given.</assert>
        <assert id="PEPPOL-T011-R041" flag="fatal" test="count(rim:Slot) &lt; 4">There MUST NOT be more than 3 elements for Estimated Value.</assert>
        <assert id="PEPPOL-T011-R042"
                 flag="fatal"
                 test="count(rim:Slot[@name='Minimum']) &lt; 2">The rim:Slot name "Minimum" can only be used once.</assert>
        <assert id="PEPPOL-T011-R043"
                 flag="fatal"
                 test="count(rim:Slot[@name='Maximum']) &lt; 2">The rim:Slot name "Maximum" can only be used once.</assert>
        <assert id="PEPPOL-T011-R044"
                 flag="fatal"
                 test="count(rim:Slot[@name='Currency']) &lt; 2">The rim:Slot name "Currency" can only be used once.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot">
        <assert id="PEPPOL-T011-R045"
                 flag="fatal"
                 test="@name = 'Minimum' or @name = 'Maximum' or @name = 'Currency'">The name of the slots under Estimated Value MUST be one of "Minimum", "Maximum" or "Currency".</assert>
      </rule>
    
      <rule context="         query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Minimum']/rim:SlotValue         | query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Maximum']/rim:SlotValue             ">
        <assert id="PEPPOL-T011-R046"
                 flag="fatal"
                 test="@xsi:type='rim:IntegerValueType'">A Minimum or Maximum MUST have an element SlotValue with xsi:type of rim:IntegerValueType.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']">
        <assert id="PEPPOL-T011-R047"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/currency'">The Currency of the Estimated Value MUST have a type of the value of "http://publications.europa.eu/resource/authority/currency".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']/rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element">
        <assert id="PEPPOL-T011-R048"
                 flag="fatal"
                 test="@xsi:type = 'rim:StringValueType'">Every element in the currency collection MUST be a StringValueType.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ProcedureType']">
        <assert id="PEPPOL-T011-R049"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/procurement-procedure-type'">A Procedure Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/procurement-procedure-type".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='SubmissionLanguage']">
        <assert id="PEPPOL-T011-R050"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/language'">A Submission Language MUST have a type of the value of "http://publications.europa.eu/resource/authority/language".</assert>
      </rule>
    
      <rule context="         query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']         | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']         | query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']         | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']             ">
        <assert id="PEPPOL-T011-R051" flag="fatal" test="count(rim:Slot) &gt; 0">A Date MUST have at least one slot.</assert>
        <assert id="PEPPOL-T011-R052" flag="fatal" test="count(rim:Slot) &lt; 3">There MUST NOT be more than 2 elements for Date.</assert>
        <assert id="PEPPOL-T011-R053"
                 flag="fatal"
                 test="count(rim:Slot[@name='EndDate']) &lt; 2">The rim:Slot name "EndDate" can only be used once.</assert>
        <assert id="PEPPOL-T011-R054"
                 flag="fatal"
                 test="count(rim:Slot[@name='StartDate']) &lt; 2">The rim:Slot name "StartDate" can only be used once.</assert>
      </rule>
    
      <rule context="         query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot         | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot         | query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot         | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot             ">
        <assert id="PEPPOL-T011-R055" flag="fatal" test="rim:SlotValue">A Date MUST have a SlotValue.</assert>
        <assert id="PEPPOL-T011-R056"
                 flag="fatal"
                 test="@name = 'StartDate' or @name = 'EndDate'">The name of the slots under Date MUST be one of "StartDate" or "EndDate".</assert>
      </rule>
    
      <rule context="         query:QueryRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='StartDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='StartDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='StartDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='StartDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='EndDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='EndDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='EndDate']/rim:SlotValue         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='EndDate']/rim:SlotValue             ">
        <assert id="PEPPOL-T011-R057"
                 flag="fatal"
                 test="@xsi:type='rim:DateTimeValueType'">A Date MUST have an element SlotValue with xsi:type of rim:DateTimeValue.</assert>
      </rule>
    
      <rule context="         query:QueryRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value         |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value             ">
        <assert id="PEPPOL-T011-R058"
                 flag="fatal"
                 test="./text()[matches(normalize-space(),'^([0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$')]">A Date MUST have timezone and a granularity of seconds.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ReservedParticipation']">
        <assert id="PEPPOL-T011-R059"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/reserved-procurement'">A Reserved Participation MUST have a type of the value of "http://publications.europa.eu/resource/authority/reserved-procurement".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='SuitableForSMEs']">
        <assert id="PEPPOL-T011-R060"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:BooleanValueType']">Suitable For SMEs MUST have an element SlotValue with xsi:type of rim:BooleanValueType.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='AwardCriterionType']">
        <assert id="PEPPOL-T011-R061"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/award-criterion-type'">An Award Criterion Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/award-criterion-type".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']">
        <assert id="PEPPOL-T011-R062" flag="fatal" test="count(rim:Slot) &gt; 0">A Buyer Information MUST have at least one slot.</assert>
        <assert id="PEPPOL-T011-R063" flag="fatal" test="count(rim:Slot) &lt; 9">There MUST NOT be more than 8 elements for Buyer Information.</assert>
        <assert id="PEPPOL-T011-R064"
                 flag="fatal"
                 test="count(rim:Slot[@name='Name']) &lt; 2">The rim:Slot name "Name" can only be used once.</assert>
        <assert id="PEPPOL-T011-R065"
                 flag="fatal"
                 test="count(rim:Slot[@name='OrganisationNumber']) &lt; 2">The rim:Slot name "OrganisationNumber" can only be used once.</assert>
        <assert id="PEPPOL-T011-R066"
                 flag="fatal"
                 test="count(rim:Slot[@name='City']) &lt; 2">The rim:Slot name "OrganisationNumber" can only be used once.</assert>
        <assert id="PEPPOL-T011-R067"
                 flag="fatal"
                 test="count(rim:Slot[@name='PostCode']) &lt; 2">The rim:Slot name "City" can only be used once.</assert>
        <assert id="PEPPOL-T011-R068"
                 flag="fatal"
                 test="count(rim:Slot[@name='OrganizationCountrySubdivision']) &lt; 2">The rim:Slot name "OrganizationCountrySubdivision" can only be used once.</assert>
        <assert id="PEPPOL-T011-R069"
                 flag="fatal"
                 test="count(rim:Slot[@name='CountryCode']) &lt; 2">The rim:Slot name "Country" can only be used once.</assert>
        <assert id="PEPPOL-T011-R070"
                 flag="fatal"
                 test="count(rim:Slot[@name='LegalType']) &lt; 2">The rim:Slot name "LegalType" can only be used once.</assert>
        <assert id="PEPPOL-T011-R071"
                 flag="fatal"
                 test="count(rim:Slot[@name='MainActivity']) &lt; 2">The rim:Slot name "MainActivity" can only be used once.</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot">
        <assert id="PEPPOL-T011-R072"
                 flag="fatal"
                 test="@name = 'Name' or @name = 'OrganisationNumber' or @name = 'City' or @name = 'PostCode' or @name = 'OrganizationCountrySubdivision' or @name = 'CountryCode' or @name = 'LegalType' or @name = 'MainActivity'">The name of the slots under Buyer Information MUST be one of "Name" or "OrganisationNumber" or "City" or "PostCode"  or "OrganizationCountrySubdivision" or "Country" or "LegalType" or "MainActivity".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganizationCountrySubdivision']">
        <assert id="PEPPOL-T011-R073"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/nuts'">An Organization Country Subdivision MUST have a type of the value of "http://publications.europa.eu/resource/authority/nuts".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='CountryCode']">
        <assert id="PEPPOL-T011-R074"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/country'">A Country Code MUST have a type of the value of "http://publications.europa.eu/resource/authority/country".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='LegalType']">
        <assert id="PEPPOL-T011-R075"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/buyer-legal-type'">A Legal Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/buyer-legal-type".</assert>
      </rule>
    
      <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='MainActivity']">
        <assert id="PEPPOL-T011-R076"
                 flag="fatal"
                 test="@type='http://publications.europa.eu/resource/authority/main-activity'">A Main Activity MUST have a type of the value of "http://publications.europa.eu/resource/authority/main-activity".</assert>
      </rule>
    
    
    
      <rule context="*/rim:Value">
        <assert id="PEPPOL-T011-R077"
                 flag="fatal"
                 test="./text()[normalize-space() != '']">Value MUST have a text.</assert>
      </rule>
    
      <rule context="*/rim:SlotValue[@xsi:type!='rim:CollectionValueType']">
        <assert id="PEPPOL-T011-R078" flag="fatal" test="count(rim:Value) &gt; 0">A Value for each SlotValue MUST be given.</assert>
      </rule>
    
      <rule context="*/rim:SlotValue[@xsi:type='rim:CollectionValueType']">
        <assert id="PEPPOL-T011-R082" flag="fatal" test="count(rim:Element) &gt; 0">At least one Element for each SlotValue with CollectionValueType MUST be given.</assert>
      </rule>
    
      <rule context="*/rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element">
        <assert id="PEPPOL-T011-R079"
                 flag="fatal"
                 test="@xsi:type='rim:StringValueType'">rim:Element be of type rim:StringValueType.</assert>
        <assert id="PEPPOL-T011-R080" flag="fatal" test="count(rim:Value) &gt; 0">At least one element MUST be given in a CollectionValueType.</assert>
      </rule>
    
   </pattern>
</schema>
