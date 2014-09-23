# -*- coding: utf-8 -*-
"""
Created on Fri Jul 11 12:21:28 2014

@author: jakschmi
"""

import sys
import json

def main():
    tweet_file = open(sys.argv[1])
    #hw()
    #lines(sent_file)
    #lines(tweet_file)
    
    wordcount = {} # empty dict
    tot_nof_words = 0
    for line in tweet_file:
        pytweet = json.loads(line)
        the_tweet = pytweet["text"]
        #print the_tweet.encode('utf-8')
        the_tweet2 = the_tweet.encode('utf-8')
        words = the_tweet2.split()
        
        for word in words:
            if word not in wordcount:
                wordcount[word] = 1
            else:
                wordcount[word] += 1
            tot_nof_words += 1
            
    for k,v in wordcount.items():   
        freq = float(v)/float(tot_nof_words)
        print k, freq

if __name__ == '__main__':
    main()