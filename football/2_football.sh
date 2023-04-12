#! /bin/zsh

source football_utils.sh
sport_name=football

max_cote=1.35
compets_name+=($(echo $1))

# treatment of each compet
for compet in $compets_name ;
do
	cat $sport_name/req_$compet | egrep -q "<table class=\"bettable\"" || {echo "pas de bet_table pour $sport_name et $compet" && continue}
	nb_match=$(cat $sport_name/req_$compet | egrep "<tr style=\"background-color:white\"" | wc -l)
	[[ $(echo "$nb_match") -lt 1 ]] && echo "pas de match pour $compet" && continue
	echo "\033[1;44m$nb_match matchs pour $compet\033[m"
	echo "----------------------------------"
	all_match_infos=$(cat $sport_name/req_$compet | egrep -A 30 "<td width=\"330\" class=\"maincol ")
	i=1
	# treatment of each match
	while [[ $i -le $nb_match ]] ;
	do
		# match time
		single_match=$(echo $all_match_infos | egrep -m$i -A 30 "<td width=\"330\" class=\"maincol " | tail -n 30)
		match_time=$(echo $single_match | egrep -o "[A-Z]?[a-z]{4,7}[ ]*[0-9]{1,2}[ ]*[a-z]{3,9}[ ]*[0-9]{4}[ ]*&agrave;[ ]*[0-9]{2}h[0-9]{2}" | sed s'/&agrave;//g' | tr -s " ")
		echo $match_time
		# bets
		betclic_lines=$(echo $single_match | grep -A 13 "trout.*betclic" | egrep -A 1 "<td class=(\"bet highlight|\"bet )")
		first_cote=$(echo $betclic_lines | egrep -m1 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		second_cote=$(echo $betclic_lines | egrep -m2 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		third_cote=$(echo $betclic_lines | egrep -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		first_cote=$(hexascii_to_deci)
		print_colorz_bet
		# team with ranking
		teams=$(echo $single_match | grep "<a class=\"otn\"" | grep -o ">.*<" | tr -d "<>")
		team_1=$(echo $teams | sed '1p;d')
		team_2=$(echo $teams | sed '2p;d') 
		echo "$team1 - ranked $(get_rank $pl1)"
		echo "$team2 - ranked $(get_rank $pl2)"
		echo "----------------------------------"
		i=$(($i+1))
	done
done
