# Author : Marco Cardoso
# Date : 02/04/2017


####### NECESSARY PACKAGES TO RUN THE SCRIPT
# install.packages("twitteR")
# install.packages("plyr")
# install.packages("stringr")
# install.packages("tm")
# install.packages("mscstexta4r")
# install.packages("Rstem")


#another excelent sentiment analytics package it is the syuzhet

library("twitteR")
library("plyr")
library("stringr")
library("tm")
library("Rstem")
library("RColorBrewer")
library("wordcloud")

###############  Twitter Configurations #############

consumer_key =  "kCAQXPAJI8o89NOSFihoLAmay"
consumer_secret =  "G0nTKiRGsLLP30zyVTq6s7sIFokp51QFUlCM9fKwf7B1ox81Zj"
access_token =   "850154395195015168-CWLaUHjzieLNvOwDtedJG62EXl6bTGg"
access_secret = "wDKdzzSOmVVkwWEyJ8OgyxwaSsLV0MPeUlDWecXwSv3di"

# the next instruction does the authentication with the twitter setup
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
brazilWoeid = 23424768

# getting the trends of the brazilians

# To know how are the  currently feelings of the brazilians , first we collect
# the trends
# Then we process the 50 main trends with a text mining algorithm to  analyse the country's
# society emotions

# the next instruction will give us a dataframe with urls and another informations.
# what we want is just the column of the trend's names
trends_list = as.list(getTrends(woeid = 23424768)[,'name'])


# removing the hashtag from the word
trends_list = lapply(trends_list, function(x) {
  gsub("#","",x)
})


# get a hundred tweets from the trends
tweetsFromTrends = lapply(trends_list[1:5] , function(x){
    as.list(searchTwitter(x, n= 50,resultType="recent",locale = brazilWoeid))
})


tweets = unlist(tweetsFromTrends)


#creating a corpus object containing all the tweets
tweetlist <- lapply(tweets, function(x){

    gsub("[^[:graph:]]"," ",x$getText())
    #iconv(x$getText(), to = "utf-8")
  }
)



# tweetlist <- sapply(tweetlist, function(x) x$getText())
corpus = Corpus(VectorSource(tweetlist))
corpus = tm_map(corpus, function(x)removeWords(x, unlist(trends_list)))
corpus = tm_map(corpus, function(x)removeWords(x, stopwords("portuguese")))
#corpus <- tm_map(corpus,
# content_transformer(function(x) iconv(x, to='UTF-8', sub='byte'))
# )
corpus = tm_map(corpus,stripWhitespace)
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus,removePunctuation)
corpus = tm_map(corpus,removeNumbers)
corpus <- Corpus(VectorSource(corpus))

#converting corpus to a text
#text  <- tm_map(corpus, PlainTextDocument)


document <- TermDocumentMatrix(corpus)
matrix <- as.matrix(matrix)
v <- sort(rowSums(matrix),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#findFreqTerms(document, lowfreq = 4)
#findAssocs(document, terms = "brt", corlimit = 0.3)
# colors = brewer.pal(12,"RdYlGn")
# wordcloud(corpus,
#           scale = c(3,1),
#           random.order = F,
#           min.freq = 0,
#           colors = colors)

# the most used words
barplot(d$freq[], las = 2, names.arg = d$word[],
        col ="red", main ="Most used words",
        ylab = "Frequencies")


# findAssocs(document, 'sofá', 0.60)

teste =  removeSparseTerms(document, sparse = 0.7)
findFreqTerms(teste ,lowfreq = 0)
findFreqTerms(document)
portuguese_positive_words = readLines("words/positive-portuguese-words.txt")
portuguese_negative_words = readLines("words/negative-portuguese-words.txt")


words = d$word
freq = d$freq
positive_score = 0
negative_score = 0
i = 0
for (word in words) {

  pos_match = match(word,portuguese_positive_words)

  if (!is.na(pos_match))
  {
    positive_score = positive_score + freq[i]
  }
  else
  {
    neg_match = match(word,portuguese_negative_words)
    if(!is.na(neg_match))
    {
      negative_score = negative_score + freq[i]
    }

  }

  i = i + 1
}

result = positive_score - negative_score
positive_score
negative_score
result

get_sentiment_dictionary(dictionary = "nrc")
s_v <- get_sentences("i hate you!")
raw_values <- get_sentiment(s_v, method = "syuzhet")
dct_vals <- get_dct_transform(raw_values)
plot(dct_vals, type="l", ylim=c(-0.1,.1))


#microsoft text analytics api
MSCS_TEXTANALYTICS_URL = "https://westus.api.cognitive.microsoft.com/texta/analytics/v2.0/"
MSCS_TEXTANALYTICS_KEY = "1e36a52634a24d37b7042e98a206d57b"

textaInit()


teste = searchTwitter(searchString = "brasil",n = 25 , resultType = "recent",locale = brazilWoeid)
tweets = sapply(teste, function(x) x$getText())

docsLanguage <- rep("pt", length(testing[-33]))

tryCatch({

  # Perform sentiment analysis
  resultados = textaSentiment(
    documents = testing[-33],    # Input sentences or documents
    languages = docsLanguage
    # "en"(English, default)|"es"(Spanish)|"fr"(French)|"pt"(Portuguese)
  )

}, error = function(err) {

  # Print error
  geterrmessage()

})

testingvector = rnorm(49)
trendsTweetsFrequencies = resultados[1]$results$score

# boxplot(trendsTweetsFrequencies , outline = TRUE ,
#         col = "blue" ,
#         ylab = "Feeling index",
#         xlab = "Topico Comentado"
#         )

testing = data.frame(v1 = testingvector, v2= trendsTweetsFrequencies)


# boxplot(result)
