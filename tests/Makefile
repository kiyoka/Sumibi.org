
.PHONY = all

DICT=sumi_bincho_1
SUMIBI=nice -19 gosh -I../lib ../sumibi
SUMIYAKI=nice -19 ./sumiyaki.sh


all : h1


h: 
	$(SUMIBI) < input-data1.txt | egrep ' 0 .$$' > result_list.log

h0:
	head -1 input-data1.txt | $(SUMIBI) -d | grep -e ' [0-9]* 0 [0-9]*'
h1:
	head -2 input-data1.txt | $(SUMIBI) -d > result.log


create:
	echo "create database " $(DICT) " DEFAULT CHARACTER SET utf8;" | mysql
	$(SUMIYAKI) -c

load:
	$(SUMIYAKI) -i ../dict/SKK-JISYO.sumibi_starter > ~/park/log

loadS:
	wget -nc http://openlab.jp/skk/skk/dic/SKK-JISYO.S
	$(SUMIYAKI) -i ./SKK-JISYO.S > ~/park/log

ossbook:
	find /home/park/sumibi_corpus/OSSBOOK -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
jf:
	find /home/park/sumibi_corpus/JFdocs -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
wikipedia:
	find /home/park/sumibi_corpus/wikipedia_ja/data -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
yamagata:
	find /home/park/sumibi_corpus/Yamagata -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
thinkgnu:
	find /home/park/sumibi_corpus/thinkgnu -name '*.TXT' -exec $(SUMIYAKI) -l {} \; > ~/park/log
postgres:
	find /home/park/sumibi_corpus/postgres8.1 -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
gauche-refj:
	find /home/park/sumibi_corpus/gauche-refj -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
hatena:
	find /home/park/sumibi_corpus/hatena -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
jmm:
	find /home/park/sumibi_corpus/jmm -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log
fortest:
	find /home/park/sumibi_corpus/fortest -name '*.txt' -exec $(SUMIYAKI) -l {} \; > ~/park/log

sum:
	$(SUMIYAKI) -s > ~/park/summary.txt

sumword:
	echo "set character set utf8; select * from word;" | mysql $(DICT) > ~/park/summary.txt


# ---- for testing ----
debug:
	echo "set character set utf8; select * from word where yomiank = 'ka' and okuri = 'k';" | mysql $(DICT) > log

wikipedia_1:
	cat ./1_100.txt       | awk '{ print "./sumiyaki.sh -l " $$0; }' | bash -s > ~/park/log
wikipedia_2:
	cat ./101_200.txt     | awk '{ print "./sumiyaki.sh -l " $$0; }' | bash -s > ~/park/log
