#Loading the rvest package
library('rvest')

#Specifying the url for desired website to be scraped
url <- 'https://www.imdb.com/list/ls050745379/'

#Reading the HTML code from the website
webpage <- read_html(url)

#Using CSS selectors to scrape the rankings section
rank_data_html <- html_nodes(webpage,'.lister-item-header a')

#Converting the ranking data to text
Actors_Name <- html_text(rank_data_html)
Actors_Name<-gsub("\n","",Actors_Name)
#Let's have a look at the rankings
head(Actors_Name)
type(Actors_Name)
Actors_Name=as.data.frame(Actors_Name)


url1 <- 'https://www.imdb.com/list/ls069887650/'

#Reading the HTML code from the website
webpage1 <- read_html(url1)

#Using CSS selectors to scrape the rankings section
actress_data_html1 <- html_nodes(webpage1,'.lister-item-header a')
Actress_Name=html_text(actress_data_html1)
Actress_Name=gsub("\n","",Actress_Name)
Actress_Name=as.data.frame(Actress_Name)

write.csv(Actress_Name,"C:\\Users\\lenovo\\Desktop\\Actress_Name.csv", row.names = FALSE,col.names = 'Actress_Name')
write.csv(Actors_Name,"C:\\Users\\lenovo\\Desktop\\Actors_Name.csv", row.names = FALSE,col.names = 'Actors_Name')
