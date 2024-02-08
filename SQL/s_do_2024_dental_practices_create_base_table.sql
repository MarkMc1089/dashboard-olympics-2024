/*
ERD: Create empty base table
Version 1.0

AMENDMENTS:
    2024-02-02  : Mark McPherson    : Initial script created
    yyyy-mm-dd  : name              : notes


DESCRIPTION:
    Creates an empty base table.
    Table will be populated via P_INT651_ERD_REFRESH.
    
DEPENDENCIES:
        F_INT651_ERD_BASE_POP       :   SQL macro function to return electronic Repeat Dispensing (eRD) data between two given months.
                                        A string to use for the metric code must be supplied also.

EXECUTION TIME:
    0s

*/

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

create table DO_2024_DENTAL_PRACTICES_BASE_POP as
select * 
from F_DO_2024_DENTAL_PRACTICES_BASE_POP(v_min_month => 190001, v_max_month => 999999);

--------------------SCRIPT END------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
