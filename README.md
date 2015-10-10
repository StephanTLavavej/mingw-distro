# MinGW Distro: [nuwen.net/mingw.html](http://nuwen.net/mingw.html)

Here are the build scripts for my MinGW distro.

You'll need to run them in MSYS2, which you can set up without an installer:

* Go to: http://sourceforge.net/projects/msys2/files/Base/x86_64/
* Download the most recent version of: `msys2-base-x86_64-20150916.tar.xz`
* Extract it to: `C:\Temp\gcc\msys64`
* Run: `msys2_shell.bat`
* CLOSE AND RESTART MSYS2.
* In MSYS2, run: `update-core`
* CLOSE AND RESTART MSYS2.
* In MSYS2, run: `pacman -Su cmake diffutils make nasm patch tar texinfo`

### Important Notes

The build scripts assume that they can use `C:\Temp\gcc` as a working directory and that they do not live directly within it.
They also assume that they live next to the sources. I generally put both of them into `C:\Temp\gcc\sources-VERSION` .

I **highly** recommend that you execute each build script **by hand** before attempting to run it in one shot.

Stephan T. Lavavej - stl@nuwen.net
