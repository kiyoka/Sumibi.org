




h: 
	sumibi < henkan1.txt | grep "#9#" > result.log

h1:
	head -1 henkan1.txt | sumibi > result.log

h2:
	cat /home/park/sumibi_corpus/unixuser/200405/part1.txt | kakasi -Ja -Ka -Ha -Ea -s > henkan2.txt
	sumibi < henkan2.txt | grep "#9#" > result.log

h3:
	cat /home/park/sumibi_corpus/unixuser/index.txt | kakasi -Ja -Ka -Ha -Ea -s > henkan3.txt
	sumibi < henkan3.txt | grep "#9#" > result.log

loadS:
	sumiyaki -i /home/park/sumibi_corpus/SKK-JISYO.S > ~/park/log

loadM:
	sumiyaki -i /home/park/sumibi_corpus/SKK-JISYO.M > ~/park/log

loadL:
	sumiyaki -i /home/park/sumibi_corpus/SKK-JISYO.L > ~/park/log

src1:
	sumiyaki -l ./src1.txt > ~/park/log

src2:
	sumiyaki -l ./src2.txt > ~/park/log

ossbook:
	find /home/park/sumibi_corpus/OSSBOOK -name '*.txt' -exec sumiyaki -l {} \; > ~/park/log
jmm:
	find /home/park/sumibi_corpus/JMM -name '*.txt' -exec sumiyaki -l {} \; > ~/park/log
jf:
	find /home/park/sumibi_corpus/JFdocs -name '*.txt' -exec sumiyaki -l {} \; > ~/park/log
yamagata:
	find /home/park/sumibi_corpus/Yamagata -name '*.txt' -exec sumiyaki -l {} \; > ~/park/log
uu:
	find /home/park/sumibi_corpus/unixuser -name '*.txt' -exec sumiyaki -l {} \; > ~/park/log


sum:
	sumiyaki -s > ~/park/summary.txt

