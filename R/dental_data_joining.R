shelf(tidyverse, readxl)

data_path <- "data/uda_contractor_sample.xlsx"

data <- read_excel(data_path, sheet = "uda_contractor")

ods_data <- read_excel(data_path, sheet = "egdpprac")

data_prac <- data %>%
  select(id = CONTRACT_NUMBER, name = PROVIDER_NAME, postcode = LATEST_PPC_ADDRESS_POSTCODE) %>%
  mutate(name = toupper(name)) %>%
  add_count(name, postcode)

data_unmatched <- data_prac %>%
  filter(n > 1) %>%
  select(-n)

data_matching <- data_prac %>%
  filter(n == 1) %>%
  select(-n)

data_postcodes_counts <- data_prac %>%
  summarise(n = n(), .by = postcode) %>%
  summarise(n = n(), .by = n)

ods_data_prac <- ods_data %>%
  select(ods = `Organisation Code`, name = Name, postcode = Postcode) %>%
  mutate(ods = paste0("V", stringr::str_pad(stringr::str_sub(ods, 2), 6, pad = "0"))) %>% 
  add_count(postcode)

ods_data_unmatched <- ods_data_prac %>%
  filter(n > 1) %>%
  select(-n)

ods_data_matching <- ods_data_prac %>%
  filter(n == 1) %>%
  select(-n)

ods_data_postcodes_counts <- ods_data_prac %>%
  summarise(n = n(), .by = postcode) %>%
  summarise(n = n(), .by = n)

matching_data <- data_matching %>%
  left_join(
    ods_data_matching,
    by = join_by(postcode),
    suffix = c("_odp", "_ods"),
    keep = TRUE
  )

matched_data <- matching_data %>%
  filter(!is.na(ods))

write.csv(matched_data, "odp_to_ods_matched.csv", row.names = FALSE)
