<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:u="utils"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        schemaVersion="iso"
        queryBinding="xslt2">

    <title>Rules for Receipt Advice</title>

	  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2"
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
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
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
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
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
                select="if (not($arg castable as xsd:integer)) then 0 else 1"/>
      <variable name="mapper"
                select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xsd:integer)) then true() else false()       )   )   else   (    false()   )   "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkCF16"
             as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xsd:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xsd:integer) and         (substring($arg,12,3) castable as xsd:string) and        (substring($arg,15,1) castable as xsd:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:checkPIVA"
             as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xsd:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
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
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
  </function>
	  <function xmlns="http://www.w3.org/1999/XSL/Transform"
             name="u:abn"
             as="xs:boolean">
	     <param name="val"/>
	     <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
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
      <rule context="cbc:EndpointID[@schemeID = '9906']">
         <assert id="PEPPOL-COMMON-R048"
                 test="u:checkPIVAseIT(normalize-space())"
                 flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
      </rule>
      <rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
         <assert id="PEPPOL-COMMON-R049"
                 test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'"
                 flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>     
      </rule> 
      <rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
         <assert id="PEPPOL-COMMON-R050"
                 test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())"
                 flag="warning">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
      </rule> 
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <let name="clDocumentStatusCode" value="tokenize('1 5 9 22', '\s')"/>
      <let name="clMimeCode"
           value="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')"/>
      <let name="clTransportHandlingUnitReason"
           value="tokenize('1 2 3 4 5 6 7', '\s')"/>
      <let name="clUNECERec21"
           value="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV OA OB OC OD OE OF OK OT OU P2 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ ', '\s')"/>
      <let name="clISO3166"
           value="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')"/>
      <let name="clICD"
           value="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 9955', '\s')"/>
      <let name="cleas"
           value="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 9901 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9957', '\s')"/>
      <let name="clReceiptAdviceActionCode" value="tokenize('1 2', '\s')"/>
      <let name="clRejectReasonCode" value="tokenize('1 2 3 4 5 6 7 8 99', '\s')"/>
      <let name="clConsignmentStatusReason"
           value="tokenize('1 2 3 4 5 6 7 8 9 10 99', '\s')"/>
      <let name="clReceiptAdviceTypeCode" value="tokenize('D S', '\s')"/>
      <let name="clUNCL1001"
           value="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')"/>
      <let name="clUNCL4343_T128" value="tokenize('AB AP CA RE', '\s')"/>
      <rule context="/ubl:ReceiptAdvice">
         <assert test="cbc:CustomizationID" flag="fatal" id="PEPPOL-T128-B00101">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="fatal" id="PEPPOL-T128-B00102">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B00103">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T128-B00104">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T128-B00105">Element 'cbc:IssueTime' MUST be provided.</assert>
         <assert test="cbc:ReceiptAdviceTypeCode"
                 flag="fatal"
                 id="PEPPOL-T128-B00106">Element 'cbc:ReceiptAdviceTypeCode' MUST be provided.</assert>
         <assert test="cac:DespatchDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T128-B00107">Element 'cac:DespatchDocumentReference' MUST be provided.</assert>
         <assert test="cac:DeliveryCustomerParty"
                 flag="fatal"
                 id="PEPPOL-T128-B00108">Element 'cac:DeliveryCustomerParty' MUST be provided.</assert>
         <assert test="cac:DespatchSupplierParty"
                 flag="fatal"
                 id="PEPPOL-T128-B00109">Element 'cac:DespatchSupplierParty' MUST be provided.</assert>
         <assert test="cac:ReceiptLine" flag="fatal" id="PEPPOL-T128-B00110">Element 'cac:ReceiptLine' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T128-B00111">Document MUST not contain schema location.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cbc:CustomizationID"/>
      <rule context="/ubl:ReceiptAdvice/cbc:ProfileID"/>
      <rule context="/ubl:ReceiptAdvice/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cbc:IssueDate"/>
      <rule context="/ubl:ReceiptAdvice/cbc:IssueTime"/>
      <rule context="/ubl:ReceiptAdvice/cbc:DocumentStatusCode">
         <assert test="(some $code in $clDocumentStatusCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B00701">Value MUST be part of code list 'Document status code (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cbc:ReceiptAdviceTypeCode">
         <assert test="(some $code in $clReceiptAdviceTypeCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B00801">Value MUST be part of code list 'Receipt Advice Type (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cbc:Note"/>
      <rule context="/ubl:ReceiptAdvice/cac:OrderReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B01001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:OrderReference/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:OrderReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B01002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B01201">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="fatal" id="PEPPOL-T128-B01202">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:IssueTime" flag="fatal" id="PEPPOL-T128-B01203">Element 'cbc:IssueTime' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/cbc:IssueDate"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/cbc:IssueTime"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/cbc:DocumentStatusCode">
         <assert test="(some $code in $clUNCL4343_T128 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B01601">Value MUST be part of code list 'Application Response type code (UNCL4343 Subset T128)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/cbc:DocumentDescription"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B01204">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B01801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cbc:DocumentTypeCode">
         <assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B02001">Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment"/>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
         <assert test="@mimeCode" flag="fatal" id="PEPPOL-T128-B02301">Attribute 'mimeCode' MUST be present.</assert>
         <assert test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)"
                 flag="fatal"
                 id="PEPPOL-T128-B02302">Value MUST be part of code list 'Mime code (IANA Subset)'.</assert>
         <assert test="@filename" flag="fatal" id="PEPPOL-T128-B02303">Attribute 'filename' MUST be present.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert test="cbc:URI" flag="fatal" id="PEPPOL-T128-B02601">Element 'cbc:URI' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B02602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/cac:Attachment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B02201">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:AdditionalDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B01802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T128-B02801">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T128-B02901">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T128-B02902">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T128-B03001">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B03002">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B03201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B03301">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B03501">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B03701">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B04501">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B04601">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B04502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B03702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T128-B04701">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T128-B04702">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B04901">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B04902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B04703">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T128-B05101">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T128-B05301">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B05302">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B05501">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B05701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B05702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B05502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B05102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B05901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B02903">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DeliveryCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B02802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T128-B06301">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party">
         <assert test="cbc:EndpointID" flag="fatal" id="PEPPOL-T128-B06401">Element 'cbc:EndpointID' MUST be provided.</assert>
         <assert test="cac:PartyLegalEntity" flag="fatal" id="PEPPOL-T128-B06402">Element 'cac:PartyLegalEntity' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T128-B06501">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B06502">Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B06701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B06801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B07001">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B07201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B08001">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B08101">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B08002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B07202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="fatal" id="PEPPOL-T128-B08201">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="fatal" id="PEPPOL-T128-B08202">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B08401">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B08402">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyTaxScheme/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B08203">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity">
         <assert test="cbc:RegistrationName" flag="fatal" id="PEPPOL-T128-B08601">Element 'cbc:RegistrationName' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T128-B08801">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B08802">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B09001">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B09201">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B09202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B09002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:PartyLegalEntity/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B08602">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/cac:Contact/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B09401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B06403">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:DespatchSupplierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B06302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T128-B09801">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B10001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B10101">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B10301">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B10501">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B11301">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B11401">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B11302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B10502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B09901">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:BuyerCustomerParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B09802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty">
         <assert test="cac:Party" flag="fatal" id="PEPPOL-T128-B11501">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B11701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B11801">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B12001">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress">
         <assert test="cac:Country" flag="fatal" id="PEPPOL-T128-B12201">Element 'cac:Country' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="fatal" id="PEPPOL-T128-B13001">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B13101">Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B13002">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B12202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/cac:Party/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B11601">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:SellerSupplierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B11502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B13201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cbc:Information"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B13501">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cac:Status" flag="fatal" id="PEPPOL-T128-B13502">Element 'cac:Status' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:Status">
         <assert test="cbc:ConditionCode" flag="fatal" id="PEPPOL-T128-B13701">Element 'cbc:ConditionCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:Status/cbc:ConditionCode">
         <assert test="(some $code in $clUNCL4343_T128 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B13801">Value MUST be part of code list 'Application Response type code (UNCL4343 Subset T128)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:Status/cbc:StatusReasonCode">
         <assert test="(some $code in $clConsignmentStatusReason satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B13901">Value MUST be part of code list 'Consignment Status Reason (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:Status/cbc:StatusReason"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:Status/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B13702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B14201">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID">
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B14301">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B14501">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person">
         <assert test="cac:IdentityDocumentReference"
                 flag="fatal"
                 id="PEPPOL-T128-B14701">Element 'cac:IdentityDocumentReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B14801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B14802">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:Person/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B14702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B14101">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Consignment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B13503">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery">
         <assert test="cbc:ActualDeliveryDate" flag="fatal" id="PEPPOL-T128-B15101">Element 'cbc:ActualDeliveryDate' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cbc:ActualDeliveryTime"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/cac:DeliveryLocation">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B15701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/cac:DeliveryLocation/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B15702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/cac:DeliveryTerms/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B15401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:Delivery/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B15102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B15901">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:TransportHandlingUnitTypeCode"
                 flag="fatal"
                 id="PEPPOL-T128-B15902">Element 'cbc:TransportHandlingUnitTypeCode' MUST be provided.</assert>
         <assert test="cac:Status" flag="fatal" id="PEPPOL-T128-B15903">Element 'cac:Status' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode">
         <assert test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B16101">Value MUST be part of code list 'Recommendation 21 (UN/ECE)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cac:Status">
         <assert test="cbc:ConditionCode" flag="fatal" id="PEPPOL-T128-B16201">Element 'cbc:ConditionCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cac:Status/cbc:ConditionCode">
         <assert test="(some $code in $clUNCL4343_T128 satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B16301">Value MUST be part of code list 'Application Response type code (UNCL4343 Subset T128)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cac:Status/cbc:StatusReasonCode">
         <assert test="(some $code in $clTransportHandlingUnitReason satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B16401">Value MUST be part of code list 'Transport Handling Unit Reason codes (based on UNCL7007). '.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cac:Status/cbc:StatusReason"/>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/cac:Status/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B16202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/cac:TransportHandlingUnit/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B15904">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:Shipment/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B13202">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B16601">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cac:DespatchLineReference"
                 flag="fatal"
                 id="PEPPOL-T128-B16602">Element 'cac:DespatchLineReference' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:Note"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:ReceivedQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T128-B16901">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:ShortQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T128-B17101">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:ShortageActionCode">
         <assert test="(some $code in $clReceiptAdviceActionCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B17301">Value MUST be part of code list 'Receipt Advice Action (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:RejectedQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T128-B17401">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:RejectReasonCode">
         <assert test="(some $code in $clRejectReasonCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B17601">Value MUST be part of code list 'Reject Reason (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:RejectReason"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:RejectActionCode">
         <assert test="(some $code in $clReceiptAdviceActionCode satisfies $code = normalize-space(text()))"
                 flag="fatal"
                 id="PEPPOL-T128-B17801">Value MUST be part of code list 'Receipt Advice Action (openPEPPOL)'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cbc:OversupplyQuantity">
         <assert test="@unitCode" flag="fatal" id="PEPPOL-T128-B17901">Attribute 'unitCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference">
         <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T128-B18101">Element 'cbc:LineID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cbc:LineID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cbc:SalesOrderLineID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cac:OrderReference"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cac:OrderReference/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cac:OrderReference/cbc:SalesOrderID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/cac:OrderReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B18401">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:OrderLineReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B18102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:DespatchLineReference">
         <assert test="cbc:LineID" flag="fatal" id="PEPPOL-T128-B18701">Element 'cbc:LineID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:DespatchLineReference/cbc:LineID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:DespatchLineReference/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B18702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item">
         <assert test="cbc:Name" flag="fatal" id="PEPPOL-T128-B18901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cbc:Name"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:BuyersItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B19101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:BuyersItemIdentification/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:BuyersItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B19102">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:SellersItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B19301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:SellersItemIdentification/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:SellersItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B19302">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:ManufacturersItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B19501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:ManufacturersItemIdentification/cbc:ID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:ManufacturersItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B19502">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:StandardItemIdentification">
         <assert test="cbc:ID" flag="fatal" id="PEPPOL-T128-B19701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:StandardItemIdentification/cbc:ID">
         <assert test="@schemeID" flag="fatal" id="PEPPOL-T128-B19801">Attribute 'schemeID' MUST be present.</assert>
         <assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)"
                 flag="fatal"
                 id="PEPPOL-T128-B19802">Value MUST be part of code list 'ISO 6523 ICD list'.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID"/>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/cac:StandardItemIdentification/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B19702">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/cac:Item/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B18902">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/cac:ReceiptLine/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B16603">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/ubl:ReceiptAdvice/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T128-B00112">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
    <pattern>

	     <rule context="cbc:CustomizationID">
		       <assert id="PEPPOL-T128-R001"
                 test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1')"
                 flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:receipt_advice:1'.</assert>
	     </rule>
	     <rule context="cbc:ProfileID">
		       <assert id="PEPPOL-T128-R002"
                 test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1')"
                 flag="fatal">ProfileID SHALL have the value urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1.</assert>
	     </rule>
	
	     <rule context="cac:ReceiptLine">
		       <assert id="PEPPOL-T128-R003"
                 test="(cac:Item/cac:StandardItemIdentification/cbc:ID) or  (cac:Item/cac:SellersItemIdentification/cbc:ID) or not(cac:Item)"
                 flag="fatal">Each item in a Receipt Advice line SHALL be identifiable by either "item seller's identifier" or "item standard identifier"</assert>
		       <assert id="PEPPOL-T128-R004"
                 test="((cbc:RejectedQuantity) and (cbc:RejectActionCode)) or not(cbc:RejectedQuantity)"
                 flag="fatal">A Reject Action Code SHALL be provided if the receipt line contains a rejected quantity</assert>
		       <assert id="PEPPOL-T128-R005"
                 test="((cbc:RejectedQuantity) and (cbc:RejectReasonCode)) or not(cbc:RejectedQuantity)"
                 flag="fatal">A Reject Reason Code SHALL be provided if the receipt line contains a rejected quantity</assert>
		       <assert id="PEPPOL-T128-R006"
                 test="((cbc:RejectedQuantity) and (cbc:RejectReason)) or not(cbc:RejectedQuantity)"
                 flag="fatal">A Reject Reason SHALL be provided if the receipt line contains a rejected quantity</assert>
		       <assert id="PEPPOL-T128-R007"
                 test="((cbc:ShortQuantity) and (cbc:ShortageActionCode)) or not(cbc:ShortQuantity)"
                 flag="fatal">A Shortage Action Code SHALL be provided if the receipt line contains a shortage quantity</assert>
	     </rule>
	
	     <rule context="cac:BuyerCustomerParty">
		       <assert id="PEPPOL-T128-R008"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A Receipt Advice Buyer Party SHALL contain the name or an identifier</assert>
	     </rule>
	     <rule context="cac:DeliveryCustomerParty">
		       <assert id="PEPPOL-T128-R108"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A Receipt Advice Delivery Customer Party SHALL contain the name or an identifier</assert>
	     </rule>
	     <rule context="cac:DespatchSupplierParty">
		       <assert id="PEPPOL-T128-R109"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A Receipt Advice Despatch Supplier Party SHALL contain the name or an identifier</assert>
	     </rule>
	     <rule context="cac:SellerSupplierParty">
		       <assert id="PEPPOL-T128-R009"
                 test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A Receipt Advice Seller Party SHALL contain the name or an identifier</assert>
	     </rule>
	     <rule context="cac:Shipment/cac:Consignment/cac:CarrierParty">
		       <assert id="PEPPOL-T128-R110"
                 test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"
                 flag="fatal">A Receipt Advice Carrier Party SHALL contain the name or an identifier</assert>
	     </rule>

	     <rule context="cac:Shipment/cac:Delivery/cac:RequestedDeliveryPeriod">
		       <assert id="PEPPOL-T128-R012"
                 test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')"
                 flag="fatal">Start date must be earlier or equal to end date</assert>
		       <assert id="PEPPOL-T128-R013"
                 test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)"
                 flag="fatal">EndTime cannot be specified without StartTime</assert>
		       <assert id="PEPPOL-T128-R014"
                 test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)"
                 flag="fatal">EndTime cannot be specified without EndDate</assert>
		       <assert id="PEPPOL-T128-R015"
                 test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) "
                 flag="fatal">StartTime must be before EndTime</assert>
	     </rule>
	     <rule context="cac:Shipment">
		       <assert id="PEPPOL-T128-R022"
                 test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))"
                 flag="fatal">Either ID or special terms need to be specified in Delivery terms</assert>
	     </rule>
	     <rule context="cbc:ReceiptAdviceTypeCode">
		       <assert id="PEPPOL-T128-R023"
                 test="((normalize-space(.) = 'D') and not(//cac:Shipment/cbc:ID) and (//cac:DespatchDocumentReference/cbc:DocumentStatusCode)) or ((normalize-space(.) = 'S') and (//cac:Shipment/cbc:ID) and not (//cac:DespatchDocumentReference/cbc:DocumentStatusCode) )"
                 flag="fatal">When ReceiptAdvice is a response to Advanced Despatch Advice (D), it MUST contain a Status on the Referred Despatch Advice but it MUST NOT contain any Shipment group. When it is a response to a recived shipment/service (S), it SHALL include the Shipment group but MUST NOT contain any Status on the Referred Despatch Advice. </assert>
	     </rule>
	     <rule context="cac:Shipment/cac:Consignment/cac:Status">
		       <assert id="PEPPOL-T128-R025"
                 test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReasonCode)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReasonCode))"
                 flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason code SHALL be provided. </assert>
		       <assert id="PEPPOL-T128-R026"
                 test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReason)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReason)) "
                 flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason (text) SHALL be provided. </assert>
	     </rule>
	     <rule context="cac:Shipment/cac:TransportHandlingUnit/cac:Status">
		       <assert id="PEPPOL-T128-R027"
                 test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReasonCode)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReasonCode))"
                 flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason code SHALL be provided. </assert>
		       <assert id="PEPPOL-T128-R028"
                 test="((normalize-space(cbc:ConditionCode) &gt;= 'AQ') and (cbc:StatusReason)) or ((normalize-space(cbc:ConditionCode) &lt;= 'AQ') and not(cbc:StatusReason)) "
                 flag="fatal">If the Consignment is Conditionally Accepted or Rejected (CA/RE), a status reason (text) SHALL be provided. </assert>
	     </rule>
	     <rule context="cac:AdditionalDocumentReference">
		       <assert id="PEPPOL-T128-R031"
                 test="(cbc:DocumentTypeCode) or (cbc:DocumentType)"
                 flag="fatal">AdditionalDocumentReference SHALL contain a Document Type Code or a Document Type. </assert>
	     </rule>
   </pattern>    

</schema>
