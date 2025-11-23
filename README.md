# Race and Ethnicity in Special Education

## Data Collection and Data Reporting

This document describes the difference between how race and ethnicity data are collected and how race and ethnicity data are reported (with a focus on special education) at the Texas Education Agency (TEA).

Revised standards for classifying individuals by race and ethnicity were issued by the US Office of Management and Budget (OMB) in 1997. In 2007, the US Department of Education (USED) issued guidance to educational institutions on how race and ethnicity data will be collected and reported. For example, race and ethnicity data are used for calculating federal significant disproportionality (SD) requirements for the ED (34 CFR §300.647) and for disaggregating student assessment data for the State’s Results-Drive Accountability (RDA) Public Reports.

USED's guidance requires using a two-part question for the self-identification of a student’s race and ethnicity. One ethnicity (Hispanic/Not Hispanic) and one or more races must be selected. The TEA then collects and stores race and ethnicity data from the two-part question using six data elements—each with a binary value (0=No; 1=Yes). Data from the six data elements are then aggregated and reported using seven categories of race and ethnicity.

![Image of Data Collection and Data Reporting](https://github.com/zanewubbena/sas-ethnicity-race-reporting/blob/main/Collection-Reporting-Flow.png)
### How do we get 7 reporting categories from 6 race and ethnicity data elements?
Race and ethnicity data are collected from local education agencies (LEAs) using six data elements that are stored in the Texas Student Data System/Public Education Information Management System (TSDS/PEIMS). Race and ethnicity data are then processed by the TEA into the seven aggregate reporting categories using three rules:

* Rule 1: If “Hispanic/Latino” is selected, then student is reported as “H” regardless of the race(s) selected.
* Rule 2: If “Not Hispanic/Latino” is selected and ONLY ONE race is selected, then student is reported as the single race category selected (I, A, B, P, or W).
* Rule 3: If “Not Hispanic/Latino” is selected and TWO OR MORE races are selected, then student is reported in the category “Two or More Races” (T).

## Repository contents

* `SAS_Program_EthRace-Reporting.sas`: SAS program that imports the example dataset, generates the 65 possible race/ethnicity combinations, and produces the aggregate reporting categories.
* `InputData.xlsx`: Excel workbook containing the sample PEIMS-style dataset used by the SAS program.
* `OutputResults.xlsx`: Excel workbook with expected outputs from the SAS program for reference.
* `Collection-Reporting-Flow.png`: Visual diagram showing how individual race and ethnicity selections are transformed into the seven reporting categories.
* `README.md`: Overview of the project, including background on collection/reporting rules and links to additional resources.

## Resources:
* Texas Education Data Standards (TEDS) Web-Enabled Data Standards
* IDEA Equity Requirements: Significant Disproportionality (SD)
* Managing an Identity Crisis: Forum Guide to Implementing New Federal Race and Ethnicity Categories
* Revisions to the Standards for the Classification of Federal Data on Race and Ethnicity
* Maintaining, Collecting and Reporting Racial and Ethnic Data to the U.S. Department of Education
