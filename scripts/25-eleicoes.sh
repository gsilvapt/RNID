#!/bin/bash

maybeOK=0;

wget "https://jigsaw.w3.org/css-validator/validator?uri=https%3A%2F%2Fwww.autarquicas2017.mai.gov.pt%2F&profile=css3&usermedium=all&warning=1&vextwarning=&lang=en" -o /dev/null -O - |grep \#errors|cut -d\> -f3|cut -d\< -f1 > aut
if [ ! "$(diff aut scripts/25/aut|wc -l)" -eq "0" ]; then
	echo "css autarquicas: incumprimento pode já não existir";
	maybeOK=1;
fi
rm aut

# TODO: check http://accessmonitor.acessibilidade.gov.pt/amp/results/eleicoes.mai.gov.pt%2Feuropeias2019%2Festrangeiro.html

if [ "$maybeOK" -eq "0" ]; then
	echo "eleicoes: Incumprimento mantém-se, a actualizar o README (faça um git diff, valide, e commit!)";
	while IFS='' read -r line || [[ -n "$line" ]]; do
		test $(echo "$line"|grep -v eleicoes|wc -l) -eq "1" \
			&& echo "$line" \
			|| (h=$(echo "$line"|cut -d\| -f1-4); t=$(echo "$line"|cut -d\| -f6-); echo "$h| $(date +%Y/%m/%d) |$t");
	done < README.md > new
	mv new README.md
fi
