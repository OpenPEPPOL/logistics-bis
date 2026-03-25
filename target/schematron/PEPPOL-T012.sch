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
    <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
    <ns uri="utils" prefix="u"/>

    
    <pattern>
      <rule context="query:QueryResponse">
        <assert id="PEPPOL-T012-R001" flag="fatal" test="./@requestId">A Notice QueryResponse MUST have an provide a
            reference to the QueryRequest Identifier.
        </assert>
        <assert id="PEPPOL-T012-R002"
                 flag="fatal"
                 test="matches(normalize-space(./@requestId), '^[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}$')">
            The Request Identifier value MUST be expressed in a UUID syntax (RFC 4122).
        </assert>
        <assert id="PEPPOL-T012-R003"
                 flag="fatal"
                 test="count(rim:Slot[@name='SpecificationIdentification']) = 1">
            There MUST be exactly 1 SpecificationIdentification.
        </assert>
        <assert id="PEPPOL-T012-R004"
                 flag="fatal"
                 test="count(rim:Slot[@name='BusinessProcessTypeIdentifier']) = 1">There MUST be exactly 1
            BusinessProcessTypeIdentifier.
        </assert>
        <assert id="PEPPOL-T012-R005"
                 flag="fatal"
                 test="count(rim:Slot[@name='IssueDateTime']) = 1">There MUST be
            exactly 1 IssueDateTime.
        </assert>
        <assert id="PEPPOL-T012-R006"
                 flag="fatal"
                 test="count(rim:Slot[@name='SenderElectronicAddress']) = 1">There
            MUST be exactly 1 SenderElectronicAddress.
        </assert>
        <assert id="PEPPOL-T012-R007"
                 flag="fatal"
                 test="count(rim:Slot[@name='ReceiverElectronicAddress']) = 1">
            There MUST be exactly 1 ReceiverElectronicAddress.
        </assert>
        <assert id="PEPPOL-T012-R008" flag="fatal" test="rim:RegistryObjectList">A Notice QueryResponse MUST have a
            Registry Object List.
        </assert>
      </rule>
    
      <rule context="         query:QueryResponse/rim:Slot[@name='SpecificationIdentification']         | query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']         | query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']         | query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']         | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']             ">
        <assert id="PEPPOL-T012-R009"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']">This
            SlotValue MUST have a xsi:type rim:StringValueType.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:Slot[@name='SpecificationIdentification']">
        <assert id="PEPPOL-T012-R010"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:trns:t012:1.3']">
            SpecificationIdentification value MUST be 'urn:fdc:peppol.eu:prac:trns:t012:1.3'.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']">
        <assert id="PEPPOL-T012-R011"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[normalize-space() = 'urn:fdc:peppol.eu:prac:bis:p006:1.3']">
            BusinessProcessTypeIdentifier value MUST be 'urn:fdc:peppol.eu:prac:bis:p006:1.3'.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']">
        <assert id="PEPPOL-T012-R012"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:DateTimeValueType']">An
            IssueDateTime MUST have an element SlotValue with xsi:type of rim:DateTimeValueType.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue/rim:Value">
        <assert id="PEPPOL-T012-R013"
                 flag="fatal"
                 test="./text()[matches(normalize-space(),'^([0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$')]">
            A Date MUST have timezone and a granularity of seconds.
        </assert>
      </rule>
    
      <rule context="         query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']         | query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']             ">

		       <assert id="PEPPOL-T012-R014"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">
			An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers
			described in the "PEPPOL Policy for using Identifiers" followed by a ":".
		</assert>

		       <assert id="PEPPOL-T012-R029" flag="fatal" test="@type = 'EAS'">The schemeID type attribute has to be
            "EAS".
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject">
        <assert id="PEPPOL-T012-R015"
                 flag="fatal"
                 test="normalize-space(./@lid) != ''">The Registry Object List
            MUST have an attribute lid.
        </assert>
        <assert id="PEPPOL-T012-R016"
                 flag="fatal"
                 test="@xsi:type='rim:ExtrinsicObjectType'">An EndpointId MUST
            have an element SlotValue with xsi:type of rim:StringValueType.
        </assert>
        <assert id="PEPPOL-T012-R017"
                 flag="fatal"
                 test="rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">A Notice
            QueryResponse MUST identify the Receiver by its party identifier and its BuyerElectronicAddress.
        </assert>
        <assert id="PEPPOL-T012-R026"
                 flag="fatal"
                 test="rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']">A Notice
            QueryResponse MUST identify the Receiver by its party identifier and its BuyerPartyIdentification.
        </assert>
        <assert id="PEPPOL-T012-R018"
                 flag="fatal"
                 test="rim:Slot[@name='ublDocumentSchema']">A Registry Object MUST
            have a UBL Document Schema.
        </assert>
        <assert id="PEPPOL-T012-R019" flag="fatal" test="rim:RepositoryItemRef">A Registry Object MUST have a
            Repository Item Reference.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']         | query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']             ">
        <assert id="PEPPOL-T012-R020" flag="fatal" test="rim:SlotValue">A Buyer
            Information MUST have an element SlotValue.
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']">
        <assert id="PEPPOL-T012-R021"
                 flag="fatal"
                 test="@type = 'ublDocumentSchema'">The @type for rim:Slot
            "ublDocumentSchema" MUST be: list to be created
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef">
        <assert id="PEPPOL-T012-R022"
                 flag="fatal"
                 test="matches(normalize-space(./@xlink:href), '.*[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}.*')">
            The xlink:href MUST be expressed in a UUID syntax (RFC 4122).
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']/rim:SlotValue/rim:Value">
        <assert id="PEPPOL-T012-R025"
                 flag="fatal"
                 test="./text()[matches(normalize-space(), 'eforms-sdk-[0-9].[0-9]')]">The eForms Version MUST be in
            the format eforms-sdk-x.y
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">
		       <assert id="PEPPOL-T012-R030"
                 flag="fatal"
                 test="rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value/text()[matches(normalize-space(), '^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957):')]">
			An Electronic Address MUST have a scheme identifier attribute from the list of "PEPPOL Party Identifiers
			described in the "PEPPOL Policy for using Identifiers" followed by a ":".
		</assert>

		       <assert id="PEPPOL-T012-R027" flag="fatal" test="@type = 'EAS'">BuyerElectronicAddress MUST have a type of
            "EAS".
        </assert>
      </rule>
    
      <rule context="query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']             ">
		       <assert id="PEPPOL-T012-R031"
                 flag="fatal"
                 test="(rim:SlotValue[@xsi:type='rim:StringValueType']/rim:Value | rim:SlotValue[@xsi:type='rim:CollectionValueType']/rim:Element/rim:Value)[matches(normalize-space(.),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3]))):')]">
			A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described in the "PEPPOL
			Policy for using Identifiers" followed by a ":".
		</assert>

		       <assert id="PEPPOL-T012-R028" flag="fatal" test="@type = 'ICD'">BuyerPartyIdentification MUST have a type of
            "ICD".
        </assert>
      </rule>
    
      <rule context="*/rim:Value">
        <assert id="PEPPOL-T012-R023"
                 flag="fatal"
                 test="./text()[normalize-space() != '']">Value MUST have a
            text.
        </assert>
      </rule>
    
      <rule context="*/rim:SlotValue[@xsi:type!='rim:CollectionValueType']">
        <assert id="PEPPOL-T012-R024" flag="fatal" test="count(rim:Value) &gt; 0">A Value for each SlotValue MUST be
            given.
        </assert>
      </rule>
   </pattern>
    <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <rule context="/query:QueryResponse">
         <assert test="rim:Slot[@name='SpecificationIdentification']"
                 flag="fatal"
                 id="PEPPOL-T012-B00101">Element 'rim:Slot[@name='SpecificationIdentification']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='BusinessProcessTypeIdentifier']"
                 flag="fatal"
                 id="PEPPOL-T012-B00102">Element 'rim:Slot[@name='BusinessProcessTypeIdentifier']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='IssueDateTime']"
                 flag="fatal"
                 id="PEPPOL-T012-B00103">Element 'rim:Slot[@name='IssueDateTime']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='SenderElectronicAddress']"
                 flag="fatal"
                 id="PEPPOL-T012-B00104">Element 'rim:Slot[@name='SenderElectronicAddress']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='ReceiverElectronicAddress']"
                 flag="fatal"
                 id="PEPPOL-T012-B00105">Element 'rim:Slot[@name='ReceiverElectronicAddress']' MUST be provided.</assert>
         <assert test="rim:RegistryObjectList" flag="fatal" id="PEPPOL-T012-B00106">Element 'rim:RegistryObjectList' MUST be provided.</assert>
         <assert test="not(@*:schemaLocation)" flag="fatal" id="PEPPOL-T012-B00107">Document MUST not contain schema location.</assert>
         <assert test="@requestId" flag="fatal" id="PEPPOL-T012-B00108">Attribute 'requestId' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SpecificationIdentification']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B00501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SpecificationIdentification'"
                 flag="fatal"
                 id="PEPPOL-T012-B00502">Attribute 'name' MUST contain value 'SpecificationIdentification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B00503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SpecificationIdentification']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B00701">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B00702">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B00703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SpecificationIdentification']/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:trns:t012:1.3'"
                 flag="fatal"
                 id="PEPPOL-T012-B00901">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:trns:t012:1.3'.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SpecificationIdentification']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B00504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B01001">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BusinessProcessTypeIdentifier'"
                 flag="fatal"
                 id="PEPPOL-T012-B01002">Attribute 'name' MUST contain value 'BusinessProcessTypeIdentifier'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B01003">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B01201">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B01202">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B01203">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']/rim:SlotValue/rim:Value">
         <assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:prac:bis:p006:1.3'"
                 flag="fatal"
                 id="PEPPOL-T012-B01401">Element 'rim:Value' MUST contain value 'urn:fdc:peppol.eu:prac:bis:p006:1.3'.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='BusinessProcessTypeIdentifier']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B01004">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='IssueDateTime']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B01501">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'IssueDateTime'"
                 flag="fatal"
                 id="PEPPOL-T012-B01502">Attribute 'name' MUST contain value 'IssueDateTime'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B01503">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B01701">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:DateTimeValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B01702">Attribute 'xsi:type' MUST contain value 'rim:DateTimeValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B01703">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='IssueDateTime']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:Slot[@name='IssueDateTime']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B01504">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B02001">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'SenderElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T012-B02002">Attribute 'name' MUST contain value 'SenderElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B02003">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'EAS'"
                 flag="fatal"
                 id="PEPPOL-T012-B02004">Attribute 'type' MUST contain value 'EAS'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T012-B02005">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B02301">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B02302">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B02303">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:Slot[@name='SenderElectronicAddress']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B02006">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B02601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ReceiverElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T012-B02602">Attribute 'name' MUST contain value 'ReceiverElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B02603">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'EAS'"
                 flag="fatal"
                 id="PEPPOL-T012-B02604">Attribute 'type' MUST contain value 'EAS'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T012-B02605">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B02901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B02902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B02903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:Slot[@name='ReceiverElectronicAddress']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B02606">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject">
         <assert test="rim:Slot[@name='BuyerInformation']"
                 flag="fatal"
                 id="PEPPOL-T012-B03301">Element 'rim:Slot[@name='BuyerInformation']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='ublDocumentSchema']"
                 flag="fatal"
                 id="PEPPOL-T012-B03302">Element 'rim:Slot[@name='ublDocumentSchema']' MUST be provided.</assert>
         <assert test="rim:Slot[@name='eFormsVersion']"
                 flag="fatal"
                 id="PEPPOL-T012-B03303">Element 'rim:Slot[@name='eFormsVersion']' MUST be provided.</assert>
         <assert test="rim:RepositoryItemRef" flag="fatal" id="PEPPOL-T012-B03304">Element 'rim:RepositoryItemRef' MUST be provided.</assert>
         <assert test="@lid" flag="fatal" id="PEPPOL-T012-B03305">Attribute 'lid' MUST be present.</assert>
         <assert test="@id" flag="fatal" id="PEPPOL-T012-B03306">Attribute 'id' MUST be present.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:ExtrinsicObjectType'"
                 flag="fatal"
                 id="PEPPOL-T012-B03307">Attribute 'xsi:type' MUST contain value 'rim:ExtrinsicObjectType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B03308">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B03801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BuyerPartyIdentification'"
                 flag="fatal"
                 id="PEPPOL-T012-B03802">Attribute 'name' MUST contain value 'BuyerPartyIdentification'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B03803">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'ICD'"
                 flag="fatal"
                 id="PEPPOL-T012-B03804">Attribute 'type' MUST contain value 'ICD'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T012-B03805">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']/rim:SlotValue">
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B04101">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']/rim:SlotValue/rim:Element">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B04301">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B04302">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B04303">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']/rim:SlotValue/rim:Element/rim:Value"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']/rim:SlotValue/rim:Element/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B04304">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerPartyIdentification']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B03806">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B04601">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'BuyerElectronicAddress'"
                 flag="fatal"
                 id="PEPPOL-T012-B04602">Attribute 'name' MUST contain value 'BuyerElectronicAddress'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B04603">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'EAS'"
                 flag="fatal"
                 id="PEPPOL-T012-B04604">Attribute 'type' MUST contain value 'EAS'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T012-B04605">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B04901">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B04902">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B04903">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='BuyerInformation']/rim:Slot[@name='BuyerElectronicAddress']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B04606">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B05201">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'ublDocumentSchema'"
                 flag="fatal"
                 id="PEPPOL-T012-B05202">Attribute 'name' MUST contain value 'ublDocumentSchema'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B05203">Attribute 'name' MUST be present.</assert>
         <assert test="not(@type) or @type = 'ublDocumentSchema'"
                 flag="fatal"
                 id="PEPPOL-T012-B05204">Attribute 'type' MUST contain value 'ublDocumentSchema'</assert>
         <assert test="@type" flag="fatal" id="PEPPOL-T012-B05205">Attribute 'type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B05501">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B05502">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B05503">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='ublDocumentSchema']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B05206">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']">
         <assert test="rim:SlotValue" flag="fatal" id="PEPPOL-T012-B05801">Element 'rim:SlotValue' MUST be provided.</assert>
         <assert test="not(@name) or @name = 'eFormsVersion'"
                 flag="fatal"
                 id="PEPPOL-T012-B05802">Attribute 'name' MUST contain value 'eFormsVersion'</assert>
         <assert test="@name" flag="fatal" id="PEPPOL-T012-B05803">Attribute 'name' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']/rim:SlotValue">
         <assert test="rim:Value" flag="fatal" id="PEPPOL-T012-B06001">Element 'rim:Value' MUST be provided.</assert>
         <assert test="not(@xsi:type) or @xsi:type = 'rim:StringValueType'"
                 flag="fatal"
                 id="PEPPOL-T012-B06002">Attribute 'xsi:type' MUST contain value 'rim:StringValueType'</assert>
         <assert test="@xsi:type" flag="fatal" id="PEPPOL-T012-B06003">Attribute 'xsi:type' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']/rim:SlotValue/rim:Value"/>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:Slot[@name='eFormsVersion']/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B05804">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/rim:RepositoryItemRef">
         <assert test="@xlink:href" flag="fatal" id="PEPPOL-T012-B06301">Attribute 'xlink:href' MUST be present.</assert>
      </rule>
      <rule context="/query:QueryResponse/rim:RegistryObjectList/rim:RegistryObject/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B03309">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
      <rule context="/query:QueryResponse/*">
         <assert test="false()" flag="fatal" id="PEPPOL-T012-B00109">Document MUST NOT contain elements not part of the data model.</assert>
      </rule>
   </pattern>
</schema>
