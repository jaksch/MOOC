# -*- coding: utf-8 -*-
"""
Created on Thu Jul 11 10:05:35 2014

Problem 3 assignment 1

@author: jakschmi
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
    
    for line in tweet_file:
        pytweet = json.loads(line)
        the_tweet = pytweet["text"]
        #print the_tweet.encode('utf-8')
        the_tweet2 = the_tweet.encode('utf-8')
        words = the_tweet.split()
        #print words
        #print words[0].encode('ascii') in scores
        total_score = 0
        non_senti = []
        senti = []
        for word in words:
            word2 = word.encode('ascii')
            #print word2
            if word2 in scores:
                temp_score = scores[word2]
                senti.append(word2)
            if word2 not in scores:
                temp_score = 0
                non_senti.append(word2)
            total_score = total_score + temp_score
        new_score = total_score/len(words)
        
        for non_senti_word in non_senti:
            new_score = total_score/len(senti)
            print non_senti_word,new_score

if __name__ == '__main__':
    main()
