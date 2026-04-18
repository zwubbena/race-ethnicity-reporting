/*----------------------------------------------------------------------------*/
/* TEA Race/Ethnicity (7 Categories) per "Race and Ethnicity in SPED"   	  */
/*																			  */	
/* Logic:                                                                     */
/*   Rule 1: If Hispanic/Latino selected -> 'H' (Hispanic/Latino)             */
/*   Rule 2: Else if exactly one non-Hisp race selected -> I/A/B/P/W          */
/*   Rule 3: Else if two or more non-Hisp races -> 'T' (Two or More Races)    */
/*																		      */
/*	   'H'='Hispanic/Latino'												  */
/*     'I'='American Indian or Alaska Native'							      */
/*     'A'='Asian'														      */
/*     'B'='Black or African American'									      */
/*     'P'='Native Hawaiian or Pacific Islander'						      */
/*     'W'='White'															  */
/*     'T'='Two or More Races'												  */
/*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
  1) INLINE TEST DATA

     Coverage:
       - Hispanic/Latino only -> H
       - Hispanic/Latino with one or more race selections -> H
       - Each single non-Hispanic race -> I/A/B/P/W
       - Two or more non-Hispanic races -> T
       - No ethnicity and no race selected -> NR
       - Duplicate DISTRICT_ID + TX_UNIQUE_STUDENT_ID for deduplication check
-----------------------------------------------------------------------------*/

data source_test;
    length
        SCHOOL_YEAR $9
        DISTRICT_ID $6
        DISTRICT_NAME $40
        TX_UNIQUE_STUDENT_ID $10
        RACE_AMER_IND_ALASK_DESC $40
        RACE_ASIAN_DESC $40
        RACE_BLACK_AFR_AMER_DESC $40
        RACE_HAW_PAC_ISL_DESC $40
        RACE_WHITE_DESC $40
    ;

    infile datalines dsd truncover;
    input
        SCHOOL_YEAR :$9.
        DISTRICT_ID :$6.
        DISTRICT_NAME :$40.
        TX_UNIQUE_STUDENT_ID :$10.
        HISPANIC_LATINO_ETHNICITY
        RACE_AMER_IND_ALASK_DESC :$40.
        RACE_ASIAN_DESC :$40.
        RACE_BLACK_AFR_AMER_DESC :$40.
        RACE_HAW_PAC_ISL_DESC :$40.
        RACE_WHITE_DESC :$40.
    ;
datalines;
2024-2025,001001,Test ISD,1000000001,1,,,,,
2024-2025,001001,Test ISD,1000000002,1,,Asian,,,White
2024-2025,001001,Test ISD,1000000003,0,American Indian or Alaska Native,,,,
2024-2025,001001,Test ISD,1000000004,0,,Asian,,,
2024-2025,001001,Test ISD,1000000005,0,,,Black or African American,,
2024-2025,001001,Test ISD,1000000006,0,,,,Native Hawaiian or Pacific Islander,
2024-2025,001001,Test ISD,1000000007,0,,,,,White
2024-2025,001001,Test ISD,1000000008,0,,Asian,,,White
2024-2025,001001,Test ISD,1000000009,0,American Indian or Alaska Native,,Black or African American,,White
2024-2025,001001,Test ISD,1000000010,0,,,,,
2024-2025,001001,Test ISD,1000000011,.,,Asian,,,
2024-2025,001001,Test ISD,1000000012,1,American Indian or Alaska Native,Asian,Black or African American,Native Hawaiian or Pacific Islander,White
2024-2025,001001,Test ISD,1000000012,0,,,,,White
;
run;

/*-----------------------------------------------------------------------------
  2) DEDUPLICATE STUDENT RECORDS
     - Keep first record per DISTRICT_ID + TX_UNIQUE_STUDENT_ID
     - Output duplicates to duplicate_review for review
-----------------------------------------------------------------------------*/

proc sort data=source_test
    out=student_unique
    dupout=duplicate_review
    nodupkey;
    by DISTRICT_ID TX_UNIQUE_STUDENT_ID;
run;

/*-----------------------------------------------------------------------------
  3) KEEP RELEVANT VARIABLES
-----------------------------------------------------------------------------*/

data analysis_base;
    set student_unique(keep=
        /* District info */
        SCHOOL_YEAR DISTRICT_ID DISTRICT_NAME 

        /* Student info */
        TX_UNIQUE_STUDENT_ID HISPANIC_LATINO_ETHNICITY 
        RACE_AMER_IND_ALASK_DESC RACE_ASIAN_DESC RACE_BLACK_AFR_AMER_DESC 
        RACE_HAW_PAC_ISL_DESC RACE_WHITE_DESC 
    );
run;

/*-----------------------------------------------------------------------------
  4) CREATE BINARY FLAGS FOR RACE/ETHNICITY
     - H = Hispanic/Latino
     - I/A/B/P/W = Non-Hispanic race indicators
-----------------------------------------------------------------------------*/

 /* Normalize to boolean flags: 1=selected, 0=not selected */
data race_flags(keep=DISTRICT_ID TX_UNIQUE_STUDENT_ID H I A B P W);
	set analysis_base;	
		/* Normalize to boolean flags: 1=selected, 0=not selected */
		H = (HISPANIC_LATINO_ETHNICITY = 1);
		I   = not missing(RACE_AMER_IND_ALASK_DESC);
		A   = not missing(RACE_ASIAN_DESC);
		B   = not missing(RACE_BLACK_AFR_AMER_DESC);
		P   = not missing(RACE_HAW_PAC_ISL_DESC);
		W   = not missing(RACE_WHITE_DESC);	
run;

/*-----------------------------------------------------------------------------
  5) COUNT NON-HISPANIC RACE SELECTIONS
-----------------------------------------------------------------------------*/

data race_count;
	set race_flags;
	RACE_CNT = sum(I, A, B, P, W);
run;

/*-----------------------------------------------------------------------------
  6) ASSIGN TEA 7-CATEGORY RACE/ETHNICITY CODE & LABEL
-----------------------------------------------------------------------------*/

data race_eth_7cat;
	length RACE_ETH_CODE $2 RACE_ETH_LABEL $75; 
	set race_count;
	
	/* Apply mutually exclusive rules */
   	if H = 1 then do;
     	RACE_ETH_LABEL = 'Hispanic/Latino (Any Race)';
     	RACE_ETH_CODE = "H";
   	end;
   	else if RACE_CNT = 1 and I then do;
     	RACE_ETH_LABEL = 'American Indian/Alaska Native (Non-Hispanic)';
     	RACE_ETH_CODE = "I";
   	end;
   	else if RACE_CNT = 1 and A then do;
     	RACE_ETH_LABEL = 'Asian (Non-Hispanic)';
     	RACE_ETH_CODE = "A";
   	end;
   	else if RACE_CNT = 1 and B then do;
     	RACE_ETH_LABEL = 'Black/African American (Non-Hispanic)';
     	RACE_ETH_CODE = "B";
   	end;
   	else if RACE_CNT = 1 and P then do;
     	RACE_ETH_LABEL   = 'Native Hawaiian/Other Pacific Islander (Non-Hispanic)';
    	RACE_ETH_CODE = "P";
   	end;
   	else if RACE_CNT = 1 and W then do;
     	RACE_ETH_LABEL = 'White (Non-Hispanic)';
     	RACE_ETH_CODE = "W";
   	end;
   	else if RACE_CNT >= 2 then do;
     	RACE_ETH_LABEL = 'Two or More Races (Non-Hispanic)';
     	RACE_ETH_CODE = "T";
   	end;
   	else if RACE_CNT = 0 and H = 0 then do;
     	RACE_ETH_LABEL = 'Not Reported (Ethnicity/Any Race)';
     	RACE_ETH_CODE = "NR";
     end;
run;

/*-----------------------------------------------------------------------------
  7) QUALITY CHECKS
     - Frequency of final codes and component flags
     - Detail print of derived records and duplicate review records
-----------------------------------------------------------------------------*/
proc freq data=race_eth_7cat order=freq;
    tables RACE_ETH_CODE RACE_ETH_LABEL H I A B P W / missing nocum;
run;

proc print data=race_eth_7cat noobs;
    title "Inline Test Results";
    var DISTRICT_ID TX_UNIQUE_STUDENT_ID H I A B P W RACE_CNT
        RACE_ETH_CODE RACE_ETH_LABEL;
run;
title;

proc print data=duplicate_review noobs;
    title "Duplicate Records Removed by DISTRICT_ID + TX_UNIQUE_STUDENT_ID";
run;
title;

/*-----------------------------------------------------------------------------
  SAS PROGRAM END
-----------------------------------------------------------------------------*/
