/*
INT#651 Service Uptake Insights
Reference Table : Metric Specifications
Version 1.1

AMENDMENTS:
	2023-11-10  : Steven Buckley    : Initial script created
	2024-01-31  : Mark McPherson    : Added ERD
	date  : name    : details


DESCRIPTION:
    Details for reference table containing the metric specifications for each of the metrics to be included in the dashboard
    
    select      'xxx'   as SERVICE_AREA,
                'xxx'   as METRIC_CODE,
                'xxx'   as METRIC,
                'xxx'   as NUMERATOR,
                'xxx'   as DENOMINATOR,
                'xxx'   as METHODOLOGY,
                'xxx'   as NOTES
    from        dual


DEPENDENCIES:
	N/A

*/
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------SCRIPT START----------------------------------------------------------------------------------------------------------------------

--drop table do_2024_dental_practices_pbi_metric_list;
create table do_2024_dental_practices_pbi_metric_list compress for query high as

--truncate table do_2024_dental_practices_pbi_metric_list;
--insert /*+ append */ into do_2024_dental_practices_pbi_metric_list

------------------------------------------------------------------------------------------------------------------------------------------------------
-----PPC Metrics--------------------------------------------------------------------------------------------------------------------------------------

    select      'Dental Contracts'       as SERVICE_AREA,
                'UDA_PERF_TARGET'     as METRIC_CODE,
                'Total contracted UDA'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Sum'   as METHODOLOGY,
                'The contracted units of dental activity (UDA) to be achieved for the year, as entered on CoMPASS by the commissioner.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'UDA_FIN_VAL'     as METRIC_CODE,
                'Total UDA financial value'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Sum'   as METHODOLOGY,
                'The financial value associated with the UDA performance target for the financial year, as entered by the commissioner.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'UDA_DELIVERED'     as METRIC_CODE,
                'Total UDA delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'The units of dental activity for the month attributed to the FP17s for the treatment provided. Please note that this excludes the UDA from Foundation Dentists.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'LATE_SUBMITTED_FP17'     as METRIC_CODE,
                'Count of late submitted FP17s'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of late submitted FP17s. Late is defined as FP17s where the treatment was completed and the time between receipt at NHS Dental Services and date of completion of treatment was greater than two months (62 days).'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'UDA_DELIVERED_FD'     as METRIC_CODE,
                'Total UDA delivered by Foundation Dentists'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'The units of dental activity for the month delivered by Foundation Dentists.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_1_DELIVERED'     as METRIC_CODE,
                'Total Band 1 FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 1 treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_2A_DELIVERED'     as METRIC_CODE,
                'Total Band 2A FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 2A treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_2B_DELIVERED'     as METRIC_CODE,
                'Total Band 2B FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 2B treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_2C_DELIVERED'     as METRIC_CODE,
                'Total Band 2C FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 2C treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_3_DELIVERED'     as METRIC_CODE,
                'Total Band 3 FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 3 treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_URGENT_DELIVERED'     as METRIC_CODE,
                'Total Band Urgent FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for a Band 1 Urgent treatment. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'BAND_OTHER_DELIVERED'     as METRIC_CODE,
                'Total Band Other FP17s delivered'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'This is a count of the number of FP17s which were for non-Banded treatment. This includes the following treatments: Prescription Only, Denture Repairs, Bridge Repairs, Arrest of Bleeding or Removal of Sutures. This is based on the Treatment Category as recorded in part 5 of the FP17.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'CHILD_12M_COUNT'     as METRIC_CODE,
                'Child patients seen in previous 12 months'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'A measure, which describes the number of child patients (less than 18 years old on the last day of the period) seen in the previous 12 months. The measure provides a count of the number of distinct patient identities scheduled during the last 12 months. This metric is an indication of the number of unique patients that are considered NHS patients. Each unique patient ID is counted against the dentist contract against which the most recent form was recorded in the 12 month period, with the following exceptions. If the most recent form is for urgent treatment, orthodontic treatment, free treatment or treatment on referral the ID remains with the previous contract, if there is one within the 12 month period. If the form for the previous contract occurred before the 12 month period the ID is allocated to the most recent contract. It is used due to NICE guidelines which recommended that the longest interval between oral reviews (for an child) should be 12 months. Therefore dental attendance is now measured by the number and proportion of patients who have attended a dentist within the previous 12 months.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'ADULT_24M_COUNT'     as METRIC_CODE,
                'Adult patients seen in previous 24 months'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'A measure, which describes the number of adult patients (18 years or over on the last day of the period) seen in the previous 24 months. An adult is defined as a patient aged 18 or over at the date of acceptance. The measure provides a count of the number of distinct patient identities scheduled during the last 24 months. This metric is an indication of the number of unique patients that are considered NHS patients. Each unique patient ID is counted against the dentist contract against which the most recent form was recorded in the 24 month period, with the following exceptions. If the most recent form is for urgent treatment, orthodontic treatment, free treatment or treatment on referral the ID remains with the previous contract, if there is one within the 24 month period. If the form for the previous contract occurred before the 24 month period the ID is allocated to the most recent contract. It is used due to NICE guidelines which recommended that the longest interval between oral reviews (for an adult) should be 24 months. Therefore dental attendance is now measured by the number and proportion of patients who have attended a dentist within the previous 24 months.'   as NOTES
    from        dual
union all
    select      'Dental Contracts'       as SERVICE_AREA,
                'GENERAL_DENTAL_FIN_VALUE'     as METRIC_CODE,
                'Total General Dental Financial Value'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Sum'   as METHODOLOGY,
                'The financial value associated with the High Street Dental Practice service line for the financial year, as entered on CoMPASS by the PCO. In effect, this is the total financial value associated with the contract for providing NHS general dentistry.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'ACCEPT_ADULTS'     as METRIC_CODE,
                'Count of practices accepting new adult NHS patients'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices accepting adults 18 and over. Acceptance status is taken from the Find a Dentist service at https://www.nhs.uk/service-search/find-a-dentist.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'ACCEPT_ADULTS_FREE'     as METRIC_CODE,
                'Count of practices accepting new adult NHS patients entitled to free dental care'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices accepting adults entitled to free dental care. Acceptance status is taken from the Find a Dentist service at https://www.nhs.uk/service-search/find-a-dentist.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'ACCEPT_CHILDREN'     as METRIC_CODE,
                'Count of practices accepting new child (under-18s) NHS patients'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices accepting children aged 17 or under. Acceptance status is taken from the Find a Dentist service at https://www.nhs.uk/service-search/find-a-dentist.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'REFERRAL_ONLY'     as METRIC_CODE,
                'Count of practices accepting referrals only'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices only taking new NHS patients for specialist dental care by referral. Acceptance status is taken from the Find a Dentist service at https://www.nhs.uk/service-search/find-a-dentist.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'NOT_UPDATED'     as METRIC_CODE,
                'Count of practices with no update in past 90 days'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices which have not updated NHS patient acceptance in the last 90 days. Acceptance status is taken from the Find a Dentist service at https://www.nhs.uk/service-search/find-a-dentist.'   as NOTES
    from        dual
union all
    select      'NHS Patient Acceptance'       as SERVICE_AREA,
                'NOT_FOUND'     as METRIC_CODE,
                'Count of practices which could not be linked to ODP data'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count'   as METHODOLOGY,
                'Count of practices for which ODS code could not be determined. To find NHS patient acceptance criteria, the ODS code is required.'   as NOTES
    from        dual
-----PPC Metrics--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------