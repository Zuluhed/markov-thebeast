setwd("~/GitHub/PalinBot")
library(ngram)
library(twitteR)

options(httr_oauth_cache=T)

apikey <- "ff6Jf9V7epy27yMbNJuDVvJun"
apisecret <- "Jzgju26tWFvoOjpKf6TiSsYgqWjHWOUQe4nKVmcCsBIg4VL5zu"
token <- "4837743903-demnJz0lwa5DHQqnoqOx04DNRiXPBys4WFqB3HY"
tokensecret <- "cDloocuGYiNwIlfaUJuqu5A5HptxBjY3r7vNPFfzpytgc"
setup_twitter_oauth(apikey, apisecret, token, tokensecret)

help(searchTwitter)


sarah.tweets <- twListToDF(userTimeline('SarahPalinUSA', n=3200))$text

sarah.tweets

# Function to strip off trailing ... and url from fb posts
strip.fb <- function(x){
   this.tweet <- gsub('\\.\\.\\..*', "", x)
   this.tweet <- gsub('http.*', "", this.tweet)
} 

new.tweets <- c()
for(i in sarah.tweets){
   new.tweets <- c(new.tweets, strip.fb(i))
}

write(new.tweets, file="palintweets.txt")


# NOTE: You need to re-encode these in Sublime to UTF-8