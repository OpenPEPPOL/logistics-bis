#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))

# Delete target folder if found
if [ -e $PROJECT/target ]; then
    docker run --rm -i -v $PROJECT:/src alpine:3.6 rm -rf /src/target
fi

# Transform the files in source dir to syntax.
echo "Generating Advanced Despatch Advice"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-advanced-despatch-advice.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-advanced-despatch-advice.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Despatch Advice Response"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-despatch-advice-response.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-despatch-advice-response.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/MLR/ UblXmlReferenceFile=ubl-mlr.xml -ext:on --allow-external-functions:on
echo "Generating Weight statement"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-weight-statement.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-weight-statement.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Waybill"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-waybill.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-waybill.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Transport execution plan request"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transport-execution-plan-request.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-transport-execution-plan-request.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Transport execution plan"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transport-execution-plan.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-transport-execution-plan.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Waybill"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-waybill.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-waybill.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Transportation Status Request"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transportation-status-request.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-transportation-status-request.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Transportation Status"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transportation-status.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-transportation-status.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on
echo "Generating Receipt Advice"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-receipt-advice.xml -xsl:/src/tools/UBLInstance-To-StructureXML.xsl -o:/src/structure/syntax/ubl-receipt-advice.xml UblBaseUrl=https://raw.githubusercontent.com/OpenPEPPOL/poacc-upgrade-3/master/structure/syntax/ UblDocBaseUrl=https://docs.peppol.eu/poacc/upgrade-3/syntax/DespatchAdvice/ UblXmlReferenceFile=ubl-despatch-advice.xml -ext:on --allow-external-functions:on

# Generate maping documents.
echo "Generating mapping documents"
echo "Advanced Despatch advice"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-advanced-despatch-advice.xml -xsl:/src/tools/create-mapping-document.xsl -o:/src/rules/mapping/AdvancedDespatchAdvice.xml -ext:on --allow-external-functions:on
echo "Despatch Advice Response"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-despatch-advice-response.xml -xsl:/src/tools/create-mapping-document.xsl -o:/src/rules/mapping/DespatchAdvice_Response.xml -ext:on --allow-external-functions:on
echo "Weight statement"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-weight-statement.xml -xsl:/src/tools/create-mapping-document.xsl -o:/src/rules/mapping/WeightStatement.xml  -ext:on --allow-external-functions:on
echo "Waybill"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-waybill.xml -xsl:/src/tools/create-mapping-document.xsl -o:/src/rules/mapping/Waybill.xml -ext:on --allow-external-functions:on
echo "Receipt Advice"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/syntax/ubl-receipt-advice.xml -xsl:/src/tools/create-mapping-document.xsl -o:/src/rules/mapping/Receipt-Advice.xml -ext:on --allow-external-functions:on

# Create examples based on documentation.
echo "Generating Advanced Despatch Advice example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-advanced-despatch-advice.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/AdvancedDespatchAdvice_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Despatch Advice Response example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-despatch-advice-response.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/DespatchAdvice_Response_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Weight statement example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-weight-statement.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/WeightStatement_Example_Full.xml  -ext:on --allow-external-functions:on
echo "Generating Transport execution plan request example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transport-execution-plan-request.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/TransportExecutionPlanRequest_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Transport execution plan example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transport-execution-plan.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/TransportExecutionPlan_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Waybill example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-waybill.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/Waybill_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Transportation Status Request example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transportation-status-request.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/TransportationStatusRequest_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Transportation Status example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-transportation-status.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/TransportationStatus_Example_Full.xml -ext:on --allow-external-functions:on
echo "Generating Receipt Advice example"
docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/generated:/target --entrypoint java klakegg/saxon:9.8.0-7 -cp /saxon.jar net.sf.saxon.Transform -s:/src/structure/source/ubl-receipt-advice.xml -xsl:/src/tools/remove-pi.xsl -o:/src/rules/examples/ReceiptAdvice_Example_Full.xml  -ext:on --allow-external-functions:on

# Structure
docker run --rm -i \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    difi/vefa-structure:0.6.1

# Testing validation rules
docker run --rm -i -v $PROJECT:/src anskaffelser/validator:2.1.0 build -x -t -n eu.peppol.poacc.upgrade.v3 -a rules -target target/validator-test /src

# Schematron
for sch in $PROJECT/rules/sch/*.sch; do
    docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/schematron:/target klakegg/schematron prepare /src/rules/sch/$(basename $sch) /target/$(basename $sch)
done
docker run --rm -i -v $PROJECT/target/site/files:/src alpine:3.6 rm -rf /src/Schematron.zip
docker run --rm -i -v $PROJECT/target/schematron:/src -v $PROJECT/target/site/files:/target -w /src kramos/alpine-zip -r /target/Schematron.zip .

# Example files
docker run --rm -i -v $PROJECT/target/site/files:/src alpine:3.6 rm -rf /src/Examples.zip
docker run --rm -i -v $PROJECT/rules/examples:/src -v $PROJECT/target/site/files:/target -w /src kramos/alpine-zip -r /target/Examples.zip .

# Mapping files
docker run --rm -i -v $PROJECT/target/site/files:/src alpine:3.6 rm -rf /src/Mapping.zip
docker run --rm -i -v $PROJECT/rules/mapping:/src -v $PROJECT/target/site/files:/target -w /src kramos/alpine-zip -r /target/Mapping.zip .

# Guides
docker run --rm -i -v $PROJECT:/documents -v $PROJECT/target:/target difi/asciidoctor

# Fix ownership
docker run --rm -i -v $PROJECT:/src alpine:3.6 chown -R $(id -g $USER).$(id -g $USER) /src/target
