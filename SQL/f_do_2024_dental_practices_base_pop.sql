create or replace FUNCTION F_DO_2024_DENTAL_PRACTICES_BASE_POP(
  v_min_month         in NUMBER,
  v_max_month         in NUMBER
)   RETURN CLOB SQL_MACRO IS

/*
ERD Base Population Cohort Figures
Version 1.0

AMENDMENTS:
    2024-01-29  : Mark McPherson    : Initial script created
    yyyy-mm-dd  : name              : notes


DESCRIPTION:
SQL macro function to return electronic Repeat Dispensing (eRD) data between two given months.
A string to use for the metric code must be supplied also.
The output will contain geographic data and LSOA-level counts of eRD and total items.
Data is filtered with the standard list (as given on the DALL Wiki) and further includes only items prescribed in England.

DEPENDENCIES:
    Tables(s):
        AML.PX_FORM_ITEM_ELEM_COMB_FACT   :   Low level prescribing data table containing NHS prescribing data
                                              Includes the patient and drug information for NHS prescriptions processed by NHSBSA
        
        DALL_REF.ONS_GEOGRAPHY_MAPPING    :   Reference table containing geographic mapping extracted from ONS published relationship data

EXAMPLE FUNCTION CALL:
-- Get data for the single month Oct 2023, labelled with metric code 'ERD01'
select * from F_INT651_ERD_BASE_POP(v_metric_code => 'ERD01', v_min_month => 202310, v_max_month => 202310);
-- Get data for latest month, labelled with metric code 'ERD_LTS'
with lym as
(select max(YEAR_MONTH) ym from AML.PX_FORM_ITEM_ELEM_COMB_FACT)
select * from F_INT651_ERD_BASE_POP(v_metric_code => 'ERD_LTS', v_min_month => (select ym from lym), v_max_month => (select ym from lym));

*/

v_sql clob;

BEGIN

    v_sql :=    '
                select      cast(''Month'' as varchar2(20))                                 as PERIOD_CATEGORY,
                            dp.YEAR_MONTH                                                   as PERIOD,
                            dp.LSOA11_CODE                                                  as LSOA_CODE,
                            ogm1.PARENT_ONS_CODE                                            as WARD_CODE,
                            cast(''Ward'' as varchar2(20))                                  as WARD_DESCR,
                            ogm2.PARENT_ONS_CODE                                            as LAD_CODE,
                            cast(''Local Authority'' as varchar2(20))                       as LAD_DESCR,
                            ogm3.PARENT_ONS_CODE                                            as REG_CODE,
                            cast(''Region'' as varchar2(20))                                as REG_DESCR,
                            ogm4.PARENT_ONS_CODE                                            as SICBL_CODE,
                            cast(''Sub-ICB'' as varchar2(20))                               as SICBL_DESCR,
                            ogm5.PARENT_ONS_CODE                                            as ICB_CODE,
                            cast(''ICB'' as varchar2(20))                                   as ICB_DESCR,
                            ogm6.PARENT_ONS_CODE                                            as NHSREG_CODE,
                            cast(''NHS Region'' as varchar2(20))                            as NHSREG_DESCR,
                            ogm7.PARENT_ONS_CODE                                            as COUNTRY_CODE,
                            cast(''National'' as varchar2(20))                              as COUNTRY_DESCR,
                            sum(ACCEPT_ADULTS) as ACCEPT_ADULTS,
                            sum(ACCEPT_ADULTS_FREE) as ACCEPT_ADULTS_FREE,
                            sum(ACCEPT_CHILDREN) as ACCEPT_CHILDREN,
                            sum(REFERRAL_ONLY) as REFERRAL_ONLY,
                            sum(NOT_UPDATED) as NOT_UPDATED,
                            sum(NOT_FOUND) as NOT_FOUND,
                            sum(UDA_PERF_TARGET) as UDA_PERF_TARGET,
                            sum(UDA_FIN_VAL) as UDA_FIN_VAL,
                            sum(UDA_DELIVERED) as UDA_DELIVERED,
                            sum(LATE_SUBMITTED_FP17) as LATE_SUBMITTED_FP17,
                            sum(UDA_DELIVERED_FD) as UDA_DELIVERED_FD,
                            sum(BAND_1_DELIVERED) as BAND_1_DELIVERED,
                            sum(BAND_2A_DELIVERED) as BAND_2A_DELIVERED,
                            sum(BAND_2B_DELIVERED) as BAND_2B_DELIVERED,
                            sum(BAND_2C_DELIVERED) as BAND_2C_DELIVERED,
                            sum(BAND_2C_DELIVERED) as BAND_2_DELIVERED,
                            sum(BAND_URGENT_DELIVERED) as BAND_URGENT_DELIVERED,
                            sum(BAND_OTHER_DELIVERED) as BAND_OTHER_DELIVERED,
                            sum(CHILD_12M_COUNT) as CHILD_12M_COUNT,
                            sum(ADULT_24M_COUNT) as ADULT_24M_COUNT,
                            sum(GENERAL_DENTAL_FIN_VALUE) as GENERAL_DENTAL_FIN_VALUE
                from        DENTAL_PRACTICES_ACCEPTING_NHS dp
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm1    on  dp.LSOA11_CODE          =   ogm1.CHILD_ONS_CODE
                                                                    and ogm1.RELATIONSHIP       =   ''LSOA11_WARD2023''
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm2    on  dp.LSOA11_CODE          =   ogm2.CHILD_ONS_CODE
                                                                    and ogm2.RELATIONSHIP       =   ''LSOA11_LAD2023''
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm3    on  dp.LSOA11_CODE          =   ogm3.CHILD_ONS_CODE
                                                                    and ogm3.RELATIONSHIP       =   ''LSOA11_REG2023''
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm4    on  dp.LSOA11_CODE          =   ogm4.CHILD_ONS_CODE
                                                                    and ogm4.RELATIONSHIP       =   ''LSOA11_SICBL2023''                                                    
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm5    on  dp.LSOA11_CODE          =   ogm5.CHILD_ONS_CODE
                                                                    and ogm5.RELATIONSHIP       =   ''LSOA11_ICB2023''
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm6    on  dp.LSOA11_CODE          =   ogm6.CHILD_ONS_CODE
                                                                    and ogm6.RELATIONSHIP       =   ''LSOA11_NHSREG2023''
                left join   DALL_REF.ONS_GEOGRAPHY_MAPPING  ogm7    on  dp.LSOA11_CODE          =   ogm7.CHILD_ONS_CODE
                                                                    and ogm7.RELATIONSHIP       =   ''LSOA11_ENGLAND''
                where       1=1
                    and     dp.YEAR_MONTH >= v_min_month
                    and     dp.YEAR_MONTH <= v_max_month
                group by    dp.YEAR_MONTH,
                            dp.LSOA11_CODE,
                            ogm1.PARENT_ONS_CODE,
                            ogm2.PARENT_ONS_CODE,
                            ogm3.PARENT_ONS_CODE,
                            ogm4.PARENT_ONS_CODE,
                            ogm5.PARENT_ONS_CODE,
                            ogm6.PARENT_ONS_CODE,
                            ogm7.PARENT_ONS_CODE
                ';

RETURN v_sql;

END;