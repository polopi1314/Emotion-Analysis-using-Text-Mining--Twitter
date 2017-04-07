# Author : Marco Cardoso
# Date : 02/04/2017


####### NECESSARY PACKAGES TO RUN THE SCRIPT
# install.packages("twitteR")
# install.packages("plyr")
# install.packages("stringr")
# install.packages("tm")
# install.packages("sentiment")
# install.packages("Rstem")

# library("twitteR")
# library("plyr")
# library("stringr")
# library("tm")
# library("sentiment")
# library("Rstem")
# library("lapply")

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
trends_list = lapply(trends, function(x) {
  gsub("#","",x)
})



tweetsFromTrends = list()


# get a hundred tweets from the trends
lapply(trends_list , function(x){
    tweetsFromTrends[[x]] <<- as.list(searchTwitter(x, n= 100,resultType="recent",locale = brazilWoeid))
})





