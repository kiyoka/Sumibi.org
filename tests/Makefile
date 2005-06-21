
SUMIBI=nice -19 ../sumibi
SUMIYAKI=nice -19 ../sumiyaki


h: 
	$(SUMIBI) < input-data1.txt | grep "#9#" > result_list.log

h1:
	head -1 input-data1.txt | $(SUMIBI) > result.log

h2:
	cat /home/park/$(SUMIBI)_corpus/unixuser/200405/part1.txt | kakasi -Ja -Ka -Ha -Ea -s > henkan2.txt
	$(SUMIBI) < henkan2.txt | grep "#9#" > result.log

loadS:
	$(SUMIYAKI) -i /home/park/sumibi_corpus/SKK-JISYO.S > ~/park/log

loadM:
	$(SUMIYAKI) -i /home/park/sumibi_corpus/SKK-JISYO.M > ~/park/log

loadL:
	$(SUMIYAKI) -i /home/park/sumibi_corpus/SKK-JISYO.L > ~/park/log

ossbook:
	find /home/park/sumibi_corpus/OSSBOOK -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
jmm:
	find /home/park/sumibi_corpus/JMM -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
jf:
	find /home/park/sumibi_corpus/JFdocs -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
yamagata:
	find /home/park/sumibi_corpus/Yamagata -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
uu:
	find /home/park/sumibi_corpus/unixuser -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
thinkgnu:
	find /home/park/sumibi_corpus/thinkgnu -name '*.TXT' -exec $(SUMIYAKI) -l {} \; > ~/park/log
postgres:
	find /home/park/sumibi_corpus/postgres8.1 -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
gauche-refj:
	find /home/park/sumibi_corpus/gauche-refj -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
hatena:
	find /home/park/sumibi_corpus/hatena -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log

sum:
	$(SUMIYAKI) -s > ~/park/summary.txt
