#! /bin/bash

airootfs="airootfs/etc"

#grub
mkdir -p "$airootfs/default"
cp -r "/etc/default/grub" "$airootfs/default"

# os-release
cp -r "/usr/lib/os-release" "$airootfs"
sed -i 's/NAME="Arch Linux"/NAME="MerlinArch Linux"/' "$airootfs/os-release"


# Wheel Group
mkdir -p "$airootfs/sudoers.d"
g_wheel="$airootfs/sudoers.d/g_wheel"
echo "%wheel ALL=(ALL:ALL) ALL" > "$g_wheel"


# Symbolic Link
## NetworkManager
mkdir -p "$airootfs/systemd/system/multi-user.target.wants"
ln -sv "/usr/lib/systemd/system/NetworkManager.service" "$airootfs/systemd/system/multi-user.target.wants"


mkdir -p "$airootfs/systemd/system/network-online.target.wants"
ln -sv "/usr/lib/systemd/system/NetworkManager-wait-online.service" "$airootfs/systemd/system/network-online.target.wants"

ln -sv "/usr/lib/systemd/system/NetworkManager-dispatcher.service" "$airootfs/systemd/system/dbus.org.freedesktop.dispatcher.service"

## Bluetooth
ln -sv "/usr/lib/systemd/system/bluetooth.service" "$airootfs/systemd/system/network-online.target.wants"

## Graphical target
ln -sv "/usr/lib/systemd/system/graphical.target" "$airootfs/systemd/system/default.target"

## SDDM
ln -sv "/usr/lib/systemd/system/sddm.service" "$airootfs/systemd/system/display-manager.service"

# SDDM config
mkdir -p "$airootfs/sddm.conf.d"
sed -n '1,35p' /usr/lib/sddm/sddm.conf.d/default.conf > "$airootfs/sddm.conf"
sed -n '38,137p' /usr/lib/sddm/sddm.conf.d/default.conf > "$airootfs/sddm.conf.d/kde_settings.conf"


# Desktop Environment

sed -i 's/Session=/Session=plasma.desktop/' "$airootfs/sddm.conf"


# Display Server

sed -i 's/DisplayServer=x11/DisplayServer=wayland/' "$airootfs/sddm.conf"


# NumLock
sed -i 's/Numlock=none/Numlock=on/' "$airootfs/sddm.conf"

# User
user=xenon
sed -i "s/User=/User=$user/" "$airootfs/sddm.conf"


## HostName
echo merlinarch > "$airootfs/hostname"

# Adding New Users 
if grep -q "$user" "$airootfs/passwd" 2> /dev/null; then
    echo -e "\nUser Found..........."
else
    sed -i "1i $user:x:1000:1000::/home/$user:/usr/bin/bash" "$airootfs/passwd"
    echo -e "\nUser not Found..........."
fi


# PassWord

hash_pd=$(openssl passwd -6 'MerlinArch@001')


if grep -q "$user" "$airootfs/shadow" > /dev/null; then
    echo -e "\nPassword exists, Not Modifying"
else
    sed -i "1i $user:$hash_pd:14871::::::" "$airootfs/shadow"
    echo -e "\nModifying the Password"
fi



# Group
touch "$airootfs/group"
echo -e "root:x:0:root\nadm:x:4:$user\nwheel:x:10:$user\nuucp:x:14:$user\n$user:x:1000:$user" > "$airootfs/group"


# GShadow
touch "$airootfs/gshadow"
echo -e "root:!*::root\n$user:!*::" > "$airootfs/gshadow"



# Grub CFG
grubcfg="grub/grub.cfg"
sed -i 's/default=archlinux/default=merlinarch/' "$grubcfg"
sed -i 's/timeout=15/timeout=10/' "$grubcfg"
sed -i 's/menuentry "Arch/menuentry "MerlinArch/' "$grubcfg"

if ! grep -q 'archisosearchuuid=%ARCHISO_UUID% cow_spacesize=10G copytoram=n' "$grubcfg" 2> /dev/null; then
	sed -i 's/archisosearchuuid=%ARCHISO_UUID%/archisosearchuuid=%ARCHISO_UUID% cow_spacesize=10G copytoram=n/' "$grubcfg"
fi

if ! grep -q '#play' "$grubcfg" 2> /dev/null; then
	sed -i 's/play/#play/' "$grubcfg"
fi

# entries
efiloader="efiboot/loader"
sed -i 's/Arch/MerlinArch/' "$efiloader/entries/01-archiso-x86_64-linux.conf"
sed -i 's/Arch/MerlinArch/' "$efiloader/entries/02-archiso-x86_64-speech-linux.conf"

#loader
sed -i 's/timeout 15/timeout 10/' "$efiloader/loader.conf"
sed -i 's/beep on/beep off/' "$efiloader/loader.conf"
