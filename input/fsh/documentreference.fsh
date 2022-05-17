Profile: EHIDocumentReference
Parent: DocumentReference
Id: ehi-document-reference
Description: "Profile for `DocumentReference` resources provided as metadata for non-FHIR content in an EHI export. Note that these resources would be minified and included as a single line in an NDJSON file"
* meta 1..
* meta.tag 1.. 
* meta.tag = #ehi-export "generated as part of an ehi-export request"
* description ..1 
* description ^short = "Should be populated if possible. Human-readable description."
* content.format ..1
* content.format ^short = "Should be populated if possible. Format/content rules for the document."
* content.attachment.contentType ..1
* content.attachment.contentType ^short = "Should be populated if possible. Mime type of the content, with charset etc."
* content.attachment.size ..1
* content.attachment.size ^short = "Should be populated if possible. Number of bytes of content."

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