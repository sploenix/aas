This directory can be used to include custom scripts within ArchAdminScript.sh.

Your scripts have to be located in a subfolder, e.g. EXAMPLE1, EXAMPLE2, ... . Inside this folder there has to be a script run.sh.
This script can be run from ArchAdminScript.sh using the command line switch -c or --custom. For the custom script
in the folder EXAMPLE your have to call ArchAdminScript.sh -c EXAMPLE1,EXAMPLE2,... .
