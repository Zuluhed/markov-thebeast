# holy.txt contains the centuries of nostradamus, the egyptian book of the dead,
# revelations, and liber logaeth, which is apparently a chunk of the necronomicon

setwd("~/GitHub/markov-thebeast")
library(ngram)
library(twitteR)
library(tm)
library(tm.plugin.webmining)


googlenews <- WebCorpus(GoogleNewsSource("Microsoft"))

googlenews.in <- paste(unlist(lapply(googlenews$content, function(x) x$content)), collapse = " ")
googlenews.in <- gsub("\\n", " ", googlenews.in)
googlenews.in <- gsub("([\\])", " ", googlenews.in)

yahoonews <- WebCorpus(YahooNewsSource("Microsoft"))

yahoonews.in <- paste(unlist(lapply(yahoonews$content, function(x) x$content)), collapse = " ")
yahoonews.in <- gsub("\\n", " ", yahoonews.in)
yahoonews.in <- gsub("([\\])", " ", yahoonews.in)

infile <- file("holy.txt")
holy.in <- readLines(infile)
holy.in <- paste(holy.in, collapse=" ")


options(httr_oauth_cache=T)

apikey <- "Sur0VwituHxoPSgQqwMynwgnh"
apisecret <- "aQVNgaqC6IIoUqAmDTYBqbJydrGYvkRNJzEHLRxoSb8mM2I5nK"
token <- "4890065174-4GGBq3nV50EOPSQTqHAORmJX66c0QhY1va2V2Fj"
tokensecret <- "H3qGjsNyQSVBPQ9BQaC8SOOYol6ypCG5v43qtVyOGGsyw"
setup_twitter_oauth(apikey, apisecret, token, tokensecret)


# Grab trends table from USA
tweets <- c()
trends <- getTrends(23424977)
for(i in 1:20){
   thistag <- trends[i, 1]
   print(paste("Harvesting tag", i, ":", thistag))
   these.tweets <- searchTwitter(thistag, 100)
   these.tweets <- paste(twListToDF(these.tweets)$text, collapse = " ")
   tweets <- paste(tweets, these.tweets, collapse = " ")
}
tweets <- paste(tweets, collapse=" ")
tweets <- gsub("http[^[:space:]]*", "", tweets)
tweets <- gsub("\\n", " ", tweets)
tweets <- gsub("([\\])", " ", tweets)
tweets <- gsub("([\"])", " ", tweets)
tweets <- iconv(tweets, "latin1", "ASCII", sub="")

# Haven't grabbed anybody's tweets yet, but that could be fun.  Maybe top trending on twitter?
# infile2 <- file("palintweets.txt")
# tweets.in <- readLines(infile2)


# Should I have it do appends?  Maybe add some religious twits
# appends <- file("palinappends.txt")
# appends.in <- readLines(appends)

# holy.in <- c(holy.in, tweets.in)

holy.in <- paste(holy.in, googlenews.in, yahoonews.in, tweets, collapse = " ")

beast.ngram <- ngram(holy.in, 2)

while(1){
   beast.babble <- babble(beast.ngram, genlen=1000)
   write(beast.babble, file="log.txt")
   # Break out sentences
   sentences <- c()
   sentence.starts <- as.vector(gregexpr("[?.!] +[A-Z]", beast.babble)[[1]])
   for(i in 1:(length(sentence.starts) - 1)){
      this.sentence <- try(substr(beast.babble, sentence.starts[i]+2, sentence.starts[i+1]), TRUE)
      if(nchar(this.sentence) <= 140){
         # De-comment this once I add appends
         # if(nchar(this.sentence) <= 100){
         #    this.sentence <- paste(this.sentence, sample(appends.in, 1))
         # }
         sentences <- c(sentences, this.sentence)
      }
   }
   out.sentence <- NULL
   if(length(sentences) > 1){
      out.sentence <- sample(sentences, 1)
   }
   else{
      out.sentence <- sentences[1]
   }
   print(out.sentence)
   # tweet(out.sentence)   
   Sys.sleep(10)
}