# spin
Install Linus Torvalds' favorite distro on your Raspberry Pi without UEFI on the Pi
# What is spin?
> **THIS SOFTWARE IS EXPERIMENTAL, CONTINUE WITH CAUTION, I AM NOT LIABLE FOR ANY DAMAGE DONE**<br>
*NO NVME support, only SD and USB-MSD boot mediums are supported, working on dynamic initramfs fstab generation to make all devices work*<br>
You will need ~48GB of disk space.<br>
The installation is **NOT IMMUTABLE**

Fedora Linux installer for Raspberry Pi. Tested on Raspberry Pi 5 (8GB) + Docker to run spin, MMC (SD) builds are being tested MSD (USB) builds are *not* tested at the moment.<br>
This tool installs Fedora Linux to a USB device or an SD card with required Raspberry Pi firmware. To use the tool you will need Docker with aarch64 support. Fedora roots are downloaded from [https://images.linuxcontainers.org/](https://images.linuxcontainers.org/) (custom Fedora rootfs service in progress). Kernel and EEPROM is fetched from Raspberry Pi's firmware repository (kernel will be compiled by the FfR project but the nonfree firmware like the GPU and EEPROM firmware need to be fetched from Raspberry Pi). Fedora and spin do **not** support *32-bit ARM* architectures.
# Known Issues
* Plymouth doesn't work when powering off or rebooting. (Plymouth actually starts but it doesnt show itself, can't fix, ignoring because it is not important, suggest fixes at issues)
* Changing boot medium after installation requires more configuration. (This will be fixed after fstab generator)
* /boot is separated from the real boot partition. The files get copied to /rpiconf. The config is stored at /opt/rpiconf.txt and the default config is stored at /opt/rpiconfig_default.txt (This will be fixed after fstab generator)
* GPU works but sometimes might create unwanted artifacts on **desktop** (mostly terminal programs). Logging out then logging back in again mostly fixes this issue. This issue does not happen in TTYs. Alacritty comes preinstalled to fix (?) this. The artifacting does not happen on videos.
* First boot may not have a splash due to the kernel configuration not being done. (first boot does resizes and kernel configurations, dracut configs will be made.
* Installing Linux kernel from Fedora might break the installation. Use `rpi-*` tools to install these. (packaging new kernel RPM's to make this not break in normal circumstances)
* Desktop might hang because of ongoing disk operations. (
* Broadcom Wi-Fi is slow. We can't control this because [Broadcom support is really bad on Linux](https://wiki.archlinux.org/title/Broadcom_wireless). (you will get half the speed)
# Image configuration
The spin tool installs the default Fedora Workstation (GNOME) into your system. To change this, change the "dnf group install workstation-product-environment" to another group you want to install. "dnf group install server-product-environment" installs Fedora Server. After the image is prepared to be installed it will be exported to your device.
# Updates
The spin tool itself won't update your system. You can update your system using dnf. To update Raspberry Pi kernel, use `rpi-kernel-update` (updater also updates kernel modules and Pi firmware); for EEPROM, use `rpi-eeprom-updater`; for syncing /boot with /rpiconf, use `rpi-boot-update`; for syncing the config file, use `rpi-config-update`; for headers use `rpi-header-update` (auto called from kernel updater); for initramfs use `rpi-initramfs-update`; to add `rhgb`, `plymouth.enabled=1`, `quiet`, `splash` to the kernel cmdline use `rpi-cmdline-update`. All `rpi-*` commands require uninterrupted power, root access (run as root) and some require access to the Internet. Use `rpi-update` to update all kernel and boot related objects (does NOT include initramfs). <br>
Update headers and kernel at the same time. <br>
A new updater is planned to use the new fstab and dracut features, planning on obsoleting the rpi-kernel update because RPM's will handle it.
# Changing boot medium (manually)
Mount the old boot medium containing the files and clone it to the new boot medium (using disk cloners etc.). Change the cmdline.txt on the new boot partition's `root=` argument according to the new medium. Then, mount the new root partition and change `/etc/fstab` file according to your disks. This will not be required after fstab and dracut update.
# Misc Information
* The eeprom-updater sticks to the master branch of rpi-eeprom. You have to clone it again if you want a different branch (clone to /opt/eeprom-updater, will be obsoleted in favor of the new RPM updaters)
* Only cypress and brcm firmware blobs are unpacked.
* Every git clone uses `--depth 1`
* Initramfs update should be done using `rpi-initramfs-update`.
* You should reboot after `rpi-kernel-update` to make sure you are on the newest release before running `rpi-initramfs-update`.
* The system can run without an initramfs, you can delete the `initramfs` entries on configuration files. Plymouth won't work and no rescue shell will be available.
* Default plymouth theme is `bgrt`, to change it; use `plymouth-set-default-theme`, then `rpi-initramfs-update`.
* Default Wi-Fi country is US. It might auto change after connecting to a network. To change, use `iw reg set COUNTRY_CODE`. To check, use `iw reg get`.
* rfkill is disabled by default. 
* Dracut creates initramfs for every kernel found at /lib/modules. (this will be fixed)
* The tool does not flash for now.
* The tool creates images that are sized 16GB.
* Alacritty comes preinstalled.
* `root` password is `root`
* The tool is subject to change rapidly, please wait for a stable version.
* FfR repos are going to be added and /opt/ configs are going ro be removed.
* Custom branding with an option to remove it is planned.
* Prefer wired networking because of the Wi-Fi firmware being broken. (might obtain from Raspberry Pi repos and package it in FfR repos)
# How to use?
* Install docker. (and arm64 support)
* Configure the spin-container scripts' configuration area.
* Run `sh setup.sh`
* You should now have `fedora-flash.img`!
* The container will be deleted after copying images.
# How to flash?
* Use Etcher to flash `fedora-flash.img` to your configured boot medium.
