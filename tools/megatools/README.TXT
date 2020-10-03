megatools - command line client application for Mega
====================================================

Megatools is a collection of programs for accessing Mega service from a command
line of your desktop or server.

Megatools allow you to copy individual files as well as entire directory trees
to and from the cloud. You can also perform streaming downloads for example to
preview videos and audio files, without needing to download the entire file.

Megatools are robust and optimized for fast operation - as fast as Mega servers
allow. Memory requirements and CPU utilization are kept at minimum. Megatools
can upload 70MiB/s and download 80 MiB/s on a cheap single core Intel based VPS.

You can register mega account using the 'megatools reg' tool, with the benefit
of having true control of your encryption keys, compared to using mega.nz web
client. Anything done in the web browser uses a code you don't have control over
(unless it's your own website), and thus can't be fully trusted with your
password.

Mega website can be found at https://mega.nz.

Megatools official website is at https://megatools.megous.com


Tools
=====

  reg      Register and verify a new mega account
  df       Show your cloud storage space usage/quota
  ls       List all remote files
  test     Test for existence of remote files or folders
  export   Create public links for remote files
  mkdir    Create remote directory
  rm       Remove remote file or directory
  put      Upload individual files
  get      Download individual files
  dl       Download file from a "public" Mega link
           (doesn't require login)
  copy     Upload or download a directory tree


All of these tools do:

- Local caching of remote session/filesystem information
  for faster execution. Cache is encrypted with your password key.
- Support loading login credentials from a configuration file.


Usage
=====

See the man pages for how to use individual tools:

  man megatools

Man pages are also available online at:

  https://megatools.megous.com/man/megatools.html


Installation on Windows
=======================

Official builds for 32bit and 64bit Windows are avaialbe at:

  https://megatools.megous.com
  https://megatools.megous.com/builds/experimental/

Megatools is also available on Windows via Chocolatey thanks to ERap320.
See:

  https://chocolatey.org/packages/megatools/

You can contact the chockolatey package maintainer here:

  https://github.com/megous/megatools/issues/347


Windows Quirks
==============

On Windows, if you see weird characters in your megals output, you'll need
to set correct CHARSET environment variable. For example on Czech Windows
this would mean executing this command in cmd before using the tools:

  set CHARSET=CP852

This is just a cosmetic issue. Internally, megatools always work with UTF-8
file names, and even if the tool's terminal output is corrupted, files names
of downloaded/uploaded files will be correct.


Installation on macOS
=====================

Thanks to Carl Moden, megatools is available in Homebrew (http://brew.sh/).

You can therefore install megatools with:

  brew install megatools


Installation on your favorite GNU/Linux distribution
====================================================

Megatools may already be pre-packaged in the package repository
of your distribution. It is already available at least in:

- Arch Linux (AUR) - https://aur.archlinux.org/packages/megatools/
- Debian - https://packages.debian.org/sid/megatools
- Fedora - https://admin.fedoraproject.org/pkgdb/package/rpms/megatools/
- Gentoo - https://packages.gentoo.org/packages/net-misc/megatools
- openSUSE - https://software.opensuse.org/package/megatools
- Ubuntu - https://packages.ubuntu.com/cosmic/megatools

Be sure to check your distribution's package repository first.


Installation on FreeBSD
=======================

Megatools is available in ports thanks to Maxim V. Kostikov:

  https://www.freshports.org/net/megatools/


Using a static build for Linux
==============================

Experimental static build is available since version 1.11.0. This build provides
a single megatools binary that can be copied to any GNU/Linux distribution and
run from there. It is reported that you can even copy an ARM build to your
Android smartphone and run it from your phone.

This build is useful if you want to avoid the hassle of bulding megatools on old
distributions like older versions of CentOS or RedHat.

Static builds are available here:

  https://megatools.megous.com/builds/experimental/


Building megatools from source code
===================================

The official source code tarball is available at:

   http://megatools.megous.com/builds/

You should check that the code was released by me by verifying PGP signatures
provided alongside the code.

You will need to install a few dependnencies before you can build megatools from
source code. Package names of these dependencies differ depending on your
GNU/Linux distribution.

Runtime dependencies are: glib2, libcurl and openssl

Build time dependencies are: gcc, make, pkg-config (pkgconf)


On Debian, Ubuntu:

  apt-get -y install build-essential libglib2.0-dev libssl-dev \
    libcurl4-openssl-dev

On Fedora and CentOS:

  yum -y install gcc make glib2-devel libcurl-devel openssl-devel

On OpenSUSE:

  zypper -n install gcc make glib2-devel libcurl-devel openssl-devel

On Arch Linux:

  pacman -Sy --noconfirm --needed pkgconf gcc make glib2 curl

On Alpine Linux:

  apk add --update build-base libcurl curl-dev asciidoc openssl-dev glib-dev \
    glib libtool automake autoconf

WARNING: Newer versions of megatools use meson build system. Build steps
are different for meson.

You can build megatools into your HOME directory, so that they'll not pollute
your /usr or /usr/local by using --prefix=$HOME/.local option to configure.

Example build steps:

  wget https://megatools.megous.com/builds/megatools-1.10.2.tar.gz{,.asc}
  gpg --verify megatools-1.10.2.tar.gz.asc
  cd megatools-1.10.2
  ./configure --prefix=$HOME/.local
  make -j4
  make install

If you encounter issues, read the error messages carefully. They may contain
hints on how you can solve the issue yourself (missing dependencies, missing
C compiler build flags, etc.).

Now you can run megatools from ~/.local/bin.

  export PATH="$HOME/.local/bin:$PATH"
  megals


Building megatools from git repository and contributing code (new method)
=========================================================================

Megatools use meson build system. See https://mesonbuild.com/

Build steps for meson are:

  git clone https://megous.com/git/megatools
  cd megatools
  meson b
  ninja -C b
  sudo ninja -C b install

You may need to install dependencies listed above in the previous section.


Building megatools from git repository and contributing code (old method)
=========================================================================

Building from git is discouraged for most users, unless you want to contribute
your code to megatools.

Please don't report build issues against code that you downloaded from git if
you're an end user and don't intend to do development on megatools. This is not
a supported method of building megatools for end users, and it is not expected
to work on all distributions, or at all. If you're an end user, just use the
official tarball. If you're a developer and want help with building megatools
from git, make sure to mention it, otherwise I'll assume you're an end user and
just refer you to this README.

If you want to contribute to megatools, you can send patches via e-mail to
megatools@megous.com. The main GIT repository is available at:

  https://megous.com/git/megatools

In addition to the regular build steps, you'll need to install additional
dependencies. For building from git repository, you'll also need: asciidoc,
docbook-xml, autoconf, libtool, automake.

Now, get the code using git:

  git clone https://megous.com/git/megatools

Documentation is built separately from the code, and must be built first.
Running make -C docs should build the docs, if you have all the dependencies
installed correctly.

Run ./autogen.sh instead of ./configure

The rest of the steps is the same as the regular source code build.

Example build steps:

  git clone https://megous.com/git/megatools
  cd megatools
  make -j8 -C docs
  ./autogen.sh --prefix=$HOME/.local
  make -j4
  make install


Third party tools/scripts
=========================

Megatools are meant as a low-level tools that can be used as a base to create
more complicated tools for working with mega.nz. Other people have created
a third party scripts on top of megatools. If you're one of them and want to
have your project listed here, let me know.

Some third party tools can be found at:

  https://amourspirit.github.io/mega_scripts/


Author
======

Megatools were written by Ondřej Jirman <megatools@megous.com>, 2013-2019

My PGP key can be found at: https://megous.com/key.txt
  (Fingerprint is: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED)

Official website is: https://megatools.megous.com


Contributors
============

- Chris Tarazi <tarazichris@gmail.com>
- Tom Maneiro <tomman@tsdx.net.ve>
- bAndie91 <bandie9100@gmail.com>
- Alberto Garcia <berto@igalia.com>
- David Guillen Fandos <david@davidgf.net>
- Erik Nordstrøm <erik@nordstroem.no>
- Johnathan Jenkins <john@nixheads.co.uk>
- Kagami Hiiragi <kagami@genshiken.org>
- Matthew Schultz <mattsch@gmail.com>
- Michael Ledin <mledin89@gmail.com>
- Michael Ripley <zkxs00@gmail.com>
- Palmer Dabbelt <palmer@dabbelt.com>
- RealDolos <dolos@cock.li>
- Viktor (Icon) VAD <vad.viktor@gmail.com>
- cyrozap <cyrozap@gmail.com>
- nyuszika7h <nyuszika7h@gmail.com>
- protomouse <root@protomou.se>
- strupo <sheeit@users.noreply.github.com>
- wdlkmpx <wdlkmpx@gmail.com>
- dal1a <waveh@trimsj.com>


Support and bug reports
=======================

If you think you've found bug in megatools, send a report including enough
information for recreating the issue to: megatools@megous.com Your message
will end up in a public archive, so be careful what you say, or infomration
you send.

I respond to most e-mails, so if you are not getting a response within a few
days, check your spam folder.


License
=======

Megatools are licensed under GPLv2 with OpenSSL exemption, see LICENSE
file for details.

This product includes software developed by the OpenSSL Project for use
in the OpenSSL Toolkit. (http://www.openssl.org/)
