#! /bin/zsh
ranking_site=https://www.tennisendirect.net/atp/classement/
#needed for women
compets_name+=($(echo "Monte-Carlo-(Masters)-ed817 Houston-(250-Series)-ed815 Estoril-(250-Series)-ed821 Charleston-(Premier-Events)-ed878 Bogota-(Intl.-Events)-ed871 Doubles-(Femmes)-ed254"))

# treatment of each compet
for compet in $compets_name ;
do
	cat req_$compet | egrep -q "<table class=\"bettable\"" || {echo "pas de bet_table pour $sport_name et $compet" && continue}
	nb_match=$(cat req_$compet | egrep "<tr style=\"background-color:white\"" | wc -l)
	[[ $(echo "$nb_match") -lt 1 ]] && echo "pas de match pour $compet" && continue
	echo "$nb_match matchs pour $compet"
	all_match_infos=$(cat req_$compet | egrep -A 30 "<td width=\"330\" class=\"maincol ")
	i=1
	# treatment of each match
	while [[ $i -le $nb_match ]] ;
	do
		single_match=$(echo $all_match_infos | egrep -m$i -A 30 "<td width=\"330\" class=\"maincol " | tail -n 30)
		match_time=$(echo $single_match | egrep -o "[A-Z]?[a-z]{4,7}[ ]*[0-9]{1,2}[ ]*[a-z]{3,9}[ ]*[0-9]{4}[ ]*&agrave;[ ]*[0-9]{2}h[0-9]{2}" | sed s'/&agrave;//g' | tr -s " ")
		echo $match_time
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
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
			echo "$pl1_bis"
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl1_bis" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
			echo "pl2 $pl2"
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl2" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
			echo "pl2_bis $pl2_bis"
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl2_bis" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
		else
			echo "pl1 $pl1"
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl1" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
			echo "pl2 $pl2"
			echo "ranked $(curl -s $ranking_site | sed s/"<tr"/\\n/g | grep -i "$pl2" | egrep -o "class=\"w20\">[0-9]{1,3}" | cut -d'>' -f2)"
		fi	
		i=$(($i+1))
	done
done

#PAS BESOIN DE CURL A CHAQUE FOIS FAIRE UNE SEULE REQ DE TENNISDIRECT PUIS GREP DESSUS
#classement hommes vs femmes
#exterioriser le ranking pour mieux gerer si pas trouve etc