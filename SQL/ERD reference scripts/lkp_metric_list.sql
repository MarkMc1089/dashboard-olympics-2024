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

--drop table int651_pbi_metric_list;
--create table int651_pbi_metric_list compress for query high as

--truncate table int651_pbi_metric_list;
--insert /*+ append */ into int651_pbi_metric_list

------------------------------------------------------------------------------------------------------------------------------------------------------
-----PPC Metrics--------------------------------------------------------------------------------------------------------------------------------------

    select      'PPC'       as SERVICE_AREA,
                'PPC01'     as METRIC_CODE,
                'No. of applications received'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count of applications received for PPC certificates'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'PPC'       as SERVICE_AREA,
                'PPC02'     as METRIC_CODE,
                'No. of certificates issued'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of PPC certificates issued to customers'   as METHODOLOGY,
                'Will include certificates that may have been subsequently cancelled, either by the customer or by the NHSBSA in cases of payment default.'   as NOTES
    from        dual
union all
    select      'PPC'       as SERVICE_AREA,
                'PPC03'     as METRIC_CODE,
                'No. of people with active certificates'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of individuals where a certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...).'   as NOTES
    from        dual
union all
    select      'PPC'       as SERVICE_AREA,
                'PPC04'     as METRIC_CODE,
                'No. of applications received per 10000 population aged 16-59'   as METRIC,
                'Count of applications received for PPC certificates'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may be in receipt or qualify for other prescription charge exemptions which would negate the need to purchase a PPC.  Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'PPC'       as SERVICE_AREA,
                'PPC05'     as METRIC_CODE,
                'No. of certificates issued per 10000 population aged 16-59'   as METRIC,
                'Count of PPC certificates issued to customers'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may be in receipt or qualify for other prescription charge exemptions which would negate the need to purchase a PPC.  Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'PPC'       as SERVICE_AREA,
                'PPC06'     as METRIC_CODE,
                'No. of people with active certificates per 10000 population aged 16-59'   as METRIC,
                'Count of individuals where a certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...). Base population will include individuals that may be in receipt or qualify for other prescription charge exemptions which would negate the need to purchase a PPC.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
-----PPC Metrics--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
-----NHS Low Income Scheme Metrics--------------------------------------------------------------------------------------------------------------------
union all
    select      'LIS'   as SERVICE_AREA,
                'LIS01' as METRIC_CODE,
                'No. of applications received'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of applications received for support via the NHS Low Income Scheme'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'LIS'   as SERVICE_AREA,
                'LIS02' as METRIC_CODE,
                'No. of certificates issued'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of HC2/HC3 certificates issued'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'LIS'   as SERVICE_AREA,
                'LIS03' as METRIC_CODE,
                'No. of people with active certificates'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of individuals where a HC2/HC3 certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...).'   as NOTES
    from        dual
union all
    select      'LIS'       as SERVICE_AREA,
                'LIS04'     as METRIC_CODE,
                'No. of applications received per 10000 population aged 16+'   as METRIC,
                'Count of applications received for support via the NHS Low Income Scheme'   as NUMERATOR,
                'Population aged 16+, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'LIS'       as SERVICE_AREA,
                'LIS05'     as METRIC_CODE,
                'No. of certificates issued per 10000 population aged 16+'   as METRIC,
                'Count of HC2/HC3 certificates issued'   as NUMERATOR,
                'Population aged 16+, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'LIS'       as SERVICE_AREA,
                'LIS06'     as METRIC_CODE,
                'No. of people with active certificates per 10000 population aged 16+'   as METRIC,
                'Count of individuals where a HC2/HC3 certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as NUMERATOR,
                'Population aged 16+, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...). Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
-----NHS Low Income Scheme Metrics--------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
-----Medical Exemption Scheme Metrics-----------------------------------------------------------------------------------------------------------------
union all
    select      'MED'   as SERVICE_AREA,
                'MED01' as METRIC_CODE,
                'No. of applications received'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of applications received for medical exemption certificates'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'MED'   as SERVICE_AREA,
                'MED02' as METRIC_CODE,
                'No. of certificates issued'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of medical exemption certificates issued'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'MED'   as SERVICE_AREA,
                'MED03' as METRIC_CODE,
                'No. of people with active certificates'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of individuals where a medical exemption certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...).'   as NOTES
    from        dual
union all
    select      'MED'       as SERVICE_AREA,
                'MED04'     as METRIC_CODE,
                'No. of applications received per 10000 population aged 16-59'   as METRIC,
                'Count of applications received for medical exemption certificates'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'MED'       as SERVICE_AREA,
                'MED05'     as METRIC_CODE,
                'No. of certificates issued per 10000 population aged 16-59'   as METRIC,
                'Count of medical exemption certificates issued'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'MED'       as SERVICE_AREA,
                'MED06'     as METRIC_CODE,
                'No. of people with active certificates per 10000 population aged 16-59'   as METRIC,
                'Count of individuals where a medical exemption certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as NUMERATOR,
                'Population aged 16-59, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...). Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
-----Medical Exemption Scheme Metrics-----------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
-----Maternity Exemption Scheme Metrics-----------------------------------------------------------------------------------------------------------------
union all
    select      'MAT'   as SERVICE_AREA,
                'MAT01' as METRIC_CODE,
                'No. of applications received'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of applications received for maternity exemption certificates'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'MAT'   as SERVICE_AREA,
                'MAT02' as METRIC_CODE,
                'No. of certificates issued'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of maternity exemption certificates issued'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'MAT'   as SERVICE_AREA,
                'MAT03' as METRIC_CODE,
                'No. of people with active certificates'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of individuals where a maternity exemption certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...).'   as NOTES
    from        dual
union all
    select      'MAT'       as SERVICE_AREA,
                'MAT04'     as METRIC_CODE,
                'No. of applications received per 10000 female population aged 15-45'   as METRIC,
                'Count of applications received for maternity exemption certificates'   as NUMERATOR,
                'Female population aged 15-45, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'MAT'       as SERVICE_AREA,
                'MAT05'     as METRIC_CODE,
                'No. of certificates issued per 10000 female population aged 15-45'   as METRIC,
                'Count of maternity exemption certificates issued'   as NUMERATOR,
                'Female population aged 15-45, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
union all
    select      'MAT'       as SERVICE_AREA,
                'MAT06'     as METRIC_CODE,
                'No. of people with active certificates per 10000 female population aged 15-45'   as METRIC,
                'Count of individuals where a maternity exemption certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as NUMERATOR,
                'Female population aged 15-45, based on population estimates published by ONS.'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...). Base population will include individuals that may not be eligible for support due to not meeting qualifying criteria.   Population figures are published on a delayed schedule and therefore the most appropriate and latest available data will be used: for example for months in 2020 the 2020 population estimates are used but may also be applied to months for 2021 and 2022 until updated figures are released.'   as NOTES
    from        dual
-----Maternity Exemption Scheme Metrics---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
-----HRT PPC Metrics----------------------------------------------------------------------------------------------------------------------------------
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC01'      as METRIC_CODE,
                'No. of applications received'   as METRIC,
                'n/a'       as NUMERATOR,
                'n/a'       as DENOMINATOR,
                'Count of applications received for HRT-PPC certificates'   as METHODOLOGY,
                'n/a'   as NOTES
    from        dual
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC02'      as METRIC_CODE,
                'No. of certificates issued'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of HRT-PPC certificates issued to customers'   as METHODOLOGY,
                'Will include certificates that may have been subsequently cancelled, either by the customer or by the NHSBSA.'   as NOTES
    from        dual
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC03'      as METRIC_CODE,
                'No. of people with active certificates'   as METRIC,
                'n/a'   as NUMERATOR,
                'n/a'   as DENOMINATOR,
                'Count of individuals where a HRT-PPC certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...).'   as NOTES
    from        dual
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC04'      as METRIC_CODE,
                'No. of applications received per 10000 patients aged 16-59 receiving HRT medication'   as METRIC,
                'Count of applications received for HRT-PPC certificates'   as NUMERATOR,
                'Patients aged 16-59 receiving NHS prescribing of qualifying HRT medication in the previous 12 month period'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may be in receipt of, or qualify for, other prescription charge exemptions which would negate the need to purchase a HRT-PPC.'   as NOTES
    from        dual
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC05'      as METRIC_CODE,
                'No. of certificates issued per 10000 patients aged 16-59 receiving HRT medication'   as METRIC,
                'Count of HRT-PPC certificates issued to customers'   as NUMERATOR,
                'Patients aged 16-59 receiving NHS prescribing of qualifying HRT medication in the previous 12 month period'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Base population will include individuals that may be in receipt of, or qualify for, other prescription charge exemptions which would negate the need to purchase a HRT-PPC.'   as NOTES
    from        dual
union all
    select      'HRT-PPC'       as SERVICE_AREA,
                'HRTPPC06'      as METRIC_CODE,
                'No. of people with active certificates per 10000 patients aged 16-59 receiving HRT medication'   as METRIC,
                'Count of individuals where a HRT-PPC certificate was issued where the start and expiry date covers one or more days in the reporting period.'   as NUMERATOR,
                'Patients aged 16-59 receiving NHS prescribing of qualifying HRT medication in the previous 12 month period'   as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Individuals identified based on a combination of personal information and therefore some individuals could be counted twice if they provided different personal information across multiple applications. Some individuals could share a "unique id" where their personal information is very similar (e.g same DOB, similar name/address ...). Base population will include individuals that may be in receipt of, or qualify for, other prescription charge exemptions which would negate the need to purchase a HRT-PPC.'   as NOTES
    from        dual
-----HRT PPC Metrics----------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


-----Optimum PPC Savings Metrics----------------------------------------------------------------------------------------------------------------------
union all
    select      'OPT-PPC'       as SERVICE_AREA,
                'OPTPPC01'      as METRIC_CODE,
                'Patient missing out on savings via PPC'   as METRIC,
                'No. of patients who could have saved money in previous 12 months by purchasing PPCs.'       as NUMERATOR,
                'No. of patients identified as paying for NHS prescriptions in the previous 12 months.'       as DENOMINATOR,
                'Numerator / Denominator * 10000'   as METHODOLOGY,
                'Based on patients with some prescription charge activity identified where a PPC could have been purchased to save some money. Prescription charge information is based on information declared by patients/pharmacies and submitted to NHSBSA for processing. Where no prescription charge or charge exemption declaration is submitted, the default assumption is that the patient paid for prescription items dispensed. Estimated savings based on aggregated monthly activity and therefore may differ from actual savings based on precise dates of dispensing activity. Based on these data quality issues, figures may over-estimate the true number of individuals who could have saved money. '   as NOTES
    from        dual

-----Optimum PPC Savings Metrics----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
-----ERD Metrics--------------------------------------------------------------------------------------------------------------------------------------
union all
    select      'ERD'                                                  as SERVICE_AREA,
                'ERD01'                                                as METRIC_CODE,
                'Percentage of all prescription items supplied as eRD' as METRIC,
                'Number of eRD prescription items'                     as NUMERATOR,
                'Number of prescription items (all prescribing types)' as DENOMINATOR,
                'Numerator / Denominator * 100'                        as METHODOLOGY,
                'Restricted to NHS prescription items processed and reimbursed by NHSBSA. Geography mapping based on the location of the prescribing account, limited to English prescribing accounts.' as NOTES
    from        dual
-----ERD Metrics--------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------SCRIPT END-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------