#!/bin/bash
clear

# Установка обязательных компонентов
function install_wine_components() {
    echo "Установка компонентов Wine..."
    echo ""
    
    # Основные компоненты Wine
    echo "Устанавливаю wine-gecko, wine-mono, winetricks..."
    sudo pacman -S wine-gecko wine-mono winetricks --noconfirm
    
    # Базовые 32-битные библиотеки
    echo ""
    echo "Устанавливаю 32-битные библиотеки..."
    sudo pacman -S \
        lib32-alsa-lib \
        lib32-alsa-plugins \
        lib32-libpulse \
        lib32-openal \
        lib32-mesa \
        --noconfirm
    
    echo ""
    echo "Компоненты установлены"
}

# Удаление компонентов
function remove_wine_components_choice() {
    echo ""
    echo "Удалить компоненты Wine? (gecko, mono, winetricks, 32-битные библиотеки)"
    echo "1) Удалить все компоненты"
    echo "2) Оставить компоненты"
    echo "3) Удалить только winetricks"
    read -p "Выберите [1-3]: " choice
    
    case $choice in
        1)
            echo "Удаляю компоненты..."
            for pkg in wine-mono wine-gecko winetricks; do
                if pacman -Qs "$pkg" > /dev/null; then
                    sudo pacman -Rns "$pkg" --noconfirm
                fi
            done
            
            # Удаляем 32-битные библиотеки
            for pkg in lib32-alsa-lib lib32-alsa-plugins lib32-libpulse lib32-openal lib32-mesa; do
                if pacman -Qs "$pkg" > /dev/null; then
                    sudo pacman -Rns "$pkg" --noconfirm
                fi
            done
            echo "Все компоненты удалены"
            ;;
        2)
            echo "Компоненты оставлены"
            ;;
        3)
            if pacman -Qs winetricks > /dev/null; then
                echo "Удаляю winetricks..."
                sudo pacman -Rns winetricks --noconfirm
            fi
            ;;
    esac
}

# Удаление wine_stable    
function remove_wine_stable() {
    echo "Проверяю wine-stable..."
    if ! command -v yay > /dev/null; then
        echo "yay не установлен"
        return 1
    fi

    if yay -Qs wine-stable > /dev/null 2>&1; then
        remove_wine_components_choice
        echo ""
        echo "Удаляю wine-stable..."
        yay -Rs wine-stable
        echo "wine-stable удален"
    else
        echo "wine-stable не установлен"
    fi
    read -p "Нажмите enter..."
}

function remove_wine_staging() {
    echo "Проверяю wine-staging..."
    if pacman -Qs wine-staging > /dev/null; then
        remove_wine_components_choice
        echo ""
        echo "Удаляю wine-staging..."
        sudo pacman -Rns wine-staging
        echo "wine-staging удален"
    else
        echo "wine-staging не установлен"
    fi
    read -p "Нажмите enter..."
}

# Установка
function install_wine_stable() {
    clear
    echo "Установка wine-stable"
    echo ""
    
    if ! command -v yay > /dev/null; then
        echo "yay не установлен"
        read -p "Нажми Enter..."
        return
    fi
    
    echo "Устанавливаю wine-stable..."
    yay -S wine --noconfirm
    
    if [ $? -eq 0 ]; then
        echo "wine-stable установлен"
        echo ""
        install_wine_components
    else
        echo "Ошибка установки"
    fi
    
    read -p "Нажмите enter..."
}

function install_wine_staging() {
    clear
    echo "Установка wine-staging"
    echo ""
    
    echo "Устанавливаю wine-staging..."
    sudo pacman -S wine-staging --noconfirm
    
    if [ $? -eq 0 ]; then
        echo "wine-staging установлен"
        echo ""
        install_wine_components
    else
        echo "Ошибка установки"
    fi
    
    read -p "Нажмите enter..."
}

# Меню удаления
function remove_menu() {
    while true; do
        clear
        echo "                                              _            "
		echo "                                             (_)           "
		echo " _ __ ___ _ __ ___   _____   _____  __      ___ _ __   ___ "
		echo "| '__/ _ \ '_   _ \ / _ \ \ / / _ \ \ \ /\ / / | '_ \ / _ |"
		echo "| | |  __/ | | | | | (_) \ V /  __/  \ V  V /| | | | |  __/"
		echo "|_|  \___|_| |_| |_|\___/ \_/ \___|   \_/\_/ |_|_| |_|\___|"
        echo ""
        echo "1) Удалить wine-stable"
        echo "2) Удалить wine-staging"
        echo "3) Назад"
        echo ""
        read -p "Выберите вариант [1-3]: " option

        case $option in
            1) remove_wine_stable ;;
            2) remove_wine_staging ;;
            3) return ;;
            *) 
                echo "Неверный выбор"
                sleep 1 
                ;;
        esac
    done
}

# Меню установки
function install_menu() {
    while true; do
        clear
        echo " _           _        _ _            _            "
		echo "(_)         | |      | | |          (_)           "
		echo " _ _ __  ___| |_ __ _| | | __      ___ _ __   ___ "
		echo "| |  _ \/ __| __/ _  | | | \ \ /\ / / |  _ \ / _ /"
		echo "| | | | \__ \ || (_| | | |  \ V  V /| | | | |  __/"
		echo "|_|_| |_|___/\__\__ _|_|_|   \_/\_/ |_|_| |_|\___|"
        echo ""
        echo "1) Установить wine-stable (AUR)"
        echo "2) Установить wine-staging (официальный)"
        echo "3) Назад"
        echo ""
        read -p "Выберите вариант [1-3]: " option
        
        case $option in
            1) install_wine_stable ;;
            2) install_wine_staging ;;
            3) return ;;
            *) 
                echo "Неверный выбор"
                sleep 1 
                ;;
        esac
    done
}

# Главное меню
while true; do
    clear
    echo "          _              _           _        _ _ "
    echo "         (_)            (_)         | |      | | |"
	echo "__      ___ _ __   ___   _ _ __  ___| |_ __ _| | |"
	echo "\ \ /\ / / | '_ \ / _ \ | | '_ \/ __| __/ _  | | |"
	echo " \ V  V /| | | | |  __/ | | | | \__ \ || (_| | | |"
	echo "  \_/\_/ |_|_| |_|\___| |_|_| |_|___/\__\__,_|_|_|"
	echo ""
    echo "1) Установить Wine"
    echo "2) Удалить Wine"
    echo "3) Выход"
    echo ""
    read -p "Выберите действие [1-3]: " main_option
    
    case $main_option in
        1) install_menu ;;
        2) remove_menu ;;
        3) 
            clear
            exit 0
            ;;
        *) 
            echo "Неверный выбор"
            sleep 1 
            ;;
    esac
done