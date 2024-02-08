create or replace view V_INT651_PBI_GEOGRAPHY_MAPPING as
/*
INT#651 Service Uptake Insights
Reference Table : Geography Mapping
Version 1.0

AMENDMENTS:
	2023-11-10  : Steven Buckley    : Initial script created
    2024-01-11  : Steven Buckley    : Amended geography mapping to latest available
                                    : Converted script to view to allow easy refresh of base table
    date  : name    : details


DESCRIPTION:
    Reference table containing the geography mapping data to be used within the report, allowing only codes to be included in metric data
    
    Consistent mapping should be applied to all metrics.


DEPENDENCIES:
	DALL_REF.ONS_GEOGRAPHY_MAPPING  :   Reference table containing geographic mapping extracted from ONS published relationship data

*/
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

--use available mappings to get child and parent geography mappings
select      case
                when RELATIONSHIP = 'WARD2023_LAD2023'      then 'Ward'
                when RELATIONSHIP = 'LAD2023_REG2023'       then 'Local Authority'
                when RELATIONSHIP = 'REG2023_ENGLAND'       then 'Region'
                when RELATIONSHIP = 'SICBL2023_ICB2023'     then 'Sub-ICB'
                when RELATIONSHIP = 'ICB2023_NHSREG2023'    then 'ICB'
                when RELATIONSHIP = 'NHSREG2023_ENGLAND'    then 'NHS Region'
            end                 as GEO_CATEGORY,
            CHILD_ONS_CODE      as GEO_CODE,
            CHILD_NAME          as GEO_NAME,
            CHILD_GEOGRAPHY     as GEO_CLASSIFICATION,
            PARENT_ONS_CODE     as PARENT_GEO_CODE,
            PARENT_NAME         as PARENT_GEO_NAME,
            PARENT_GEOGRAPHY    as PARENT_GEO_CLASSIFICATION
from        DALL_REF.ONS_GEOGRAPHY_MAPPING
where       1=1
    and     RELATIONSHIP in     (
                                'WARD2023_LAD2023',
                                'LAD2023_REG2023',
                                'REG2023_ENGLAND',
                                'SICBL2023_ICB2023',
                                'ICB2023_NHSREG2023',
                                'NHSREG2023_ENGLAND'
                                )
    and     CHILD_ONS_CODE like 'E%'

union all
--manually create England geography as no mapping exists
select      'National'  as GEO_CATEGORY, 
            'E92000001' as GEO_CODE, 
            'England'   as GEO_NAME, 
            'ENGLAND'   as GEO_CLASSIFICATION, 
            null        as PARENT_GEO_CODE, 
            null        as PARENT_GEO_NAME, 
            null        as PARENT_GEO_CLASSIFICATION
from        dual
;

--------------------SCRIPT END------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------