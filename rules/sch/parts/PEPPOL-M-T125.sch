<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T125-R001"
		  test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:waybill:1')"
		  flag="fatal">CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:waybill:1'.</assert>
	</rule>
	<rule context="cbc:ProfileID">
		<assert id="PEPPOL-T125-R002"
		   test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:bis:waybill_only:1')"
		  flag="fatal">ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:waybill_only:1'.</assert>
	</rule>
	
	<rule context="cac:Consignment">
		<assert id="PEPPOL-T125-R003" test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) &gt;= 0" flag="warning">Total transport handling unit quantity SHALL not be negative</assert>
		<assert id="PEPPOL-T125-R004" test="not(cbc:TotalTransportHandlingUnitQuantity) or not(cac:TransportHandlingUnit) or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)" flag="warning">Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</assert>
		<assert id="PEPPOL-T125-R005" test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) or number(cbc:GrossWeightMeasure) = sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure)" flag="warning">Shipment  gross weight measure SHALL match the gross weight of the transport handling units specified</assert>
		<assert id="PEPPOL-T125-R006" test="not(cbc:GrossVolumeMeasure) or number(cbc:GrossVolumeMeasure) &gt;= sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure)" flag="warning">Shipment gross volume measure SHALL greater or equal of the transport handling units specified</assert>		
		<assert id="PEPPOL-T125-R007" test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))" flag="fatal">Either ID or special terms need to be specified in Delivery terms</assert>
		<assert id="PEPPOL-T125-R008" test="(cbc:GrossWeightMeasure) or (cbc:GrossVolumeMeasure) or (cbc:LoadingLengthMeasure)" flag="warning">Either gross weight, gross volume or loading length must be specified</assert>
		<assert id="PEPPOL-T125-R010" test ="not(cac:PaymentTerms) or cac:PaymentTerms/cbc:ID or cac:PaymentTerms/cbc:Note"	flag="warning">When Payment terms is specified, either the ID or the note must be specified</assert>			
	</rule>
	
	<rule context="cac:Shipment/cac:Delivery/cac:EstimatedDeliveryPeriod">
		<assert id="PEPPOL-T124-R011" test="cbc:EndDate or cbc:StartDate" flag="fatal">Start date or end date must be spefied in a period</assert>
		<assert id="PEPPOL-T125-R012" test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" flag="fatal">Start date must be earlier or equal to end date</assert>
		<assert id="PEPPOL-T125-R013" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)" flag="fatal">EndTime cannot be specified without StartTime</assert>
		<assert id="PEPPOL-T125-R014" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" flag="fatal">EndTime cannot be specified without EndDate</assert>
		<assert id="PEPPOL-T125-R015" test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) " flag="fatal">StartTime must be before EndTime</assert>
		<assert id="PEPPOL-T125-R016" test= "not(cbc:StartTime) or  contains(cbc:StartTime, '+') or contains(cbc:StartTime, '-') or contains(cbc:StartTime, 'z') or contains(cbc:StartTime, 'Z')" flag="fatal">StartTime cannot be specified without timezone</assert>
		<assert id="PEPPOL-T125-R017" test= "not(cbc:EndTime) or contains(cbc:EndTime, '+') or contains(cbc:EndTime, '-') or contains(cbc:EndTime, 'z') or contains(cbc:EndTime, 'Z')" flag="fatal">EndTime cannot be specified without time zone</assert>
	</rule>
	
	<rule context="ubl:Waybill/cbc:IssueTime">
		<assert id="PEPPOL-T125-R018" test="count(timezone-from-time(.)) &gt; 0" flag="fatal"> [PEPPOL-T125-R018] IssueTime MUST include timezone information.</assert>
	</rule>

	<rule context="cac:Shipment/cac:Delivery/cac:Despatch/cac:EstimatedDespatchPeriod">
		<assert id="PEPPOL-T124-R021" test="cbc:EndDate or cbc:StartDate" flag="fatal">Start date or end date must be spefied in a period</assert>
		<assert id="PEPPOL-T125-R022" test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" flag="fatal">Start date must be earlier or equal to end date</assert>
		<assert id="PEPPOL-T125-R023" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:StartTime)" flag="fatal">EndTime cannot be specified without StartTime</assert>
		<assert id="PEPPOL-T125-R024" test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" flag="fatal">EndTime cannot be specified without EndDate</assert>
		<assert id="PEPPOL-T125-R025" test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) &gt;= dateTime((cbc:StartDate),(cbc:StartTime)) " flag="fatal">StartTime must be before EndTime</assert>
		<assert id="PEPPOL-T125-R026" test= "not(cbc:StartTime) or  contains(cbc:StartTime, '+') or contains(cbc:StartTime, '-') or contains(cbc:StartTime, 'z') or contains(cbc:StartTime, 'Z')" flag="fatal">StartTime cannot be specified without timezone</assert>
		<assert id="PEPPOL-T125-R027" test= "not(cbc:EndTime) or contains(cbc:EndTime, '+') or contains(cbc:EndTime, '-') or contains(cbc:EndTime, 'z') or contains(cbc:EndTime, 'Z')" flag="fatal">EndTime cannot be specified without time zone</assert>
	</rule>
	
	<rule context="cac:ShipmentStage">
		<assert id= "PEPPOL-T125-R030" test= "(cbc:TransportModeCode = 4 and cac:TransportMeans/cac:AirTransport/cbc:AircraftID) or (cbc:TransportModeCode = 3 and cac:TransportMeans/cac:RoadTransport/cbc:LicensePlateID) or (cbc:TransportModeCode = 2 and cac:TransportMeans/cac:RailTransport/cbc:TrainID) or (cbc:TransportModeCode = 1 and cac:TransportMeans/cac:MaritimeTransport/cbc:VesselID) or not(cac:TransportMeans)" flag="warning">Id for the transport means needs to be specified if Transport Means group is provided.</assert>
		<assert id= "PEPPOL-T125-R031" test= "not(cac:TransportMeans) or (count(cac:TransportMeans/cac:AirTransport) + count(cac:TransportMeans/cac:RoadTransport) + count(cac:TransportMeans/cac:RailTransport) + count(cac:TransportMeans/cac:MaritimeTransport) = 1)" flag="warning">Only one type of transport means can be specified</assert>
	</rule>
	
	<rule context="cac:Waybill">
		<assert id= "PEPPOL-T125-R040" test= "not(cbc:Name = 'CMR') or cac:Shipment/cac:Consignment/cbc:GrossWeightMeasure" flag="faltal">In a waybill the grosswaight needs to be speficied</assert>		
	</rule>
	
	
</pattern>

