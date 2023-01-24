#! /bin/bash
# Scrapes MSdocs for list of windows commands. Captures them with "-" instead of spaces so they can be used in a URI
curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands | grep -e '<li><a href="' | sed -e 's/^[^"]*"//' | sed -e 's/"[^\n]*//' | grep '^[^/]' >> cmdURI.txt

# Scrapes MSdocs for list of windows commands. Replaces "-" with a space so multiple word commands can be properly regexed.
curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands | grep -e '<li><a href="' | sed -e 's/^[^"]*"//' | sed -e 's/"[^\n]*//' | grep '^[^/]'| sed -e 's/-/ /g'>> wincmdlist.txt

# Sorts commands in wincmdlist.txt by decending length then replaces newline characters with a "|" for use in regex.
cat wincmdlist.txt | sed 's/^[ \t]*//' | awk '{ print length, $0 }' | sort -n -r | cut -d" " -f2- | tr "\n" "|" | tr '[:upper:]' '[:lower:]' | sed 's/^/\\b(?<![a-zA-Z-])(/' | sed 's~|$~)(?![a-zA-Z-\.])\\b/g~' >> wincmdregex.txt

#For each entry in cmdURI.txt, create a link to the description page.
curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands | grep -e '<li><a href="' | sed -e 's/^[^"]*"//' | sed -e 's/"[^\n]*//' | grep '^[^/]' | sed 's|^|https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/|' >> links.txt

#For each entry in cmdURI.txt, curls the appropriate description page and parses out the Description section.
while read f; do
    echo $f
    g=$(curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/"${f}" | grep -A 1 -e '<content>' -e '</blockquote>'  | grep "<p>" | sed -e 's/^[ \t]*//' | sed -e 's/^<p>//' | sed -e 's|</p>||')
    n=${#g};
    if (( $n > 1 ));
    then
        echo '"'$g'"' >> description.txt;
    else
        echo '"No description Available"' >> description.txt;
    fi;
done < cmdURI.txt

#For each entry in cmdURI.txt, curls the appropriate description page and parses out the Syntax section.
while read f; do
    echo $f
    g=$(curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/"${f}" | grep -A 1 '<h2 id="syntax">Syntax</h2>' | grep '<pre><code>' | sed 's/<pre><code>//' | sed 's/&lt;/</g' | sed 's/&gt;/>/g')
    n=${#g};
    if (( $n > 1 ));
    then
        echo '"'$g'"' >> Syntax.txt;steam os
    else
        echo '"No description Available"' >> Syntax.txt;
    fi;
done < cmdURI.txt

#For each entry in cmdURI.txt, curls the appropriate description page and parses out the Parameters section.
while read f; do
    echo $f
    g=$(curl -s https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/"${f}" | sed '/<th>Parameter/,$!d' | sed '/<h3 id=/,$d'| grep '<td>' | sed 's/<td>//g' | sed 's|</td>||g' | sed 's/&lt;/</g' | sed 's/&gt;/>/g' |sed '1~2s/$/ - /'  | paste -s -d' \n'| sed 's/$/ | /g' | sed 's/<code>//g' | sed 's|</code>||g' | sed 's/<strong>//g' | sed 's|</strong>||g' | sed 's|<em>||g' | sed 's|</em>||g' | sed 's|\. [A-Z][^|]*<a href.*</a>[^\.]*\.||g' | sed 's|<a href="||g' | sed 's|" data-linktype="relative-path">||g' | sed 's|</a>||g' | sed 's|<li>||g' | sed 's|</li>||g' | sed 's|<ul>||g' | sed 's|</ul>||g' | sed 's|<br>| |g' | sed 's|<br/>| |g' | sed 's|</br>||g' | sed 's|<p>| |g' )
    n=${#g};
    if (( $n > 3 ));
    then
        echo '"'$g'"' | sed 's/ | "/"/g' >> Parameters.txt;
    else
        echo '"No description Available"' >> Parameters.txt;
    fi;
done < cmdURI.txt

# combines all entries into a csv file for lookup and deletes the txt files used in building.
paste -d',' wincmdlist.txt description.txt Syntax.txt Parameters.txt links.txt| sed 's/ |/\n/g' | sed 's/<code>//g' | sed 's|</code>||g' | sed 's/<strong>//g' | sed 's|</strong>||g' | sed 's|<em>||g' | sed 's|</em>||g' | sed 's|\. [A-Z][^|]*<a href.*</a>[^\.]*\.||g' | sed 's|<a href="||g' | sed 's|" data-linktype="relative-path">||g' | sed 's|</a>||g' | sed 's|<li>||g' | sed 's|</li>||g' | sed 's|<ul>||g' | sed 's|</ul>||g' | sed 's|<br>| |g' | sed 's|<br/>| |g' | sed 's|</br>||g' | sed 's|<p>| |g' >> wincmddb.csv
rm description.txt
rm Syntax.txt
rm Parameters.txt
rm cmdURI.txt
rm wincmdlist.txt
rm links.txt
