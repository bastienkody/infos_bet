#! /bin/zsh

#fichier des max cotes
[[ -e ~/.max_cote_infos_bet.txt ]] || {echo "No file \"~/.max_cote_infos_bet.txt\"" && exit 3}

# fichier de sortie - mettre "/dev/stdout" pour le terminal
outfile=result.txt

# print intro
echo "------------------------------------" > $outfile
echo "------------------------------------" >> $outfile
echo "\tSCRIPT INFOS_BET" >> $outfile
echo "Started at $(date +%R) - $(date +"%d %B %Y")" >> $outfile
echo "by $USER on $(uname -sm) $DESKTOP_SESSION" >> $outfile 
echo "------------------------------------" >> $outfile
echo "------------------------------------\n" >> $outfile

# lancement des scripts
zsh tennis/tennis.sh $outfile
zsh football/football.sh $outfile

# supp des fichiers de requetes (quote for debug)
rm -rf tennis/req*
rm -rf football/req*
