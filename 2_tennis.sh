#! /bin/zsh

max_cote=1.30

function hexascii_to_deci()
{
	ref_file=hex_ascii_html.txt
	deci=""
	char_nb=$(echo $first_cote | grep -o ";" | wc -l | tr -d "[:blank:]")
	j=1
	while [[ $j -le $char_nb ]] ; 
	do
		deci+=$(cat $ref_file | grep "$(echo $first_cote | cut -d';' -f$j)" | cut -d' ' -f1)
		j=$(($j+1))
	done
	echo -n $deci
}

function print_colorz_bet()
{
	if [[ $first_cote -le $max_cote ]] || [[ $second_cote -le $max_cote ]] ;
	then
		echo "\033[42m$first_cote - $second_cote \033[m"
		
	else
		echo "\033[41m$first_cote - $second_cote \033[m"
	fi
}

# men
ranking_site_m=https://www.tennisendirect.net/atp/classement/
ranking_men_data=$(curl -i -s $ranking_site_m)
code_m=$(echo $ranking_men_data | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ -z $code_m ]] && echo "Erreur requete ranking men : pas de code retour" && exit 3
[[ $(echo $code_m) != 200 ]] && echo "Erreur requete ranking men, code : $code_m" && exit 4
# women
ranking_site_w=https://www.tennisendirect.net/wta/classement/
ranking_women_data=$(curl -i -s $ranking_site_w)
code_w=$(echo $ranking_women_data | egrep -m1 "^HTTP" | egrep -o "[0-9]{3}")
[[ -z $code_w ]] && echo "Erreur requete ranking men : pas de code retour" && exit 3
[[ $(echo $code_w) != 200 ]] && echo "Erreur requete ranking men, code : $code_w" && exit 4


compets_name+=($(echo "Monte-Carlo-(Masters)-ed817"))

# treatment of each compet
for compet in $compets_name ;
do
	cat req_$compet | egrep -q "<table class=\"bettable\"" || {echo "pas de bet_table pour $sport_name et $compet" && continue}
	nb_match=$(cat req_$compet | egrep "<tr style=\"background-color:white\"" | wc -l)
	[[ $(echo "$nb_match") -lt 1 ]] && echo "pas de match pour $compet" && continue
	echo "\033[1;44m$nb_match matchs pour $compet\033[m"
	echo "----------------------------------"
	all_match_infos=$(cat req_$compet | egrep -A 30 "<td width=\"330\" class=\"maincol ")
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
			pl1_bis=$(echo $pl1 | cut -d'&' -f2)
			pl1=$(echo $pl1 | cut -d'&' -f1)
			pl2_bis=$(echo $pl2 | cut -d'&' -f2)
			pl2=$(echo $pl2 | cut -d'&' -f1)
			echo "pl1 $pl1"
			echo "ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
			echo "$pl1_bis"
			echo "ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl1_bis" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
			echo "pl2 $pl2"
			echo "ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl2" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
			echo "pl2_bis $pl2_bis"
			echo "ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl2_bis" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
		else
			echo "$pl1 - ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
			echo "$pl2 - ranked $(echo $ranking_men_data | sed s/"<tr"/\\n/g | grep -i "$pl2" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2 | uniq)"
		fi	
		echo "----------------------------------"
		i=$(($i+1))
	done
done



#classement hommes vs femmes
#exterioriser le ranking pour mieux gerer si pas trouve etc