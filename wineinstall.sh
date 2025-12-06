#!/bin/bash
clear

#Вспомогательные функции удаления wine-gecko-mono
function remove_wine_components() {
	echo "Удаление компонентов wine..."
	for pkg in wine-mono wine-gecko; do
		if pacman -Qs "pkg" > dev/null; then
		  echo "Удаляю $pkg..."
 	          sudo pacman -Rns wine-mono wine-gecko --noconfirm
		else
		  echo "$pkg не установлен...
		fi
	done
}
	
function remove_wine_stable() {
	if yay -Qs wine-stable > /dev/null 2>&1: then
		yay -Rs wine-stable
	else
		echo "wine-stable не установлен"
	fi
}

function remove_wine_staging() {
	if pacman -Qs wine-staging > dev/null; then
		sudo pacman -Rns wine-staging
	else
		echo "wine-staging не установлен"
	fi
}


echo "Выберите версию пакета:"

select option in "wine-stable[AUR]" "wine-staging" "exit"; do
	case $option in
	"wine-stable[AUR]") exit 0 ;;
	"wine-staging") exit 0 ;;
	*) echo "Неверный выбор" ;;
	esac
done
