# -*- coding: utf-8 -*-
"""
Created on Fri Jul 11 20:41:34 2014

@author: Jakob
"""

import sys
import json

def hw():
    print 'Hello, Jakob!'

def lines(fp):
    print str(len(fp.readlines()))

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    #hw()
    #lines(sent_file)
    #lines(tweet_file)
    
    scores = {} # initialize an empty dictionary
    for line in sent_file:
        term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
        scores[term] = int(score)  # Convert the score to an integer.
        
    statecount = {} # empty dict
    for line in tweet_file:
        pytweet = json.loads(line)
        the_tweet = pytweet["text"]
        #print the_tweet.encode('utf-8')
        the_tweet2 = the_tweet.encode('utf-8')
        words = the_tweet2.split()
        #print words
        tweet_score = 0
        for word in words:
            word2 = word
            #print word2
            if word2 in scores:
                temp_score = scores[word2]
            if word2 not in scores:
                temp_score = 0
            tweet_score = tweet_score + temp_score
        #print tweet_score
        tweet_state = pytweet["place"]["full_name"][-2:].encode('utf-8')
        #print tweet_state
    
        if tweet_state not in statecount:
            statecount[tweet_state] = tweet_score
        else:
            statecount[tweet_state] = statecount[tweet_state] + tweet_score

    #print statecount.items()

    max_score = 0
    happeist_state = "jakob"
    for k,v in statecount.items():
        if v > max_score:
            happeist_state = k
    print happeist_state

if __name__ == '__main__':
    main()