## adapted form: Dr Bernie Hogan, Research Fellow, Oxford Internet Institute, University of Oxford
import csv

f = open('../twomode.csv', 'w')

with open('../twomodematrix.csv', 'U') as csvfile:

	data = csv.reader(csvfile, delimiter=',')
	matrix = data #consider reading in using csvreader
	edgetups = []
	collabels = rows[0] # there will be a blank first entry, but that's no matter
	rowlabels = [rows[0] for rows in data] #again, first entry blank but no matter  

	for c,i in enumerate(rows): #removing first entry here creates off-by-one errors below, so keep for now.
		for d,j in enumerate(i):
			if c > 0 and d > 0 and j > 0: #don't want first row, col, or j if j is 0 
				edgetups.append(collabels[c],collabels[d]) 

f.write(edgetups) #Edgetups is now your edgelist. Insert as normal. 
f.close() #Close the target file
 