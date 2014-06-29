SYNOPSIS
--------

    ./build-package -f <flavor> -p <platform> -v <version> -u

DESCRIPTION
--------

`build-package` will create a platform-specific package of Jetbrain's
Intellij IDEA. The packages can be installed using platform
specific/native tools and/or distributed from local package repositories.

It currently only supports building packages of the development builds
of IDEA, either by finding and downloading the latest version directly
from Jetbrain's servers or by being pointed to a build output directory
and use that.

OPTIONS
--------

* `-f <flavor>`

    The IDEA flavor to package. 'flavor' can be one of 'IU' and 'IC'
    for IDEA Ultimate or IDEA Community Edition respectively.

* `-F`

    Force a build of a package, even if there is a package with the same
    version in the repository.

* `-p <platform>`

    The operating system platform to build the package for. Can be one
    of 'debian' and 'solaris'.
    
    'debian' will build a package for any of the Debian based Linux
    distributions, including Debian and Ubuntu.

    'solaris' will build a package for Solaris 8 to 10. The package itself
    will work on later versions of Solaris and OpenSolaris but uses the
    'old style' packaging tools (pkgadd, pkgmk, etc)

    Platform autodetection will be implemented once someone has been
    annoyed enough by the manual procedure.

* `-s <directory>`

    Sets <directory> to be the input directory when creating the
    package. This is used to build packages from custom builds of IDEA.

    Note that you have to specify the version explicitly.

* `-u`

    Updates the package repository with the appropriate command for
    the platform.

    For debian this means dpkg-scanpackages, for solaris bldcat is used.

* `-v <version>`

    The version of the build to use. If not specified the script will
    automatically find and download the latest EAP build of 13.1, 
    discovered from:
    http://confluence.jetbrains.net/display/IDEADEV/IDEA+13.1+EAP

SOLARIS
-------

To build a pkgutil repository run bldcat like this:

    bldcat repository/solaris/`uname -p`/`uname -r`
  
make sure you have the `pkgutilplus` package installed

EXAMPLES
-------

Example 1: Creating a Solaris package of the latest Ultimate Edition.

    ./build-package -f IU -p solaris

Example 2: Creating a Debian package of the 95.4 build of the Community Edition.

    ./build-package -f IC -p debian -v 95.4

Example 3: Creating a Debian from a custom build of IDEA:

    ./build-package -p debian -f IC -v 1.2.3 -s idea-IC-95.54

BUGS
----

The scripts are not bullet proof, so there might certainly be bugs in
them. The scripts also depend on jetbrains to not change the way they
package and distribute the tar files.

If you find a bug, please file a bug on GitHub:
http://github.com/trygvis/intellij-idea-dpkg/issues


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/trygvis/intellij-idea-dpkg/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

