# HL7 to FHIR Integration Pipeline
 
## About
End-to-end HL7 v2.x to FHIR R4 conversion pipeline built in Mirth Connect, demonstrating interface engine configuration 
and healthcare interoperability standards mapping.
 
## Skills Demonstrated
- Mirth Connect channel configuration
- HL7 v2.x message processing (ADT A01)
- FHIR R4 resource mapping (Patient, Encounter)
- JavaScript transformation logic
 
## Mappings Completed
| HL7 Message | FHIR Resource | Status |
| ADT A01 (PID segment) | Patient | Complete |
| ADT A01 (PV1 segment) | Encounter | Complete |
 
## HL7 to FHIR Field Mapping
| HL7 Field | FHIR Field |
| PID-3 | Patient.id |
| PID-5.1 | Patient.name.family |
| PID-5.2 | Patient.name.given |
| PID-7 | Patient.birthDate |
| PID-8 | Patient.gender |
| PV1-3 | Encounter.location |
| PV1-19 | Encounter.id |
 
## Sample Transformation
Input (HL7 ADT A01): PID segment with patient demographics,
PV1 segment with visit information
Output (FHIR JSON): Patient and Encounter resources in FHIR R4 format
 
## Technical Environment
- Mirth Connect 4.7.0
- JavaScript transformers
- HL7 v2.5 messages
