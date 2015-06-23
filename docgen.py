## READS .CSV AND SAVES EACH TEXT CELL TO A TEXT DOCUMENT

import csv
import re

directory = "../lsadocs/"
txtcol = 6 # set the column holding the text

with open('../data_lsa.csv', 'U') as csvfile:

    reader = csv.reader(csvfile, delimiter=',')
    included_cols = [txtcol]

    fcount = 0
    txt = []

    for row in reader:
		# read  text from column in .csv
		content = list(row[i] for i in included_cols)
		txt = str(content)
		# add value to files with < 50 characters
		if (len(txt) < 50):
			txt = "123456789"
		else:		
		# generate a nice, clean string
			txt = txt.translate(None, '[]@:')
			txt = txt.strip() 
			#	txt = txt.translate(None, '[]@:')
			txt = re.sub('\n', '', txt)
	#	txt = txt.replace("['", "")
	#	txt = txt.replace("[", "")
	#	txt = txt.replace("']", "")
	#	txt = txt.replace("]", "")
	#	txt = txt.replace("@", "")
	#	txt = txt.replace(":", "")
	#	txt = txt.replace("\n", "")
		
			
		#write to .txt file
		if not os.path.exists(directory):
    		os.makedirs(directory)
		f = open("../lsadocs/"+str(fcount)+'.txt', 'w')
		f.write(txt)
		
		#Close the target file
		f.close()
		
		# increment fcount
		print "Processed doc #: " + str(fcount)
		fcount = fcount + 1	
