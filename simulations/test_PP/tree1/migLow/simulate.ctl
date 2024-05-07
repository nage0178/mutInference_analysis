seed = 1

seqfile =  simulate_IM.txt
treefile=  simulate_trees.txt
Imapfile = simple.Imap.txt

modelparafile = parameters.txt

# fixed number of species/populations 
*speciesdelimitation = 0

# fixed species tree

species&tree = 4  A B C D
                  5 5 5 5
		  ((A #0.001, B #0.001):.00005 #.001, (C #0.001, D #0.001 ):.00007 #0.001):.0001 #.001;

migration = 4
A B 0.02
B A 0.02
C D 0.02
D C 0.02

# phased data for population
phase =   0 0 0 0 

loci&length = 100 5000
clock = 1
locusrate =0
model =7

printlocus = 100 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 
qrates =  1 2 1 1 1 1 2
basefreqs = 1 .24 .26 .23 .27