import csv

with open('data_lsa.csv', 'U') as csvfile:

    reader = csv.reader(csvfile, delimiter=',')
    #post_col = reader[6]
    included_cols = [6]

    fcount = 0
    txt = []


    for row in reader:
		# read  text from column in csv
		content = list(row[i] for i in included_cols)
		
		# generate a nice, clean string
		txt = str(content)
		txt = txt.replace("['", "")
		txt = txt.replace("']", "")
		txt = txt.replace("\n", "")
		if (len(txt) < 3):
			txt = "No available terms"
			
		#write to .txt file
		f = open(str(fcount)+'.txt', 'w')
		f.write(txt)
		
		#Close the target file
		f.close()
		
		# increment fcount
		print "Processed doc #: " + str(fcount)
		fcount = fcount + 1	


			
			
						
		

