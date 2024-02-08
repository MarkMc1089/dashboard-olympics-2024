create or replace FUNCTION F_DO_2024_DENTAL_PRACTICES_METRIC(
  v_metric_code       in varchar2,
  v_metric_col        in dbms_tf.columns_t,
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
                with
                -----SECTION START: ERD METRIC AGGREGATION------------------------------------------------------------------------------------------------------------
                -- aggregate the counts for all geographical levels
                -- add metric values
                dp as
                (
                select
--                    cast(v_metric_code as varchar2(20))                             as METRIC_CODE,
                    PERIOD_CATEGORY,
                    PERIOD,
                    coalesce(WARD_DESCR, LAD_DESCR, REG_DESCR, SICBL_DESCR, ICB_DESCR, NHSREG_DESCR, COUNTRY_DESCR) GEO_CATEGORY,
                    coalesce(WARD_CODE, LAD_CODE, REG_CODE, SICBL_CODE, ICB_CODE, NHSREG_CODE, COUNTRY_CODE) GEO_CODE,
                    sum(base.'||v_metric_col(1)||') as VALUE
                from DO_2024_DENTAL_PRACTICES_BASE_POP base
                group by
                    grouping sets(
                        (PERIOD_CATEGORY, PERIOD, WARD_DESCR, WARD_CODE),
                        (PERIOD_CATEGORY, PERIOD, LAD_DESCR, LAD_CODE),
                        (PERIOD_CATEGORY, PERIOD, REG_DESCR, REG_CODE),
                        (PERIOD_CATEGORY, PERIOD, SICBL_DESCR, SICBL_CODE),
                        (PERIOD_CATEGORY, PERIOD, ICB_DESCR, ICB_CODE),
                        (PERIOD_CATEGORY, PERIOD, NHSREG_DESCR, NHSREG_CODE),
                        (PERIOD_CATEGORY, PERIOD, COUNTRY_DESCR, COUNTRY_CODE)
                    )
                )
                -----SECTION END: ERD METRIC AGGREGATION--------------------------------------------------------------------------------------------------------------
                ,
                -----SECTION START: PARENT MAPPING--------------------------------------------------------------------------------------------------------------------
                -- isolate the relationships of interest, to use for mapping geo child to parent
                ogm as
                (
                select      case
                                when RELATIONSHIP = ''WARD2023_LAD2023''      then ''Ward''
                                when RELATIONSHIP = ''LAD2023_REG2023''       then ''Local Authority''
                                when RELATIONSHIP = ''REG2023_ENGLAND''       then ''Region''
                                when RELATIONSHIP = ''SICBL2023_ICB2023''     then ''Sub-ICB''
                                when RELATIONSHIP = ''ICB2023_NHSREG2023''    then ''ICB''
                                when RELATIONSHIP = ''NHSREG2023_ENGLAND''    then ''NHS Region''
                            end             as GEO_CATEGORY,
                            CHILD_ONS_CODE  as GEO_CODE, 
                            PARENT_ONS_CODE as PARENT_GEO_CODE 
                from        DALL_REF.ONS_GEOGRAPHY_MAPPING
                where       RELATIONSHIP in (
                                            ''WARD2023_LAD2023'',
                                            ''LAD2023_REG2023'',
                                            ''REG2023_ENGLAND'',
                                            ''SICBL2023_ICB2023'',
                                            ''ICB2023_NHSREG2023'',
                                            ''NHSREG2023_ENGLAND''
                                            )
                union all
                select  distinct
                            ''National''  as GEO_CATEGORY,
                            PARENT_ONS_CODE,
                            null as PARENT_GEO_CODE
                from        DALL_REF.ONS_GEOGRAPHY_MAPPING
                where       RELATIONSHIP = ''NHSREG2023_ENGLAND''
                )
                -----SECTION END: PARENT MAPPING----------------------------------------------------------------------------------------------------------------------
                ,
                -----SECTION START: IDENTIFY ALL POTENTIAL COMBINATIONS OF GEOGRAPHY AND METRIC DATA------------------------------------------------------------------
                -- to prevent any potential gaps in the data we may want to include all combinations, even those without activity
                -- this can prevent the end user selecting an area and not understanding why no results exist, a value of 0 at least signifies no activity
                -- simply cross join all combinations of metric code and time period with the potential geographies
                potential_reporting_combinations as
                (
                select      --md.METRIC_CODE,
                            md.PERIOD_CATEGORY,
                            md.PERIOD,
                            ogm.GEO_CATEGORY,
                            ogm.GEO_CODE,
                            ogm.PARENT_GEO_CODE
                from        (
                            select  distinct
                                        --METRIC_CODE,
                                        PERIOD_CATEGORY,
                                        PERIOD
                            from        dp
                            where       1=1
                            )   md,
                                ogm
                )
                -----SECTION END: IDENTIFY ALL POTENTIAL COMBINATIONS OF GEOGRAPHY AND METRIC DATA--------------------------------------------------------------------
                
                
                -----OUTPUT-------------------------------------------------------------------------------------------------------------------------------------------
                -- join the eRD data to get the values for each geography mapping
                select      --prc.METRIC_CODE,
                            cast(v_metric_code as varchar2(20))                             as METRIC_CODE,
                            prc.PERIOD_CATEGORY,
                            prc.PERIOD,
                            prc.GEO_CATEGORY,
                            prc.GEO_CODE,
                            prc.PARENT_GEO_CODE,
                            0 as NUMERATOR,
                            0 AS DENOMINATOR,
                            nvl(lhs.VALUE,0)        as VALUE,
                            nvl(rhs.VALUE,0)        as PARENT_GEO_VALUE
                from        potential_reporting_combinations    prc
                left join   dp                                 lhs on  prc.GEO_CODE        =   lhs.GEO_CODE
                                                                    --and prc.METRIC_CODE     =   lhs.METRIC_CODE
                                                                    and prc.PERIOD_CATEGORY =   lhs.PERIOD_CATEGORY
                                                                    and prc.PERIOD          =   lhs.PERIOD
                left join   dp                                 rhs on  prc.PARENT_GEO_CODE =   rhs.GEO_CODE
                                                                    --and prc.METRIC_CODE     =   rhs.METRIC_CODE
                                                                    and prc.PERIOD_CATEGORY =   rhs.PERIOD_CATEGORY
                                                                    and prc.PERIOD          =   rhs.PERIOD
                
                
                ';

RETURN v_sql;

END;


