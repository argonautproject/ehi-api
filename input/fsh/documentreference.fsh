Profile: EHIDocumentReference
Parent: DocumentReference
Id: ehi-document-reference
Description: "Profile for `DocumentReference` resources provided as metadata for non-FHIR content in an EHI export. Note that these resources would be minified and included as a single line in an NDJSON file"
* meta.tag 1.. 
* meta.tag = #ehi-export "generated as part of an ehi-export request"
* description ..1
* content.format ..1
* content.attachment.contentType ..1
* content.attachment.size ..1

Instance:    EHIDocumentReferenceExample
InstanceOf:  EHIDocumentReference
Usage:       #example
Title:       "EHI export metadata"
Description: "Example of EHI export metadata DocumentReference."
* meta.tag.code = #ehi-export "generated as part of an ehi-export request"
* description = "Demographic information not included in Patient resource, described at http://vendor.example.com/docs/cures-ehi-demographics.html"
* content.attachment.url = "http://server.example.org/patient_file_1.csv"
* content.attachment.contentType = #text/csv
* content.format = https://vendor.example.com/docs/cures-ehi/v2.0.1#demographics-table "Demographics table export"
* status = #current