/**************************************************************************************/
/**************************************************************************************/
/*    Program Name     :	Ethnicity and Race Data Reporting
/*    Program Path     :	
/*
/*    Site Name        :	
/*    Site Number      :	
/*    Software/Version :	SAS 9.04.01M6P111518
/*
/*    Program Date     :	2021-06-13   Last Updated: 2021-08-03
/*
/*    Authors(s)       :	Zane Wubbena, PhD
/*    Quality Assurer  :	
/*
/*    Program Purpose  :	The purpose of the SAS program is to input ethnicity and
/*				race data based on 6 data elements and then produce two
/*				main outputs. The first output is 65 combinations of race/
/*				ethnicity with 62 being valid categories. The two additional
/*				categories are for "Missing" and "Not Avaliable" data. The
/*				second output is the aggregate 7 race/ethnicity categories.
/*
/*    Notes  :  The program uses a test data set created to ensure each of the 63
		valid ethncity and race combinations have a value.
/**************************************************************************************/
/**************************************************************************************/

%put _automatic_ ; RUN; /*Displays SAS system macro variables*/
%put My SAS version is &sysvlong;  /*Displays the SAS version*/
PROC SETINIT; RUN; /*Displays what products are licensed*/

/**************************************************************************************
			IMPORT TEST DATASET FOR SAS PROGRAM
**************************************************************************************/
OPTIONS VALIDVARNAME=V7;
/* Use the Excel workbook shipped with this repository */
LIBNAME ER XLSX "InputData.xlsx";

PROC CONTENTS DATA=ER.DATA_ETH_RACE; RUN;
PROC PRINT DATA=ER.DATA_ETH_RACE; RUN;

/**************************************************************************************
			CREATE TEST DATASET FOR SAS PROGRAM
**************************************************************************************/
DATA ETH_RACE;
	INPUT STUDENT_ID $ SPED H I A P B W; *Read instream data using column input;
	DATALINES;
	0001 1 1 0 0 0 0 0
	0002 1 0 1 0 0 0 0
	0003 1 0 0 1 0 0 0
	0004 1 0 0 0 1 0 0
	0005 1 0 0 0 0 1 0
	0006 1 0 0 0 0 0 1
	0007 1 1 1 0 0 0 0
	0008 1 0 1 1 0 0 0
	0009 1 1 0 1 0 0 0
	0010 1 0 0 1 1 0 0
	0011 1 0 1 0 1 0 0
	0012 1 1 0 0 1 0 0
	0013 1 0 0 0 1 1 0
	0014 1 0 0 1 0 1 0
	0015 1 0 1 0 0 1 0
	0016 1 1 0 0 0 1 0
	0017 1 0 0 0 0 1 1
	0018 1 0 0 0 1 0 1
	0019 1 0 0 1 0 0 1
	0020 1 0 1 0 0 0 1
	0021 1 1 0 0 0 0 1
	0022 1 1 1 1 0 0 0
	0023 1 1 0 1 1 0 0
	0024 1 0 1 1 1 0 0
	0025 1 1 1 0 1 0 0
	0026 1 1 0 0 1 1 0
	0027 1 0 1 0 1 1 0
	0028 1 0 0 1 1 1 0
	0029 1 1 0 1 0 1 0
	0030 1 0 1 1 0 1 0
	0031 1 1 1 0 0 1 0
	0032 1 1 0 0 0 1 1
	0033 1 0 1 0 0 1 1
	0034 1 0 0 1 0 1 1
	0035 1 0 0 0 1 1 1
	0036 1 1 0 0 1 0 1
	0037 1 0 1 0 1 0 1
	0038 1 0 0 1 1 0 1
	0039 1 1 0 1 0 0 1
	0040 1 0 1 1 0 0 1
	0041 1 1 1 0 0 0 1
	0042 1 1 1 1 1 0 0
	0043 1 1 1 0 1 1 0
	0044 1 0 1 1 1 1 0
	0045 1 1 0 1 1 1 0
	0046 1 1 1 1 0 1 0
	0047 1 1 1 0 0 1 1
	0048 1 0 1 1 0 1 1
	0049 1 1 0 1 0 1 1
	0050 1 0 0 1 1 1 1
	0051 1 0 1 0 1 1 1
	0052 1 1 0 0 1 1 1
	0053 1 1 1 0 1 0 1
	0054 1 0 1 1 1 0 1
	0055 1 1 0 1 1 0 1
	0056 1 1 1 1 0 0 1
	0057 1 1 1 1 1 1 0
	0058 1 1 1 1 0 1 1
	0059 1 1 0 1 1 1 1
	0060 1 0 1 1 1 1 1
	0061 1 1 1 0 1 1 1
	0062 1 1 1 1 1 0 1
	0063 1 1 1 1 1 1 1
	0064 1 0 0 0 0 0 0
	0065 1 . . . . . .
	0066 1 . 1 1 1 1 1
	0067 1 1 . 1 1 1 1
	0068 1 1 1 . 1 1 1
	0069 1 1 1 1 . 1 1
	0070 1 1 1 1 1 . 1
	0071 1 1 1 1 1 1 .
	;
RUN;

/* Run descriptive check on test dataset */
/* Test dataset is in the form of PEIMS data submitted by districts  */
PROC CONTENTS DATA=ETH_RACE; RUN;
PROC PRINT DATA=ETH_RACE (obs=20); RUN;

/**************************************************************************************
	DO NOT RUN THIS CODE - CODE USED TO GENERATE LOGIC USED IN DATA STEP
**************************************************************************************/
/* Generate all possible ethnicity/race combinations without replacement */
/* 1 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 1;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 1/6"];

/* 2 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 2;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 2/6"];

/* 3 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 3;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 3/6"];

/* 4 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 4;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 4/6"];

/* 5 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 5;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 5/6"];

/* 6 of 6 race/ethnicity combinations */
proc iml;
N = 6;                        /* number of race/ethnicity categories */
k = 6;                        /* number of race/ethnicity combinations */
idx = allcomb(N, k);
print idx;

Items = {"H" "I" "A" "P" "B" "W"};
S = Items[ ,idx];
S = shape(S, 0, k);           /* reshape S to have 3 cols */
print S[r=(char(1:nrow(S))) L="Combinations 6/6"];
/**************************************************************************************
			END OF CODE USED TO GENERATE DATA STEP LOGIC
**************************************************************************************/

/**************************************************************************************
		DATA STEP FOR PROCESSING AGGREGATE RACE/ETHNIC STUDENT DATA
**************************************************************************************/
DATA ETH_RACE_ALL;
	SET ER.DATA_ETH_RACE;

	KEEP ID SPED H I A P B W ETH_RACE ETH_RACEX ETH_RACEX_L ETH_RACE_AGG ETH_RACE_VALID;
		LENGTH ETH_RACE_AGG $30 ETH_RACEX_L $200 ETH_RACEX $12;

	/* Logic for "Missing" and "Not Available" data - Adds the 64th and 65th unique categories of combined output */
	/* "Missing" and "Not Available" data means both ethnicity and at least one race value are missing*/
	/* If any ethnic or race variables have a missing value, then the entire observation is excluded */

	/* Missing Test #1 */
	IF MISSING(H) OR MISSING(I) OR MISSING(A) OR MISSING(P) OR MISSING(B) OR MISSING(W) THEN
		DO;
			ETH_RACE = 0;
			ETH_RACEX = "M";
			ETH_RACEX_L = "Missing";
			ETH_RACE_AGG = "M";
			ETH_RACE_VALID = "FALSE";
		END;
		
	/* Missing Test #2 */
/* 	IF MISSING(H) AND (MISSING(I) OR MISSING(A) OR MISSING(P) OR MISSING(B) OR MISSING(W)) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */

	/* Missing Test #3 */
/* 	IF MISSING(H) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */
/* 	ELSE IF MISSING(I) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */
/* 	ELSE IF MISSING(A) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */
/* 	ELSE IF MISSING(P) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */
/* 	ELSE IF MISSING(B) THEN */
/* 		DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */
/* 	ELSE IF MISSING(W) THEN */
/* 			DO; */
/* 			ETH_RACE = 0; */
/* 			ETH_RACEX = "M"; */
/* 			ETH_RACEX_L = "Missing"; */
/* 			ETH_RACE_AGG = "M"; */
/* 			ETH_RACE_VALID = "FALSE"; */
/* 		END; */

	/* 64 Race/Ethnic Combinations https://blogs.sas.com/content/iml/2013/09/30/generate-combinations-in-sas.html */
        ELSE IF H = 0 AND I = 0 AND A = 0 AND P = 0 AND B = 0 AND W = 0 THEN
                DO;
                        ETH_RACE = 64;
                        ETH_RACEX = "N";
                        ETH_RACEX_L = "Not Available";
                        ETH_RACE_AGG = "N";
                        ETH_RACE_VALID = "FALSE"; *NO valid race code;
                END;

	/* 1 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF H = 1 AND I = 0 AND A = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 32;
			ETH_RACEX = "H";
			ETH_RACEX_L = "Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "FALSE"; *NO valid race code;
		END;
	ELSE IF I = 1 AND H = 0 AND A = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 1;
			ETH_RACEX = "I";
			ETH_RACEX_L = "American Indian or Alaska Native";
			ETH_RACE_AGG = "I";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND I = 0 AND H = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 2;
			ETH_RACEX = "A";
			ETH_RACEX_L = "Asian";
			ETH_RACE_AGG = "A";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF P = 1 AND A = 0 AND I = 0 AND H = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 8;
			ETH_RACEX = "P";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "P";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND P = 0 AND A = 0 AND I = 0 AND H = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 4;
			ETH_RACEX = "B";
			ETH_RACEX_L = "Black or African American";
			ETH_RACE_AGG = "B";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF W = 1 AND B = 0 AND P = 0 AND A = 0 AND I = 0 AND H = 0 THEN
		DO;
			ETH_RACE = 16;
			ETH_RACEX = "W";
			ETH_RACEX_L = "White";
			ETH_RACE_AGG = "W";
			ETH_RACE_VALID = "TRUE";
		END;

	/* 2 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF H = 1 AND I = 1 AND A = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 33;
			ETH_RACEX = "I,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND H = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 3;
			ETH_RACEX = "I,A";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF H = 1 AND A = 1 AND I = 0 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 34;
			ETH_RACEX = "A,H";
			ETH_RACEX_L = "Asian + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND P = 1 AND H = 0 AND I = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 10;
			ETH_RACEX = "A,P";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND P = 1 AND H = 0 AND A = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 9;
			ETH_RACEX = "I,P";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF H = 1 AND P = 1 AND I = 0 AND A = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 40;
			ETH_RACEX = "P,H";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF P = 1 AND B = 1 AND H = 0 AND I = 0 AND A = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 12;
			ETH_RACEX = "B,P";
			ETH_RACEX_L = "Black or African American + Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND H = 0 AND I = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 6;
			ETH_RACEX = "A,B";
			ETH_RACEX_L = "Asian + Black or African American";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND H = 0 AND A = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 5;
			ETH_RACEX = "I,B";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF H = 1 AND B = 1 AND I = 0 AND A = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 36;
			ETH_RACEX = "B,H";
			ETH_RACEX_L = "Black or African American + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND W = 1 AND H = 0 AND I = 0 AND A = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 20;
			ETH_RACEX = "B,W";
			ETH_RACEX_L = "Black or African American + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF P = 1 AND W = 1 AND H = 0 AND I = 0 AND A = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 24;
			ETH_RACEX = "P,W";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND W = 1 AND H = 0 AND I = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 18;
			ETH_RACEX = "A,W";
			ETH_RACEX_L = "Asian + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND W = 1 AND H = 0 AND A = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 17;
			ETH_RACEX = "I,W";
			ETH_RACEX_L = "American Indian or Alaska Native + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF H = 1 AND W = 1 AND I = 0 AND A = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 48;
			ETH_RACEX = "W,H";
			ETH_RACEX_L = "White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;

	/* 3 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF I = 1 AND A  = 1 AND B = 1 AND H = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 7;
			ETH_RACEX = "I,A,B";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND P = 1 AND H = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 11;
			ETH_RACEX = "I,A,P";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND P = 1 AND H = 0 AND A = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 13;
			ETH_RACEX = "I,B,P";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND P = 1 AND H = 0 AND I = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 14;
			ETH_RACEX = "A,B,P";
			ETH_RACEX_L = "Asian + Black or African American + Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND W = 1 AND H = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 19;
			ETH_RACEX = "I,A,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND W = 1 AND H = 0 AND A = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 21;
			ETH_RACEX = "I,B,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND W = 1 AND H = 0 AND I = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 22;
			ETH_RACEX = "A,B,W";
			ETH_RACEX_L = "Asian + Black or African American + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND P = 1 AND W = 1 AND H = 0 AND A = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 25;
			ETH_RACEX = "I,P,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND P = 1 AND W = 1 AND H = 0 AND I = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 26;
			ETH_RACEX = "A,P,W";
			ETH_RACEX_L = "Asian + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND P = 1 AND W = 1 AND H = 0 AND I = 0 AND A = 0 THEN
		DO;
			ETH_RACE = 28;
			ETH_RACEX = "B,P,W";
			ETH_RACEX_L = "Black or African American + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND H = 1 AND P = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 35;
			ETH_RACEX = "I,A,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND H = 1 AND A = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 37;
			ETH_RACEX = "I,B,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND H = 1 AND I = 0 AND P = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 38;
			ETH_RACEX = "A,B,H";
			ETH_RACEX_L = "Asian + Black or African American + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND P = 1 AND H = 1 AND A = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 41;
			ETH_RACEX = "I,P,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND P = 1 AND H = 1 AND I = 0 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 42;
			ETH_RACEX = "A,P,H";
			ETH_RACEX_L = "Asian + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND P = 1 AND H = 1 AND I = 0 AND A = 0 AND W = 0 THEN
		DO;
			ETH_RACE =44;
			ETH_RACEX = "B,P,H";
			ETH_RACEX_L = "Black or African American + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND W = 1 AND H = 1 AND A = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 49;
			ETH_RACEX = "I,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND W = 1 AND H = 1 AND I = 0 AND P = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 50;
			ETH_RACEX = "A,W,H";
			ETH_RACEX_L = "Asian + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND W = 1 AND H = 1 AND I = 0 AND A = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 52;
			ETH_RACEX = "B,W,H";
			ETH_RACEX_L = "Black or African American + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF P = 1 AND W = 1 AND H = 1 AND I = 0 AND A = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 56;
			ETH_RACEX = "P,W,H";
			ETH_RACEX_L = "Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;

	/* 4 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF I = 1 AND A = 1 AND B = 1 AND P = 1 AND H = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 15;
			ETH_RACEX = "I,A,B,P";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + Native Hawaiian/Other Pacific Islander";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND B = 1 AND W = 1 AND H = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 23;
			ETH_RACEX = "I,A,B,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND P = 1 AND W = 1 AND H = 0 AND B = 0 THEN
		DO;
			ETH_RACE = 27;
			ETH_RACEX = "I,A,P,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND P = 1 AND W = 1 AND A = 0 AND H = 0 THEN
		DO;
			ETH_RACE = 29;
			ETH_RACEX = "I,B,P,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND P = 1 AND W = 1 AND H = 0 AND I = 0 THEN
		DO;
			ETH_RACE = 30;
			ETH_RACEX = "A,B,P,W";
			ETH_RACEX_L = "Asian + Black or African American + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND B = 1 AND H = 1 AND W = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 39;
			ETH_RACEX = "I,A,B,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND P = 1 AND H = 1 AND B = 0 AND W = 0 THEN
		DO;
			ETH_RACE = 43;
			ETH_RACEX = "I,A,P,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND P = 1 AND H = 1 AND W = 0 AND A = 0 THEN
		DO;
			ETH_RACE = 45;
			ETH_RACEX = "I,B,P,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND P = 1 AND H = 1 AND W = 0 AND I = 0 THEN
		DO;
			ETH_RACE = 46;
			ETH_RACEX = "A,B,P,H";
			ETH_RACEX_L = "Asian + Black or African American + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND W = 1 AND H = 1 AND B = 0 AND P = 0  THEN
		DO;
			ETH_RACE = 51;
			ETH_RACEX = "I,A,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND W = 1 AND H = 1 AND A = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 53;
			ETH_RACEX = "I,B,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND W = 1 AND H = 1 AND I = 0 AND P = 0 THEN
		DO;
			ETH_RACE = 54;
			ETH_RACEX = "A,B,W,H";
			ETH_RACEX_L = "Asian + Black or African American + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND P = 1 AND W = 1 AND H = 1 AND B = 0 AND A = 0 THEN
		DO;
			ETH_RACE = 57;
			ETH_RACEX = "I,P,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND P = 1 AND W = 1 AND H = 1 AND B = 0 AND I = 0 THEN
		DO;
			ETH_RACE = 58;
			ETH_RACEX = "A,P,W,H";
			ETH_RACEX_L = "Asian + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF B = 1 AND P = 1 AND W = 1 AND H = 1 AND A = 0 AND I = 0 THEN
		DO;
			ETH_RACE = 60;
			ETH_RACEX = "B,P,W,H";
			ETH_RACEX_L = "Black or African American + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;

	/* 5 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF I = 1 AND A = 1 AND B = 1 AND P = 1 AND W = 1 AND H = 0 THEN
		DO;
			ETH_RACE = 31;
			ETH_RACEX = "I,A,B,P,W";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + Native Hawaiian/Other Pacific Islander + White";
			ETH_RACE_AGG = "T";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND B = 1 AND P = 1 AND H = 1 AND W = 0  THEN
		DO;
			ETH_RACE = 47;
			ETH_RACEX = "I,A,B,P,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + Native Hawaiian/Other Pacific Islander + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND B = 1 AND W = 1 AND H = 1 AND P = 0 THEN
		DO;
			ETH_RACE = 55;
			ETH_RACEX = "I,A,B,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND A = 1 AND P = 1 AND W = 1 AND H = 1 AND B = 0 THEN
		DO;
			ETH_RACE = 59;
			ETH_RACEX = "I,A,P,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF I = 1 AND B = 1 AND P = 1 AND W = 1 AND H = 1 AND A = 0 THEN
		DO;
			ETH_RACE = 61;
			ETH_RACEX = "I,B,P,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Black or African American + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	ELSE IF A = 1 AND B = 1 AND P = 1 AND W = 1 AND H = 1 AND I = 0 THEN
		DO;
			ETH_RACE = 62;
			ETH_RACEX = "A,B,P,W,H";
			ETH_RACEX_L = "Asian + Black or African American + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;

	/* 6 of 6 race/ethnicity combinations and aggregate output */
	ELSE IF H = 1 AND I = 1 AND A = 1 AND P = 1 AND B = 1 AND W  = 1 THEN
		DO;
			ETH_RACE = 63;
			ETH_RACEX = "I,A,B,P,W,H";
			ETH_RACEX_L = "American Indian or Alaska Native + Asian + Black or African American + Native Hawaiian/Other Pacific Islander + White + Hispanic/Latino";
			ETH_RACE_AGG = "H";
			ETH_RACE_VALID = "TRUE";
		END;
	WHERE SPED = 1; *Included only special education students;
RUN;

/**************************************************************************************
	TEMPORARY LABELS FOR AGGREGATE OUTPUT (7 RACE/ETHNIC REPORTING CATEGORIES
**************************************************************************************/
PROC FORMAT;
	value $ETH_RACE_LABEL
		'H' = 'Hispanic/Latino'
		'I' = 'American Indian or Alaska Native'
		'A' = 'Asian'
		'P' = 'Native Hawaiian or Other Pacific Islander'
		'B' = 'Black or African American'
		'W' = 'White'
		'T' = 'Two or More Races'
                'N' = 'Not Available'
		'M' = 'Missing'
		;
RUN;

/**************************************************************************************
	CHECK DESCRIPTIVE INFORMATION FOR RACE/ETHNIC DATA PROCESSED IN THE DATA STEP
**************************************************************************************/
PROC CONTENTS DATA=ETH_RACE_ALL;
RUN;

PROC SORT DATA=ETH_RACE_ALL;
	BY ETH_RACE;
RUN;

PROC PRINT DATA=ETH_RACE_ALL;
	FORMAT ETH_RACE_AGG $ETH_RACE_LABEL.;
RUN;

/**************************************************************************************
	COMPUTE FREQUENCY STATISTICS FOR THE 7 AGGREGATE RACE/ETHNIC REPORTING CATEGORIES
**************************************************************************************/

  /*Subset rows by ETH_RACE_VALID column value to get all actual eth_race combinations.
  ETH_RACE_VALID gives T or F based on whether data reporting would produce a fatal
  error. A fatal error is produced when ethnic or race has a missing value or
  when race has no valid value (i.e., 1) for an observation/person*/

PROC FREQ DATA=ETH_RACE_ALL ORDER=FREQ;
	TABLE ETH_RACE_AGG; 	*Aggregate output based on letter values;
RUN;

PROC FREQ DATA=ETH_RACE_ALL ORDER=FREQ;
	TABLE ETH_RACE_AGG; 	*Aggregate output based on letter values;
	WHERE ETH_RACE_VALID ^= "FALSE"; *Removes observations that violate data collection rules;
RUN;

PROC FREQ DATA=ETH_RACE_ALL ORDER=FREQ nlevels;
	FORMAT ETH_RACE_AGG $ETH_RACE_LABEL. ;  *Aggregate output based on labeled values;
	TABLE ETH_RACE_AGG;
	TABLE ETH_RACEX;
	WHERE ETH_RACE_VALID ^= "FALSE";
RUN;

/**************************************************************************************
			END OF SAS PROGRAM - HAVE A NICE DAY!!
**************************************************************************************/

LIBNAME ER CLEAR;
