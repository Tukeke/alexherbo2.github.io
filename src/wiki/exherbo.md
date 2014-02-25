Exherbo
=======

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
 * friendship community (join [#exherbo][] on freenode)
 * easy to contribute using the [patchbot](http://exherbo.org/docs/patchbot.html)

Installing
----------

Table of contents:

$toc$

Note that most of you will see below is borrowed from the official [Exherbo
Install Guide](http://exherbo.org/docs/install-guide.html) but adapted for my
needs and preferences.

### 1. Read the documentation

 * Re-read everything on http://paludis.exherbo.org and http://exherbo.org
 * Check [recent mailing list posts](http://lists.exherbo.org/pipermail/exherbo-dev)
   for any possible issues, especially Paludis upgrade information

### 2. Boot a live system

```bash
wget http://releases.ubuntu.com/saucy/ubuntu-13.10-desktop-amd64.iso
wget http://releases.ubuntu.com/saucy/SHA1SUMS
grep ubuntu-13.10-desktop-amd64.iso SHA1SUMS | sha1sum --check
dd if=ubuntu-13.10-desktop-amd64.iso of=/dev/sdb
```

### 3. Prepare the hard disk

There are two partitions, `/` and a data partition.

Create a root (SSD) and home partition.

```bash
fdisk /dev/sd{a,b} → /dev/sd{a,b}1
```

Format the filesystems

```bash
mkfs.ext4 /dev/sd{a,b}1
```

Mount root and `cd` into it

```bash
mount /dev/sda1 /mnt; cd /mnt
```

Create and activate the swapfile (optional, discouraged with SSD)

```bash
free --total --mega (ramsize)
fallocate -l (ramx2)M swapfile
```

```bash
mkswap swapfile
swapon swapfile
```

Get the latest archive of Exherbo from Stages and verify the consistence of the file.

```bash
wget http://dev.exherbo.org/stages/exherbo-amd64-current.tar.xz
wget http://dev.exherbo.org/stages/sha1sum
grep exherbo-adm64-current.tar.xz sha1sum | sha1sum --check
```

Extract the stage

```bash
unxz --to-stdout exherbo*xz | tar --extract --preserve --file -
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

### 4. Chroot into the system

Mount everything for the chroot

```bash
mount --options rbind /dev dev
mount --options bind /sys sys
mount --types   proc none proc

mount /dev/sdb1 home
```

Make sure the network can resolve DNS

_etc/resolv.conf_

```bash
# Google DNS

nameserver 8.8.8.8
nameserver 8.8.4.4

# https://developers.google.com/speed/public-dns/docs/using
```

Change your root

```bash
env --ignore-environment TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) . /bin/bash
source /etc/profile
PS1="(chroot) $PS1"
```

### 5. Update the install

Make sure Paludis is configured correctly

```bash
cd /etc/paludis; kak bashrc; kak *conf
```

Sync all the trees – now it is safe to sync

```bash
cave sync
```

### 6. Make bootable

Download the latest stable [kernel][] and verify its signature.

```bash
wget kernel.org/pub/linux/kernel/v3.x/linux-3.11.3.tar.xz
wget kernel.org/pub/linux/kernel/v3.x/linux-3.11.3.tar.sign
unxz linux*xz
gpg --verify linux*sign #=> key ID
gpg --recv-keys $key_id
gpg --verify linux*sign
```

Extract

```bash
tar --extract --preserve --file linux*tar
```

Install the kernel

```
cd path-to-kernel; make menuconfig
```

Activate devtmpfs (udev requires devtmpfs support)

```
Device Drivers
  Generic Driver Options
    [*] Maintain a devtmpfs filesystem to mount at /dev
    [*] Automount devtmpfs at /dev, after the kernel mounted the rootfs
```

```bash
make; make modules_install; cp arch/x86/boot/bzImage /boot/kernel
```

Install and configure bootloader

```bash
cave resolve syslinux
```

1. install the files
2. mark the partition active with the boot flag
3. install the MBR boot code

```bash
1. extlinux --install /boot/syslinux
2. fdisk /dev/sda
3. dd if=/usr/share/syslinux/mbr.bin of=/dev/sda bs=440 count=1 (cave print-id-contents syslinux | grep mbr.bin)
```

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

1. Set systemd option globally in /etc/paludis/options.conf
2. Install systemd
3. Reinstall every package with the new option set
4. Switch to systemd as your init system

```
1. */* systemd
2. cave resolve sys-apps/systemd
3. cave resolve world
4. eclectic init set systemd
```

Configure your hostname for systemd

```bash
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

```bash
LANG=en_US.UTF-8
```

Set system timezone

```bash
ln --symbolic /usr/share/zoneinfo/Europe/Paris /etc/localtime
```

Synchronize hardware clock 'aka BIOS' with the current system time.

```bash
hwclock --systohc --utc
```

Set root password

```bash
passwd root
```

Add a new user for daily use

```bash
useradd -m -G adm,disk,wheel,cdrom,video,usb,users USERNAME
```

Set user password

```bash
passwd USERNAME
```

Install sudo

```bash
cave resolve sudo
```

Edit /etc/sudoers

```
%wheel ALL=(ALL) NOPASSWD: ALL
```

Reboot

```bash
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

```bash
cave show stages
```

If you wish to remove them, you can simply execute the resolution of cave purge:

```bash
cave purge
```

Alternatively, you can add packages you wish to retain to the world set by using
the update-world command.  As an example, the following adds Kakoune to the
world set.

```bash
cave update-world app-editors/kakoune
```

Or, if you want to add all packages of the stages set to the world set:

```bash
cave update-world --set stages
```

#### Network configuration

Start dhcpcd

```bash
dhcpcd
```

Install and configure wicd

```bash
cave resolve wicd
```

```bash
systemctl enable wicd
```

```bash
wicd-{gtk,curses,cli}
```

Stop dhcpcd

```bash
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

```bash
cave resolve sys-sound/alsa-utils
```

All channels are muted by default.

```bash
amixer set {Master,PCM} on
```

In `alsamixer`, the _MM_ label below a channel indicates that the channel is
muted, and _00_ indicates that it is open.  `m` command enables to switch this
state.

#### Window manager

Activate KMS (Kernel Mode Setting) (optional, recommended if you have a look at tty)

```
Device Drivers
  Graphics support
    [*] DRIVER
    [*] Enable userspace modesetting on DRIVER
```

```bash
cave resolve xorg (group) x11-driver/xf86-video-{driver}
```

```bash
cave resolve x11-wm/i3
```

```bash
startx
```

#### Fonts

```bash
cave resolve fonts/dejavu
```

```bash
ln --symbolic /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
```

#### Browser

```bash
cave resolve net-www/uzbl
```

```bash
cave resolve net-plugins/adobe-flash
```

```bash
cave print-id-contents adobe-flash #=> /opt/netscape/plugins/libflashplayer.so ...
ln --symbolic /opt/netscape /usr/lib/mozilla
```

```bash
cave resolve dev-lang/icedtea-web
```

```bash
cave resolve dev-libs/nspluginwrapper
```

```bash
nspluginwrapper --verbose --auto --install
```

### 8. Contributing

 * http://imagination-land.org/posts/2013-01-03-knowing-your-system---part-7---contributing-to-exherbo.html (Keruspe)
 * https://github.com/alexherbo2/paludis

_/home/alex/paludis/repositories/arbor.conf_

```
...
sync = git://git.exherbo.org/arbor local: git+file:///home/alex/exherbo/arbor
...
```

```bash
cd /home/alex/exherbo; git clone git://git.exherbo.org/arbor
```

Make your changes and commit them.

```bash
cave sync --source local arbor
```


_/home/alex/bin/git-patch_

```bash
git format-patch     \
  --find-renames      \
  --find-copies        \
  --find-copies-harder  \
  --stdout $@
```

```bash
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

 * http://exherbo.org/docs/exheres-for-smarties.html
 * https://github.com/alexherbo2/exheres

### 10. Submit your personal repository

```
!pq https://github.com/alexherbo2/exheres ::unavailable-unofficial alexherbo2’s supplemental repository
```

[Exherbo]:  http://exherbo.org
[LFS]:      http://linuxfromscratch.org
[Paludis]:  http://paludis.exherbo.org
[kernel]:   http://kernel.org
[#exherbo]: http://webchat.freenode.net/?channels=exherbo


coffee
    for image in document.images
        image.style.cssFloat = 'right'