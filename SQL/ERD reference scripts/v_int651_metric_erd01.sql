create or replace view V_INT651_METRIC_ERD01 as
/*
ERD01: eRD Counts Aggregation
Version 1.0

AMENDMENTS:
    2024-01-29  : Mark McPherson    : Initial script created
    2024-01-30  : Steven Buckley    : Suggested adjustments that would allow all geography areas to be captured regardless of activity
    yyyy-mm-dd  : name              : notes


DESCRIPTION:
    The base data table INT651_ERD_BASE_POP is aggregated on the geographical levels.

    Time Period:
        Will use all data present in the base table.
    
    Geographic areas:
        To support quick analysis this script will aggregate figures by a commonly used list of geographic areas to get totals for each.
        Mapping will be based on mappings published by ONS to link LSOA to parent geography areas including:
            WARD (2023 classification)
            LAD (2023 classification)
            REG (2023 classification)
            SICBL (2023 classification)
            ICB (2023 classification)
            NHSREG (2023 classification)
            ENGLAND

DEPENDENCIES:
        DALL_REF.INT651_ERD_BASE_POP            :   Electronic Repeat Dispensing (eRD) and non-eRD LSOA-level counts
                                                    Also contains the geographical and organisational hierarchies for each LSOA
        
        DALL_REF.ONS_GEOGRAPHY_MAPPING          :   Reference table for geographic mapping data sourced from ONS
                                                    Can be used to align a LSOA to a parent geography (e.g. LSOA to ICB...)

EXECUTION TIME:
    View used to populate data table in ~??mins (with 4 parallel)

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------


with
-----SECTION START: ERD METRIC AGGREGATION------------------------------------------------------------------------------------------------------------
-- aggregate the counts for all geographical levels
-- add metric values
erd as
(
select
    metric_code,
    period_category,
    period,
    coalesce(ward_descr, lad_descr, reg_descr, sicbl_descr, icb_descr, nhsreg_descr, country_descr) geo_category,
    coalesce(ward_code, lad_code, reg_code, sicbl_code, icb_code, nhsreg_code, country_code) geo_code,
    sum(numerator) numerator,
    sum(denominator) denominator,
    round(100 * sum(numerator) / sum(denominator), 2) value
from DALL_REF.INT651_ERD_BASE_POP
group by
    grouping sets(
        (metric_code, period_category, period, ward_descr, ward_code),
        (metric_code, period_category, period, lad_descr, lad_code),
        (metric_code, period_category, period, reg_descr, reg_code),
        (metric_code, period_category, period, sicbl_descr, sicbl_code),
        (metric_code, period_category, period, icb_descr, icb_code),
        (metric_code, period_category, period, nhsreg_descr, nhsreg_code),
        (metric_code, period_category, period, country_descr, country_code)
    )
)
-----SECTION END: ERD METRIC AGGREGATION--------------------------------------------------------------------------------------------------------------
,
-----SECTION START: PARENT MAPPING--------------------------------------------------------------------------------------------------------------------
-- isolate the relationships of interest, to use for mapping geo child to parent
ogm as
(
select      case
                when RELATIONSHIP = 'WARD2023_LAD2023'      then 'Ward'
                when RELATIONSHIP = 'LAD2023_REG2023'       then 'Local Authority'
                when RELATIONSHIP = 'REG2023_ENGLAND'       then 'Region'
                when RELATIONSHIP = 'SICBL2023_ICB2023'     then 'Sub-ICB'
                when RELATIONSHIP = 'ICB2023_NHSREG2023'    then 'ICB'
                when RELATIONSHIP = 'NHSREG2023_ENGLAND'    then 'NHS Region'
            end             as geo_category,
            child_ons_code  as geo_code, 
            parent_ons_code as parent_geo_code 
from        DALL_REF.ONS_GEOGRAPHY_MAPPING
where       relationship in (
                            'WARD2023_LAD2023',
                            'LAD2023_REG2023',
                            'REG2023_ENGLAND',
                            'SICBL2023_ICB2023',
                            'ICB2023_NHSREG2023',
                            'NHSREG2023_ENGLAND'
                            )
union all
select  distinct
            'National'  as geo_category,
            parent_ons_code,
            null as parent_geo_code
from        DALL_REF.ONS_GEOGRAPHY_MAPPING
where       relationship = 'NHSREG2023_ENGLAND'
)
-----SECTION END: PARENT MAPPING----------------------------------------------------------------------------------------------------------------------
,
-----SECTION START: IDENTIFY ALL POTENTIAL COMBINATIONS OF GEOGRAPHY AND METRIC DATA------------------------------------------------------------------
-- to prevent any potential gaps in the data we may want to include all combinations, even those without activity
-- this can prevent the end user selecting an area and not understanding why no results exist, a value of 0 at least signifies no activity
-- simply cross join all combinations of metric code and time period with the potential geographies
potential_reporting_combinations as
(
select      md.METRIC_CODE,
            md.PERIOD_CATEGORY,
            md.PERIOD,
            ogm.GEO_CATEGORY,
            ogm.GEO_CODE,
            ogm.PARENT_GEO_CODE
from        (
            select  distinct
                        METRIC_CODE,
                        PERIOD_CATEGORY,
                        PERIOD
            from        erd
            where       1=1
            )   md,
                ogm
)
-----SECTION END: IDENTIFY ALL POTENTIAL COMBINATIONS OF GEOGRAPHY AND METRIC DATA--------------------------------------------------------------------


-----OUTPUT-------------------------------------------------------------------------------------------------------------------------------------------
-- join the eRD data to get the values for each geography mapping
select      prc.metric_code,
            prc.period_category,
            prc.period,
            prc.geo_category,
            prc.geo_code,
            prc.parent_geo_code,
            nvl(lhs.numerator,0)    as numerator,
            nvl(lhs.denominator,0)  as denominator,
            nvl(lhs.value,0)        as value,
            nvl(rhs.value,0)        as parent_geo_value
from        potential_reporting_combinations    prc
left join   erd                                 lhs on  prc.geo_code        =   lhs.geo_code
                                                    and prc.metric_code     =   lhs.metric_code
                                                    and prc.period_category =   lhs.period_category
                                                    and prc.period          =   lhs.period
left join   erd                                 rhs on  prc.parent_geo_code =   rhs.geo_code
                                                    and prc.metric_code     =   rhs.metric_code
                                                    and prc.period_category =   rhs.period_category
                                                    and prc.period          =   rhs.period
;
--------------------SCRIPT END------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
