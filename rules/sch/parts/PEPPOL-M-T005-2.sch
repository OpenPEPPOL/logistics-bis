<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

        <rule context="cac:Country//cbc:IdentificationCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"
                    flag="fatal" id="CL-T90-R001">[CL-T90-R001]-A country identification code must be coded using ISO 3166, alpha 2 codes</assert>
        </rule>

        <rule context="cbc:DocumentTypeCode" flag="fatal">
            <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 9 13 310 311 916 ',concat(' ',normalize-space(.),' ') ) ) )"
                    flag="fatal" id="CL-T90-R003">DocumentTypeCode  must be from the code list UNCL 1001 9, 13, 310, 311 oder 916.</assert>
        </rule>

   </pattern>