#! /bin/zsh

source tennis/tennis_utils.sh
sport_name=tennis

max_cote=1.30
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
		betclic_lines=$(echo $single_match | grep -A 8 "trout.*betclic" | egrep -A 1 "<td class=(\"bet highlight|\"bet )")
		first_cote=$(echo $betclic_lines | egrep -m1 -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		second_cote=$(echo $betclic_lines | egrep -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		first_cote=$(hexascii_to_deci)
		print_colorz_bet
		# players with ranking
		players=$(echo $single_match | grep "<a class=\"otn\"" | grep -o ">.*<" | tr -d "<>")
		pl1=$(echo $players | sed '1p;d')
		pl2=$(echo $players | sed '2p;d') 
		if [[ $(echo $compet | grep -i "double" ) ]] ;
		then
			pl1_bis=$(echo $pl1 | cut -d'&' -f2) ; pl1=$(echo $pl1 | cut -d'&' -f1)
			pl2_bis=$(echo $pl2 | cut -d'&' -f2) ; pl2=$(echo $pl2 | cut -d'&' -f1)
			echo "$pl1 - ranked $(get_rank $pl1)"
			echo "$pl1_bis - ranked $(get_rank $pl1_bis)"
			echo "$pl2 - ranked $(get_rank $pl2)"
			echo "$pl2_bis - ranked $(get_rank $pl2_bis)"
		else
			echo "$pl1 - ranked $(get_rank $pl1)"
			echo "$pl2 - ranked $(get_rank $pl2)"
		fi	
		echo "----------------------------------"
		i=$(($i+1))
	done
done