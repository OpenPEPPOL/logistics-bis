    <pattern>
        <rule context="*">
            <assert id="PEPPOL-T45-S002" flag="fatal" test="normalize-space(.) != ''">A Tender Withdrawal
                Receipt Notification document MUST NOT contain empty elements.
            </assert>
        </rule>
    </pattern>

    <pattern>
        <let name="syntaxError"
             value="string('[PEPPOL-T45-S003] A Tender Withdrawal Receipt Notification document SHOULD only contain elements and attributes described in the syntax mapping. - ')"/>

        <rule context="ubl:TenderReceipt">
            <assert id="PEPPOL-T014-R001" flag="fatal" test="(cbc:UBLVersionID)">[PEPPOL-T014-R001] A Tender Withdrawal
                Receipt Notification MUST have a syntax identifier.
            </assert>
            <assert id="PEPPOL-T014-S301" flag="warning" test="not(ext:UBLExtensions)">
                [PEPPOL-T014-S301] UBLExtensions SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S305" flag="warning" test="not(cbc:ProfileExectuionID)">[PEPPOL-T014-S305] ProfileExecutionID SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S307" flag="warning" test="not(cbc:CopyIndicator)">
                [PEPPOL-T014-S307] CopyIndicator SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S308" flag="warning" test="not(cbc:UUID)">
                [PEPPOL-T014-S308] UUID SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S310" flag="warning" test="not(cbc:ConctractName)">[PEPPOL-T014-S310] ContractName SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S312" flag="warning" test="not(cbc:Note)">
                [PEPPOL-T014-S312] Note SHOULD NOT be used.
            </assert>
            <assert id="PEPPOL-T014-S313" flag="warning" test="3 > count(cac:TenderDocumentReference)">[PEPPOL-T014-S313] TenderDocumentReference SHOULD NOT be used more than twice.
            </assert>
            <assert id="PEPPOL-T014-S322" flag="warning" test="not(cac:Signature)">
                [PEPPOL-T014-S322] Signature SHOULD NOT be used.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:UBLVersionID">
            <assert id="PEPPOL-T014-R019" flag="fatal" test="normalize-space(.) = '2.2'">[PEPPOL-T014-R019] UBLVersionID
                value MUST be '2.2'
            </assert>
            <assert id="PEPPOL-T014-S302" flag="warning" test="not(./@*)">[PEPPOL-T014-S302]
                UBLVersionID SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:CustomizationID">
            <assert id="PEPPOL-T014-R002" flag="fatal"
                    test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:trns:t014:1.1'">
                [PEPPOL-T014-R002] CustomizationID value MUST be
                'urn:fdc:peppol.eu:prac:trns:t014:1.1'
            </assert>
            <assert id="PEPPOL-T014-S303" flag="warning" test="not(./@*)">[PEPPOL-T014-S303]
                CustomizationID SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:ProfileID">
            <assert id="PEPPOL-T014-R003" flag="fatal"
                    test="normalize-space(.) = 'urn:fdc:peppol.eu:prac:bis:p007:1.1'">[PEPPOL-T014-R003] ProfileID
                value MUST be 'urn:fdc:peppol.eu:prac:bis:p007:1.1'
            </assert>
            <assert id="PEPPOL-T014-S304" flag="warning" test="not(./@*)">[PEPPOL-T014-S304]
                ProfileID SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:ID">
            <assert id="PEPPOL-T014-R004" flag="fatal" test="./@schemeURI">[PEPPOL-T014-R004] A Tender Withdrawal Receipt
                Notification Identifier MUST have a schemeURI attribute.
            </assert>
            <assert id="PEPPOL-T014-R005" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T014-R005]
                schemeURI for Tender Withdrawal Receipt Notification Identifier MUST be 'urn:uuid'.
            </assert>
            <assert id="PEPPOL-T014-S306" flag="warning" test="./@*[name()='schemeURI']">[PEPPOL-T014-S306] A Tender Withdrawal Receipt Notification Identifier SHOULD NOT have
                any attributes but schemeURI
            </assert>
            <assert id="PEPPOL-T014-R006" flag="fatal"
                    test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
                [PEPPOL-T014-R006] A Tender Withdrawal Receipt Notification Identifier MUST be expressed in a UUID syntax (RFC 4122)
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:ContractFolderID">
            <assert id="PEPPOL-T014-S309" flag="warning" test="not(./@*)">[PEPPOL-T014-S309]
                ContractFolderID SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:IssueTime">
            <assert id="PEPPOL-T014-R007" flag="fatal"
                    test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
                [PEPPOL-T014-R007] IssueTime MUST have a granularity of seconds
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cbc:RegisteredTime">
            <assert id="PEPPOL-T014-R012" flag="fatal"
                    test="matches(normalize-space(.),'^(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$')">
                [PEPPOL-T014-R012] Reception of tender withdrawal time MUST have a granularity of seconds.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference">
            <assert id="PEPPOL-T014-S314" flag="warning"
                    test="count(./*) - count(./cbc:ID) - count(./cbc:DocumentTypeCode) - count(./cac:Attachment) - count(./cac:IssuerParty) = 0">
                [PEPPOL-T014-S314] TenderDocumentReference SHOULD NOT contain any
                elements but ID, DocumentTypeCode, Attachment, IssuerParty.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:ID">
            <assert id="PEPPOL-T014-R013" flag="fatal"
                    test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
                [PEPPOL-T014-R013] The document reference Identifier MUST reference the Tender ID expressed in a UUID
                syntax (RFC 4122)
            </assert>
            <assert id="PEPPOL-T014-R014" flag="fatal" test="./@schemeURI">[PEPPOL-T014-R004] A Tender Document Reference Identifier MUST have a schemeURI attribute.
            </assert>
            <assert id="PEPPOL-T014-R015" flag="fatal" test="normalize-space(./@schemeURI)='urn:uuid'">[PEPPOL-T014-R005]
                schemeURI for Tender Document Reference Identifier MUST be 'urn:uuid'.
            </assert>
            <assert id="PEPPOL-T014-S315" flag="warning" test="./@*[name()='schemeURI']">[PEPPOL-T014-S306] A Tender Document Reference Identifier SHOULD NOT have
                any attributes but schemeURI
            </assert>
            <assert id="PEPPOL-T014-R016" flag="fatal"
                    test="matches(normalize-space(.),'^[a-fA-F0-9]{8}(\-[a-fA-F0-9]{4}){3}\-[a-fA-F0-9]{12}$')">
                [PEPPOL-T014-R006] A Tender Document Reference Identifier MUST be expressed in a UUID syntax (RFC 4122)
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cbc:DocumentTypeCode">
            <assert id="PEPPOL-T014-R017" flag="fatal" test="(normalize-space(.)='13') or (normalize-space(.)='310')">[PEPPOL-T014-R014] The document type code for the document reference (the received tender) MUST be '310' or '13' if you refer to a REM evidence.
            </assert>
            <assert id="PEPPOL-T014-R023" flag="fatal" test="normalize-space(./@listID)='UNCL1001'">[PEPPOL-T014-R023]
                listID for Document Type Code MUST be 'UNCL1001'.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment">
            <assert id="PEPPOL-T014-S316" flag="warning" test="count(./*)-count(./cac:ExternalReference)=0">[PEPPOL-T014-S316] Attachment SHOULD NOT contain any elements but
                ExternalReference
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference">
            <assert id="PEPPOL-T014-S317" flag="warning"
                    test="count(./*)-count(./cbc:DocumentHash)-count(./cbc:HashAlgorithmMethod)=0">[PEPPOL-T014-S317] Attachment/ExternalReference SHOULD NOT contain any
                elements but DocumentHash, HashAlgorithmMethod
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash">
            <assert id="PEPPOL-T014-R018" flag="fatal" test="matches(normalize-space(.),'^[a-fA-F0-9]{64}$')">
                [PEPPOL-T014-R015] DocumentHash MUST resemble a SHA-256 hash value (32 byte HexString)
            </assert>
            <assert id="PEPPOL-T014-S318" flag="warning" test="not(./@*)">[PEPPOL-T014-S318]
                DocumentHash SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:Attachment/cac:ExternalReference/cbc:HashAlgorithmMethod">
            <assert id="PEPPOL-T014-R022" flag="fatal"
                    test="normalize-space(.)='http://www.w3.org/2001/04/xmlenc#sha256'">[PEPPOL-T014-R016]
                HashAlgorithmMethod MUST be 'http://www.w3.org/2001/04/xmlenc#sha256'
            </assert>
            <assert id="PEPPOL-T014-S319" flag="warning" test="not(./@*)">[PEPPOL-T014-S319]
                HashAlgorithmMethod SHOULD NOT contain any attributes.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:TenderDocumentReference/cac:IssuerParty">
            <assert id="PEPPOL-T014-S320" flag="warning" test="count(./*)-count(./cbc:EndpointID)=0">[PEPPOL-T014-S320] IssuerParty SHOULD NOT contain any elements but EndpointID.
            </assert>
        </rule>

        <rule context="cbc:EndpointID">
            <assert id="PEPPOL-T014-R010" flag="fatal" test="./@schemeID">[PEPPOL-T014-R010] An Endpoint Identifier MUST
                have a scheme identifier attribute.
            </assert>
            <assert id="PEPPOL-T014-R011" flag="fatal"
                    test="matches(normalize-space(./@schemeID),'^(0002|0007|0009|0037|0060|0088|0096|0097|0106|0130|0135|0142|0151|0183|0184|0190|0191|0192|0193|0195|0196|0198|0199|0200|0201|0202|0204|0208|0209|0210|0211|0212|0213|9901|9906|9907|9910|9913|9914|9915|9918|9919|9920|9922|9923|9924|9925|9926|9927|9928|9929|9930|9931|9932|9933|9934|9935|9936|9937|9938|9939|9940|9941|9942|9943|9944|9945|9946|9947|9948|9949|9950|9951|9952|9953|9955|9957)')">
                [PEPPOL-T014-R011] An Endpoint Identifier Scheme MUST be from the list of PEPPOL Party Identifiers
                described in the "PEPPOL Policy for using Identifiers".
            </assert>
            <assert id="PEPPOL-T014-S321" flag="warning" test="./@*[name()='schemeID']">[PEPPOL-T014-S321] EndpointID SHOULD NOT have any attributes but schemeID
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:SenderParty">
            <assert id="PEPPOL-T014-R020" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
                [PEPPOL-T014-R017] A Tender Withdrawal Receipt Notification MUST identify the Contracting Authority by its party and
                endpoint identifiers.
            </assert>
        </rule>

        <rule context="ubl:TenderReceipt/cac:ReceiverParty">
            <assert id="PEPPOL-T014-R021" flag="fatal" test="(./cac:PartyIdentification) and (./cbc:EndpointID)">
                [PEPPOL-T014-R018] A Tender Withdrawal Receipt Notification MUST identify the Economic Operator by its party and
                endpoint identifiers.
            </assert>
        </rule>


        <rule context="ubl:TenderReceipt/cac:SenderParty | ubl:TenderReceipt/cac:ReceiverParty">
            <assert id="PEPPOL-T014-S323" flag="warning"
                    test="count(./*) - count(./cac:PartyIdentification) - count(./cbc:EndpointID) - count(./cac:PartyName) = 0">
                [PEPPOL-T014-S323] ContractingParty Party SHOULD NOT contain any
                elements but EndpointID, PartyIdentification, PartyName
            </assert>
            <assert id="PEPPOL-T014-S324" flag="warning" test="count(./cac:PartyIdentification) = 1">[PEPPOL-T014-S324] PartyIdentification SHOULD be used exactly once.
            </assert>
            <assert id="PEPPOL-T014-S326" flag="warning" test="2 > count(./cac:PartyName)">[PEPPOL-T014-S326] PartyName SHOULD NOT be used more than once.
            </assert>
        </rule>

        <rule context="cac:PartyIdentification/cbc:ID">
            <assert id="PEPPOL-T014-R008" flag="fatal" test="./@schemeID">[PEPPOL-T014-R008] A Party Identifier MUST have
                a scheme identifier attribute.
            </assert>
            <assert id="PEPPOL-T014-R009" flag="fatal"
                    test="matches(normalize-space(./@schemeID),'^(0((00[3-9])|(0[1-9]\d)|(1\d{2})|(20\d)|(21[0-3])))$')">
                [PEPPOL-T014-R009] A Party Identifier Scheme MUST be from the list of PEPPOL Party Identifiers described
                in the "PEPPOL Policy for using Identifiers".
            </assert>
            <assert id="PEPPOL-T014-S325" flag="warning" test="./@*[name()='schemeID']">[PEPPOL-T014-S325] PartyIdentifier SHOULD NOT have any further attributes but
                schemeID
            </assert>
        </rule>

        <rule context="cbc:Name">
            <assert id="PEPPOL-T014-S327" flag="warning" test="not(./@*)">[PEPPOL-T014-S327]
                Name SHOULD NOT contain any attributes.
            </assert>
        </rule>
    </pattern>
