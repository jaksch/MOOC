# -*- coding: utf-8 -*-
"""
Created on Thu Jul 10 12:57:09 2014

@author: jakschmi
"""

import json

afinnfile = open("AFINN-111.txt")
scores = {} # initialize an empty dictionary
for line in afinnfile:
  term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
  scores[term] = int(score)  # Convert the score to an integer.

#print scores.items() # Print every (term, score) pair in the dictionary

#print scores[""]

#tweets = open("problem_1_submission.txt")

tweets = open("manipulated_tweets.txt")

hashtag_count = {} # empty dict
hashtags = []
for line in tweets:
    pytweet = json.loads(line)
    
    hash1 = pytweet["entities"]["hashtags"]
    for element in hash1:
        hash2 = element["text"].encode('utf-8')
        hashtags.append(hash2)
    
print hashtags

for hashtag in hashtags:
    if hashtag not in hashtag_count:
        hashtag_count[hashtag] = 1
    else:
        hashtag_count[hashtag] += 1

print hashtag_count.items()

sorted_hashtags = sorted(hashtag_count.iteritems(), key=lambda (k,v): (v,k))[-2:]

for k,v in reversed(sorted_hashtags):   
    print k, v





    

    


