#!/bin/bash
clear

#Вспомогательные функции удаления wine-gecko-mono
function remove_wine_components() {
	echo "Удаление компонентов wine..."
	for pkg in wine-mono wine-gecko; do
		if pacman -Qs "$pkg" > dev/null; then
		  echo "Удаляю $pkg..."
 	          sudo pacman -Rns "$pkg" --noconfirm
		else
		  echo "$pkg не установлен..."
		fi
	done
}

#Функции удаления wine_stable	
function remove_wine_stable() {
	echo "Проверяю wine-stable..."
	if ! command -v yay > dev/null; then
		echo "yay не установлен, проверка остановлена"
		return 1
	fi

	if yay -Qs wine-stable > /dev/null 2>&1; then
		echo "Удаляю wine-stable..."
		echo "---------------------"
		yay -Rs wine-stable 
		echo "---------------------"
		echo "wine-stable удален"
		remove_wine_components
	else
		echo "wine-stable не установлен"
	fi
	read -p "Нажмите enter..."
}

function remove_wine_staging() {
	echo "Проверяю wine-staging..."
	if pacman -Qs wine-staging > /dev/null; then
		echo "Удаляю wine-staging..."
		echo "-----------------------"
		sudo pacman -Rns wine-staging 
		echo "-----------------------"
		echo "wine-staging удален"
		remove_wine_components
	else
		echo "wine-staging не установлен"
	fi
}

#Меню удаления
function remove_menu() {
	while true; do
	   clear
	   echo "Выберите действие"
	   select option in "Удалить wine-stable" "Удалить wine-staging" "Назад"; do
		case $option in
		   "Удалить wine-stable")
		   remove_wine_stable
		   break
		   ;;
		
		   "Удалить wine-staging")
		   remove_wine_staging
		   break
		   ;;
		   
		   "Назад")
		   return
		   ;;
		esac
	   done
	done
}

#Главное меню
while true; do
	clear
	echo "Выберите опцию"
	select option in "Установить wine" "Удалить wine" "Выход"; do
	   case $option in
		"Установить wine")
		echo "Затычка"
		read -p "Нажмите enter..."
		break
		;;
		"Удалить wine")
		remove_menu
		break
		;;
		"Выход")
		exit 0
		;;
	   esac
	done
done
	
