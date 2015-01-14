## GENERATES EDGE LIST FOR SOCIAL NETWORK ANALYSIS

import csv
import re

f = open('edgelist.csv', 'w')

with open('data_formatted_edges.csv', 'U') as csvfile:

	# set which columns holds the info for source, target, data
    reader = csv.reader(csvfile, delimiter=',')
    source_col = [0]
    date_col = [1]
    target_col = [2]

    for row in reader:
		
		# get source
		source = str(list(row[i] for i in source_col))
		source = re.sub('[\[\]]', '', source)
		source = re.sub('[\']', '', source)
		print 'SOURCE: ' + source
		
		# get date
		date = str(list(row[i] for i in date_col))
		date = re.sub('[\[\]]', '', date)						#replaces '[' and ']' with ' '
		date = re.sub('[\']', '', date)							#replaces '  with ' '
		print 'DATE: ' + date
		
		# get targets...
		targets = []
		target_content = list(row[i] for i in target_col)
		t_content = str(target_content)
		group_targets = re.findall("@(.*?)]", t_content)		#finds all strings between '@' and ']'
		employee_targets = re.findall("\((.*?)\)", t_content)	#finds all strings between '(' and ')'
		
		for g in group_targets:
			g = re.sub('[\[]', '', g)
			f.write(source + "," + g + "," + date + '\n')

		for e in employee_targets:
			e = re.sub('[\(\)]', '', e)
			f.write(source + "," + e + "," + date + '\n')

		print 'GROUP TARGETS: ' + str(group_targets)
		print 'EMPLOYEE TARGETS: ' + str(employee_targets)
		print 'TARGETS: ' + str(targets)
		print 'TEXT: ' + str(target_content) + '\n'						
		
#Close the target file
f.close()
