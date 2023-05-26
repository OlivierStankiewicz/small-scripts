#!/bin/bash
while [[ $INPUT != 8 ]]
do
echo
if [ -z "$FILE_NAME" ]; then
	menu1="1 - Podanie nazwy pliku (domyslnie bede szukal wszystkich ktore spelnia pozostale warunki)"
else
	menu1="1 - Podana nazwa pliku: $FILE_NAME"
fi

if [ -z "$DIR_NAME" ]; then
	menu2="2 - Podanie sciezki do pliku (przeszukam rekurencyjnie w dol, domyslnie z tego miejsca w ktorym teraz jestes)"
else
	menu2="2 - Podana sciezka: $DIR_NAME (przeszukam rekurencyjnie w dol)"
fi

if [ -z "$LAST_MOD" ]; then
	menu3="3 - Filtrowanie po czasie ostatniej modyfikacji"
else
	menu3="3 - Pliki modyfikowane mniej niz $LAST_MOD minut temu"
fi

if [ -z "$MAX_SIZE" ]; then
	menu4="4 - Filtrowanie po maksymalnym rozmiarze"
else
	menu4="4 - Pliki mniejsze niz $MAX_SIZE"
fi

if [ -z "$EXT" ]; then
	menu5="5 - Filtrowanie po rozszezeniu"
elif [ "$EXT" = "bez" ]; then
	menu5="5 - Pliki bez rozszezenia"
else
	menu5="5 - Pliki z rozszezeniem .$EXT"
fi

if [ "$DISPLAY" = true ]; then
	menu6="6 - Wyswietlanie zawartosc pliku wlaczone"
else
	menu6="6 - Wyswietlanie zawartosc pliku wylaczone"
fi

menu7="7 - Szukaj"
menu8="8 - Koniec"

MENU=("$menu1" "$menu2" "$menu3" "$menu4" "$menu5" "$menu6" "$menu7" "$menu8")
INPUT=$(zenity --list --title "Wyszukiwarka" --column=MENU "${MENU[@]}" --height 320 --width 800)

case "$INPUT" in
	$menu1) FILE_NAME=$(zenity --entry --title "Wyszukiwarka" --text "Nazwa pliku")
	if [ -z "$FILE_NAME" ]; then
	FILE_CMD=""
	else
	FILE_CMD="-name $FILE_NAME"
	fi;;
	$menu2) DIR_NAME=$(zenity --entry --title "Wyszukiwarka" --text "Podaje nazwe katalogu")
	if [ -z "$DIR_NAME" ]; then
	DIR_CMD=""
	else
	DIR_CMD="/home/olst/$DIR_NAME"
	fi;;
	$menu3) LAST_MOD=$(zenity --entry --title "Wyszukiwarka" --text "Maksymalna liczba minut od ostatniej modyfikacji pliku")
	if [ -z "$LAST_MOD" ]; then
	LAST_MOD_CMD=""
	else
	LAST_MOD_CMD="-mmin -$LAST_MOD"
	fi;;
	$menu4) MAX_SIZE=$(zenity --entry --title "Wyszukiarka" --text "Maksymalny rozmiar pliku")
	if [ ! -z "$MAX_SIZE" ]; then
	UNIT=$(zenity --entry --title "Wyszukiwarka" --text "Jednostka (c - bajty, k - kilo, M - mega, G - giga)")
	if [ "$UNIT" = "c" ] || [ "$UNIT" = "k" ] || [ "$UNIT" = "M" ] || [ "$UNIT" = "G" ]; then
	MAX_SIZE+="${UNIT}"
	else
	zenity --info --title "Wyszukiwarka" --text "Nie znam takiej jednostki"
	MAX_SIZE=""
	fi
	fi
	if [ -z "$MAX_SIZE" ]; then
	MAX_SIZE_CMD=""
	else
	MAX_SIZE_CMD="-size -$MAX_SIZE"
	fi;;
	$menu5) EXT=$(zenity --entry --title "Wyszukiwarka" --text "Rozszerzenie pliku (jesli chcesz bez wpisz 'bez')") ;;
	$menu6) if [ $DISPLAY = true ]; then
	zenity --info --title "Wyszukiwarka" --text "Nie bede wyswietlal zawartosci plikow"
	DISPLAY=false
	else
	zenity --info --title "Wyszukiwarka" --text "Jesli plik zostanie znaleziony to wyswietle jego zawartosc jak bede mial prawa"
	DISPLAY=true
	fi;;
	$menu7) if [ -z "$EXT" ]; then
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD)
	elif [ "$EXT" = "bez" ]; then
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD ! -name '*.*')
	else
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD -name "*.$EXT")
	fi
	if [ -z "$result" ]; then
	zenity --info --title "Wyszukiwarka" --text "Niestety nie znalazlem"
	else
	zenity --info --title "Wyszukiwarka" --text "Znalazlem"
		if [ $DISPLAY = true ]; then
		cat $result | zenity --text-info --title "Zawartosc znalezionych plikow"
		fi
	fi;;
	$menu8) INPUT=8 ;;
esac
done
