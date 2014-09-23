# -*- coding: utf-8 -*-
"""
Created on Wed Jul 10 15:28:46 2014

Problem 1 assignment 1

@author: jakschmi
"""

import oauth2 as oauth
import urllib2 as urllib

# See assignment1.html instructions or README for how to get these credentials

api_key = "jTLnACRUgxD7YkxJcovXCrKa7"
api_secret = "6x0PDMW0hSHdmAJvCWetC8PEpYggiFp9fTkvO5UQLqIsjR3Xrb"
access_token_key = "2610301021-dE8vGWE3PUthSg6l8fL97e4Dy9rSQLPwBjCkvsI"
access_token_secret = "n7DsPtbLOAWhawDChufC28vF9fjYMGM207GAonWbrPkGu"

_debug = 0

oauth_token    = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=api_key, secret=api_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"

http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

'''
Construct, sign, and open a twitter request
using the hard-coded credentials above.
'''
def twitterreq(url, method, parameters):
  req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url,
                                             parameters=parameters)

  req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

  headers = req.to_header()

  if http_method == "POST":
    encoded_post_data = req.to_postdata()
  else:
    encoded_post_data = None
    url = req.to_url()

  opener = urllib.OpenerDirector()
  opener.add_handler(http_handler)
  opener.add_handler(https_handler)

  response = opener.open(url, encoded_post_data)

  return response

def fetchsamples():
  url = "https://stream.twitter.com/1/statuses/sample.json"
  parameters = []
  response = twitterreq(url, "GET", parameters)
  for line in response:
    print line.strip()

if __name__ == '__main__':
  fetchsamples()
