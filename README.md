# CommandDB
Offline command reference database files and the scripts to create them.

This is a project to document command line reference page content in an offline lookup file. While there are a few available for things like bash (https://git.kernel.org/pub/scm/docs/man-pages/man-pages), a quality one offline for items line Windows cmd and Powershell are difficult. The goal of this project is to target Bash, CMD, and Powershell to start, then expand into other command languages.

Each Language entry will include a CSV to be used as the primary lookup file, and a txt file containing a single regex string for matching any of the found commands in the contents of another file.

The contents of each CSV file will attempt to include the following:
- Command Name
- Command Description
- Command Syntax
- Command Parameters
- Command Reference Link
- Command Category
- Tags

The command references will be pulled from the following pages:
Windows Commands - https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands
Linux Commands - https://ss64.com/bash/
Powershell Commands - https://ss64.com/ps/

Future development will be to include as many other command groups as possible including all the powershell modules found here: https://learn.microsoft.com/en-us/powershell/module/?view=windowsserver2022-ps
