### Authentication and Authorization

Systems providing the EHI Export API (EHI Servers) SHALL support the [SMART App Launch](https://hl7.org/fhir/smart-app-launch/app-launch.html) flow with a scope of `patient/$ehi-export` for apps to obtain an access token and refresh token to use in the EHI export operation described below.

EHI Servers that also support use by internal applications at a healthcare institution SHALL support the [SMART Backend Services](https://hl7.org/fhir/smart-app-launch/backend-services.html) flow with a scope of `system/$ehi-export` for apps to obtain an access token to use in the EHI export operation described below. If the internal application is user facing, it SHOULD ensure that the user of the application has been authenticated and is authorized to access the data prior to making an export request on their behalf.

### API

This API builds on the [FHIR Asynchronous Bulk Data Request Pattern](https://build.fhir.org/async-bulk.html) (Async Pattern). Unless otherwise noted, http requests, responses, and other elements of that pattern described in the FHIR documentation apply to the `ehi-export` operation API described below.


#### Kick-off Request

`POST` to `[fhir base]/Patient/:id/$ehi-export`

Requests originating from a patient-facing application do not need to supply any parameters in the kick-off request. 

Requests originating from an internal application (for example, an app used within a hospital's HIM department) that does not require retrieval of the entire record SHOULD include a [Parameters](https://www.hl7.org/fhir/parameters.html) resource populated with vendor specific values that reflect the data filtering options offered by that vendor. The available filter types and values SHOULD be described in the EHI Server's documentation.


#### Kick-off Response - success

EHI Servers that support returning a subset of a patient's EHI dataset or that wish to have additional information or approval screens displayed to the user, SHOULD return a `Link` header in the kick-off response with the URL of a web page the app can direct the patient to for them to specify the content filters that should be associated with this EHI Request (e.g., date ranges, data types, etc). 

If provided, this link SHALL include a `rel` value of `patient-interaction`. For example:

    Link: <https://ehr.example.com/req/specify/1892719857135>; rel="patient-interaction"
    
Client applications SHALL be capable of opening this link in a browser window either through a redirect or in response to a prompted user action. When the link is accessed, the EHI Server MAY authenticate the user using the same method as was used to request an access token prior to displaying or accepting the form. After the form is submitted, the EHI Server SHOULD redirect the user to a url provided by the app at registration time. 

Regardless of whether a patient interaction link is provided, the EHI Server SHALL return a `Content-Location` header to retrieve the status and results of the request as described in the Async Pattern. 


#### Status Request

After the export request has been started, the client MAY poll the status URL provided in the `Content-Location` header by issuing `HTTP GET` requests to the location.

If the EHI Server provided a patient interaction link in the Kick-off response and the patient has not completed the form at that link, the EHI Server SHALL return the same `Link` header as part of the status response (along with optional `Retry-After` and `X-Progress` headers as described in the Async Pattern). If the form has been completed, or the EHI Server did not provide a patient interaction link, the EHI Server SHALL return either the in-progress response described in the Async Pattern, the error response described in the Async Pattern, or the complete response described below.

Note that the export job may encompass manual steps such as HIM staff review, in which case the EHI Server SHALL return the in-progress response described in the Async Pattern until all workflow steps are complete and the data is ready for retrieval by the requesting app.

#### Status Response - complete

Upon completion of the export job, the EHI Server SHALL return a status of `200 OK` and a JSON manifest described in the Async Pattern. 

Example manifest:
```json
{
  "transactionTime": "[instant]",
  "requiresAccessToken" : true,
  "output" : [{
    "type" : "Patient",
    "url" : "http://serverpath2/patient.ndjson"
  },{
    "type" : "Observation",
    "url" : "http://serverpath2/observation.ndjson"
  },{
    "type" : "DocumentReference",
    "url" : "http://serverpath2/csv_export.ndjson"
  }],
  "error" : [{
    "type" : "OperationOutcome",
    "url" : "http://serverpath2/err_file_1.ndjson"
  }]
}
```

#### DocumentReference Resources

In addition to FHIR resources with the patient's data in NDJSON format, the manifest described above MAY also be populated with one or more NDJSON files consisting of FHIR `DocumentReference` resources that embed or provide urls pointing to files in vendor-defined formats (e.g., vendor-specific JSON formats, or CSV database table snapshots). When included, these resources SHOULD conform to the [EHIDocumentReference Profile](StructureDefinition-ehi-document-reference.html).

Each `DocumentReference` returned SHOULD contain:
  * `meta.tag` with a code of `ehi-export` to indicate that this file is not accessible through other FHIR APIs
  * `description` explaining how to process the file (e.g., links to data dictionary or developer documentation)
  * `content.format` providing a vendor-specific code for this data format, so clients can apply consistent processing to other files of the same format 
    * `system` is a URL for the vendor's EHI Export documentation
    * `code` is particular to this file's format
    * `display` is a human-readable descriptor for this file's format
  * `content.attachment.contentType` with a MIME type for the content (e.g., `text/csv`) 
  * `content.attachment.size` with the number of bytes of the content

EHI Servers are encouraged to make use of `DocumentReference` properties and FHIR extensions to incorporate any other relevant metadata about the files being referenced, such as their creation date or number of pages.

Referenced attachments that are archives containing other files (e.g., `.zip`) SHOULD include one or more NDJSON files named `document_reference.ndjson`. These files SHOULD contain `DocumentReference` resources with the metadata listed above that point to the individual files in the archive through relative references in `content.attachment.url`. Each non-metadata file in the archive SHOULD be referenced by a `DocumentReference` in one of the `document_reference.ndjson` files and SHOULD NOT be referenced by more than one `DocumentReference`.

Example `DocumentReference` (this would appear as a single minified line in an NDJSON file):

```json
{
  "resourceType": "DocumentReference",
  "meta": {
    "tag": [{
      "code": "ehi-export",
      "display": "generated as part of an ehi-export request"
      }
  ]},
  "description": "Demographic information not included in Patient resource, described at http://vendor.example.com/docs/cures-ehi-demographics.html",
  "content": [{
    "attachment": {
      "url": "http://server.example.org/patient_file_1.csv",
      "contentType": "text/csv"
    },
    "format": {
      "system": "https://vendor.example.com/docs/cures-ehi/v2.0.1",
      "code": "demographics-table",
      "display": "Demographics table export"
    }
  }],
  "status": "current"
}
```

### Scenarios

Examples approaches a health system may use to integrate the internal and patient-facing EHI APIs with EHR and patient portal infrastructure:

 <figure>
  {% include ehi-scenarios.svg %}
</figure>
