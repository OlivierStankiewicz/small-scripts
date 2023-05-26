#!/bin/bash
while [[ $INPUT != 8 ]]
do
clear
echo
if [ -z "$FILE_NAME" ]; then
	echo "1 - Podanie nazwy pliku (domyslnie bede szukal wszystkich ktore spelnia pozostale warunki)"
else
	echo "1 - Podana nazwa pliku: $FILE_NAME"
fi

if [ -z "$DIR_NAME" ]; then
	echo "2 - Podanie sciezki do pliku (przeszukam rekurencyjnie w dol, domyslnie z tego miejsca w ktorym teraz jestes)"
else
	echo "2 - Podana sciezka: $DIR_NAME (przeszukam rekurencyjnie w dol)"
fi

if [ -z "$LAST_MOD" ]; then
	echo "3 - Filtrowanie po czasie ostatniej modyfikacji"
else
	echo "3 - Pliki modyfikowane mniej niz $LAST_MOD minut temu"
fi

if [ -z "$MAX_SIZE" ]; then
	echo "4 - Filtrowanie po maksymalnym rozmiarze"
else
	echo "4 - Pliki mniejsze niz $MAX_SIZE"
fi

if [ -z "$EXT" ]; then
	echo "5 - Filtrowanie po rozszezeniu"
elif [ "$EXT" = "bez" ]; then
	echo "5 - Pliki bez rozszezenia"
else
	echo "5 - Pliki z rozszezeniem .$EXT"
fi

if [ "$DISPLAY" = true ]; then
	echo "6 - Wyswietlanie zawartosc pliku wlaczone"
else
	echo "6 - Wyswietlanie zawartosc pliku wylaczone"
fi

echo "7 - Szukaj"
echo "8 - Koniec"
echo
read INPUT
echo

case $INPUT in
	1) echo "Nazwa pliku: "
	read FILE_NAME
	if [ -z "$FILE_NAME" ]; then
	FILE_CMD=""
	else
	FILE_CMD="-name $FILE_NAME"
	fi;;
	2) echo "Podaj nazwe katalogu: "
	read DIR_NAME
	if [ -z "$DIR_NAME" ]; then
	DIR_CMD=""
	else
	DIR_CMD="/home/olst/$DIR_NAME"
	fi;;
	3) echo "Maksymalna liczbe minut od ostatniej modyfikacji pliku: "
	read LAST_MOD
	if [ -z "$LAST_MOD" ]; then
	LAST_MOD_CMD=""
	else
	LAST_MOD_CMD="-mmin -$LAST_MOD"
	fi;;
	4) echo "Maksymalny rozmiar pliku: "
	read MAX_SIZE
	if [ ! -z "$MAX_SIZE" ]; then
	echo "Jednostka (c - bajty, k - kilo, M - mega, G - giga)"
	read UNIT
	if [ "$UNIT" = "c" ] || [ "$UNIT" = "k" ] || [ "$UNIT" = "M" ] || [ "$UNIT" = "G" ]; then
	MAX_SIZE+="${UNIT}"
	else
	echo "Nie znam takiej jednostki"
	MAX_SIZE=""
	fi
	fi
	if [ -z "$MAX_SIZE" ]; then
	MAX_SIZE_CMD=""
	else
	MAX_SIZE_CMD="-size -$MAX_SIZE"
	fi;;
	5) echo "Rozszezenie pliku (jesli chcesz bez wpisz 'bez'): "
	read EXT;;
	6) if [ $DISPLAY = true ]; then
	echo "Nie bede wyswietlal zawartosci plikow"
	DISPLAY=false
	else
	echo "Jesli plik zostanie znaleziony to wyswietle jego zawartosc jak bede mial prawa"
	DISPLAY=true
	fi;;
	7) echo "Szukam!"
	echo
	if [ -z "$EXT" ]; then
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD)
	elif [ "$EXT" = "bez" ]; then
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD ! -name '*.*')
	else
	result=$(find $DIR_CMD -type f $FILE_CMD $LAST_MOD_CMD $MAX_SIZE_CMD -name "*.$EXT")
	fi
	if [ -z "$result" ]; then
	echo "Niestety nie znalazlem"
	else
	echo "Znalazlem"
		if [ $DISPLAY = true ]; then
		echo
		echo "Oto zawartosci znalezionych plikow:"
		cat $result
		echo
		fi
	fi;;
	8) echo "Do widzenia" ;;
	*) echo "Podana zostala zla wartoc";;
esac
echo
if [ ! $INPUT = 1 ] && [ ! $INPUT = 2 ] && [ ! $INPUT = 3 ] && [ ! $INPUT = 8 ]; then
echo "Enter - kontynuuj"
read
fi
done
