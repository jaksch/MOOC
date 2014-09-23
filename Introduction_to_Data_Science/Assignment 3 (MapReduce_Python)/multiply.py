import MapReduce
import sys

"""
Problem 6: Matrix multiplication in MapReduce
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: document identifier
    # value: document contents
    if record[0] == "a":
        for k in range(5):
            value = [0,0,0,0,0,0,0,0,0,0]
            key = (record[1], k)
            value[record[2]] = record[3]
            mr.emit_intermediate(key, value)
            
    if record[0] == "b":
        for k in range(5):
            value = [0,0,0,0,0,0,0,0,0,0]
            key = (k, record[2])
            value[5+record[1]] = record[3]
            mr.emit_intermediate(key, value)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    vals = [0,0,0,0,0,0,0,0,0,0]
    for i in list_of_values:
        vals = [x + y for x, y in zip(vals, i)]
        
    sums = [0,0,0,0,0]
    for j in range(5):
        sums[j] = vals[j]*vals[j+5]
    
    end_val = sum(sums)
    
    mr.emit((key[0], key[1], end_val))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
