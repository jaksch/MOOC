# -*- coding: utf-8 -*-
"""
Created on Fri Jul 11 21:26:19 2014

@author: Jakob
"""

import sys
import json

def hw():
    print 'Hello, Jakob!'

def lines(fp):
    print str(len(fp.readlines()))

def main():
    tweet_file = open(sys.argv[1])
    #hw()
    #lines(sent_file)
    #lines(tweet_file)
    
    hashtag_count = {} # empty dict
    hashtags = []
    for line in tweet_file:
        pytweet = json.loads(line)
        
        hash1 = pytweet["entities"]["hashtags"]
        for element in hash1:
            hash2 = element["text"].encode('utf-8')
            hashtags.append(hash2)
    
    for hashtag in hashtags:
        if hashtag not in hashtag_count:
            hashtag_count[hashtag] = 1
        else:
            hashtag_count[hashtag] += 1
    
    #print hashtag_count.items()
    
    sorted_hashtags = sorted(hashtag_count.iteritems(), key=lambda (k,v): (v,k))[-10:]

    for k,v in reversed(sorted_hashtags):   
        print k, v

if __name__ == '__main__':
    main()