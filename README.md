# Currently in Alpha-Stable

# Introduction/Description
You might have already read the description, but this project builds a functional, pretty fully-featured Embedded Linux distro that uses Xorg and Supports SDL. It is primarily intended to run your graphical apps that might need an os backbone. This is a hobby project and i primarily made it for my own projects so i included a lot of stuff inside of it that is handy to use, but of course you can edit the configuration file and rip stuff out or add stuff in. Its based on buildroot, a build environment and toolset for building embedded linuxes, that have the stuff you select, compiled in and nothing else, unlike a traditional distro. This makes it so depending on what you select, you wont have all the bloat or overhang like a traditional GNU/Linux distro, and also no standard packagemanager or installer. This project builds a initrd, but also builds a ext2/ext4 image you can directly flash to a drive, and it builds a linux kernel of course! Its primarily intended for running python GUI Apps like with sdl or Pygame, and it has pip package manager pre-installed. On first deployment, you might need to implement some logic yourself that it downloads all dependancies and then boots the application. 
This is an inide side-project that is being maintained and created by myself, out of interst for embedded linux and as a hobby project so i dont live my day doomscrolling on tiktok or youtube. If you would like to contribute or suggest features to implement/change, feel free to do so, but contact me first. I'll try and respond as soon as i can, but i am still just a student who is busy with school and work life and i cant always respond quickly, but i will try and respond in 2 weeks max. 

# Why the name?
I dont really know why, but the name 'GREMLIN' fit perfectly with the goal and end product. A 'GRaphical EMbedded LINux' distro. Also cause i came up with the idea in a mischievous moment, and i wanted to think of a name that described/included part of the project but also was not random letters or gibberish. I also could not think of a better name. If you have any suggestion for a better name, feel free to leave it in the Issues tab or somewhere on my github, or email me @309Electronics@gmail.com. 

# What do you get?
A Full working embedded linux distro with:
- Xorg and SDL(2).
- Networking & NTP time setting.
- Audio support.
- Touchscreen support.
- User customiseability in mind.
- Set and Forget deployment.
- Support for running as a RAMDISK.
- Error handeling and fallback mechanisms.
- Smaller footprint than commercial GNU/Linux distros.
- Not too much bloat.
- A nice userland with plenty of handy stuff.
- Some nice games embedded for testing functionality or just for fun.
- 2 Stage Init, with support for custom services put in /System/Services named like this S{service_number}{Service_name}. Eg: S25Foobar.
- No SystemD, just normal busybox Init.
- Ssh
- Matchbox window manager
- Python3 and Pip preinstalled
- Easy to use build system
- Linux-6.x.x kernel
- Isolated /System directory for Services and the Application.
- Freedom of use
- Passion and enthusiasm put in

# What is the boot flow?
BIOS/UEFI > Bootloader > Linux kernel > Init Stage1 (Start basic low level system services like rng, syslog, udev, klog, etc etc) > Xorg (Started in Stage1) > Init Stage2 (Load higher level services like; Network, Avahi, ntp, ssh, etc etc) > Start Window manager (matchbox) fullscreen > Start /System/App/App_init.sh > Application. 
While its starting and initialising everything, it will write a lot of logfiles to make debugging really easy. If App_init.sh fails, or the App directory or App_init.sh does not exist, it enters a developer shell. In App_init.sh, you can put all the logic to start your desired application (eg some pygame GUI or whatever project). 

# What architecture(s) does it support?
Currently only X86_64, but i want to expand it to Arm platforms (raspberry pi and other known boards primarily) in the future somewhere. 32 bit (legacy i386/x86) is not supported, due to 32 bit suport being slowly phased out of the Linux kernel and Linux ecosystem because its not worth maintaining for such a small userbase. And many people these days have a 64 bit computer/sbc, so for me its also not worth it to implement legacy x86/i386. But if you want, you can do it yourself if you are familiar with buildroot and Linux, but you gotta fix bugs and issues yourself. If anyone would like to help speed up this porting over step, also feel free to do so, but follow the aformentioned rules.

# How to build?
1. Clone the repository in whatever directory you like (personally, the /home/{user} directory will be used standard)
2. Install all the typical tools: which, sed, make, binutils, build-essential, gcc, g++, bash, patch, perl, tar, cpio, unzip, rsync, findutils, bc, awk, wget, curl, qemu, ncurses
3. cd into the directory of the project.
4. execute './prepare.sh' to prepare the build. This downloads buildrooit source code and applies configurations.
5. Create/copy over your App_init.sh to /System/App and make sure its executable and if relevant, also copy over the Application itself and its files. 
6. execute './build.sh'. It will initially ask if you want to do any before-build modifications. Answer either y/n and it will start building. Please note: This can take quite some time on slow/old systems, just be patient.
7. If everything went well, it should say '[Build SUCCESS]'in terminal.
8. (Optional) Try it out by executing './Test.sh', which will launch qemu and boot up your distro as a RAMDISK initially (Unless you remove the rootfs.cpio, then it auto falls back to using the disk image).

# How to modify the build?
If you need to modify the buildroot or kernel config, simply run './build.sh' again and it will prompt you if you want to modify the buildroot config (and if the kernel has been built), the kernel config. For this it will open the easy to use ncurses based buildroot and linux menuconfig. Apply configurations in this menu and hit save, then it auto continues to the build. If you need to modify any of the Init scripts or add Services/your application binary, go to the buildroot-external/overlay directory and apply modifications inside here, as this overlay gets copied everytime to the targets root filesystem. Changing the files in output/target in the buildroot folder will not be perssistent. The whole overlay directory will get copied over as it is, so overlay/etc will be copied as /etc in the target rootfs folder. 
If you need to modify specific elements, cd into the 'buildroot' folder and then execute 'make {package_name}-menuconfig'. (eg: make linux-menuconfig, make busybox-menuconfig). 

# (Remote) Administration
You can ssh into the system running the distro, or hook up a keyboard (and or mouse) and then switch tty or enter some UART console.







