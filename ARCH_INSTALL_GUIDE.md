# Arch Linux

# Installation procedure (systemd, EFI, encrypted LVM2):
* Ensure running under EFI `# ls /sys/firmware/efi/efivars`
* Use wifi-menu to connect to network
* Update packages and install reflector: `# pacman -Syyu reflector`
* Download latest mirrors `# reflector --country 'United Kingdom' --latest 10 --age 24 --sort rate --save /etc/pacman.d/mirrorlist`
* Create partitons:
```
# gdisk /dev/nvme0n1
o
n
enter
enter
+512M
EF00

n
enter
enter
enter
8E00

w
```
* `# mkfs.fat -F32 /dev/nvme0n1p1`
* Set up encryption
  * `# cryptsetup luksFormat /dev/nvme0n1p2`
  * `# cryptsetup luksOpen /dev/nvme0n1p2 cryptlvm`
* Set up lvm:
  * `# pvcreate --dataalignment 512k /dev/mapper/cryptlvm`
  * `# vgcreate main /dev/mapper/cryptlvm`
  * `# lvcreate -L 64GB -n root main`
  * `# lvcreate -l 100%FREE -n home main`
  * `# modprobe dm_mod`
  * `# vgscan`
  * `# vgchange -ay`
* `# mkfs.ext4 /dev/main/root`
* `# mkfs.ext4 /dev/main/home`
* `# mount /dev/main/root /mnt`
* `# mkdir /mnt/home`
* `# mount /dev/main/home /mnt/home`
* `# mkdir /mnt/boot`
* `# mount /dev/nvme0n1p1 /mnt/boot`
* `# pacstrap -i /mnt base base-devel efibootmgr dosfstools connman iwd intel-ucode zsh sudo mesa vulkan-intel linux-headers`
* Edit `/etc/mkinitcpio.conf` and add `sd-encrypt sd-lvm2` in between `block` and `filesystems`, and switch `udev` to `systemd`, and uncomment the `lz4` compression option.
```
HOOKS=(base systemd autodetect modconf block filesystems sd-encrypt sd-lvm2 keyboard fsck)
```
* `# mkinitcpio -p linux`
* `# pacman -S linux-zen linux-lts linux-hardened`
* `# genfstab -U /mnt >> /mnt/etc/fstab`
* Add `discard` to `/mnt/etc/fstab`
* `# arch-chroot /mnt`
* `# ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime`
* `# hwclock --systohc`
* `# echo '<hostname>' > /etc/hostname`
* Add the following to `/etc/hosts`
```
*0.0.1	  localhost
::1	      	  localhost
*0.1.1	  <hostname>.localdomain <hostname>
```
* `# nano /etc/locale.gen` (uncomment en_GB.UTF-8)
* `# locale-gen`
* Add `LANG=en_GB.UTF-8` to `/etc/locale.conf`
* `# passwd` (for setting root password)
* `# bootctl --path=/boot update`
* Change `/boot/loader/loader.conf` to
```
default  arch-linux
timeout  4
console-mode max
editor   no
```
* Create entires such as `/boot/loader/entries/arch-linux.conf`
```
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options rd.luks.name=<UUID for /dev/nvme0n1p2>=cryptlvm rd.luks.options=discard root=UUID=<UUID for /dev/mapper/main-root> rw quiet
```
* Add the following to `/etc/pacman.d/hooks/systemd-boot.hook`
```
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
```
* Create swap file:
  * `# fallocate -l 16G /swapfile`
  * `# chmod 600 /swapfile`
  * `# mkswap /swapfile`
  * `# swapon /swapfile`
  * `# echo '/swapfile none swap defaults 0 0' >> /etc/fstab`
* `# useradd -m -s -G wheel /bin/zsh <name>`
* `# passwd <name>`
* `# nano /etc/sudoers` uncomment wheel
* `# exit`
* `# umount -a`
* `# reboot`
* `# timedatectl set-ntp true`
* `# localectl set-locale LANG="en_GB.UTF-8"`

## Post Installation

### General

`# pacman -Syu gnome reflector otf-overpass tlp acpi_call smartmontools tpacpi-bat x86_energy_perf_policy ethtool rsync restic python3`

`# pacman -Rns networkmanager netctl wpa_supplicant`

`# systemctl enable gdm tlp dhcpcd connman iwd tlp-sleep`

`# systemctl enable rfkill-unblock@all`

`# mkdir /etc/pacman.d/hooks`
`# nano /etc/pacman.d/hooks/mirrorupgrade.hook`
```
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector and removing pacnew.
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c "reflector --country 'United Kingdom' --latest 10 --age 24 --sort rate --save /etc/pacman.d/mirrorlist;  rm -f /etc/pacman.d/mirrorlist.pacnew"
```

sudo `nano /etc/pacman.conf`
Uncomment `VerbosePkgLists`, `Color`, `TotalDownload`, and add `ILoveCandy`

### TRIM

I don't enable continuous TRIM because not all controllers fully support it.

NB: I added 'allow-discards' to my cryptdevice entry earlier.

Change `/etc/lvm/lvm.conf` to `issue_discards = 1`.

`# systemctl enable fstrim.timer`

`# systemctl start fstrim.service`

https://wiki.archlinux.org/index.php/Swap#Swappiness
