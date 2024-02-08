create or replace procedure P_DO_2024_DENTAL_PRACTICES_REFRESH is
/*
INT651 Service Uptake Insight Dashboard
ERD Metric Data Refresh
Version 1.0

AMENDMENTS:
    2024-01-29  : Mark McPherson    : Initial script created
    2024-01-30  : Steven Buckley    : Suggested adjustments that would allow conditional updates
                                    :   Checks the latest data loaded and updates if additional months are available
    yyyy-mm-dd  : name              : notes


DESCRIPTION:
    Procedure script to refresh the ERD metric data for the Service Uptake Insight Dashboard

    Procedure will be scheduled to run on a monthly basis (6th day of the month should allow time for underlying tables to be updated)

    Script will:
        1)  Append latest month of data to DALL_REF.INT651_ERD_BASE_POP
        2)  Flush any data for ERD metrics from DALL_REF.INT651_STG_METRIC_DATA
        3)  Repopulate the ERD metric data in DALL_REF.INT651_STG_METRIC_DATA
        4)  Flush any data for ERD metrics from DALL_REF.INT651_PBI_METRIC_DATA
        5)  Repopulate the ERD metric data in DALL_REF.INT651_PBI_METRIC_DATA
        6)  Update the DALL_REF.DATA_UPDATE_LOG table to show latest refresh dates

DEPENDENCIES:
    DALL_REF.INT651_PBI_METRIC_DATA     :   Data table to hold final aggregated metric data for the ERD metrics in the Service Uptake Insight Dashboard
                                            INSERT and DELETE access required to clear/repopulate data table

    DALL_REF.DATA_UPDATE_LOG            :   Data table to track when data has been refreshed
                                            UPDATE acces required to update tracking record

    AML.PX_FORM_ITEM_ELEM_COMB_FACT     :   Low level prescribing data table containing NHS prescribing data
                                            Includes the patient and drug information for NHS prescriptions processed by NHSBSA

    DALL_REF.INT651_ERD_BASE_POP        :   Electronic Repeat Dispensing (eRD) and non-eRD LSOA-level counts
                                            Also contains the geographical and organisational hierarchies for each LSOA

    DALL_REF.F_INT651_METRIC_ERD01      :   SQL macro function to calculate aggregated metric data

    Required access to execute views/functions                                            
    DALP                        :   DIM.ONS_POSTCODE_DATA_DIM
                                    DALL_REF.ONS_IMD_RANK_AVG_SCORE_BY_AREA
                                    DALL_REF.ONS_GEOGRAPHY_MAPPING
                                    DIM.YEAR_MONTH_DIM
                                    DALL_REF.ONS_POPULATION

EXPECTED RUNTIME:
    Executed in ~2mins

*/

-----DECLARATIONS-------------------------------------------------------------------------------------------------------------------------------------
-- latest available prescription month
--        v_latest_pxmonth    NUMBER;
-- latest period loaded to base table
--        v_latest_period     NUMBER; 
-- define months to load (if any) based on existing and available data
--        v_update_required   BOOLEAN;
--        v_min_month         NUMBER;
--        v_max_month         NUMBER;


BEGIN

-----POPULATE VARIABLES-------------------------------------------------------------------------------------------------------------------------------
--        --populate the variables to identify if any data needs to be loaded
--        select max(YEAR_MONTH) into v_latest_pxmonth from AML.PX_FORM_ITEM_ELEM_COMB_FACT;
--        
--        -- latest period loaded to base table
--        select nvl(max(PERIOD),190001) into v_latest_period from DALL_REF.INT651_ERD_BASE_POP;
--
--        -- define months to load (if any) based on existing and available data
--        IF v_latest_period = 190001 THEN 
--            -- if no months have been loaded, pull data from 201804 to the latest available month
--            v_update_required := TRUE;
--            v_min_month := 201804;
--            v_max_month := v_latest_pxmonth;
--        ELSIF v_latest_period < v_latest_pxmonth THEN
--            -- if the latest loaded month is less than the latest available import the latest months that are required
--            v_update_required := TRUE;
--            select min(YEAR_MONTH) into v_min_month from AML.PX_FORM_ITEM_ELEM_COMB_FACT where YEAR_MONTH > v_latest_period and YEAR_MONTH > 201803;
--            v_max_month := v_latest_pxmonth;
--        ELSIF v_latest_period = v_latest_pxmonth THEN
--            -- if the latest loaded month matches the latest available then nothing new to import
--            v_update_required := FALSE;
--        ELSE
--            -- catch all, should never be reached
--            v_update_required := FALSE;
--        END IF; 

-----DATA LOAD AND UPDATE-----------------------------------------------------------------------------------------------------------------------------        
--    IF v_update_required = TRUE THEN
            -----ERD Base Table-----------------------------------------------------------------------------------------------------------------------
            execute immediate 'truncate table DO_2024_DENTAL_PRACTICES_BASE_POP'
            ;

            -- insert data for latest month, labelled with metric code 'ERD01'
            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_BASE_POP
                select  *
                from F_DO_2024_DENTAL_PRACTICES_BASE_POP(v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            -- update the tracking log
--            update  DALL_REF.DATA_UPDATE_LOG
--                set     LATEST_REFRESH  = sysdate
--                where   DATA_TABLE      = 'DALL_REF.INT651_ERD_BASE_POP'
--            ;
--            commit;

        -----ERD Metric Aggregation-------------------------------------------------------------------------------------------------------------------
            -- clear existing ERD metric data
            delete
                from    DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                where 1=1   
--                and   METRIC_CODE like 'ERD%'
            ;
            commit;

            -- populate the staging table with ERD metrics
--            insert /*+ append */ into DALL_REF.INT651_STG_METRIC_DATA select * from V_INT651_METRIC_ERD01;
--            commit;
            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'ACCEPT_ADULTS', v_metric_col => columns(ACCEPT_ADULTS), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'ACCEPT_ADULTS_FREE', v_metric_col => columns(ACCEPT_ADULTS_FREE), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'ACCEPT_CHILDREN', v_metric_col => columns(ACCEPT_CHILDREN), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'REFERRAL_ONLY', v_metric_col => columns(REFERRAL_ONLY), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'NOT_UPDATED', v_metric_col => columns(NOT_UPDATED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'NOT_FOUND', v_metric_col => columns(NOT_FOUND), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'UDA_PERF_TARGET', v_metric_col => columns(UDA_PERF_TARGET), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'UDA_FIN_VAL', v_metric_col => columns(UDA_FIN_VAL), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'UDA_DELIVERED', v_metric_col => columns(UDA_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'LATE_SUBMITTED_FP17', v_metric_col => columns(LATE_SUBMITTED_FP17), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'UDA_DELIVERED_FD', v_metric_col => columns(UDA_DELIVERED_FD), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_1_DELIVERED', v_metric_col => columns(BAND_1_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_2A_DELIVERED', v_metric_col => columns(BAND_2A_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_2B_DELIVERED', v_metric_col => columns(BAND_2B_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_2C_DELIVERED', v_metric_col => columns(BAND_2C_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_3_DELIVERED', v_metric_col => columns(BAND_3_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_URGENT_DELIVERED', v_metric_col => columns(BAND_URGENT_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'BAND_OTHER_DELIVERED', v_metric_col => columns(BAND_OTHER_DELIVERED), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'CHILD_12M_COUNT', v_metric_col => columns(CHILD_12M_COUNT), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'ADULT_24M_COUNT', v_metric_col => columns(ADULT_24M_COUNT), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_STG_METRIC_DATA
                select * from
                F_DO_2024_DENTAL_PRACTICES_METRIC(v_metric_code => 'GENERAL_DENTAL_FIN_VALUE', v_metric_col => columns(GENERAL_DENTAL_FIN_VALUE), v_min_month => 190001, v_max_month => 999999)
            ;
            commit;

            -- update the tracking log
--            update  DALL_REF.DATA_UPDATE_LOG
--                set     LATEST_REFRESH  = sysdate
--                where   DATA_TABLE      = 'DALL_REF.INT651_STG_METRIC_DATA'
--            ;
--            commit;

        -----ERD Metric Analysis----------------------------------------------------------------------------------------------------------------------
            -- clear existing ERD metric data
            delete
                from    DO_2024_DENTAL_PRACTICES_PBI_METRIC_DATA
                where   1=1
--                and     METRIC_CODE like 'CONTRACT%'
            ;
            commit;

            -- populate the metric table with ERD metrics
            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_PBI_METRIC_DATA
                select  * 
                from    V_DO_2024_DENTAL_PRACTICES_PBI_METRIC_DATA
                where 1=1
--                and   METRIC_CODE like 'ERD%'
            ;
            commit;

            -- update the tracking log
--            update  DALL_REF.DATA_UPDATE_LOG
--                set     LATEST_REFRESH  = sysdate
--                where   DATA_TABLE      = 'DALL_REF.INT651_PBI_METRIC_DATA'
--            ;
--            commit;

-----PPC Metric Analysis------------------------------------------------------------------------------------------------------------------------------
    --refresh the time period lookup by clearing and repopulating to ensure all months are captured
            delete
                from    DO_2024_DENTAL_PRACTICES_PBI_TIME_DIM
                where   1=1
            ;
            commit;
        
            insert /*+ append */ 
                into DO_2024_DENTAL_PRACTICES_PBI_TIME_DIM
                select  * 
                from    V_DO_2024_DENTAL_PRACTICES_PBI_TIME_DIM
            ;
            commit;

--    END IF;

END;
