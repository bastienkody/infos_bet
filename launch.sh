#! /bin/zsh

source config_infos_bet.txt

[[ -z $outfile ]] && echo "Specify outfile in config_infos_bet.txt (/dev/stdout for none)" && exit 3

# print intro
echo "------------------------------------" > $outfile
echo "------------------------------------" >> $outfile
echo "\tSCRIPT INFOS_BET" >> $outfile
echo "Started at $(date +%R) - $(date +"%d %B %Y")" >> $outfile
echo "by $USER on $(uname -sm) $DESKTOP_SESSION" >> $outfile 
echo "outfile : $outfile" >> $outfile
echo "max odds : $(cat config_infos_bet.txt | grep football) $(cat config_infos_bet.txt | grep tennis) "
echo "------------------------------------" >> $outfile
echo "------------------------------------\n" >> $outfile

# lancement des scripts
zsh tennis/tennis.sh $outfile
zsh football/football.sh $outfile

# supp des fichiers de requetes (quote for debug)
rm -rf tennis/req*
rm -rf football/req*
