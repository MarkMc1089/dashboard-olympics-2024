create or replace view V_INT651_PBI_METRIC_DATA as 
/*
INT651 Service Uptake Insight Dashboard
Add analysis to metric data
Version 1.0

AMENDMENTS:
	2023-11-15  : Steven Buckley    : Initial script created
    date  : name    : details


DESCRIPTION:
    The Service Uptake Insight Dashboard will highlight some key metrics across a range of service areas.
    
    This script will create a view that can be used to extend the basic metric data with additional analysis.
        Allowing common analysis for all metrics to be handled in one query rather than being added to each metric code.
        This should also allow performance improvements as analysis will be based on a smaller set of data.
    
    To support the rank functions the values in the STG table will not be rounded so more granular data is available for ranking
        Rounding will be applied in this script.   
    
    For each metric record (metric/month/geography) the following fields will be calculated:
        COMPOSITE_LINK      :   Create a composite field based on METRIC_CODE-PERIOD-GEO_CODE
                                This will allow child records to be identified for a selection COMPOSITE_LINK = COMPOSITE_LINK_PRNT     
        
        COMPOSITE_LINK_PRNT :   Create a composite field based on METRIC_CODE-PERIOD-PARENT_GEO_CODE
                                This will allow peers to be joined where they share a COMPOSITE_LINK_PRNT (geographies with the same parent geography)
        
        VAL_CHANGE_MONTH    :   Change in metric value based on the previous month's value
                                Metric data should be captured so that all months are included, even where no metric value was available
        
        VAL_CHANGE_YEAR     :   Change in metric value based on the previous years value (same month previous year)
                                Metric data should be captured so that all months are included, even where no metric value was available
        
        RANK_OVR            :   Ranking for the metric value (within month) in comparision to all areas within the same geography type
                                Ranks will be based on metric value descending (highest value = 1)
                                Data should be captured as a string value in format (RANK / NUM_OF_AREAS)
        
        RANK_PRNT           :   Ranking for the metric value (within month) in comparision to only areas that share the same parent geography
                                Ranks will be based on metric value descending (highest value = 1)
                                Data should be captured as a string value in format (RANK / NUM_OF_AREAS_WITH_SAME_PARENT)


DEPENDENCIES:
	DALP
        DALL_REF.INT651_STG_METRIC_DATA     :   Staging table created to hold all metric data for the Service Uptake Insight dashboard
                                            :   Each record in the dataset will represent the data for a combination of metric/month/geography

ESTIMATED RUNTIME:
    Full output used to populate table in 51s
*/

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

select      METRIC_CODE,
            PERIOD_CATEGORY,
            PERIOD,
            GEO_CATEGORY,
            GEO_CODE,
            PARENT_GEO_CODE,
            round(NUMERATOR,0)          as NUMERATOR,
            round(DENOMINATOR,0)        as DENOMINATOR,
            round(VALUE,0)              as VALUE,
            round(PARENT_GEO_VALUE,0)   as PARENT_GEO_VALUE,
        --composite link field based on metric, period and geography-----------------------------------------
            METRIC_CODE||'-'||PERIOD||'-'||GEO_CODE                             as COMPOSITE_LINK,
        --composite link field based on metric, period and parent geography----------------------------------
            METRIC_CODE||'-'||PERIOD||'-'||PARENT_GEO_CODE                      as COMPOSITE_LINK_PRNT,
        --change in value v previous month-------------------------------------------------------------------
            round(VALUE,0) - lag(round(VALUE,0)) 
                                over    (
                                        partition by    METRIC_CODE,
                                                        GEO_CATEGORY,
                                                        PERIOD_CATEGORY,
                                                        GEO_CODE
                                        order by        PERIOD
                                        )                                       as VAL_CHANGE_MONTH,
        --change in value v previous year--------------------------------------------------------------------
            round(VALUE,0) - lag(round(VALUE,0),12) 
                                over    (
                                        partition by    METRIC_CODE,
                                                        GEO_CATEGORY,
                                                        PERIOD_CATEGORY,
                                                        GEO_CODE
                                        order by        PERIOD
                                        )                                       as VAL_CHANGE_YEAR,
        --rank in relation to all other areas----------------------------------------------------------------
            to_char(rank() over (
                                partition by    METRIC_CODE,
                                                GEO_CATEGORY,
                                                PERIOD_CATEGORY,
                                                PERIOD 
                                order by        VALUE desc
            ))||'/'||
            to_char(count(GEO_CODE) over    (
                                            partition by    METRIC_CODE,
                                                            GEO_CATEGORY,
                                                            PERIOD_CATEGORY,
                                                            PERIOD
                                            )
            )                                                                   as RANK_OVR,
        --rank in relation to areas sharing a parent---------------------------------------------------------
            to_char(rank() over (
                                partition by    METRIC_CODE,
                                                GEO_CATEGORY,
                                                PARENT_GEO_CODE,
                                                PERIOD_CATEGORY,
                                                PERIOD 
                                order by        VALUE desc
            ))||'/'||
            to_char(count(GEO_CODE) over    (
                                            partition by    METRIC_CODE,
                                                            GEO_CATEGORY,
                                                            PARENT_GEO_CODE,
                                                            PERIOD_CATEGORY,
                                                            PERIOD
                                            )
            )                                                                   as RANK_PRNT
from        DALL_REF.INT651_STG_METRIC_DATA
;

--------------------SCRIPT END------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------