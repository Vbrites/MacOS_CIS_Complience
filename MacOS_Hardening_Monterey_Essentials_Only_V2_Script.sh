#!/bin/bash

# Desabilitar sudo timeout temporariamente
saida_comando58=$(
    {
        echo "Defaults timestamp_timeout=500"
        echo "Defaults timestamp_type=tty"
    } | sudo tee /etc/sudoers.d/10_cissudoconfiguration > /dev/null
)

# Função para exibir barra de progresso int
exibir_barra_progresso() {
    local largura_barra=50
    local progresso=$1
    local preenchimento=$((progresso * largura_barra / 100))

    # Mover o cursor para cima antes de imprimir a próxima linha
    printf "\033[A"

    # Limpar a linha
    printf "\033[K"

    # Exibe o item CIS
    printf "CIS Item: $CIS_item\n"
    printf "\033[K"
    printf "Wazuh_ID: $Wazuh_id\n"
    
    printf "\033[K"
    printf "> Status: "
    printf "\033[K"
    printf "["
    for ((j = 0; j < preenchimento; j++)); do
        printf "*"
    done
    printf "%-$((largura_barra - preenchimento))s" "]"
    printf " %d%%\r" "$progresso"
}

# --------------------------------------------------------------------------------------
# Função para execução de comandos e armazenar saídas
executar_comandos() {
    # Inicializar progresso
    progresso=0
    proporcao=$(echo "100 / 77" | bc)

    resto=4

    # --------------------------------------------------------------------------------------
    # Executar comando 1
    CIS_item="1.6   Ensure Install of macOS Updates Is Disabled."
    Wazuh_id="29005"
    saida_comando1=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false)
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 2
    CIS_item="1.1   Ensure All Apple-provided Software Is Current."
    Wazuh_id="29000"
#    saida_comando2=$(/usr/bin/sudo /usr/sbin/softwareupdate -l 2>&1 > /dev/null)
    # Verificar se a saída contém "No updates available"
#    if [[ $saida_comando2 == *"No new software available."* ]]; then
#    resultado="Sucesso"
#   else
#    resultado="Erro"
#    fi
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 3
    CIS_item="1.2   Ensure Auto Update Is Enabled."
    Wazuh_id="29001"
    saida_comando3=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true)
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 4
    CIS_item="1.3   Ensure Download New Updates When Available Is Enabled."
    Wazuh_id="29002"
    saida_comando4=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool)
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 5
    CIS_item="1.4   Ensure Installation of App Update Is Enabled."
    Wazuh_id="29003"
    saida_comando5=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true)
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05
   
    # -------------------------------------------------------------------------------------- 
    # Executar comando 6
    CIS_item="1.5   Ensure System Data Files and Security Updates Are Downloaded Automatically Is Enabled."
    Wazuh_id="29004"
    saida_comando6=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true ; /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true)
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 7
    # CIS_item="1.5   Ensure Bluetooth is disabled if No devices Are Paired."
    # Wazuh_id="29006"
    # #saida_comando7=$(sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0 && sudo killall -HUP bluetoohd)
    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 8
    CIS_item="1.5   Ensure Show Bluetooth Status in Menu Bar is Enabled."
    Wazuh_id="29007"
    comando8="sudo -u <username> defaults -currentHost write com.apple.controlcenter.plist Bluetooth -int 18"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando8=$(eval "${comando8//<username>/$home_directory}")
        fi
    done
    
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 9
    CIS_item="2.2.1 Ensure Set time and date automatically Is Enabled."
    Wazuh_id="29008"
    saida_comando9=$(/usr/bin/sudo /usr/sbin/systemsetup -settimezone America/Sao_Paulo 2>&1 > /dev/null ; /usr/bin/sudo /usr/sbin/systemsetup -setnetworktimeserver time.apple.com 2>&1 > /dev/null ; /usr/bin/sudo /usr/sbin/systemsetup -setusingnetworktime on 2>&1 > /dev/null)
    
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 10
    CIS_item="2.2.2 Ensure Time Is Set Within Appropriate Limits."
    Wazuh_id="29009"
    saida_comando10=$(sudo sntp -sS time.apple.com > /dev/null 2>&1)
    
    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 11
    # CIS_item="2.3.1	Ensure an Inactivity Interval of 20 Minutes Or Less for the Screen Saver Is Enabled."
    # Wazuh_id="29010"
    # comando11="sudo -u <username> /usr/bin/defaults -currentHost write com.apple.screensaver idleTime -int 600"
    # check_users=$(ls /Users/)

    # # Iterar sobre os diretórios de home dos usuários
    # for home_directory in $check_users; do
    #     if [ "$home_directory" != "Shared" ]; then
    #         saida_comando11=$(eval "${comando11//<username>/$home_directory}")
    #     fi
    # done

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 12
    CIS_item="2.3.2 Ensure Screen Saver Corners Are Secure."
    Wazuh_id="29011"
    comando12="sudo -u <username> /usr/bin/defaults write com.apple.dock wvous-tl-corner -int 0 ; sudo -u <username> /usr/bin/defaults write com.apple.dock wvous-bl-corner -int 0 ; sudo -u <username> /usr/bin/defaults write com.apple.dock wvous-tr-corner -int 0 ; sudo -u <username> /usr/bin/defaults write com.apple.dock wvous-br-corner -int 0"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando12=$(eval "${comando12//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 13
    CIS_item="2.4.1 Ensure Remote Apple Events is Disabled."
    Wazuh_id="29012"
    saida_comando13=$(sudo systemsetup -setremoteappleevents off)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 14
    CIS_item="2.4.2 Ensure Internet Sharing is Disabled."
    Wazuh_id="29013"
    saida_comando14=$(sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 15
    CIS_item="2.4.3 Ensure Screen Sharing is Disabled."
    Wazuh_id="29014"
    saida_comando15=$(/usr/bin/sudo /bin/launchctl disable system/com.apple.screensharing)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 16
    CIS_item="2.4.4 Ensure Printer Sharing is Disabled."
    Wazuh_id="29015"
    saida_comando16=$(/usr/bin/sudo /usr/sbin/cupsctl --no-share-printers)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 17
    CIS_item="2.4.5 Ensure Remote Login is Disabled."
    Wazuh_id="29016"
    saida_comando17=$(/usr/bin/sudo /usr/sbin/systemsetup -setremotelogin off <<< "yes")

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 18
    CIS_item="2.4.6 Ensure DVD or CD Sharing is Disabled."
    Wazuh_id="29017"
    saida_comando18=$(/usr/bin/sudo /bin/launchctl disable system/com.apple.ODSAgent)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 19
    CIS_item="2.4.8 Ensure File Sharing is Disabled."
    Wazuh_id="29019"
    saida_comando19=$(/usr/bin/sudo /bin/launchctl disable system/com.apple.smbd)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 20
    CIS_item="2.4.9 Ensure Remote Management is Disabled."
    Wazuh_id="29020"
    saida_comando20=$(/usr/bin/sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 21
    CIS_item="2.4.10 Ensure Content Caching is Disabled."
    Wazuh_id="29021"
    saida_comando21=$(/usr/bin/sudo /usr/bin/AssetCacheManagerUtil deactivate 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 22
    CIS_item="2.4.11 Ensure AirDrop is Disabled."
    Wazuh_id="29022"
    comando22="/usr/bin/sudo -u <username> defaults write com.apple.NetworkBrowser DisableAirDrop -bool true"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando22=$(eval "${comando22//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 23
    CIS_item="2.4.12 Ensure Media Sharing is Disabled."
    Wazuh_id="29023"
    comando23="/usr/bin/sudo -u <username> /usr/bin/defaults write com.apple.amp.mediasharingd home-sharing-enabled -int 0"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando23=$(eval "${comando23//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 24
    CIS_item="2.4.13 Ensure AirPlay Receiver is Disabled."
    Wazuh_id="29024"
    comando24="/usr/bin/sudo -u <username> /usr/bin/defaults -currentHost write com.apple.controlcenter.plist AirplayRecieverEnabled -bool false"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando24=$(eval "${comando24//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 25
    CIS_item="2.5.2.1 Ensure Firewall is Enabled."
    Wazuh_id="29021"
    saida_comando25=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.alfglobalstate -int 1)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 26
    CIS_item="2.5.2.2 Ensure Firewall Stealth Mode is Enabled."
    Wazuh_id="29021"
    saida_comando26=$(/usr/bin/sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 27
    CIS_item="2.5.3 Ensure Location Services is Enabled."
    Wazuh_id="29021"
    saida_comando27=$(/usr/bin/sudo /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -bool false ; /usr/bin/sudo /bin/launchctl kickstart -k system/com.apple.locationd)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 28
    CIS_item="2.5.5 Ensure Sending Diagnostic and Usage Data to Apple is Disabled."
    Wazuh_id="29021"
    saida_comando28=$(/usr/bin/sudo /usr/bin/defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false ; /usr/bin/sudo /usr/bin/defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ThirdPartyDataSubmit -bool false ; /usr/bin/sudo /bin/chmod 644 /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ; /usr/bin/sudo /usr/bin/chgrp admin /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist)
    comando28_1="/usr/bin/sudo -u <username> /usr/bin/defaults write /Users/<username>/Library/Preferences/com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando28_1=$(eval "${comando28_1//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 29
    CIS_item="2.5.6 Ensure Limit Ad Tracking is Enabled."
    Wazuh_id="29021"
    comando29="/usr/bin/sudo -u <username> /usr/bin/defaults write /Users/<username>/Library/Preferences/com.apple.Adlib.plist allowApplePersonalizedAdvertising -bool false"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando29=$(eval "${comando29//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 30
    CIS_item="2.5.7 Ensure Gatekeeper is Enabled."SS
    Wazuh_id="29021"
    saida_comando30=$(/usr/bin/sudo /usr/sbin/spctl --master-enable)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # ----------------------------------------------------------------SS----------------------
    # Executar comando 31
    CIS_item="2.5.8 Ensure a Custom Message for the Login Screen is Enabled."
    Wazuh_id="29021"
    saida_comando31=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Acesso somente para pessoas autorizadas. \nEste sistema está sendo monitorado.")

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 32
    CIS_item="2.5.9 Ensure an Administrator Password is Required to Access System-Wide Preferences."
    Wazuh_id="29021"
    saida_comando32=$(/usr/bin/sudo /usr/bin/security authorizationdb read system.preferences > /$HOME/Desktop/system.preferences.plist 2>&1 > /dev/null ; /usr/bin/sudo plutil -replace shared -bool false "$HOME/Desktop/system.preferences.plist" ; /usr/bin/sudo /usr/bin/security authorizationdb write system.preferences < /$HOME/Desktop/system.preferences.plist 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 33
    # CIS_item="2.5.9 Ensure a Password is Required to Wake the Computer From Sleep or Screen Saver is Enabled."
    # Wazuh_id="29021"

    # exibir_barra_progresso $progresso

    # echo "\nEnter the administrator password: "
    # read -s administrator_password
    # echo "\n"
    # saida_comando33=$(/usr/bin/sudo /usr/sbin/sysadminctl -screenLock 5 seconds -password $administrator_password)

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # printf "\033[1A"
    # printf "\033[K"
    # printf "\033[3A"
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 34
    cpu_model=$(/usr/sbin/sysctl -n machdep.cpu.brand_string)
    CIS_item="2.8.1 Ensure the OS in Not Active When Resuming from Sleep and Display Sleep ($cpu_model)"
    Wazuh_id="29021"
    if [[ $cpu_model == *Apple* ]]; then
        saida_apple_comando34=$(/usr/bin/sudo /usr/bin/pmset -a sleep 10 ; /usr/bin/sudo /usr/bin/pmset -a displaysleep 15 ; /usr/bin/sudo /usr/bin/pmset -a hibernatemode 25)
    elif [[ $cpu_model == *Intel* ]]; then
        saida_intel_comando34=$(/usr/bin/sudo /usr/bin/pmset -a standbydelaylow 900 ; /usr/bin/sudo /usr/bin/pmset -a standbydelayhigh 900 ; /usr/bin/sudo /usr/bin/pmset -a highstandbythreshold 600 ; /usr/bin/sudo /usr/bin/pmset -a destroyfvkeyonstandby 1 ; /usr/bin/sudo /usr/bin/pmset -a hibernatemode 25)
    else
        saida_cpu_model34=$(echo "CPU Model not found")
    fi

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 35
    CIS_item="2.8.2 Ensure Wake for Network Access is Disabled."
    Wazuh_id="29021"
    saida_comando35=$(/usr/bin/sudo /usr/bin/pmset -a womp 0)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 36
    CIS_item="2.8.3 Ensure Power Nap is Disabled for Intel Macs."
    Wazuh_id="29021"
    cpu_model=$(/usr/sbin/sysctl -n machdep.cpu.brand_string)
    if [[ $cpu_model == *Apple* ]]; then
        : # Não fazer nada para CPUs Apple
    elif [[ $cpu_model == *Intel* ]]; then
        saida_intel_comando36=$(/usr/bin/sudo /usr/bin/pmset -a powernap 0)
    else
        saida_cpu_model36=$(echo "CPU Model not found")
    fi

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 37
    CIS_item="3.1 Ensure Security Auditing is Enabled."
    Wazuh_id="29021"
    saida_comando37=$(/usr/bin/sudo /bin/launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 38
    CIS_item="3.2 Ensure Security Auditing Flags for User-Attributable Events Are Configured Per Local Organizational Requirements."
    Wazuh_id="29021"
    saida_comando38=$(sudo sed -i '' 's/^flags:.*$/flags:-fm,ad,-ex,aa,-fr,lo,-fw/' /etc/security/audit_control)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 39
    CIS_item="3.3 Ensure install.log is Retained for 365 or More Days and No Maximum Size."
    Wazuh_id="29021"
    saida_comando39=$(sudo sed -i '' 's|^.*file /var/log/install.log.*$|* file /var/log/install.log format='\''$((Time)(JZ)) $Host $(Sender)[$(PID)]: $Message'\'' rotate=seq compress file_max=50M size_only ttl=365|' /etc/asl/com.apple.install)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 40
    CIS_item="3.2 Ensure Security Auditing Retention is Enabled."
    Wazuh_id="29021"
    saida_comando40=$(sudo sed -i '' 's|^expire-after:.*$|expire-after:60d|' /etc/security/audit_control)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 41
    CIS_item="3.5 Ensure Access to Audit Records is Controlled."
    Wazuh_id="29021"
    saida_comando41=$(/usr/bin/sudo /usr/sbin/chown -R root:wheel /etc/security/audit_control ; /usr/bin/sudo /bin/chmod -R o-rw /etc/security/audit_control ; /usr/bin/sudo /usr/sbin/chown -R root:wheel /var/audit/ ; /usr/bin/sudo /bin/chmod -R o-rw /var/audit/)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 42
    CIS_item="3.6 Ensure Access to Audit Records is Controlled."
    Wazuh_id="29021"
    saida_comando42=$(/usr/bin/sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on 2>&1 > /dev/null ; /usr/bin/sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingopt detail 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 43
    CIS_item="4.1 Ensure Bonjour Advertising Services is Disabled."
    Wazuh_id="29021"
    saida_comando43=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 44
    CIS_item="4.2 Ensure HTTP Server is Disabled."
    Wazuh_id="29021"
    saida_comando44=$(sudo /usr/bin/sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 45
    CIS_item="4.3 Ensure NFS Server is Disabled."
    Wazuh_id="29021"
    saida_comando45=$(/usr/bin/sudo /bin/launchctl disable system/com.apple.nfsd 2>&1 > /dev/null ; /usr/bin/sudo /bin/rm /etc/exports 2> /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 46
    # CIS_item="5.1.1 Ensure Home Folders Are Secure."
    # Wazuh_id="29021"
    # comando46="/usr/bin/sudo /bin/chmod -R og-rwx /Users/<username>"
    # check_users=$(ls /Users/)

    # # Iterar sobre os diretórios de home dos usuários
    # for home_directory in $check_users; do
    #     if [ "$home_directory" != "Shared" ]; then
    #         saida_comando46=$(eval "${comando46//<username>/$home_directory}")
    #     fi
    # done

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 47
    CIS_item="5.1.3 Ensure Apple Mobile File Integrity (AMFI) is Enabled."
    Wazuh_id="29021"
    saida_comando47=$(/usr/bin/sudo /usr/sbin/nvram boot-args="")

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 47-1
    CIS_item="x.x.x Ensure Library Validation is Enabled."
    Wazuh_id="29021"
    saida_comando47-1=$(sudo /usr/bin/defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool false)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 48
    CIS_item="5.1.5 Ensure Appropriate Permissions Are Enabled for System Wide Applications"
    Wazuh_id="29021"
    
    #IFS=$'\n' # Utilizar IFS para tratar espaços em nomes de aplicativos
    # Iterar sobre aplicativos encontrados
    #for app in $(find /Applications -iname "*.app" -type d -perm -2); do
    #    chmod -R o-w "$app" # Remover permissões de escrita para outros usuários
    #done
    #IFS=$' \t\n' # Restaurar IFS para seu valor padrão (espaço, tabulação, nova linha)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 49
    CIS_item="5.1.6 Ensure No World Writable Files Exist in the System Folder."
    Wazuh_id="29021"
    /usr/bin/sudo IFS=$'\n'
    for sysPermissions in $(/usr/bin/find /System/Volumes/Data/System -type d -perm -2 | /usr/bin/grep -v "Drop Box"); do
       /bin/chmod -R o-w "$sysPermissions"
    done



    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 50
    CIS_item="5.1.7 Ensure No World Writable Files Exist in the Library Folder."
    Wazuh_id="29021"
    # /usr/bin/sudo IFS=$'\n'
    # for libPermissions in $(sudo /usr/bin/find /System/Volumes/Data/Library -type d -perm -2 | /usr/bin/grep -v Caches | /usr/bin/grep -v /Preferences/Audio/Data); do
    #    /bin/chmod -R o-w "$libPermissions"
    # done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 51
    # CIS_item="5.2.1 Ensure Password Account Lockout Threshold is Configured."
    # Wazuh_id="29021"
    # saida_comando51=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "maxFailedLoginAttempts=5")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 52
    # CIS_item="5.2.1 Ensure Password Minimum Length is Configured."
    # Wazuh_id="29021"
    # saida_comando52=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "minChars=12")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 53
    # CIS_item="5.2.3 Ensure Complex Password Must Contain Alphabetic Characters is Configured."
    # Wazuh_id="29021"
    # saida_comando53=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresAlpha=1")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 54
    # CIS_item="5.2.4 Ensure Complex Password Must Contain Numeric Character is Configured."
    # Wazuh_id="29021"
    # saida_comando54=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresNumeric=2")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 55
    # CIS_item="5.2.5 Ensure Complex Password Must Contain Special Character is Configured."
    # Wazuh_id="29021"
    # saida_comando55=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresSymbol=1")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 56
    # CIS_item="5.2.6 Ensure Complex Password Must Contain Uppercase and Lowercase Characters is Configured."
    # Wazuh_id="29021"
    # saida_comando56=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresMixedCase=1")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 57
    # CIS_item="5.2.7 Ensure Password Age is Configured."
    # Wazuh_id="29021"
    # saida_comando57=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "maxMinutesUntilChangePassword=259200")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 58
    # CIS_item="5.2.8 Ensure Password History is Configured."
    # Wazuh_id="29021"
    # saida_comando58=$(/usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "usingHistory=15")

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 61
    # CIS_item="5.5 Ensure the "root" Account is Disabled."
    # Wazuh_id="29021"
    # saida_comando61=$(/usr/bin/sudo /usr/sbin/dsenableroot -d 2>&1 > /dev/null)

    # # Atualizar barra de progresso
    # progresso=$((progresso + proporcao))
    # printf "\033[4A"
    # exibir_barra_progresso $progresso
    # sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 62
    CIS_item="5.6 Ensure Automatic Login is Disabled."
    Wazuh_id="29021"
    saida_comando62=$(/usr/bin/sudo /usr/bin/defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 63
    CIS_item="5.7 Ensure an Administrator Account Cannot Log in to Another Users Active and Locked Session."
    Wazuh_id="29021"
    saida_comando63=$(/usr/bin/sudo /usr/bin/security authorizationdb write system.login.screensaver use-login-window-ui 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 63-1
    CIS_item="x.x Ensure Fast User Switching is Disabled."
    Wazuh_id="29057"
    saida_comando63-1=$(sudo /usr/bin/defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 64
    CIS_item="5.9 Ensure Users Accounts Do Not Have a Password Hint."
    Wazuh_id="29021"
    comando64="/usr/bin/sudo /usr/bin/dscl . -delete /Users/<username> hint"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando64=$(eval "${comando64//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 65
    CIS_item="5.10 Ensure Secure Keyboard Entry Terminal.app is Enabled."
    Wazuh_id="29021"
    comando65="/usr/bin/sudo -u <username> /usr/bin/defaults write -app Terminal SecureKeyboardEntry -bool true"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando65=$(eval "${comando65//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 66
    CIS_item="6.1.1 Ensure Login Windows Displays as Name and Password is Enabled."
    Wazuh_id="29021"
    saida_comando66=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 67
    CIS_item="6.1.2 Ensure Show Password Hints is Disabled."
    Wazuh_id="29021"
    saida_comando67=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 68
    CIS_item="6.1.3 Ensure Guest Account is Disabled."
    Wazuh_id="29021"
    saida_comando68=$(/usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 69
    CIS_item="6.1.4 Ensure Guest Access to Shared Folders is Disabled."
    Wazuh_id="29021"
    saida_comando69=$(/usr/bin/sudo /usr/sbin/sysadminctl -smbGuestAccess off 2>&1 > /dev/null)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 70
    CIS_item="6.1.5 Ensure the Guest home Folder Does Not Exist."
    Wazuh_id="29021"
    saida_comando70=$(/usr/bin/sudo /bin/rm -R /Users/Guest > /dev/null 2>&1)

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 71
    CIS_item="6.2 Ensure Show All Filename Extensions Setting is Enabled."
    Wazuh_id="29021"
    comando71="/usr/bin/sudo -u <username> /usr/bin/defaults write /Users/<username>/Library/Preferences/.GlobalPreferences.plist AppleShowAllExtensions -bool true"
    check_users=$(ls /Users/)
    comando71-root=$(sudo defaults write /var/root/Library/Preferences/.GlobalPreferences.plist AppleShowAllExtensions -bool true)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando71=$(eval "${comando71//<username>/$home_directory}")
            saida_comando71_2=$(/usr/bin/sudo killall Finder)
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 72
    CIS_item="7.2.1 Ensure Automatic Opening of Safe Files in Safari is Disabled."
    Wazuh_id="29021"
    comando72="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads > /dev/null 2>&1"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando72=$(eval "${comando72//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 73
    CIS_item="7.2.4 Ensure Warn When Visiting A Fradulent Website in Safari Is Enabled."
    Wazuh_id="29021"
    comando73="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WarnAboutFraudulentWebsites > /dev/null 2>&1"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando73=$(eval "${comando73//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 74
    CIS_item="7.2.5 Ensure Prevent Cross-site Tracking in Safari is Enabled."
    Wazuh_id="29021"
    comando74="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari BlockStoragePolicy > /dev/null 2>&1"
    comando74_2="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.storageBlockingPolicy > /dev/null 2>&1"
    comando74_3="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitStorageBlockingPolicy > /dev/null 2>&1"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando74=$(eval "${comando74//<username>/$home_directory}")
            saida_comando74_2=$(eval "${comando74_2//<username>/$home_directory}")
            saida_comando74_3=$(eval "${comando74_3//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 75
    CIS_item="7.2.6 Ensure Automatic Opening of Safe Files in Safari is Disabled."
    Wazuh_id="29021"
    comando75="/usr/bin/sudo -u firstuser /usr/bin/defaults write /Users/firstuser/Library/Containers/com.apple.Safari/Data/Library/Preferences /com.apple.Safari WBSPrivacyProxyAvailabilityTraffic -int 3300 > /dev/null 2>&1"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando75=$(eval "${comando75//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 76
    CIS_item="7.2.7 Ensure Automatic Opening of Safe Files in Safari is Disabled."
    Wazuh_id="29021"
    comando76="/usr/bin/sudo -u <username> /usr/bin/defaults write /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool > /dev/null 2>&1 "
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando76=$(eval "${comando76//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05

    # --------------------------------------------------------------------------------------
    # Executar comando 77
    CIS_item="7.2.8 Ensure Show Full Website Address in Safari is Enabled."
    Wazuh_id="29021"
    comando77="/usr/bin/sudo -u <username> /usr/bin/defaults read /Users/<username>/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowFullURLInSmartSearchField > /dev/null 2>&1"
    check_users=$(ls /Users/)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando77=$(eval "${comando77//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05
    }

    # --------------------------------------------------------------------------------------
    # Executar comando 78
    CIS_item="2.4.7 Ensure Bluetooth Sharing Is Disabled."
    Wazuh_id="29018"
    comando78="/usr/bin/sudo -u <username> /usr/bin/defaults -currentHost write com.apple.Bluetooth PrefKeyServicesEnabled -bool false"
    check_users=$(ls /Users/)
    comando78-root=$(sudo defaults write /var/root/Library/Preferences/com.apple.Bluetooth PrefKeyServicesEnabled -bool false)
    comando78-root2=$(sudo defaults write /var/root/Library/Preferences/ByHost/com.apple.Bluetooth PrefKeyServicesEnabled -bool false)

    # Iterar sobre os diretórios de home dos usuários
    for home_directory in $check_users; do
        if [ "$home_directory" != "Shared" ]; then
            saida_comando78=$(eval "${comando78//<username>/$home_directory}")
        fi
    done

    # Atualizar barra de progresso
    progresso=$((progresso + proporcao))
    exibir_barra_progresso $progresso
    sleep 0.05
    # --------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------
    # --------------------------------------------------------------------------------------


# Chamada da função para executar comandos
executar_comandos

# Limpar linha para evitar sobreposição
# echo


# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------
#                               COMANDOS EXTRAS
# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------

# 5.8	Ensure a Login Window Banner Exists
sudo tee /Library/Security/PolicyBanner.txt > /dev/null <<EOL
=================================================================
                                                        AVISO DE LOGIN
=================================================================

Este sistema é propriedade da Bluebird.

O acesso e uso deste sistema estão restritos a usuários autorizados.

Ao fazer login neste sistema, você concorda em cumprir todas as políticas e regula-
mentos da Bluebird. O uso indevido e/ou não autorizado é estritamente proibido.

Todas as atividades no sistema são monitoradas e registradas. Qualquer violação
das políticas resultará em ações disciplinares ou legais, conforme apropriado.

Se você não concorda com estas condições, desconecte-se imediatamente.


                                                             BLUEBIRD
EOL

# ------------------------------------------------------------------------------------------
# Restart wazuh agent
sudo /Library/Ossec/bin/wazuh-control restart

# ------------------------------------------------------------------------------------------
# Executar comando 59 e 60
CIS_item="5.3-4 Ensure the Sudo Timeout Period is Set to Zero and Separate Timestamp is Enabled to Each User/tty Combo."
Wazuh_id="29021"
saida_comando59=$(
    {
        echo "Defaults timestamp_timeout=0"
           echo "Defaults timestamp_type=tty"
       } | sudo tee /etc/sudoers.d/10_cissudoconfiguration > /dev/null
    )

    # Atualizar barra de progresso
   progresso=$((progresso + proporcao))
   progresso=$((progresso + proporcao))
   exibir_barra_progresso $progresso
   sleep 0.05

echo "\n Vlw!!!!"