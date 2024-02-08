# !diagnostics suppress=RSelenium,tidyverse
shelf(
  RSelenium,
  tidyverse
)

matched_data <- read.csv("odp_to_ods_matched.csv")
result_file  <- "dental_practice_accepting_nhs_px.csv"
url <- "https://www.nhs.uk/services/dentist/foo/"

extraCap <- list(
  chromeOptions = list(
    args = c(
      '--window-size=1280,800',
      '--no-sandbox',
      '--disable-blink-features=AutomationControlled',
      paste0(
        '--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit',
        '/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'
      )
    ),
    excludeSwitches = list("enable-automation", "enable-logging"),
    prefs = list(
      `profile.default_content_settings.popups` = 0
    ),
    useAutomationExtension = FALSE
  )
)

rD <- rsDriver(
  browser = "chrome",
  chromever = "120.0.6099.109",
  port = netstat::free_port(),
  verbose = FALSE,
  check = FALSE,
  extraCapabilities = extraCap
)

remDr <- rD$client

empty_data <- matched_data %>%
  mutate(
    accept_adults = NA,
    accept_adults_free = NA,
    accept_children = NA,
    referral_only = NA,
    not_updated = NA,
    not_found = NA
  ) %>% 
  drop_na()

write.csv(
  empty_data,
  file = result_file,
  row.names = FALSE
)

accepting_targets <- c(
  "accepting adults 18 and over",
  "accepting adults entitled to free dental care",
  "accepting children aged 17 or under"
)

get_result <- function(row) {
  remDr$navigate(paste0(url, row$ods))
  
  Sys.sleep(1)
  
  not_found <- remDr$findElements("id", "page-heading") %>% 
    length() %>% 
    as.logical() %>% 
    not()
  
  if (not_found) {
    result <- row %>% 
      left_join(empty_data) %>% 
      mutate(not_found = TRUE)
    
    return(result)
  }
  
  not_updated <- remDr$findElements("id", "accepting_patients_not_updated") %>% 
    length() %>% 
    as.logical()
  
  if (not_updated) {
    result <- row %>% 
      left_join(empty_data) %>% 
      mutate(
        not_updated = TRUE,
        not_found = FALSE
      )
    
    return(result)
  }
  
  referral_only <- remDr$findElements("id", "accepting_patients_referral_only") %>% 
    length() %>% 
    as.logical()
  
  if (referral_only) {
    result <- row %>% 
      left_join(empty_data) %>% 
      mutate(
        referral_only = TRUE,
        not_updated = FALSE,
        not_found = FALSE
      )
    
    return(result)
  }
  
  accepting_text <- remDr$
    findElement("class", "nhsuk-list")$
    getElementText()
  
  flags <- str_split(accepting_text, "\n")[[1]] == accepting_targets
  
  row %>% 
    left_join(empty_data) %>% 
    mutate(
      accept_adults = flags[1],
      accept_adults_free = flags[2],
      accept_children = flags[3],
      referral_only = FALSE,
      not_updated = FALSE,
      not_found = FALSE
    )
}

write_result <- function(result, file) {
  write.table(
    result,
    file,
    append = TRUE,
    sep = ",",
    col.names = FALSE,
    row.names = FALSE
  )
}

by(
  matched_data,
  seq_len(nrow(matched_data)),
  \(row) {
    result <- get_result(row)
    write_result(result, result_file)
  }
)

rD$server$stop()
