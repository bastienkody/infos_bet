#! /bin/zsh

sport_name=tennis

# get compets
req=$(curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name)
code=$(echo $req | egrep "^HTTP" | egrep -o "[0-9]{3}")
[[ -z $code ]] && echo "Erreur requete : pas de code retour" && exit 3
[[ $(echo $code) != 200 ]] && echo "Erreur requete code : $code" && exit 4
#echo $req

compets_name=($(echo $req | grep -o "<a href=\"comparateur/$sport_name/.*\"><" | grep -o "/[^/]*\"" | tr -d "/\""))
[[ -z "$compets_name[1]" ]] && echo "Pas d'entree pour la compet 1 de $sport_name. Verifiez compets_name" && exit 4
echo $compets_name

# request each compet
for compet in $compets_name ;
do
	curl -i -s http://www.comparateur-de-cotes.fr/comparateur/$sport_name/$compet > "req_$compet"
	code=$(cat req_$compet | egrep "^HTTP" | egrep -o "[0-9]{3}")
	[[ -z $code ]] && echo "Erreur requete : pas de code retour" && exit 5
	[[ $(echo $code) != 200 ]] && echo "Erreur requete code : $code" && exit 6
done


