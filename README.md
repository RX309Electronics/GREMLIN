# Under maintennace currently!

# Introduction
You might have already read the description, but this project builds a functional, pretty fully-featured Embedded Linux distro that uses Xorg and Supports SDL and OpenGL. It is primarily intended to run your graphical apps that might need an os backbone. This is a hobby project and i primarily made it for my own projects so i included a lot of stuff inside of it that is/might be handy to use, but of course you can edit the configuration file and rip stuff out or add stuff in. Its based on buildroot, a build environment and toolset for building embedded linuxes, that have the stuff,  you select, compiled in and nothing else, unlike a traditional distro. This makes it so depending on what you select, you wont have all the bloat or overhang like a traditional GNU/Linux distro, and also no standard packagemanager or installer. This project builds a initrd, but also builds a ext2/ext4 image you can directly flash to a drive, and it builds a linux kernel of course! Its intended for X86_64 based pc's, due to 32bit being thrown out the window in a few releases of the linux kernel and other packages, cause the amount of x86 / i386 users is quite small and thus its not worth the effort to maintain. I focus now on pc's, but might later port it over to Arm platforms. You can use this distro for whataver you might need that requires a UI. I will primarily use it for my Python or C/C++ Applications, like a screen for a vending machine/ordering kiosk/control panel, but you can also enable a webbrowser in the menuconfig and use it as a kiosk.

# Why the name?
I dont really know why, but the name 'GREMLIN' fit perfectly with the goal and end product. A 'GRaphical EMbedded LINux' distro. Also cause i came up with the idea in a mischievous moment, and i wanted to think of a name that described/included part of the project but also was not random letters or gibberish. 

# What do i get?
A Full working embedded linux distro with:
- Xorg and SDL
- Audio support
- Touchscreen and mouse input
- On-screen keyboard
- Python3 + Pip built in
- Networking and NTP time
- A Userland with a ton of handy and nice to have stuff
- smaller format than most typical Distro's
- possibility to run as a ramdisk
- user customisability in mind
- Splash screen support

# How to build?
1. Simply git clone the repository into whatever directory you like and 'cd' into the directory of the project.
2. First off all, to prepare everything and download buildroot, run './prepare.sh' and wait for it to complete.
3. Simply run './build.sh', which will start building everything.
4. Find your output files in buildroot/output/images. Kernel will be 'bzImage' and rootfs will be in .cpio.gz or .ext2/ext4 format. 

