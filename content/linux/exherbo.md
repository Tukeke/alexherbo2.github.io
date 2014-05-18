Exherbo
=======

%gittip
%flattr-identifier exherbo
%disqus-identifier exherbo

[![Zebrapig](/images/zebrapig.svg 'Exherbo')](http://exherbo.org)

What is Exherbo?
----------------

Basically [Exherbo][] is [LFS][] with [Paludis][], a source package manager.

It includes:

 * a package mangler – [cave](http://paludis.exherbo.org/clients/cave.html)    (
     [search](http://paludis.exherbo.org/clients/cave-search.html)             |
     [show](http://paludis.exherbo.org/clients/cave-show.html)                 |
     [resolve](http://paludis.exherbo.org/clients/cave-resolve.html)           |
     [sync](http://paludis.exherbo.org/clients/cave-sync.html)                 )
 * a news reader     – `eclectic news read new`
 * alternatives      – `eclectic gcc set 4.8`

Why Exherbo?
------------

 * source based Linux distribution with [Paludis][]
 * decentralised (It is very easy to make/maintain it’s [own packages](http://exherbo.org/docs/exheres-for-smarties.html) and add those from other)
 * friendly community (join [#exherbo][] on freenode)
 * easy to contribute using the [patchbot](http://exherbo.org/docs/patchbot.html)

Installing
----------

Note that most of you will see below is borrowed from the official [Exherbo
Install Guide](http://exherbo.org/docs/install-guide.html) but adapted for my
needs and preferences.

### 1. Read the documentation

 * Re-read everything on <http://paludis.exherbo.org> and <http://exherbo.org>
 * Check [recent mailing list posts](http://lists.exherbo.org/pipermail/exherbo-dev)
   for any possible issues, especially Paludis upgrade information

### 2. Boot a live system

[Get Manjaro][] and verify the integrity of the ISO.

```sh
grep manjaro-xfce-0.8.9-x86_64.iso manjaro-xfce-0.8.9-sha1sum.txt | sha1sum --check
```

Then write Manjaro on your device (be careful, it’s `sdb` in my case).

```sh
dd if=manjaro-xfce-0.8.9-x86_64.iso of=/dev/sdb
```

Boot Manjaro then you’re ready to the next step :) __Prepare the hard disk__

### 3. Prepare the hard disk

There are two partitions, `/` and a data partition.

Create a root (SSD) and home partition.

```sh
fdisk /dev/sd{a,b} → /dev/sd{a,b}1
```

Format the filesystems

```sh
mkfs.ext4 /dev/sd{a,b}1
```

Mount root and `cd` into it

```sh
mount /dev/sda1 /mnt; cd /mnt
```

Create and activate the swapfile (optional, discouraged with SSD)

```sh
free --total --mega (ramsize)
fallocate -l (ramx2)M swapfile
```

```sh
mkswap swapfile
swapon swapfile
```

Get the latest archive of Exherbo from Stages and verify the consistence of the file.

```sh
wget http://dev.exherbo.org/stages/exherbo-amd64-current.tar.xz
wget http://dev.exherbo.org/stages/sha1sum
grep exherbo-adm64-current.tar.xz sha1sum | sha1sum --check
```

Extract the stage

```sh
unxz --to-stdout exherbo*xz | tar --extract --preserve-permissions --preserve-order --file -
```

Update etc/fstab

```
<filesystem>        <mountpoint>    <type>    <options>                                        <dump/pass>
/dev/sda1           /               ext4      noatime,nobh,data=writeback,barrier=0,discard    0 0
/dev/sdb1           /home           ext4      defaults                                         0 0 # if SSD
/swapfile           none            swap      defaults                                         0 0 # else (optional)
tmpfs               /tmp            tmpfs     noatime,nodev,nosuid                             0 0
tmpfs               /var/spool      tmpfs     noatime,nodev,nosuid                             0 0
tmpfs               /var/cache      tmpfs     noatime,nodev,nosuid                             0 0
tmpfs               /var/tmp        tmpfs     noatime,nodev,nosuid                             0 0
tmpfs               /var/log        tmpfs     noatime,nodev,nosuid                             0 0
```

Note: my laptop has a SSD, so it takes extra care options to stretch its lifetime.

 * noatime
 * nobh
 * data=writeback
 * barrier=0
 * discard

### 4. Run Exherbo

Mount home in the name space container

```sh
mount /dev/sdb1 home
```

Make sure the network can resolve DNS

_etc/resolv.conf_

```sh
# Google DNS

nameserver 8.8.8.8
nameserver 8.8.4.4

# https://developers.google.com/speed/public-dns/docs/using
```

Spawn Exherbo name space container

```sh
systemd-nspawn
```

_Note_ If for some reason it does not work, mount everything needed then
chroot into the system:

```sh
mount --options rbind /dev dev
mount --options bind /sys sys
mount --types   proc none proc
env --ignore-environment TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) . /bin/bash
```

Then when in Exherbo

```sh
PS1=(Exherbo)\ $PS1
```

### 5. Update the install

Make sure Paludis is configured correctly

```sh
kak /etc/paludis/{bashrc,{*}conf}
```

Sync all the trees – now it is safe to sync

```sh
cave sync
```

### 6. Make bootable

Clone the latest stable [kernel][].

```sh
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux; cd linux
```

Configure and install the kernel

```
make menuconfig
```

```sh
make; make modules_install; cp arch/x86/boot/bzImage /boot/kernel
```

Install and configure a boot loader

```sh
cave resolve syslinux
```

1. install the files                            → `extlinux --install /boot/syslinux`
2. mark the partition active with the boot flag → `fdisk /dev/sda`
3. install the MBR boot code                    → `dd if=/usr/share/syslinux/mbr.bin of=/dev/sda bs=440 count=1` (`cave print-id-contents syslinux | grep mbr.bin`)

Edit /boot/syslinux/syslinux.cfg

```
DEFAULT linux
PROMPT   0
TIMEOUT 50

LABEL linux
  MENU LABEL Linux
  APPEND root=/dev/sda1 ro
  LINUX   ../kernel
```

Install an init system

1. Set systemd option globally in /etc/paludis/options.conf → `*/* systemd`
2. Install systemd                                          → `cave resolve sys-apps/systemd`
3. Reinstall every package with the new option set          → `cave resolve world`
4. Switch to systemd as your init system                    → `eclectic init set systemd`

Configure your hostname for systemd

```sh
echo $hostname > /etc/hostname
```

Make sure your hostname is mapped to localhost in /etc/hosts,
otherwise some packages test suites will fail because of network sandboxing.

```
127.0.0.1    localhost $hostname
::1          localhost $hostname
```

Configure locales

```
localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8
```

_/etc/env.d/99locale_

```sh
LANG=en_US.UTF-8
```

Set system timezone

```sh
ln --symbolic /usr/share/zoneinfo/Europe/Paris /etc/localtime
```

Synchronize hardware clock 'aka BIOS' with the current system time.

```sh
hwclock --systohc --utc
```

Set root password

```sh
passwd root
```

Add a new user for daily use

```sh
useradd -m -G adm,disk,wheel,cdrom,video,usb,users USERNAME
```

Set user password

```sh
passwd USERNAME
```

Automatic login to virtual console

_/etc/systemd/system/getty@tty1.service.d/autologin.conf_

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin USERNAME --noclear %I 38400 linux
```

Install sudo

```sh
cave resolve sudo
```

Edit /etc/sudoers

```
%wheel ALL=(ALL) NOPASSWD: ALL
```

Reboot

```sh
reboot
```

### 7. Post-installation

#### Remove the stage tarball

The stage tarball is no longer needed and can be safely removed.

#### Clean up packages

The installation images (stages) contain additional tools which are useful
for the installation process but are not part of the system nor world sets
but the stages set.

You can identify the additional packages using cave show:

```sh
cave show stages
```

If you wish to remove them, you can simply execute the resolution of cave purge:

```sh
cave purge
```

Alternatively, you can add packages you wish to retain to the world set by using
the update-world command.  As an example, the following adds Kakoune to the
world set.

```sh
cave update-world app-editors/kakoune
```

Or, if you want to add all packages of the stages set to the world set:

```sh
cave update-world --set stages
```

#### Shell

```sh
cave resolve fish-shell
```

#### Network configuration

Start dhcpcd

```sh
dhcpcd
```

Install and configure NetworkManager

```sh
cave resolve net-apps/NetworkManager
cave resolve gnome-desktop/gnome-keyring
cave resolve gnome-desktop/network-manager-applet
```

```sh
systemctl enable NetworkManager
```

Stop dhcpcd

```sh
dhcpcd
```

#### Sound

Activate sound driver

```
Device Drivers
  Sound card Support
    ALSA
      PCI Sound Device
        $DRIVER
```

```sh
cave resolve sys-sound/alsa-utils
```

```sh
cave resolve media-sound/pulseaudio
cave resolve media-sound/pulseaudio-applet
```

#### Window manager

Activate KMS (Kernel Mode Setting) (optional, recommended if you have a look at tty)

```
Device Drivers
  Graphics support
    [*] DRIVER
    [*] Enable userspace modesetting on DRIVER
```

```sh
cave resolve xorg (group) x11-driver/xf86-video-{driver}
```

```sh
cave resolve x11-wm/i3
```

```sh
startx
```

Start X at Login

```fish
if status --is-login
  if not test "$DISPLAY"
    startx
  end
end
```

#### Fonts

```sh
cave resolve fonts/dejavu
```

```sh
ln --symbolic /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
```

#### Browser

```sh
cave resolve net-www/chromium-dev                                              \
             net-www/chromium-dev-flash-plugin                                 \
             net-www/chromium-dev-pdf-plugin
```

```sh
cave resolve net-plugins/adobe-flash
```

```sh
cave print-id-contents adobe-flash → /opt/netscape/plugins/libflashplayer.so […]
ln --symbolic /opt/netscape /usr/lib/mozilla
```

```sh
cave resolve dev-lang/icedtea-web
```

```sh
cave resolve dev-libs/nspluginwrapper
```

```sh
nspluginwrapper --verbose --auto --install
```

### 8. Contributing

 * [Knowing your system — Part 7 — Contributing to Exherbo](http://imagination-land.org/posts/2013-01-03-knowing-your-system---part-7---contributing-to-exherbo.html)
 * <https://github.com/alexherbo2/paludis>

_/home/alex/paludis/repositories/arbor.conf_

```
...
sync = git://git.exherbo.org/arbor local: git+file:///home/alex/exherbo/arbor
...
```

```sh
cd /home/alex/exherbo; git clone git://git.exherbo.org/arbor
```

Make your changes and commit them.

```sh
cave sync --source local arbor
```


_/home/alex/bin/git-patch_

```sh
git format-patch     \
  --find-renames      \
  --find-copies        \
  --find-copies-harder  \
  --stdout $@
```

```sh
git patch -<number_of_commits> | gist --open
```

Copy the raw

`!pq RAW_URL ::arbor [DESCRIPTION]`

Commands and aliases:

```
!patchqueue RAW_URL ::REPO [DESCRIPTION]
!pq
```

```
!patchdone TEXT
!pd
```

```
!patchlist
!pl
```

### 9. Make your supplemental repository

 * [Exheres for Smarties](http://exherbo.org/docs/exheres-for-smarties.html)
 * <https://github.com/alexherbo2/exheres>

### 10. Submit your personal repository

```
!pq https://github.com/alexherbo2/exheres ::unavailable-unofficial alexherbo2’s supplemental repository
```

[Exherbo]:     http://exherbo.org
[Manjaro]:     http://manjaro.org
[Get Manjaro]: http://manjaro.org/get-manjaro
[LFS]:         http://linuxfromscratch.org
[Paludis]:     http://paludis.exherbo.org
[kernel]:      http://kernel.org
[#exherbo]:    http://webchat.freenode.net/?channels=exherbo


coffee
    for image in document.images
        image.style.cssFloat = 'right'
