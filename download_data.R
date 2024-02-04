library(dplyr)
library(ggplot2)
library(baseballr)


# User Interface
# average will be calculated by event1/(event1+event2), event that is not in event1 or event2 will be ignored
start_date <- as.Date("2023-01-01")
end_date <- as.Date("2023-12-31")
versus_data_path <- "versus_data_23ML.csv"
batter_data_path <- "batter_data_23ML.csv"
pitcher_data_path <- "pitcher_data_23ML.csv"
teams <- c("KC", "SD", "AZ", "NYM", "PHI", "STL", "DET", "PIT", "MIN", "BAL", 
    "CWS", "CHC", "HOU", "TEX", "CIN", "ATL", "SEA", "OAK", "MIL", "COL", 
    "MIA", "TOR", "NYY", "BOS", "SF", "LAA", "WSH", "CLE", "LAD", "TB")
event1 <- c("single", "double", "home_run", "triple")
event2 <- c("field_out", "strikeout", "grounded_into_double_play", "fielders_choice_out", "double_play")



# Download data from baseballr package
c
fulldata <- 0

date_sequence <- seq(start_date, end_date, by = "days")

for(i in 1:(length(date_sequence)-1)){
    print(paste("Progress : ", i, "/", length(date_sequence)-1, "data length : ", nrow(fulldata)))
    today <- date_sequence[i]

    try({
        data <- baseballr::scrape_statcast_savant_batter(today, today)
        if(typeof(fulldata)==typeof(0) && nrow(data) > 0){
            fulldata <- data
        }
        else{
            fulldata <- rbind(fulldata, data)
        }
    })
}

# Data Preprocessing
fulldata <- as_tibble(fulldata)
fulldata <- filter(fulldata, game_type=="R")
fulldata <- filter(fulldata,!(fulldata$events=="")) 
fulldata <- filter(fulldata, (home_team %in% teams))
fulldata <- filter(fulldata, (away_team %in% teams))
total_event <- c(event1, event2)
fulldata <- filter(fulldata, (events %in% total_event))
rfull4$event1 <- ifelse(rfull4$events %in% event1, 1, 0)
rfull4$event2 <- ifelse(rfull4$events %in% event2, 1, 0)

versus_data <- fulldata %>% group_by(batter, pitcher) %>% summarise(event1 = sum(event1), event2 = sum(event2), total = n())
batter_data <- fulldata %>% group_by(batter) %>% summarise(event1 = sum(event1), event2 = sum(event2), total = n(), average = event1/total)
pitcher_data <- fulldata %>% group_by(pitcher) %>% summarise(event1 = sum(event1), event2 = sum(event2), total = n(), average = event1/total)

# save data
write.csv(versus_data, versus_data_path)
write.csv(batter_data, batter_data_path)
write.csv(pitcher_data, pitcher_data_path)