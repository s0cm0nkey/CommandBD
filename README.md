# CommandBD
Offline command reference database files and the scripts to create them.

This is a project to document command line reference page content in an offline lookup file. While there are a few available for things like bash (https://git.kernel.org/pub/scm/docs/man-pages/man-pages), a quality one offline for items line Windows cmd and Powershell are difficult. The goal of this project is to target Bash, CMD, and Powershell to start, then expand into other command languages.

Each Language will have a simple bash script used to scrape and parse the contents of the appropriate web page, then format its output. The output will include a CSV to be used as the primary lookup file, and a txt file containing a single regex string for matching any of the found commands in the contents of another file.

The contents of each CSV file will attempt to include the following:
- Command Name
- Command Description
- Command Syntax
- Command Parameters
- Command Reference Link

Future development will look to add user generated tags and categories for reference.

The command references will be pulled from the following pages:
- https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands
- https://ss64.com/bash/
- https://www.pdq.com/powershell/
