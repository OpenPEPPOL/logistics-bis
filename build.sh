#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))
UBL_SYNTAX_FILE=${UBL_SYNTAX_FILE:-structure/syntax/ubl-pre-award-catalogue.xml}

if [ -z "$UBL_OUTPUT_FILE" ]; then
  UBL_TERM=$(sed -n 's:.*<Term>\([^<]*\)</Term>.*:\1:p' "$PROJECT/$UBL_SYNTAX_FILE" | head -n 1)
  UBL_TERM_LOCAL=${UBL_TERM#*:}
  UBL_IDENTIFIER=$(sed -n 's:.*<Property key="sch:identifier">\([^<]*\)</Property>.*:\1:p' "$PROJECT/$UBL_SYNTAX_FILE" | head -n 1)
  UBL_TRANSACTION=${UBL_IDENTIFIER%%-*}

  if [ -z "$UBL_TERM_LOCAL" ]; then
    echo "Unable to derive UBL term from $UBL_SYNTAX_FILE"
    exit 1
  fi

  if [ -z "$UBL_TRANSACTION" ]; then
    UBL_TRANSACTION=generated
  fi

  UBL_OUTPUT_FILE=rules/examples/$UBL_TRANSACTION/${UBL_TERM_LOCAL}_full.xml
fi

mkdir -p "$PROJECT/$(dirname "$UBL_OUTPUT_FILE")"

echo "Generating UBL example: input=$UBL_SYNTAX_FILE output=$UBL_OUTPUT_FILE"

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

# Testing validation rules 
#docker run --rm -i -v $PROJECT:/src anskaffelser/validator:2.1.0 build -x -t -n eu.peppol.poacc.upgrade.v3 -a rules -target target/validator-test /src
docker run --rm -i -v $PROJECT:/src phelger/vefa-validator:2.3.1 build -x -t -n eu.peppol.poacc.upgrade.v3 -a rules -target target/validator-test /src

# Schematron
for sch in $PROJECT/rules/sch/*.sch; do
    docker run --rm -i -v $PROJECT:/src -v $PROJECT/target/schematron:/target klakegg/schematron prepare /src/rules/sch/$(basename $sch) /target/$(basename $sch)
done

# Generate full UBL example
docker run --rm -i -v $PROJECT:/src --entrypoint java klakegg/saxon:9.8.0-7 \
  -cp /saxon.jar net.sf.saxon.Transform \
  -s:/src/$UBL_SYNTAX_FILE \
  -xsl:/src/tools/create-ubl-example-from-syntax.xsl \
  -o:/src/$UBL_OUTPUT_FILE

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
