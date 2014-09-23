import MapReduce
import sys

"""
Problem 4: Find asymmetric friendships
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: document identifier
    # value: document contents
    key = record[0]
    value = record[1] 
    mr.emit_intermediate((key, value), 1)  
    key = record[1]
    value = record[0]
    mr.emit_intermediate((key, value), -1)
    
def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    total = sum(list_of_values)
    if total != 0:
        mr.emit(key)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
