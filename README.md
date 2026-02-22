# spin
Install Linus Torvalds' favorite distro on your Raspberry Pi
# What is spin?
> **THIS SOFTWARE IS EXPERIMENTAL, CONTINUE WITH CAUTION**<br>

Fedora Linux installer for Raspberry Pi. Tested on Raspberry Pi 5 (8GB) + Fedora 43 installation + Raspberry Pi OS latest to run spin.<br>
This tool installs Fedora Linux to a USB device or an SD card with required Raspberry Pi firmware. It should be used in aarch64 Linux devices that support chroot and have root access, wget, tar, git, xz, arch-install-scripts, sudo etc. It installs Fedora Linux to an *external* drive. To use the tool in another kernel or another architecture (not tested) you could use a container that supports chroot to do so. Fedora roots are downloaded from [https://images.linuxcontainers.org/](https://images.linuxcontainers.org/). Kernel and EEPROM is fetched from Raspberry Pi's firmware repository. Fedora and spin do **not** support *32-bit ARM* architectures, the parameters are there for further customisation.
# Known Issues
* Plymouth doesn't work when powering off or rebooting.
* Changing boot medium after installation requires more configuration.
* /boot is separated from the real boot partition. The files get copied to /rpiconf. The config is stored at /opt/rpiconf.txt and the default config is stored at /opt/rpiconfig_default.txt
* GPU works but sometimes might create unwanted artifacts on **desktop**. Logging out then logging back in again mostly fixes this issue. This issue does not happen in TTYs.
* Kernel headers are only for arm64
* First boot may not have a splash due to the kernel configuration not being done.
* Installing Linux kernel from Fedora might break the installation. Use `rpi-*` tools to install these.
# Image configuration
The spin tool installs the default Fedora Workstation (GNOME) into your system. To change this, change the "dnf group install workstation-product-environment" to another group you want to install. "dnf group install server-product-environment" installs Fedora Server. After the image is prepared to be installed, you will be on a chroot environment to modify the image.
# Updates
The spin tool itself won't update your system. You can update your system using dnf. To update Raspberry Pi kernel, use `rpi-kernel-update` (updater also updates kernel modules and Pi firmware); for EEPROM, use `rpi-eeprom-updater`; for syncing /boot with /rpiconf, use `rpi-boot-update`; for syncing the config file, use `rpi-config-update`; for headers use `rpi-header-update` (auto called from kernel updater); for initramfs use `rpi-initramfs-update`; to add `rhgb`, `plymouth.enabled=1`, `quiet`, `splash` to the kernel cmdline use `rpi-cmdline-update`. All `rpi-*` commands require uninterrupted power, root access (run as root) and some require access to the Internet. Use `rpi-update` to update all kernel and boot related objects (does NOT include initramfs). 
# Changing boot medium (manually)
Mount the old boot medium containing the files and clone it to the new boot medium (using disk cloners etc.). Change the cmdline.txt on the new boot partition's `root=` argument according to the new medium. Then, mount the new root partition and change `/etc/fstab` file according to your disks.
# Misc Information
* The eeprom-updater sticks to the master branch of rpi-eeprom. You have to clone it again if you want a different branch (clone to /opt/eeprom-updater)
* Only cypress and brcm firmware blobs are unpacked.
* Every git clone uses `--depth 1`
* Initramfs update should be done using `rpi-initramfs-update`.
* You should reboot after `rpi-kernel-update` to make sure you are on the newest release before running `rpi-initramfs-update`.
* The system can run without an initramfs, you can delete the `initramfs` entries on configuration files. Plymouth won't work and no rescue shell will be available.
* Default plymouth theme is `bgrt`, to change it; use `plymouth-set-default-theme`, then `rpi-initramfs-update`.
* Default Wi-Fi country is US. It might auto change after connecting to a network. To change, use `iw reg set COUNTRY_CODE`. To check, use `iw reg get`.
* rfkill is disabled by default.
* Dracut creates initramfs for every kernel found at /lib/modules.
* The tool does not flash for now.
