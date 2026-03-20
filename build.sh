#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))

# Delete target folder if found
if [ -e $PROJECT/target ]; then
    docker run --rm -i -v $PROJECT:/src alpine:3.6 rm -rf /src/target
fi

# Transform the files in source dir to syntax.
# echo "Generating documentation: Advanced Despatch Advice"
# docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-advanced-despatch-advice.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-advanced-despatch-advice.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on

# Structure
docker run --rm -i \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    difi/vefa-structure:0.6.1


# Generate full UBL examples
echo "Generating UBL example: Expression Of Interest Request (T001)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-expression-of-interest-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T001/ExpressionOfInterestRequest_full.xml

echo "Generating UBL example: Expression Of Interest Response (T002)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-expression-of-interest-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T002/ExpressionOfInterestResponse_full.xml

echo "Generating UBL example: Tender Status Request (T003)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-status-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T003/TenderStatusRequest_full.xml

echo "Generating UBL example: Call For Tenders (T004)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-call-for-tenders.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T004/CallForTenders_full.xml

echo "Generating UBL example: Tender (T005)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-submit-tender.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T005/Tender_full.xml

echo "Generating UBL example: Tender Receipt (T006)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-receipt.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T006/TenderReceipt_full.xml

echo "Generating UBL example: Tendering Questions (T007)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tendering-questions.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T007/TenderingQuestions_full.xml

echo "Generating UBL example: Tendering Answers (T008)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tendering-answers.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T008/TenderingAnswers_full.xml

echo "Generating UBL example: Tender Clarification Request (T009)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-clarification-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T009/TenderClarificationRequest_full.xml

echo "Generating UBL example: Tender Clarification (T010)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-clarification.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T010/TenderClarification_full.xml

echo "Generating ebXML example: Search Notice Request (T011)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ebxml-search-notice-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T011/ExampleSearchNoticeRequest.xml

echo "Generating ebXML example: Search Notice Response (T012)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ebxml-search-notice-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T012/ExampleSearchNoticeResponse.xml

echo "Generating UBL example: Tender Withdrawal Request (T013)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-withdrawal-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T013/TenderWithdrawalRequest_full.xml

echo "Generating UBL example: Tender Withdrawal Response (T014)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tender-withdrawal-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T014/TenderWithdrawalResponse_full.xml

echo "Generating ebXML example: Publish Notice (T015)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ebxml-publish-notice.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T015/ExamplePublishNotice.xml

echo "Generating UBL example: Notice Publication Response (T016)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-publish-notice-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T016/NoticePublicationResponse_full.xml

echo "Generating UBL example: Awarding Notification (T017)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-notify-awarding.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T017/AwardingNotification_full.xml

echo "Generating UBL example: Tendering Message Response (T018)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-tendering-message-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T018/TenderingMessageResponse_full.xml

echo "Generating UBL example: Qualification (T019)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-qualification.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T019/Qualification_full.xml

echo "Generating UBL example: Qualification Receipt (T020)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-qualification-reception-confirmation.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T020/QualificationReceipt_full.xml

echo "Generating UBL example: Unsubscribe From Procedure Request (T021)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-unsubscribe-from-procedure-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T021/UnsubscribeFromProcedureRequest_full.xml

echo "Generating UBL example: Unsubscribe From Procedure Response (T022)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-unsubscribe-from-procedure-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T022/UnsubscribeFromProcedureResponse_full.xml

echo "Generating UBL example: Qualification Response (T023)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-qualification-response.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T023/QualificationResponse_full.xml

echo "Generating UBL example: Invitation To Tender (T024)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-invitation-to-tender.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T024/InvitationToTender_full.xml

echo "Generating UBL example: Catalogue Request (T035)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-pre-award-catalogue-request.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T035/CatalogueRequest_full.xml

echo "Generating UBL example: Catalogue (T036)"
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-pre-award-catalogue.xml -xsl:/src/tools/create-ubl-example-from-syntax.xsl -o:/src/rules/examples/T036/Catalogue_full.xml


# Testing validation rules 
#docker run --rm -i -v $PROJECT:/src anskaffelser/validator:2.1.0 build -x -t -n eu.peppol.poacc.upgrade.v3 -a rules -target target/validator-test /src
docker run --rm -i -v $PROJECT:/src phelger/vefa-validator:2.3.1 build -x -t -n eu.peppol.poacc.upgrade.v3 -a rules -target target/validator-test /src

# Schematron
for sch in $PROJECT/rules/sch/*.sch; do
    docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/schematron:/target klakegg/schematron prepare /src/rules/sch/$(basename $sch) /target/$(basename $sch)
done

# Removing old zip files and creating new ones
docker run --rm -i \
  -v $PROJECT/target/site/files:/files \
  -v $PROJECT/target/schematron:/schematron \
  -v $PROJECT/rules/examples:/examples \
  -w /tmp \
  alpine:latest sh -c '
    apk add --no-cache zip
    echo "Schematron files"
    rm -rf /files/Schematron.zip
    cd /schematron && zip -r /files/Schematron.zip .
    echo "Example files"
    rm -rf /files/Examples.zip
    cd /examples && zip -r /files/Examples.zip .
  '

# Guides
docker run --rm -i -v $PROJECT:/documents -v $PROJECT/target:/target difi/asciidoctor

# Fix ownership
docker run --rm -i -v $PROJECT:/src alpine:3.6 chown -R $(id -g $USER).$(id -g $USER) /src/target

