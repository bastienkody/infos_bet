#! /bin/zsh

source football/football_utils.sh

outfile=$2

sport_name=football

max_cote=$(cat ~/.max_cote_infos_bet.txt | grep -ia $sport_name | cut -d'=' -f2)

compets_name+=($(echo $1))

# treatment of each compet
for compet in $compets_name ;
do
	#[[ $compet != "France-Ligue-1-ed3" ]] && continue
	cat $sport_name/req_$compet | egrep -q "<table class=\"bettable\"" || {echo "pas de bet_table pour $sport_name et $compet" >> $outfile && continue}
	nb_match=$(cat $sport_name/req_$compet | egrep "<tr style=\"background-color:white\"" | wc -l)
	[[ $(echo "$nb_match") -lt 1 ]] && echo "pas de match pour $compet" >> $outfile && continue
	echo "\033[1;44m$nb_match matchs pour $compet\033[m" >> $outfile 
	echo "----------------------------------" >> $outfile 
	all_match_infos=$(cat $sport_name/req_$compet | egrep -a -A 33 "<td width=\"[0-9].*\" class=\"maincol ")
	i=1
	# treatment of each match
	while [[ $i -le $nb_match ]] ;
	do
		# match time
		single_match=$(echo $all_match_infos | egrep -m$i -a -A 33 "<td width=\"[0-9].*\" class=\"maincol " | tail -n 33)
		match_time=$(echo $single_match | egrep -a -o "[A-Z]?[a-z]{4,7}[ ]*[0-9]{1,2}[ ]*[a-z]{3,9}[ ]*[0-9]{4}[ ]*&agrave;[ ]*[0-9]{2}h[0-9]{2}" | sed s'/&agrave;//g' | tr -s " ")
		echo $match_time >> $outfile

		# bets
		betclic_lines=$(echo $single_match | grep -A 13 "trout.*betclic" | egrep -A 1 "<td class=(\"bet highlight|\"bet )")
		[[ -z $betclic_lines ]] && {betclic_lines=$(echo $single_match | grep -i -A 13 "trout" | egrep -A 1 "<td class=(\"bet highlight|\"bet )") && echo "\033[3mCotes $(echo $single_match | grep -i trout | egrep -m1 -i -o "[a-z]*\">" | tr -d "\">") (pas de betclic)\033[m"} >> $outfile 
		first_cote=$(echo $betclic_lines | egrep -m1 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		second_cote=$(echo $betclic_lines | egrep -m2 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		third_cote=$(echo $betclic_lines | egrep -m3 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		first_cote=$(hexascii_to_deci)
		print_colorz_bet

		# team with ranking
		teams=$(echo $single_match | grep -a "<a class=\"otn\"" | iconv -c -f UTF-8 -t ASCII//TRANSLIT | grep -o ">.*<" | tr -d "<>")
		team_1=$(echo $teams | sed '1p;d')
		team_2=$(echo $teams | sed '2p;d')
		echo "$team_1 - $team_2" >> $outfile
		echo "----------------------------------" >> $outfile 
		i=$(($i+1))
	done
done
