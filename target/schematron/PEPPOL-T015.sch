<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">
        
    <title>PEPPOL business and syntax rules for publish notice</title>

    <ns prefix="rim" uri="urn:oasis:names:tc:ebxml-regrep:xsd:rim:4.0"/>
    <ns prefix="lcm" uri="urn:oasis:names:tc:ebxml-regrep:xsd:lcm:4.0"/>
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
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
      <rule context="/lcm:SubmitObjectsRequest">
         <assert test="rim:Slot@name=SpecificationIdentification"
                 flag="fatal"
                 id="PEPPOL-T015-B00101">Element 'rim:Slot@name=SpecificationIdentification' MUST be provided.</assert>
         <assert test="rim:Slot@name=BusinessProcessTypeIdentifier"
                 flag="fatal"
                 id="PEPPOL-T015-B00102">Element 'rim:Slot@name=BusinessProcessTypeIdentifier' MUST be provided.</assert>
         <assert test="rim:Slot@name=IssueDateTime"
                 flag="fatal"
                 id="PEPPOL-T015-B00103">Element 'rim:Slot@name=IssueDateTime' MUST be provided.</assert>
         <assert test="rim:Slot@name=SenderElectronicAddress"
                 flag="fatal"
                 id="PEPPOL-T015-B00104">Element 'rim:Slot@name=SenderElectronicAddress' MUST be provided.</assert>
         <assert test="rim:Slot@name=ReceiverElectronicAddress"
                 flag="fatal"
                 id="PEPPOL-T015-B00105">Element 'rim:Slot@name=ReceiverElectronicAddress' MUST be provided.</assert>
         <assert test="rim:Slot@name=PublicationRequested"
                 flag="fatal"
                 id="PEPPOL-T015-B00106">Element 'rim:Slot@name=PublicationRequested' MUST be provided.</assert>
         <assert test="rim:Slot@name=NoticePublicationDatePreferred"
                 flag="fatal"
                 id="PEPPOL-T015-B00107">Element 'rim:Slot@name=NoticePublicationDatePreferred' MUST be provided.</assert>
         <assert test="rim:RegistryObjectList" flag="fatal" id="PEPPOL-T015-B00108">Element 'rim:RegistryObjectList' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T015-B00109">Document MUST not contain schema location.</assert>
         <assert test="@id" flag="fatal" id="PEPPOL-T015-B00110">Attribute 'id' MUST be present.</assert>
         <assert test="not(@mode) or @mode = 'CreateOrVersion'"
                 flag="fatal"
                 id="PEPPOL-T015-B00111">Attribute 'mode' MUST contain value 'CreateOrVersion'</assert>
         <assert test="@mode" flag="fatal" id="PEPPOL-T015-B00112">Attribute 'mode' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B00401">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SpecificationIdentification'"
                 flag="fatal"
                 id="PEPPOL-T015-B00402">Attribute 'name' MUST contain value 'SpecificationIdentification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B00403">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B00601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B00602">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B00603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t015:1.2'"
                 flag="fatal"
                 id="PEPPOL-T015-B00801">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t015:1.2'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B00802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B00604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SpecificationIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B00404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B00901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BusinessProcessTypeIdentifier'"
                 flag="fatal"
                 id="PEPPOL-T015-B00902">Attribute 'name' MUST contain value 'BusinessProcessTypeIdentifier'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B00903">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B01101">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B01102">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B01103">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p008:1.2'"
                 flag="fatal"
                 id="PEPPOL-T015-B01301">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p008:1.2'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=BusinessProcessTypeIdentifier/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B00904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B01401">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'IssueDateTime'"
                 flag="fatal"
                 id="PEPPOL-T015-B01402">Attribute 'name' MUST contain value 'IssueDateTime'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B01403">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B01601">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B01602">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B01603">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01801">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=IssueDateTime/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B01901">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SenderElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T015-B01902">Attribute 'name' MUST contain value 'SenderElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B01903">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'eas'"
                 flag="fatal"
                 id="PEPPOL-T015-B01904">Attribute 'type' MUST contain value 'eas'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T015-B01905">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B02201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B02202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B02203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/rim:Value">
         <assert test="(some $code in $cleas satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T015-B02401">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B02402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B02204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=SenderElectronicAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B01906">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B02501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ReceiverElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T015-B02502">Attribute 'name' MUST contain value 'ReceiverElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B02503">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'eas'"
                 flag="fatal"
                 id="PEPPOL-T015-B02504">Attribute 'type' MUST contain value 'eas'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T015-B02505">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B02801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B02802">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B02803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/rim:Value">
         <assert test="(some $code in $cleas satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T015-B03001">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B02804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=ReceiverElectronicAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B02506">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B03101">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'PublicationRequested'"
                 flag="fatal"
                 id="PEPPOL-T015-B03102">Attribute 'name' MUST contain value 'PublicationRequested'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B03103">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B03301">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:BooleanValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B03302">Attribute 'xsi:type' MUST contain value 'rim:BooleanValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B03303">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03501">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=PublicationRequested/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03104">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B03601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'NoticePublicationDatePreferred'"
                 flag="fatal"
                 id="PEPPOL-T015-B03602">Attribute 'name' MUST contain value 'NoticePublicationDatePreferred'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B03603">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B03801">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B03802">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B03803">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B04001">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:Slot@name=NoticePublicationDatePreferred/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B03604">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList">
         <assert test="rim:RegistryObject" flag="fatal" id="PEPPOL-T015-B04101">Element 'rim:RegistryObject' MUST be provided.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject">
         <assert test="rim:Slot@name=UBLDocumentSchema"
                 flag="fatal"
                 id="PEPPOL-T015-B04201">Element 'rim:Slot@name=UBLDocumentSchema' MUST be provided.</assert>
         <assert test="rim:Slot@name=NoticeVersion"
                 flag="fatal"
                 id="PEPPOL-T015-B04202">Element 'rim:Slot@name=NoticeVersion' MUST be provided.</assert>
         <assert test="rim:Slot@name=CustomizationID"
                 flag="fatal"
                 id="PEPPOL-T015-B04203">Element 'rim:Slot@name=CustomizationID' MUST be provided.</assert>
         <assert test="rim:Slot@name=BuyerInformation"
                 flag="fatal"
                 id="PEPPOL-T015-B04204">Element 'rim:Slot@name=BuyerInformation' MUST be provided.</assert>
         <assert test="rim:RepositoryItemRef" flag="fatal" id="PEPPOL-T015-B04205">Element 'rim:RepositoryItemRef' MUST be provided.</assert>
         <assert test="@lid" flag="fatal" id="PEPPOL-T015-B04206">Attribute 'lid' MUST be present.</assert>
         <assert test="@id" flag="fatal" id="PEPPOL-T015-B04207">Attribute 'id' MUST be present.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:ExtrinsicObjectType'"
                 flag="fatal"
                 id="PEPPOL-T015-B04208">Attribute 'xsi:type' MUST contain value 'rim:ExtrinsicObjectType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B04209">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B04601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'UBLDocumentSchema'"
                 flag="fatal"
                 id="PEPPOL-T015-B04602">Attribute 'name' MUST contain value 'UBLDocumentSchema'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B04603">Attribute 'name' MUST be present.</assert>
         <assert test="not(@List Identifier) or @List Identifier = 'ublDocumentSchema'"
                 flag="fatal"
                 id="PEPPOL-T015-B04604">Attribute 'List Identifier' MUST contain value 'ublDocumentSchema'</assert>
         <assert test="@List Identifier" flag="fatal" id="PEPPOL-T015-B04605">Attribute 'List Identifier' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B04901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B04902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B04903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B04904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=UBLDocumentSchema/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B04606">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B05201">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'NoticeVersion'"
                 flag="fatal"
                 id="PEPPOL-T015-B05202">Attribute 'name' MUST contain value 'NoticeVersion'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B05203">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B05401">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:IntegerValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B05402">Attribute 'xsi:type' MUST contain value 'rim:IntegerValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B05403">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05404">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=NoticeVersion/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B05701">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'CustomizationID'"
                 flag="fatal"
                 id="PEPPOL-T015-B05702">Attribute 'name' MUST contain value 'CustomizationID'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B05703">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B05901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B05902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B05903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B06101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=CustomizationID/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B05704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation">
         <assert test="not(@name) or @name = 'BuyerInformation'"
                 flag="fatal"
                 id="PEPPOL-T015-B06201">Attribute 'name' MUST contain value 'BuyerInformation'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B06202">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B06401">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BuyerPartyIdentification'"
                 flag="fatal"
                 id="PEPPOL-T015-B06402">Attribute 'name' MUST contain value 'BuyerPartyIdentification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B06403">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'ICD'"
                 flag="fatal"
                 id="PEPPOL-T015-B06404">Attribute 'type' MUST contain value 'ICD'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T015-B06405">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue">
         <assert test="rim:Element" flag="fatal" id="PEPPOL-T015-B06701">Element 'rim:Element' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:CollectionValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B06702">Attribute 'xsi:type' MUST contain value 'rim:CollectionValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B06703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B06901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B06902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B06903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue/rim:Element/rim:Value">
         <assert test="(some $code in $clICD satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T015-B07101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue/rim:Element/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B07102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B06904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B06704">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerPartyIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B06406">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B07201">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BuyerElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T015-B07202">Attribute 'name' MUST contain value 'BuyerElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B07203">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'eas'"
                 flag="fatal"
                 id="PEPPOL-T015-B07204">Attribute 'type' MUST contain value 'eas'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T015-B07205">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B07501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B07502">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B07503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress/rim:SlotValue/rim:Value">
         <assert test="(some $code in $cleas satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T015-B07701">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B07702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B07504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=BuyerElectronicAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B07206">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T015-B07801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'AdditionalDocumentReference'"
                 flag="fatal"
                 id="PEPPOL-T015-B07802">Attribute 'name' MUST contain value 'AdditionalDocumentReference'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T015-B07803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T015-B08001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T015-B08002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T015-B08003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference/rim:SlotValue/rim:Value"/>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference/rim:SlotValue/rim:Value/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B08201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference/rim:SlotValue/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B08004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/rim:Slot@name=AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B07804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot@name=BuyerInformation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B06203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef">
         <assert test="@xlink" flag="fatal" id="PEPPOL-T015-B08301">Attribute 'xlink' MUST be present.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B08302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B04210">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/lcm:SubmitObjectsRequest/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T015-B00113">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>

    <pattern>
        <rule context="lcm:SubmitObjectsRequest">
            <assert id="PEPPOL-T015-R001"
                 flag="fatal"
                 test="matches(normalize-space(./@id), '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')">LCM Identifier value MUST be expressed in a UUID syntax (RFC 4122).</assert>
            <assert id="PEPPOL-T015-R012"
                 flag="fatal"
                 test="matches(normalize-space(./@mode), 'CreateOrVersion')">A Notice SubmitObjectsRequest MUST have mode definition with the value "CreateOrVersion".</assert>
            <assert id="PEPPOL-T015-R002"
                 flag="fatal"
                 test="count(rim:Slot[@name='SpecificationIdentification']) = 1">A Notice SubmitObjectsRequest MUST have an identifier.</assert>
            <assert id="PEPPOL-T015-R003"
                 flag="fatal"
                 test="count(rim:Slot[@name='BusinessProcessTypeIdentifier']) = 1">There MUST be exactly 1 BusinessProcessTypeIdentifier.</assert>
            <assert id="PEPPOL-T015-R004"
                 flag="fatal"
                 test="count(rim:Slot[@name='IssueDateTime']) = 1">There MUST be exactly 1 IssueDateTime.</assert>
            <assert id="PEPPOL-T015-R005"
                 flag="fatal"
                 test="count(rim:Slot[@name='SenderElectronicAddress']) = 1">There MUST be exactly 1 SenderElectronicAddress.</assert>
            <assert id="PEPPOL-T015-R006"
                 flag="fatal"
                 test="count(rim:Slot[@name='ReceiverElectronicAddress']) = 1">There MUST be exactly 1 ReceiverElectronicAddress.</assert>
            <assert id="PEPPOL-T015-R020"
                 flag="fatal"
                 test="count(rim:Slot[@name='PublicationRequested']) = 1">There MUST be exactly 1 PublicationRequested.</assert>
            <assert id="PEPPOL-T015-R007" flag="fatal" test="rim:RegistryObjectList">A Publish Notice MUST have a RegistryObjectList.</assert>
        </rule>

        <rule context="           lcm:SubmitObjectsRequest/rim:Slot[@name='SpecificationIdentification']         | lcm:SubmitObjectsRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']         | lcm:SubmitObjectsRequest/rim:Slot[@name='SenderElectronicAddress']         | lcm:SubmitObjectsRequest/rim:Slot[@name='ReceiverElectronicAddress']         | lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='UBLDocumentSchema']         | lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='AdditionalDocumentInformation']         | lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']         | lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']         | lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']         ">
            <assert id="PEPPOL-T015-R008"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']">This SlotValue MUST have a xsi:type rim:StringValueType.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:Slot[@name='SpecificationIdentification']">
            <assert id="PEPPOL-T015-R009"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:trns:t015:1.2']">SpecificationIdentification value MUST be 'urn:fdc:peppol.eu:prac:trns:t015:1.2'.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']">
            <assert id="PEPPOL-T015-R010"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:bis:p008:1.2']">BusinessProcessTypeIdentifier value MUST be 'urn:fdc:peppol.eu:prac:bis:p008:1.2'.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:Slot[@name='SenderElectronicAddress'] | lcm:SubmitObjectsRequest/rim:Slot[@name='ReceiverElectronicAddress']">
            <assert id="PEPPOL-T015-R011"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers" followed by a ":".</assert>
            <assert id="PEPPOL-T015-R026" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be "EAS".</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:Slot[@name='PublicationRequested']">
            <assert id="PEPPOL-T015-R021"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:BooleanValueType']">PublicationRequested MUST have an element SlotValue with xsi:type of rim:BooleanValueType.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='UBLDocumentSchema']">
            <assert id="PEPPOL-T015-R016"
                 flag="fatal"
                 test="@type = 'ublDocumentSchema'">The UBLDocumentSchema MUST have a type of the value of "http://docs.peppol.eu/document-type-code".</assert>
        </rule>

       <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='NoticeVersion']/rim:SlotValue/rim:Value">
            <assert id="PEPPOL-T015-R013"
                 flag="fatal"
                 test="./text()[matches(normalize-space(), '^\d{1,2}$')]">The Notice Version MUST be consecutive numbers made of 1 or 2 digits.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']">
            <assert id="PEPPOL-T015-R022"
                 flag="warning"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), 'eforms((-[a-zA-Z]{1,3})|(-sdk))-[0-9]\.[0-9]')]">The eForms version does not comply with the european version in the format eforms-sdk-x.y or the national variant eforms-[CountryCode]-x.y</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']">
            <assert id="PEPPOL-T015-R042"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3]))):')]">A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers" followed by a ":".</assert>
            <assert id="PEPPOL-T015-R017" flag="fatal" test="@type = 'ICD'">The schemeID type attribute has to be "ICD".</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">
            <assert id="PEPPOL-T015-R041"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers" followed by a ":".</assert>
            <assert id="PEPPOL-T015-R014" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be "EAS".</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']">
            <assert id="PEPPOL-T015-R018" flag="fatal" test="count(rim:Slot) &gt; 0">At least one element for Buyer Information MUST be given.</assert>
            <assert id="PEPPOL-T015-R019" flag="fatal" test="count(rim:Slot) &lt; 4">There MUST NOT be more than 3 elements for Buyer Information.</assert>
            <assert id="PEPPOL-T015-R023"
                 flag="fatal"
                 test="count(rim:Slot[@name='BuyerPartyIdentification']) &lt; 2">The rim:Slot name "BuyerPartyIdentification" can only be used once.</assert>
            <assert id="PEPPOL-T015-R024"
                 flag="fatal"
                 test="count(rim:Slot[@name='BuyerElectronicAddress']) &lt; 2">The rim:Slot name "BuyerElectronicAddress" can only be used once.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot">
            <assert id="PEPPOL-T015-R025"
                 flag="fatal"
                 test="@name = 'BuyerPartyIdentification' or @name = 'BuyerElectronicAddress'">The name of the slots under Buyer Information MUST be either "BuyerPartyIdentification" or "BuyerElectronicAddress".</assert>
        </rule>

        <rule context="             lcm:SubmitObjectsRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
            <assert id="PEPPOL-T015-R033"
                 flag="fatal"
                 test="@xsi:type='rim:DateTimeValueType'">A Date MUST have an element SlotValue with xsi:type of rim:DateTimeValue.</assert>
        </rule>

        <rule context="             lcm:SubmitObjectsRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
            <assert id="PEPPOL-T015-R034"
                 flag="fatal"
                 test="./text()[matches(normalize-space(),'^([0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$')]">A Date MUST have timezone and a granularity of seconds.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='NoticeVersion']">
            <assert id="PEPPOL-T015-R036"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:IntegerValueType']">NoticeVersion MUST have an element SlotValue with xsi:type of rim:IntegerValueType.</assert>
        </rule>

        <rule context="lcm:SubmitObjectsRequest/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef">
            <assert id="PEPPOL-T015-R015"
                 flag="fatal"
                 test="matches(normalize-space(./@xlink:href), '^\./[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}\.eform\.xml$')">The xlink:href MUST be expressed in a UUID syntax (RFC 4122). The file referenced by the xlink:href MUST be present in the ASiC-E Container. </assert>
        </rule>

        

          <rule context="*/rim:Value">
              <assert id="PEPPOL-T015-R037"
                 flag="fatal"
                 test="./text()[normalize-space() != '']">Value MUST have a text.</assert>
          </rule>

          <rule context="*/rim:SlotValue[@xsi:type!='rim:CollectionValueType']">
              <assert id="PEPPOL-T015-R038" flag="fatal" test="count(rim:Value) &gt; 0">A Value for each SlotValue MUST be given.</assert>
          </rule>

          <rule context="*/rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element">
              <assert id="PEPPOL-T015-R039"
                 flag="fatal"
                 test="@xsi:type='rim:StringValueType'">rim:Element be of type rim:StringValueType.</assert>
              <assert id="PEPPOL-T015-R040" flag="fatal" test="count(rim:Value) &gt; 0">At least one element MUST be given in a CollectionValueType.</assert>
          </rule>

      </pattern>

</schema>
