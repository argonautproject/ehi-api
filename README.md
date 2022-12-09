# EHI Export API Implementation Guide

The ONC Final Rule regulating the 21st Century Cures Act requires certified EHR systems to be able to provide [computable copies of a patient's electronic protected health information (EHI)](https://www.healthit.gov/test-method/electronic-health-information-export). Once the rule is fully in effect at the end of 2023, this data set must encompass the entire clinical record (essentially: the "designated record set" that individuals are entitled to under HIPAA's right of access).

To empower patients to leverage apps across all of the data in their medical record, this implementation guide defines a standards-based API to access this EHI information integrated with the existing regulatory mandated patient-facing FHIR APIs that encompass the USCDI data set.

The continuous build for EHI Export API IG version 0.1.0 is published here: http://build.fhir.org/ig/argonautproject/ehi-api/
