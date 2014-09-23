import MapReduce
import sys

"""
Problem 2: Implement a relational join as a MapReduce query
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: document identifier
    # value: document contents
    key = record[1]
    value = record[:]
    mr.emit_intermediate(key, value)

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    total = []
    for v in list_of_values[1:]:
      total = list_of_values[0] + v
      mr.emit(total)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
