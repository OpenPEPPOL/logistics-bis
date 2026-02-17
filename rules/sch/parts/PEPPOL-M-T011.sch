<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

    <pattern>
        <rule context="query:QueryRequest">
            <assert id="PEPPOL-T011-R001" flag="fatal" test="matches(normalize-space(./@id), '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')">QueryRequest Identifier value MUST be expressed in a UUID syntax (RFC 4122).</assert>
            <assert id="PEPPOL-T011-R002" flag="fatal" test="count(rim:Slot[@name='SpecificationIdentification']) = 1">There MUST be exactly 1 SpecificationIdentification.</assert>
            <assert id="PEPPOL-T011-R003" flag="fatal" test="count(rim:Slot[@name='BusinessProcessTypeIdentifier']) = 1">There MUST be exactly 1 BusinessProcessTypeIdentifier.</assert>
            <assert id="PEPPOL-T011-R004" flag="fatal" test="count(rim:Slot[@name='IssueDateTime']) = 1">There MUST be exactly 1 IssueDateTime.</assert>
            <assert id="PEPPOL-T011-R005" flag="fatal" test="count(rim:Slot[@name='SenderElectronicAddress']) = 1">There MUST be exactly 1 SenderElectronicAddress.</assert>
            <assert id="PEPPOL-T011-R006" flag="fatal" test="count(rim:Slot[@name='ReceiverElectronicAddress']) = 1">There MUST be exactly 1 ReceiverElectronicAddress.</assert>
            <assert id="PEPPOL-T011-R007" flag="fatal" test="query:ResponseOption">A Search Notice Request MUST have a ResponseOption.</assert>
            <assert id="PEPPOL-T011-R008" flag="fatal" test="query:ResponseOption[@returnType='LeafClassWithRepositoryItem']">The returnType of ResponseOption MUST be "LeafClassWithRepositoryItem".</assert>
            <assert id="PEPPOL-T011-R009" flag="fatal" test="query:Query[@queryDefinition='SearchNotice']">A Search Notice Request MUST have a Query with a queryDefinition set to 'SearchNotice'.</assert>
        </rule>

        <rule context="query:QueryRequest/rim:Slot[@name='SpecificationIdentification']">
            <assert id="PEPPOL-T011-R011" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), 'urn:fdc:peppol.eu:prac:trns:t011:1.1')]">SpecificationIdentification value MUST be 'urn:fdc:peppol.eu:prac:trns:t011:1.1'.</assert>
        </rule>

        <rule context="query:QueryRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']">
            <assert id="PEPPOL-T011-R012" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:bis:p006:1.1']">BusinessProcessTypeIdentifier value MUST be 'urn:fdc:peppol.eu:prac:bis:p006:1.1'.</assert>
        </rule>

        <rule context="query:QueryRequest/rim:Slot[@name='SenderElectronicAddress'] | query:QueryRequest/rim:Slot[@name='ReceiverElectronicAddress']">
            <assert id="PEPPOL-T011-R013" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers described in the "PEPPOL Policy for using Identifiers" followed by a ":".</assert>
            <assert id="PEPPOL-T011-R081" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be "EAS".</assert>
        </rule>

        <rule context="
          query:QueryRequest/rim:Slot[@name='SpecificationIdentification']
        | query:QueryRequest/rim:Slot[@name='BusinessProcessTypeIdentifier']
        | query:QueryRequest/rim:Slot[@name='SenderElectronicAddress']
        | query:QueryRequest/rim:Slot[@name='ReceiverElectronicAddress']
        | query:QueryRequest/query:Query/rim:Slot[@name='Keywords']
        | query:QueryRequest/query:Query/rim:Slot[@name='WinnerEconomicOperatorName']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='Name']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganisationNumber']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='City']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='PostCode']
        ">
            <assert id="PEPPOL-T011-R010" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']">This SlotValue MUST have a xsi:type rim:StringValueType.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query">
            <assert id="PEPPOL-T011-R014" flag="fatal" test="count(rim:Slot[@name='Keywords']) &lt; 2">A rim:Slot Keywords can only be used once.</assert>
            <assert id="PEPPOL-T011-R015" flag="fatal" test="count(rim:Slot[@name='FormType']) &lt; 2">A rim:Slot FormType can only be used once.</assert>
            <assert id="PEPPOL-T011-R016" flag="fatal" test="count(rim:Slot[@name='NoticeType']) &lt; 2">A rim:Slot NoticeType can only be used once.</assert>
            <assert id="PEPPOL-T011-R017" flag="fatal" test="count(rim:Slot[@name='Classification']) &lt; 3">A rim:Slot Classification can only be used twice.</assert>
            <assert id="PEPPOL-T011-R018" flag="fatal" test="count(rim:Slot[@name='ContractNature']) &lt; 2">A rim:Slot ContractNature can only be used once.</assert>
            <assert id="PEPPOL-T011-R019" flag="fatal" test="count(rim:Slot[@name='PlaceOfPerformance']) &lt; 2">A rim:Slot PlaceOfPerformance can only be used once.</assert>
            <assert id="PEPPOL-T011-R020" flag="fatal" test="count(rim:Slot[@name='EstimatedValue']) &lt; 2">A rim:Slot EstimatedValue can only be used once.</assert>
            <assert id="PEPPOL-T011-R021" flag="fatal" test="count(rim:Slot[@name='ProcedureType']) &lt; 2">A rim:Slot ProcedureType can only be used once.</assert>
            <assert id="PEPPOL-T011-R022" flag="fatal" test="count(rim:Slot[@name='SubmissionLanguage']) &lt; 2">A rim:Slot SubmissionLanguage can only be used once.</assert>
            <assert id="PEPPOL-T011-R023" flag="fatal" test="count(rim:Slot[@name='PublicationDate']) &lt; 2">A rim:Slot PublicationDate can only be used once.</assert>
            <assert id="PEPPOL-T011-R024" flag="fatal" test="count(rim:Slot[@name='DeadlineReceiptTenders']) &lt; 2">A rim:Slot DeadlineReceiptTenders can only be used once.</assert>
            <assert id="PEPPOL-T011-R025" flag="fatal" test="count(rim:Slot[@name='AdditionalInformationDeadline']) &lt; 2">A rim:Slot AdditionalInformationDeadline can only be used once.</assert>
            <assert id="PEPPOL-T011-R026" flag="fatal" test="count(rim:Slot[@name='DeadlineReceiptRequests']) &lt; 2">A rim:Slot DeadlineReceiptRequests can only be used once.</assert>
            <assert id="PEPPOL-T011-R027" flag="fatal" test="count(rim:Slot[@name='NoticeIdentifier']) &lt; 2">A rim:Slot NoticeIdentifier can only be used once.</assert>
            <assert id="PEPPOL-T011-R028" flag="fatal" test="count(rim:Slot[@name='ProcedureIdentifier']) &lt; 2">A rim:Slot ProcedureIdentifier can only be used once.</assert>
            <assert id="PEPPOL-T011-R029" flag="fatal" test="count(rim:Slot[@name='ProcedureLegalBasis']) &lt; 2">A rim:Slot ProcedureLegalBasis can only be used once.</assert>
            <assert id="PEPPOL-T011-R030" flag="fatal" test="count(rim:Slot[@name='ReservedParticipation']) &lt; 2">A rim:Slot ReservedParticipation can only be used once.</assert>
            <assert id="PEPPOL-T011-R031" flag="fatal" test="count(rim:Slot[@name='SuitableForSMEs']) &lt; 2">A rim:Slot SuitableForSMEs can only be used once.</assert>
            <assert id="PEPPOL-T011-R032" flag="fatal" test="count(rim:Slot[@name='WinnerEconomicOperatorName']) &lt; 2">A rim:Slot WinnerEconomicOperatorName can only be used once.</assert>
            <assert id="PEPPOL-T011-R033" flag="fatal" test="count(rim:Slot[@name='AwardCriterionType']) &lt; 2">A rim:Slot AwardCriterionType can only be used once.</assert>
        </rule>

        <rule context="
          query:QueryRequest/query:Query/rim:Slot[@name='FormType']
        | query:QueryRequest/query:Query/rim:Slot[@name='NoticeType']
        | query:QueryRequest/query:Query/rim:Slot[@name='Classification']
        | query:QueryRequest/query:Query/rim:Slot[@name='ContractNature']
        | query:QueryRequest/query:Query/rim:Slot[@name='PlaceOfPerformance']
        | query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']
        | query:QueryRequest/query:Query/rim:Slot[@name='ProcedureType']
        | query:QueryRequest/query:Query/rim:Slot[@name='SubmissionLanguage']
        | query:QueryRequest/query:Query/rim:Slot[@name='ReservedParticipation']
        | query:QueryRequest/query:Query/rim:Slot[@name='AwardCriterionType']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganizationCountrySubdivision']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='CountryCode']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='LegalType']
        | query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='MainActivity']
        ">
            <assert id="PEPPOL-T011-R034" flag="fatal" test="rim:SlotValue[@xsi:type='rim:CollectionValueType']">rim:SlotValue MUST be of type rim:CollectionValueType.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='FormType']">
            <assert id="PEPPOL-T011-R035" flag="fatal" test="@type = 'http://publications.europa.eu/resource/authority/form-type'">A Form Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/form-type".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='NoticeType']">
            <assert id="PEPPOL-T011-R036" flag="fatal" test="@type = 'http://publications.europa.eu/resource/authority/notice-type'">A Notice Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/notice-type".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='Classification']">
            <assert id="PEPPOL-T011-R037" flag="fatal" test="normalize-space(./@type) = 'http://publications.europa.eu/resource/authority/cpv/cpv' or normalize-space(./@type) = 'http://publications.europa.eu/resource/authority/cpv/cpvsuppl'">The Type for Classification MUST be "http://publications.europa.eu/resource/authority/cpv/cpv" or "http://publications.europa.eu/resource/authority/cpv/cpvsuppl".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ContractNature']">
            <assert id="PEPPOL-T011-R038" flag="fatal" test="@type = 'http://publications.europa.eu/resource/authority/contract-nature'">A Contract Nature MUST have a type of the value of "http://publications.europa.eu/resource/authority/contract-nature".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='PlaceOfPerformance']">
            <assert id="PEPPOL-T011-R039" flag="fatal" test="@type = 'http://publications.europa.eu/resource/authority/nuts'">The Place Of Performance MUST have a type of the value of "http://publications.europa.eu/resource/authority/nuts".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']">
            <assert id="PEPPOL-T011-R040" flag="fatal" test="count(rim:Slot) > 0">At least one element for Estimated Value MUST be given.</assert>
            <assert id="PEPPOL-T011-R041" flag="fatal" test="count(rim:Slot) &lt; 4">There MUST NOT be more than 3 elements for Estimated Value.</assert>
            <assert id="PEPPOL-T011-R042" flag="fatal" test="count(rim:Slot[@name='Minimum']) &lt; 2">The rim:Slot name "Minimum" can only be used once.</assert>
            <assert id="PEPPOL-T011-R043" flag="fatal" test="count(rim:Slot[@name='Maximum']) &lt; 2">The rim:Slot name "Maximum" can only be used once.</assert>
            <assert id="PEPPOL-T011-R044" flag="fatal" test="count(rim:Slot[@name='Currency']) &lt; 2">The rim:Slot name "Currency" can only be used once.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot">
            <assert id="PEPPOL-T011-R045" flag="fatal" test="@name = 'Minimum' or @name = 'Maximum' or @name = 'Currency'">The name of the slots under Estimated Value MUST be one of "Minimum", "Maximum" or "Currency".</assert>
        </rule>

        <rule context="
              query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Minimum']/rim:SlotValue
            | query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Maximum']/rim:SlotValue
            ">
            <assert id="PEPPOL-T011-R046" flag="fatal" test="@xsi:type='rim:IntegerValueType'">A Minimum or Maximum MUST have an element SlotValue with xsi:type of rim:IntegerValueType.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']">
            <assert id="PEPPOL-T011-R047" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/currency'">The Currency of the Estimated Value MUST have a type of the value of "http://publications.europa.eu/resource/authority/currency".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='EstimatedValue']/rim:Slot[@name='Currency']/rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element">
            <assert id="PEPPOL-T011-R048" flag="fatal" test="@xsi:type = 'rim:StringValueType'">Every element in the currency collection MUST be a StringValueType.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ProcedureType']">
            <assert id="PEPPOL-T011-R049" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/procurement-procedure-type'">A Procedure Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/procurement-procedure-type".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='SubmissionLanguage']">
            <assert id="PEPPOL-T011-R050" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/language'">A Submission Language MUST have a type of the value of "http://publications.europa.eu/resource/authority/language".</assert>
        </rule>

        <rule context="
          query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']
        | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']
        | query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']
        | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']
        ">
            <assert id="PEPPOL-T011-R051" flag="fatal" test="count(rim:Slot) > 0">A Date MUST have at least one slot.</assert>
            <assert id="PEPPOL-T011-R052" flag="fatal" test="count(rim:Slot) &lt; 3">There MUST NOT be more than 2 elements for Date.</assert>
            <assert id="PEPPOL-T011-R053" flag="fatal" test="count(rim:Slot[@name='EndDate']) &lt; 2">The rim:Slot name "EndDate" can only be used once.</assert>
            <assert id="PEPPOL-T011-R054" flag="fatal" test="count(rim:Slot[@name='StartDate']) &lt; 2">The rim:Slot name "StartDate" can only be used once.</assert>
        </rule>

        <rule context="
          query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot
        | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot
        | query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot
        | query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot
        ">
            <assert id="PEPPOL-T011-R055" flag="fatal" test="rim:SlotValue">A Date MUST have a SlotValue.</assert>
            <assert id="PEPPOL-T011-R056" flag="fatal" test="@name = 'StartDate' or @name = 'EndDate'">The name of the slots under Date MUST be one of "StartDate" or "EndDate".</assert>
        </rule>

        <rule context="
           query:QueryRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='StartDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='StartDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='StartDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='StartDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='EndDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='EndDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='EndDate']/rim:SlotValue
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='EndDate']/rim:SlotValue
        ">
            <assert id="PEPPOL-T011-R057" flag="fatal" test="@xsi:type='rim:DateTimeValueType'">A Date MUST have an element SlotValue with xsi:type of rim:DateTimeValue.</assert>
        </rule>

        <rule context="
           query:QueryRequest/rim:Slot[@name='IssueDateTime']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='StartDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='PublicationDate']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptTenders']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='AdditionalInformationDeadline']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value
        |  query:QueryRequest/query:Query/rim:Slot[@name='DeadlineReceiptRequests']/rim:Slot[@name='EndDate']/rim:SlotValue/rim:Value
        ">
            <assert id="PEPPOL-T011-R058" flag="fatal" test="./text()[matches(normalize-space(),'^([0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$')]">A Date MUST have timezone and a granularity of seconds.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='ReservedParticipation']">
            <assert id="PEPPOL-T011-R059" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/reserved-procurement'">A Reserved Participation MUST have a type of the value of "http://publications.europa.eu/resource/authority/reserved-procurement".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='SuitableForSMEs']">
            <assert id="PEPPOL-T011-R060" flag="fatal" test="rim:SlotValue[@xsi:type='rim:BooleanValueType']">Suitable For SMEs MUST have an element SlotValue with xsi:type of rim:BooleanValueType.</assert>
        </rule>

         <rule context="query:QueryRequest/query:Query/rim:Slot[@name='AwardCriterionType']">
            <assert id="PEPPOL-T011-R061" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/award-criterion-type'">An Award Criterion Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/award-criterion-type".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']">
            <assert id="PEPPOL-T011-R062" flag="fatal" test="count(rim:Slot) > 0">A Buyer Information MUST have at least one slot.</assert>
            <assert id="PEPPOL-T011-R063" flag="fatal" test="count(rim:Slot) &lt; 9">There MUST NOT be more than 8 elements for Buyer Information.</assert>
            <assert id="PEPPOL-T011-R064" flag="fatal" test="count(rim:Slot[@name='Name']) &lt; 2">The rim:Slot name "Name" can only be used once.</assert>
            <assert id="PEPPOL-T011-R065" flag="fatal" test="count(rim:Slot[@name='OrganisationNumber']) &lt; 2">The rim:Slot name "OrganisationNumber" can only be used once.</assert>
            <assert id="PEPPOL-T011-R066" flag="fatal" test="count(rim:Slot[@name='City']) &lt; 2">The rim:Slot name "OrganisationNumber" can only be used once.</assert>
            <assert id="PEPPOL-T011-R067" flag="fatal" test="count(rim:Slot[@name='PostCode']) &lt; 2">The rim:Slot name "City" can only be used once.</assert>
            <assert id="PEPPOL-T011-R068" flag="fatal" test="count(rim:Slot[@name='OrganizationCountrySubdivision']) &lt; 2">The rim:Slot name "OrganizationCountrySubdivision" can only be used once.</assert>
            <assert id="PEPPOL-T011-R069" flag="fatal" test="count(rim:Slot[@name='CountryCode']) &lt; 2">The rim:Slot name "Country" can only be used once.</assert>
            <assert id="PEPPOL-T011-R070" flag="fatal" test="count(rim:Slot[@name='LegalType']) &lt; 2">The rim:Slot name "LegalType" can only be used once.</assert>
            <assert id="PEPPOL-T011-R071" flag="fatal" test="count(rim:Slot[@name='MainActivity']) &lt; 2">The rim:Slot name "MainActivity" can only be used once.</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot">
            <assert id="PEPPOL-T011-R072" flag="fatal" test="@name = 'Name' or @name = 'OrganisationNumber' or @name = 'City' or @name = 'PostCode' or @name = 'OrganizationCountrySubdivision' or @name = 'CountryCode' or @name = 'LegalType' or @name = 'MainActivity'">The name of the slots under Buyer Information MUST be one of "Name" or "OrganisationNumber" or "City" or "PostCode"  or "OrganizationCountrySubdivision" or "Country" or "LegalType" or "MainActivity".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='OrganizationCountrySubdivision']">
            <assert id="PEPPOL-T011-R073" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/nuts'">An Organization Country Subdivision MUST have a type of the value of "http://publications.europa.eu/resource/authority/nuts".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='CountryCode']">
            <assert id="PEPPOL-T011-R074" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/country'">A Country Code MUST have a type of the value of "http://publications.europa.eu/resource/authority/country".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='LegalType']">
            <assert id="PEPPOL-T011-R075" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/buyer-legal-type'">A Legal Type MUST have a type of the value of "http://publications.europa.eu/resource/authority/buyer-legal-type".</assert>
        </rule>

        <rule context="query:QueryRequest/query:Query/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='MainActivity']">
            <assert id="PEPPOL-T011-R076" flag="fatal" test="@type='http://publications.europa.eu/resource/authority/main-activity'">A Main Activity MUST have a type of the value of "http://publications.europa.eu/resource/authority/main-activity".</assert>
        </rule>

        <!--Global Rules (only matches if no other does)-->

        <rule context="*/rim:Value">
            <assert id="PEPPOL-T011-R077" flag="fatal" test="./text()[normalize-space() != '']">Value MUST have a text.</assert>
        </rule>

        <rule context="*/rim:SlotValue[@xsi:type!='rim:CollectionValueType']">
            <assert id="PEPPOL-T011-R078" flag="fatal" test="count(rim:Value) > 0">A Value for each SlotValue MUST be given.</assert>
        </rule>

        <rule context="*/rim:SlotValue[@xsi:type='rim:CollectionValueType']">
            <assert id="PEPPOL-T011-R082" flag="fatal" test="count(rim:Element) > 0">At least one Element for each SlotValue with CollectionValueType MUST be given.</assert>
        </rule>

        <rule context="*/rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element">
            <assert id="PEPPOL-T011-R079" flag="fatal" test="@xsi:type='rim:StringValueType'">rim:Element be of type rim:StringValueType.</assert>
            <assert id="PEPPOL-T011-R080" flag="fatal" test="count(rim:Value) > 0">At least one element MUST be given in a CollectionValueType.</assert>
        </rule>

    </pattern>

</schema>
