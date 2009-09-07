#! /usr/bin/python
from TOSSIM import *
import sys

t = Tossim([])
r = t.radio()
f = open("4x4-grid.txt", "r")

lines = f.readlines()
for line in lines:
	s = line.split()
	if (len(s) > 0):
		if(s[0] == "gain"):
			r.add(int(s[1]), int(s[2]), float(s[3]))

t.addChannel("APP", sys.stdout)
t.addChannel("API", sys.stdout)
t.addChannel("OERP", sys.stdout)
t.addChannel("L3", sys.stdout)
t.addChannel("L4", sys.stdout)
# Remove the comment in the next line if you want to observe multi-hop routing
#t.addChannel("mhe", sys.stdout)

noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
	str = line.strip()
	if (str != ""):
		val = int(str)
		for i in range(1, 15):
			t.getNode(i).addNoiseTraceReading(val)

for i in range(1, 15):
	print "Creating noise model for ",i
	t.getNode(i).createNoiseModel()
	t.getNode(i).bootAtTime(i*1001)

print "Start simulation"
for i in range(0, 50000000):
	t.runNextEvent()
