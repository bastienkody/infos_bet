#! /bin/zsh

source tennis/tennis_utils.sh

outfile=$2

sport_name=tennis

max_cote=$(cat config_infos_bet.txt | grep -ia $sport_name | cut -d'=' -f2)

compets_name+=($(echo $1))

# treatment of each compet
for compet in $compets_name ;
do
	cat $sport_name/req_$compet | egrep -q "<table class=\"bettable\"" || {echo "pas de bet_table pour $sport_name et $compet" >> $outfile && continue}
	nb_match=$(cat $sport_name/req_$compet | egrep -a "<tr style=\"background-color:white\"" | wc -l | tr -d "[:blank:]")
	[[ $(echo "$nb_match") -lt 1 ]] && echo "pas de match pour $compet" >> $outfile && continue
	echo "\033[1;44m$compet ($nb_match)\033[m" >> $outfile
	echo "----------------------------------" >> $outfile
	all_match_infos=$(cat $sport_name/req_$compet | egrep -a -A 30 "<td width=\"330\" class=\"maincol ")
	i=1
	# treatment of each match
	while [[ $i -le $nb_match ]] ;
	do
		# match time
		single_match=$(echo $all_match_infos | egrep -m$i -a -A 30 "<td width=\"330\" class=\"maincol " | tail -n 30)
		match_time=$(echo $single_match | egrep -a -o "[A-Z]?[a-z]{4,7}[ ]*[0-9]{1,2}[ ]*[a-z]{3,9}[ ]*[0-9]{4}[ ]*&agrave;[ ]*[0-9]{2}h[0-9]{2}" | sed s'/&agrave;//g' | tr -s " ")
		echo $match_time >> $outfile

		# bets
		betclic_lines=$(echo $single_match | grep -a -A 8 "trout.*betclic" | egrep -A 1 "<td class=(\"bet highlight|\"bet )")
			[[ -z $betclic_lines ]] && {betclic_lines=$(echo $single_match | grep -i -A 8 "trout" | egrep -A 1 "<td class=(\"bet highlight|\"bet )") && echo "\033[3mCotes $(echo $single_match | grep -i trout | egrep -m1 -i -o "[a-z]*\">" | tr -d "\">") (pas de betclic)\033[m"} >> $outfile
			first_cote=$(echo $betclic_lines | egrep -m1 -a -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		second_cote=$(echo $betclic_lines | egrep -a -A 1 "<td class=(\"bet highlight|\"bet )" | tail -n 1 | tr -d "[:blank:]")
		first_cote=$(hexascii_to_deci)
		print_colorz_bet

		# players with ranking
		players=$(echo $single_match | grep -a "<a class=\"otn\"" | iconv -c -f UTF-8 -t ASCII//TRANSLIT | grep -o ">.*<" | tr -d "<>")
		pl1=$(echo $players | sed '1p;d')
		pl2=$(echo $players | sed '2p;d') 
		if [[ $(echo $compet | grep -a -i "double" ) ]] ;
		then
			pl1_bis=$(echo $pl1 | cut -d'&' -f2) ; pl1=$(echo $pl1 | cut -d'&' -f1)
			pl2_bis=$(echo $pl2 | cut -d'&' -f2) ; pl2=$(echo $pl2 | cut -d'&' -f1)
			echo "$pl1 - ranked $(get_rank $pl1)" >> $outfile
			echo "$pl1_bis - ranked $(get_rank $pl1_bis)" >> $outfile
			echo "$pl2 - ranked $(get_rank $pl2)" >> $outfile
			echo "$pl2_bis - ranked $(get_rank $pl2_bis)" >> $outfile
		else
			echo "$pl1 - ranked $(get_rank $pl1)" >> $outfile
			echo "$pl2 - ranked $(get_rank $pl2)" >> $outfile
		fi	
		echo "----------------------------------" >> $outfile
		i=$(($i+1))
	done
done


