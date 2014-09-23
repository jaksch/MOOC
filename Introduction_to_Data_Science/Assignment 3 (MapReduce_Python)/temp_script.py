# -*- coding: utf-8 -*-
"""
Created on Tue Jul 22 10:12:32 2014

@author: jakschmi
"""

r1 = ["a", 0, 0, 63]
r2 = ["a", 0, 1, 45]
r3 = ["a", 0, 2, 93]
r4 = ["a", 0, 3, 32]
r5 = ["a", 0, 4, 49]


if r1[0] == "a":
        for k in range(5):
            value = [0,0,0,0,0,0,0,0,0,0]
            key = (r1[1], k)
            value[r1[2]] = r1[3]
            print (key, value)
            
            
if r2[0] == "a":
        for k in range(5):
            value = [0,0,0,0,0,0,0,0,0,0]
            key = (r2[1], k)
            value[r2[2]] = r2[3]
            print (key, value)
 
new_key =   [1, 3]         
new_val = [[33, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 26, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 95, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 28, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 12, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 3, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 69]]

vals = [0,0,0,0,0,0,0,0,0,0]
for i in new_val:
    vals = [x + y for x, y in zip(vals, i)]
    
print vals    
    

sums = [0,0,0,0,0]
for j in range(5):
    sums[j] = vals[j]*vals[j+5]

print sums

print sum(sums)
