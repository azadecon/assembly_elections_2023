library(tidyverse)
library(janitor)
library(readxl)
library(rvest)
library(data.table)
library(httr)

## Election was adjourned in AC 3 (Karanpur) due to death of congress candidate Gurmeet Singh Koonar.

## https://www.thehindu.com/news/national/poll-adjourned-in-rajasthan-assembly-seat-due-to-candidates-death-now-on-jan-5/article67606681.ece

for (const in c(1:2, 4:200)) {
  headers = c(
    'authority' = 'results.eci.gov.in',
    'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'accept-language' = 'en-US,en;q=0.9',
    'cookie' = 'RT="z=1&dm=results.eci.gov.in&si=981bc7bf-7ba3-43b0-b725-b539e92aef8b&ss=lqh10mbo&sl=7&tt=2c1&bcn=%2F%2F684d0d48.akstat.io%2F&ld=2td8&nu=31utebg0&cl=2x6n&ul=2x6s"',
    'referer' = 'https://results.eci.gov.in/AcResultGenDecNew2023/candidateswise-S2053.htm',
    'sec-ch-ua' = '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
    'sec-ch-ua-mobile' = '?1',
    'sec-ch-ua-platform' = '"Android"',
    'sec-fetch-dest' = 'document',
    'sec-fetch-mode' = 'navigate',
    'sec-fetch-site' = 'same-origin',
    'sec-fetch-user' = '?1',
    'upgrade-insecure-requests' = '1',
    'user-agent' = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
  )
  url <- paste0("https://results.eci.gov.in/AcResultGenDecNew2023/ConstituencywiseS20", const, ".htm")
  res <- VERB("GET", url = url, add_headers(headers))
  
  df <- read_html(res) |> html_table() |> as.data.frame() |> clean_names()
  df$constituency <- paste0(const)
  
  colnames(df) <- c("s_n",
                    "candidate",
                    "party",
                    "evm_votes",
                    "postal_votes",
                    "total_votes", 
                    "perc_of_votes",
                    "constituency"
  )
  
  writexl::write_xlsx(df, paste0("./raj/", const, ".xlsx"))
  
}





