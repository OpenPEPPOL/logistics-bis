<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
<pattern>
  <rule context="ubl:Catalogue/cac:CatalogueLine/cac:Item">
    <assert test="cac:BuyersItemIdentification/cbc:ID
                      or cac:SellersItemIdentification/cbc:ID
                      or cac:ManufacturersItemIdentification/cbc:ID
                      or cac:StandardItemIdentification/cbc:ID" flag="fatal" id="PEPPOL-T036-R001">
      At least one item identifier (Buyer, Seller, Manufacturer or Standard) MUST be present on each catalogue line.
    </assert>
  </rule>
</pattern>

