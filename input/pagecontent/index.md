
### Background

The ONC Final Rule regulating the 21st Century Cures Act requires certified EHR systems to be able to provide [computable copies of a patient's electronic protected health information (EHI)](https://www.healthit.gov/test-method/electronic-health-information-export). Once the rule is fully in effect at the end of 2023, this data set must encompass the entire clinical record (essentially: the "designated record set" that individuals are entitled to under HIPAA's right of access).

To empower patients to leverage apps across all of the data in their medical record, this implementation guide defines a standards based API to access this EHI information integrated with the existing regulatory mandated patient-facing FHIR APIs that encompass the USCDI data set.

### Use Case

A patient wants to send a computable version of their medical record (or a subset of their record) from one or more institutions to:
* A provider at a separate institution who will offer a second opinion or take over clinical care
* An app offering AI driven care recommendations or tailored insurance coverage suggestions
* A research study that leverages medical data that are not currently available in USCDI data set
* Etc.

As defined in section 170.315(b)(10) of the 21st Century Cures Act Rules, this export must contain all of the electronic health information the institution produces and electronically manages on that patient. The export file(s) must be electronic and in a computable format, and must include documentation of the file format, including its structure and syntax.


### Design Goals

* Support integration with manual workflow steps such as HIM staff review, redaction, or format conversion
* Support vendor specific capabilities to filter or limit the volume of data sent when users make that choice
* Support internal use of the API by HIM staff or automated systems to stitch together data from multiple certified EHR systems
* Support returning EHI data in proprietary formats, in proprietary formats supplemented with FHIR metadata,  in FHIR format, or a combination of these.

### Resources

* [EHI Export Operation](ehi-export.html)
* [Mockup of App Flow](https://docs.google.com/presentation/d/1-c6GcXrexCJhYzcmnQwbVuooZInG8ONfNyFbDzfFzyg/edit?usp=sharing)