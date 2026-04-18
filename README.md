# Race and Ethnicity in Special Education

## Data Collection and Data Reporting

This document describes the difference between how race and ethnicity data are collected and how race and ethnicity data are reported, with a focus on special education at the Texas Education Agency (TEA).

Revised standards for classifying individuals by race and ethnicity were issued by the U.S. Office of Management and Budget (OMB) in 1997. In 2007, the U.S. Department of Education (USED) issued guidance to educational institutions on how race and ethnicity data should be collected and reported. For example, race and ethnicity data are used to calculate federal significant disproportionality (SD) requirements for the ED (34 CFR §300.647) and to disaggregate student assessment data for the State’s Results-Driven Accountability (RDA) Public Reports.

USED guidance requires a two-part question for self-identifying a student’s race and ethnicity. One ethnicity category (Hispanic/Not Hispanic) and one or more race categories must be selected. TEA then collects and stores race and ethnicity data from the two-part question using six data elements, each with a binary value (0=No; 1=Yes). Data from the six data elements are aggregated and reported using seven categories of race and ethnicity.

![Data Collection and Data Reporting](Collection-Reporting-Flow.png)

### How do we get 7 reporting categories from 6 race and ethnicity data elements?

Race and ethnicity data are collected from local education agencies (LEAs) using six data elements that are stored in the Texas Student Data System/Public Education Information Management System (TSDS/PEIMS). Race and ethnicity data are then processed by the TEA into the seven aggregate reporting categories using three rules:

* Rule 1: If “Hispanic/Latino” is selected, the student is reported as “H” regardless of the race(s) selected.
* Rule 2: If “Not Hispanic/Latino” is selected and only one race is selected, the student is reported as the single race category selected (I, A, B, P, or W).
* Rule 3: If “Not Hispanic/Latino” is selected and two or more races are selected, the student is reported in the category “Two or More Races” (T).

## SAS Programs

* `race_ethnicity_reporting_v1.sas` - Original SAS program
* `race_ethnicity_reporting_v2.sas` - Updated SAS program with inline test data and simplified race/ethnicity derivation lineage

## Resources
* Texas Education Data Standards (TEDS) Web-Enabled Data Standards
* IDEA Equity Requirements: Significant Disproportionality (SD)
* Managing an Identity Crisis: Forum Guide to Implementing New Federal Race and Ethnicity Categories
* Revisions to the Standards for the Classification of Federal Data on Race and Ethnicity
* Maintaining, Collecting and Reporting Racial and Ethnic Data to the U.S. Department of Education
