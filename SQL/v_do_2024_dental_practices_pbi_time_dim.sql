create or replace view V_DO_2024_DENTAL_PRACTICES_PBI_TIME_DIM as
/*
INT#651 Service Uptake Insights
Reference Table : Time Periods
Version 1.0

AMENDMENTS:
	2023-11-10  : Steven Buckley    : Initial script created
    date  : name    : details


DESCRIPTION:
    Reference table containing the time period information, such as formatted month string and calendar/financial years
    

DEPENDENCIES:
	DALL_REF.INT651_PBI_METRIC_DATA :   Data table to hold aggregated metric data for the PPC metrics in the Service Uptake Insight Dashboard
                                        
    DIM.YEAR_MONTH_DIM              :   Reference table containing atributes information linked to time periods

*/
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

select      dat.PERIOD_CATEGORY,
            dat.PERIOD,
            ymd.MONTH_IN_WORDS  as MONTH,
            ymd.CALENDAR_YEAR,
            ymd.FINANCIAL_YEAR
from        DO_2024_DENTAL_PRACTICES_PBI_METRIC_DATA dat
left join   DIM.YEAR_MONTH_DIM              ymd on  dat.PERIOD  =   ymd.YEAR_MONTH
group by    dat.PERIOD_CATEGORY,
            dat.PERIOD,
            ymd.MONTH_IN_WORDS,
            ymd.CALENDAR_YEAR,
            ymd.FINANCIAL_YEAR
order by    dat.PERIOD_CATEGORY,
            dat.PERIOD            
;

--------------------SCRIPT END------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------