## SAVES UNSTRUCTURED TEXT FILE TO DATA TABLE

import re
import csv

f = open('post_text.txt')
authors = []
bodies = []
dates = []
 

# find all the posts in the unstructured data file
posts = re.findall(r"(?s)(?<=[' Report'|'Question Report'|'Poll Report'|'people like this. ']).+?(?=ago)", f.read())

# for each post extract author, time, content 

for p in posts:	
	# extract author and clean text from navigation
	index = p.find(':') 							# find next ':'
	author = p[7:index+1]							# get the string following ':'
	author = author.replace(":", "")				# delete noisy bits from the text...
	author = author.replace("\n", "")
	author = author.replace("ago\n", "DING!")
	author = author.replace("LikeCommentFollow-upMoreViewGet LinkComment\nReport this item for being abusive or offensive.Your name will not be sent along with this report.Report \n\n Report", "BINGGG!!!")
 	author = author.replace("eCommentFollow-upMoreShareViewGet LinkComment","DONG!!")
 	author = author.replace("eCommentFollow-upMoreViewGet LinkComment", "DoooiiiING!")
 	author = author.replace("Report this item for being abusive or offensive.Your name will not be sent along with this report.Report", "DANG!")
	author = author.replace("  Report", "YEEEHAA!!!")
	author = author.replace("RcommentsView less ", "BOOOOMMM!!!")
	author = author.replace("eCommentFollow-upMoreShareViewGet", "YIIPPPEEEE!!")
	author = author.replace("e  ", "ZAAPPP!!!")
	author = author.replace(" asked a question", "BOOOYYYAAAAAAA!")
	authors.append(author)
	print 'Author: ' + str(author)

	# get body text
	body = p[index+1:len(p)]
	bodies.append(body)
	print 'Body: ' + str(body)


	# get timestamp
	index = p.find('ago  ')
	date = p[0:index+1]
	dates.append(date)
	print 'Date: ' + str(date) + '\n'
		

# print output to console
print '\n' + 'EXTRACTION REPORT'
print "Total number of posts: " + str(len(posts))
print 'Total number of authors: ' + str(len(authors))
print 'Total number of bodies: ' + str(len(bodies))
print 'Total number of dates: ' + str(len(dates))

# close the source file
f.close()

# write structured data to .csv
with open('data.csv', 'wb') as f:
    writer = csv.writer(f)
    rows = zip(authours,bodies,dates)

    for row in rows:
    	writer.writerow(row)



