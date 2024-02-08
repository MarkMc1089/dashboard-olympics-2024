shelf(
  tidyverse,
  purrr,
  nhsbsaR
)

dp_files <- list.files("data", pattern = "uda_contractor_[0-9]{6}.csv", full.names = TRUE)

nhs_accept_data <- read.csv("data/dental_practice_accepting_nhs_px.csv") %>% 
  select(-c(year_month, starts_with("postcode")))

dp_data  <- map_dfr(dp_files, read.csv) %>% 
  left_join(
    nhs_accept_data %>% 
      select(-name_odp),
    join_by(CONTRACT_NUMBER == id)
  ) %>% 
  rename_with(toupper) %>% 
  select(
    YEAR_MONTH,
    CONTRACT_NUMBER,
    ODS,
    NAME_ODP = PROVIDER_NAME,
    NAME_ODS,
    POSTCODE = LATEST_PPC_ADDRESS_POSTCODE,
    everything(),
    ACCEPT_ADULTS,
    ACCEPT_ADULTS_FREE,
    ACCEPT_CHILDREN,
    REFERRAL_ONLY,
    NOT_UPDATED,
    NOT_FOUND,
    PROVIDER_NAME = NULL,
    LATEST_PPC_ADDRESS_POSTCODE = NULL
  ) %>% 
  mutate(
    POSTCODE = gsub(" ", "", POSTCODE)
  )

con <- con_nhsbsa(database = "DALP")

con %>% 
  copy_to(
    dp_data,
    "DENTAL_PRACTICES_ACCEPTING_NHS",
    temporary = FALSE,
    overwrite = TRUE
  )

DBI::dbDisconnect(con)
