# Arch Linux

# Installation procedure (encrypted LVM on EFI):
  1. Ensure running under EFI `# ls /sys/firmware/efi/efivars`
  2. Use wifi-menu to connect to network
  3. `# timedatectl set-ntp true`
  4. Update packages and install reflector: `# pacman -Syyu reflector`
  5. Download latest mirrors `# reflector --country 'United Kingdom' --latest 10 --age 24 --sort rate --save /etc/pacman.d/mirrorlist`
  6. Create partitons:
      ```
      # gdisk /dev/nvme0n1
      o
      n
      enter
      enter
      +256M
      EF00

      n
      enter
      enter
      +512M
      8300

      n
      enter
      enter
      enter
      8E00

      w
      ```
  7. `# mkfs.fat -F32 /dev/nvme0n1p1`
  8. `# mkfs.ext2 /dev/nvme0n1p2`
  9. Set up encryption
        * `# cryptsetup luksFormat /dev/nvme0n1p3`
        * `# cryptsetup open /dev/nvme0n1p1 cryptlvm`
  10. Set up lvm:
        * `# pvcreate --dataalignment 512k /dev/mapper/cryptlvm`
        * `# vgcreate main /dev/mapper/cryptlvm`
        * `# lvcreate -L 64GB -n root main`
        * `# lvcreate -l 100%FREE -n home main`
        * `# modprobe dm_mod`
        * `# vgscan`
        * `# vgchange -ay`
  11. `# mkfs.ext4 /dev/main/root`
  12. `# mkfs.ext4 /dev/main/home`
  13. `# mount /dev/main/root /mnt`
  14. `# mkdir /mnt/boot`
  15. `# mkdir /mnt/home`
  16. `# mount /dev/nvme0n1p2 /mnt/boot`
  17. `# mount /dev/main/home /mnt/home`
  18. `# mkdir /mnt/boot/EFI`
  19. `# mount /dev/nvme0n1p1 /boot/EFI`
  20. `# pacstrap -i /mnt base base-devel grub efibootmgr dosfstools connman iwd intel-ucode zsh sudo mesa vulkan-intel linux-headers linux-lts`
  21. `# genfstab -U /mnt >> /mnt/etc/fstab`
  22. Add `discard` to `/mnt/etc/fstab`
  23. `# arch-chroot /mnt`
  24. `# ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime`
  25. `# hwclock --systohc`
  26. `# timedatectl set-ntp true`
  27. `# echo '<hostname>' > /etc/hostname`
  28. Add the following to `/etc/hosts`
    ```
    127.0.0.1	  localhost
    ::1	      	localhost
    127.0.1.1	  <hostname>.localdomain <hostname>
    ```
  29. Edit `/etc/mkinitcpio.conf` and add `encrypt lvm2` in between `block` and `filesystems`
  30. `# mkinitcpio -p linux`
  31. `# mkinitcpio -p linux-lts`
  32. `# nano /etc/locale.gen` (uncomment en_GB.UTF-8)
  33. `# locale-gen`
  34. Add `LANG=en_GB.UTF-8` to `/etc/locale.conf`
  35. `# localectl set-locale LANG="en_GB.UTF-8"`
  36. `# passwd` (for setting root password)
  37. Edit `/etc/default/grub`:
        add `cryptdevice=UUID=<UUID>:cryptlvm:allow-discards` to the `GRUB_CMDLINE_LINUX`
  38. `# # grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=arch_grub --recheck`
  39. `# cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo`
  40. `# grub-mkconfig -o /boot/grub/grub.cfg`
  41. Create swap file:
        * `# fallocate -l 16G /swapfile`
        * `# chmod 600 /swapfile`
        * `# mkswap /swapfile`
        * `# swapon /swapfile`
        * `# echo '/swapfile none swap defaults 0 0' >> /etc/fstab`
  42. `# useradd -m -s -G wheel /bin/zsh <name>`
  43. `# passwd <name>`
  44. `# nano /etc/sudoers` uncomment wheel
  45. `# exit`
  46. `# umount -a`
  47. `# reboot`

## Post Installation

### General

`# pacman -Syu gnome reflector otf-overpass tlp acpi_call acpi_call-lts smartmontools tpacpi-bat x86_energy_perf_policy ethtool rsync restic atom python3`

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

NB: I added 'allow-discards' to my grub config earlier.

Change `/etc/lvm/lvm.conf` to `issue_discards = 1`.

`# systemctl enable fstrim.timer`

`# systemctl start fstrim.service`


https://wiki.archlinux.org/index.php/Swap#Swappiness
