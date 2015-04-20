## READ FROM WEB
library(XML)

searchIndex <- 0
# tweak 'start=0' below to iterate through the total of 7 pages
con = url("http://www.google.co.uk/search?q=barclays+bank&num=100&hl=en&gl=uk&authuser=0&biw=1333&bih=757&tbs=cdr:1,cd_min:01/01/2010,cd_max:01/05/2012&tbm=nws&ei=HsPIVL3nE8Hzaom-gVA&start=&sa=N&dpr=10")
htmlCode = readLines(con)
close(con)
htmlCode

# read specific info
url <- "https://www.google.co.uk/search?q=barclays+bank&num=100&hl=en&gl=uk&authuser=0&biw=1333&bih=757&tbs=cdr:1,cd_min:01/01/2010,cd_max:01/05/2012&tbm=nws&ei=HsPIVL3nE8Hzaom-gVA&start=&sa=N&dpr=10"
html <- htmlTreeParse(url, useInternalNodes=T)
titles <- xpathSApply(html, "//title", xmlValue)
titles

xpathSApply(html, "//td[@id='st']", xmlValue)

# GET from httr package
library(httr); html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)