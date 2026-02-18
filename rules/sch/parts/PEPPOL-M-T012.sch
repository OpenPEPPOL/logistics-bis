<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
        <rule context="query:QueryResponse">
            <assert id="PEPPOL-T012-R001" flag="fatal" test="./@requestId">A Notice QueryResponse MUST have an provide a
                reference to the QueryRequest Identifier.
            </assert>
            <assert id="PEPPOL-T012-R002" flag="fatal"
                    test="matches(normalize-space(./@requestId), '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')">
                The Request Identifier value MUST be expressed in a UUID syntax (RFC 4122).
            </assert>
            <assert id="PEPPOL-T012-R003" flag="fatal" test="count(rim:Slot[@name='SpecificationIdentification']) = 1">
                There MUST be exactly 1 SpecificationIdentification.
            </assert>
            <assert id="PEPPOL-T012-R004" flag="fatal"
                    test="count(rim:Slot[@name='BusinessProcessTypeIdentifier']) = 1">There MUST be exactly 1
                BusinessProcessTypeIdentifier.
            </assert>
            <assert id="PEPPOL-T012-R005" flag="fatal" test="count(rim:Slot[@name='IssueDateTime']) = 1">There MUST be
                exactly 1 IssueDateTime.
            </assert>
            <assert id="PEPPOL-T012-R006" flag="fatal" test="count(rim:Slot[@name='SenderElectronicAddress']) = 1">There
                MUST be exactly 1 SenderElectronicAddress.
            </assert>
            <assert id="PEPPOL-T012-R007" flag="fatal" test="count(rim:Slot[@name='ReceiverElectronicAddress']) = 1">
                There MUST be exactly 1 ReceiverElectronicAddress.
            </assert>
            <assert id="PEPPOL-T012-R008" flag="fatal" test="rim:RegistryObjectList">A Notice QueryResponse MUST have a
                Registry Object List.
            </assert>
        </rule>

        <rule context="
          query:QueryResponse/rim:Slot[@name='SpecificationIdentification']
        | query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']
        | query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']
        | query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']
        | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']
        ">
            <assert id="PEPPOL-T012-R009" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']">This
                SlotValue MUST have a xsi:type rim:StringValueType.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentification']">
            <assert id="PEPPOL-T012-R010" flag="fatal"
                    test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:trns:t012:1.1']">
                SpecificationIdentification value MUST be 'urn:fdc:peppol.eu:prac:trns:t012:1.1'.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']">
            <assert id="PEPPOL-T012-R011" flag="fatal"
                    test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:bis:p006:1.1']">
                BusinessProcessTypeIdentifier value MUST be 'urn:fdc:peppol.eu:prac:bis:p006:1.1'.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']">
            <assert id="PEPPOL-T012-R012" flag="fatal" test="rim:SlotValue[@xsi:type='rim:DateTimeValueType']">An
                IssueDateTime MUST have an element SlotValue with xsi:type of rim:DateTimeValueType.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue/rim:Value">
            <assert id="PEPPOL-T012-R013" flag="fatal"
                    test="./text()[matches(normalize-space(),'^([0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$')]">
                A Date MUST have timezone and a granularity of seconds.
            </assert>
        </rule>

        <rule context="
          query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']
        | query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']
        ">
            <assert id="PEPPOL-T012-R014" flag="fatal"
                    test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">
                An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers
                described in the "PEPPOL Policy for using Identifiers" followed by a ":".
            </assert>
            <assert id="PEPPOL-T012-R029" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be
                "EAS".
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject">
            <assert id="PEPPOL-T012-R015" flag="fatal" test="normalize-space(./@lid) != ''">The Registry Object List
                MUST have an attribute lid.
            </assert>
            <assert id="PEPPOL-T012-R016" flag="fatal" test="@xsi:type='rim:ExtrinsicObjectType'">An EndpointId MUST
                have an element SlotValue with xsi:type of rim:StringValueType.
            </assert>
            <assert id="PEPPOL-T012-R017" flag="fatal"
                    test="rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">A Notice
                QueryResponse MUST identify the Receiver by its party identifier and its BuyerElectronicAddress.
            </assert>
            <assert id="PEPPOL-T012-R026" flag="fatal"
                    test="rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']">A Notice
                QueryResponse MUST identify the Receiver by its party identifier and its BuyerPartyIdentification.
            </assert>
            <assert id="PEPPOL-T012-R018" flag="fatal" test="rim:Slot[@name='ublDocumentSchema']">A Registry Object MUST
                have a UBL Document Schema.
            </assert>
            <assert id="PEPPOL-T012-R019" flag="fatal" test="rim:RepositoryItemRef">A Registry Object MUST have a
                Repository Item Reference.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']
            | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']
            ">
            <assert id="PEPPOL-T012-R020" flag="fatal" test="rim:SlotValue[@xsi:type='rim:StringValueType']">A Buyer
                Information MUST have an element SlotValue with xsi:type of rim:StringValueType.
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']">
            <assert id="PEPPOL-T012-R021" flag="fatal" test="@type = 'ublDocumentSchema'">The @type for rim:Slot
                "ublDocumentSchema" MUST be: list to be created
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef">
            <assert id="PEPPOL-T012-R022" flag="fatal"
                    test="matches(normalize-space(./@xlink:href), '.*[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}.*')">
                The xlink:href MUST be expressed in a UUID syntax (RFC 4122).
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']/rim:SlotValue/rim:Value">
            <assert id="PEPPOL-T012-R025" flag="fatal"
                    test="./text()[matches(normalize-space(), 'eforms-sdk-[0-9].[0-9]')]">The eForms Version MUST be in
                the format eforms-sdk-x.y
            </assert>
        </rule>

        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">
            <assert id="PEPPOL-T012-R030" flag="fatal"
                    test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">
                An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers
                described in the "PEPPOL Policy for using Identifiers" followed by a ":".
            </assert>
            <assert id="PEPPOL-T012-R027" flag="fatal" test="@type = 'EAS'">BuyerElectronicAddress MUST have a type of
                "EAS".
            </assert>
        </rule>
    </pattern>

    <pattern>
        <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']
        ">
            <assert id="PEPPOL-T012-R031" flag="fatal"
                    test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3]))):')]">
                A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL
                Policy for using Identifiers" followed by a ":".
            </assert>
            <assert id="PEPPOL-T012-R028" flag="fatal" test="@type = 'ICD'">BuyerPartyIdentification MUST have a type of
                "ICD".
            </assert>
        </rule>
    </pattern>
    <!--Global Rules (only matches if no other does)-->
    <pattern>
        <rule context="*/rim:Value">
            <assert id="PEPPOL-T012-R023" flag="fatal" test="./text()[normalize-space() != '']">Value MUST have a
                text.
            </assert>
        </rule>

        <rule context="*/rim:SlotValue[@xsi:type!='rim:CollectionValueType']">
            <assert id="PEPPOL-T012-R024" flag="fatal" test="count(rim:Value) > 0">A Value for each SlotValue MUST be
                given.
            </assert>
        </rule>
    </pattern>

</schema>
