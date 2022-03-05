#!/bin/sh

# TODO rework into C++
#  - download special offers from links in txt file
#  - sort the list
#  - merge duplicate offers into one
#  - show the list in a table?

cat /dev/null > "/tmp/akcie.txt"

# Load special offers from zlacnene.sk

number_of_pages="$(curl --silent "https://www.zlacnene.sk/akciovy-tovar/zelenina/najlacnejsie/strana-1/" | grep '<span class="qc-sel">' | sed 's:</option></select></span><span>/:\nnumber_of_pages=:g' | sed 's:</span></label></div></div></div><div class=:\n</span></label></div></div></div><div class=:g' | grep "number_of_pages=" | cut -d '=' -f 2)"

for page_number in $(seq 1 "${number_of_pages}")
do
  curl --silent "https://www.zlacnene.sk/akciovy-tovar/zelenina/najlacnejsie/strana-${page_number}/" | sed 's#itemtype="http://schema.org/Product"#\n---\n#g' | sed 's:/"><strong>:\nstore=:g' | sed 's:</strong></a></h3>:\n:g' | sed 's/<span itemprop="name" content="\s*/\nname=/g' | sed 's/" aria-hidden="true"/\n/g' | sed 's/itemprop="price" content="/\nprice=/g' | sed 's:"></span>:\n:g' | sed 's:<i class="far fa-calendar-alt"></i> :\nfrom=:g' |  sed 's/ - <span class="platiDo">/\nuntil=/g' | sed 's:</span></p><p class="mb-1:\n:g' | grep -e "name=" -e "price=" -e "store=" -e "from=" -e "until=" -e "---" | tail -n +5 | head -n -1 >> "/tmp/akcie.txt"
done

number_of_pages="$(curl --silent "https://www.zlacnene.sk/akciovy-tovar/ovocie/najlacnejsie/strana-1/" | grep '<span class="qc-sel">' | sed 's:</option></select></span><span>/:\nnumber_of_pages=:g' | sed 's:</span></label></div></div></div><div class=:\n</span></label></div></div></div><div class=:g' | grep "number_of_pages=" | cut -d '=' -f 2)"

for page_number in $(seq 1 "${number_of_pages}")
do
  curl --silent "https://www.zlacnene.sk/akciovy-tovar/ovocie/najlacnejsie/strana-${page_number}/" | sed 's#itemtype="http://schema.org/Product"#\n---\n#g' | sed 's:/"><strong>:\nstore=:g' | sed 's:</strong></a></h3>:\n:g' | sed 's/<span itemprop="name" content="\s*/\nname=/g' | sed 's/" aria-hidden="true"/\n/g' | sed 's/itemprop="price" content="/\nprice=/g' | sed 's:"></span>:\n:g' | sed 's:<i class="far fa-calendar-alt"></i> :\nfrom=:g' |  sed 's/ - <span class="platiDo">/\nuntil=/g' | sed 's:</span></p><p class="mb-1:\n:g' | grep -e "name=" -e "price=" -e "store=" -e "from=" -e "until=" -e "---" | tail -n +5 | head -n -1 >> "/tmp/akcie.txt"
done

# Load special offers from kompaszliav.sk

# The page gives a much broader overview of current special offers in more shops, but some entries lack price which has to be looked up manually within the catalogue
#  and the page is protected with CloudFlare to prevent DDoS attacks which makes the page even harder to access via curl

#curl --silent 'https://kompaszliav.sk/zelenina?storeFilterAmp-monitoringProducts-page=0&storeFilterAmp-monitoringProducts-column=price&storeFilterAmp-monitoringProducts-order=asc&storeFilterAmp-monitoringProducts-archive=0&store=billa,coop-jednota,kaufland,kraj,lidl,metro,potraviny-koruna,tesco,tesco-supermarket&do=storeFilterAmp-monitoringProducts-showProducts' \
#  -H 'Host: kompaszliav.sk:443' \
#  -H 'Accept: */*' \
#  -H 'sec-ch-ua: "Chromium";v="97", " Not;A Brand";v="99"' \
#  -H 'sec-ch-ua-mobile: ?0' \
#  -H 'sec-ch-ua-platform: "Linux"' \
#  -H 'Sec-Fetch-Dest: empty' \
#  -H 'Sec-Fetch-Mode: cors' \
#  -H 'Sec-Fetch-Site: same-origin' \
#  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' \
#  -H 'X-Requested-With: XMLHttpRequest' \
#  | grep "\{.*\"snippets\":" | sed '/"snippets"/s/":"\s*/":"\n/g' | tail -n -1 \
#  | sed 's:\\n::g' \
#  | sed 's:[\\/]&quot;::g' \
#  | sed 's/\\//g' \
#  | sed 's/^\s*//g' \
#  | sed 's:<tr>:\n<tr>:g' \
#  | sed 's:</tr>::g' \
#  | sed 's:<td>:\n<td>:g' \
#  | sed 's/<td class="price">/\n<td class="price">/g' \
#  | sed 's:</td>::g' \
#  | sed 's:\s*</div>::g' \
#  | tr --squeeze '[:space:]' \
#  | grep \
#    -e 'class="store-name"' \
#    -e 'class="desc"' \
#    -e 'class="validity-cell-wrapper"' \
#    -e 'class="price"' \
#    -e '<a href="https://kompaszliav.sk/' \
#  | sed 's/<tr class="last-detail">/\n<tr>/g' \
#  | sed 's/<tr>.*<div>/store=/g' \
#  | sed 's#<td> <a href="https://kompaszliav.sk/.*">#subcategory=#g' \
#  | sed '/subcategory=/s/\s*<\/a>//g' \
#  | sed 's/<td> <div class="desc">\s*/name=/g' \
#  | sed '/name=/s/<a href=".*$//g' \
#  | sed 's/\. - /\nuntil=/g' \
#  | sed 's/<td> <div class="validity-cell-wrapper">.*>\s*/from=/g' \
#  | sed '/until=/s/\s*<\/a>.*//g' \
#  | sed 's/<td class="price">\s*/price=/g' \
#  | sed '/price=/s/<div>\s*.*<\/p>\s*//g' \
#  | sed '/price=/s/<div>\s*//g' \
#  | sed '/price=/s/<a href="//g' \
#  | sed '/price=/s/">.*$//g' \
#  | sed '/price=/s/\s*"}}\s*//g' \
#  | sed '/price=/s/ €.*\s*//g' \
#  | sed '/price=/s/,/\./g' \
#  | sed '/price=/s/$/\n---/g' \
#  | nl | less

printf "%s\n" "---" >> "/tmp/akcie.txt"

page_index=0
while true
do
  products_in_special_offer="$(\
    curl --silent "https://kompaszliav.sk/zelenina?storeFilterAmp-monitoringProducts-page=${page_index}&storeFilterAmp-monitoringProducts-column=price&storeFilterAmp-monitoringProducts-order=asc&storeFilterAmp-monitoringProducts-archive=0&store=billa,coop-jednota,kaufland,kraj,lidl,metro,potraviny-koruna,tesco,tesco-supermarket&do=storeFilterAmp-monitoringProducts-showProducts" \
      -H 'Host: kompaszliav.sk:443' \
      -H 'Accept: */*' \
      -H 'sec-ch-ua: "Chromium";v="97", " Not;A Brand";v="99"' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'sec-ch-ua-platform: "Linux"' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Site: same-origin' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' \
      -H 'X-Requested-With: XMLHttpRequest' \
      | grep "\{.*\"snippets\":" | sed '/"snippets"/s/":"\s*/":"\n/g' | tail -n -1 \
      | sed 's:\\n::g' \
      | sed 's:[\\/]&quot;::g' \
      | sed 's/\\//g' \
      | sed 's/^\s*//g' \
      | sed 's:<tr>:\n<tr>:g' \
      | sed 's:</tr>::g' \
      | sed 's:<td>:\n<td>:g' \
      | sed 's/<td class="price">/\n<td class="price">/g' \
      | sed 's:</td>::g' \
      | sed 's:\s*</div>::g' \
      | tr --squeeze '[:space:]' \
      | grep \
        -e 'class="store-name"' \
        -e 'class="desc"' \
        -e 'class="validity-cell-wrapper"' \
        -e 'class="price"' \
        -e '<a href="https://kompaszliav.sk/' \
      | sed 's/<tr class="last-detail">/\n<tr>/g' \
      | sed 's/<tr>.*<div>/store=/g' \
      | sed 's#<td> <a href="https://kompaszliav.sk/.*">#subcategory=#g' \
      | sed '/subcategory=/s/\s*<\/a>//g' \
      | sed 's/<td> <div class="desc">\s*/name=/g' \
      | sed '/name=/s/<a href=".*$//g' \
      | sed 's/\. - /\nuntil=/g' \
      | sed 's/<td> <div class="validity-cell-wrapper">.*>\s*/from=/g' \
      | sed '/until=/s/\s*<\/a>.*//g' \
      | sed 's/<td class="price">\s*/price=/g' \
      | sed '/price=/s/<div>\s*.*<\/p>\s*//g' \
      | sed '/price=/s/<div>\s*//g' \
      | sed '/price=/s/<a href="//g' \
      | sed '/price=/s/">.*$//g' \
      | sed '/price=/s/\s*"}}\s*//g' \
      | sed '/price=/s/ €.*\s*//g' \
      | sed '/price=/s/,/\./g' \
      | sed '/price=/s/$/\n---/g' \
  )"

  if [ -z "${products_in_special_offer}" ]
  then
    break
  fi

  printf "%s\n" "${products_in_special_offer}" >> "/tmp/akcie.txt"
  page_index=$(( page_index + 1 ))
done

page_index=0
while true
do
  products_in_special_offer="$(\
    curl --silent "https://kompaszliav.sk/ovocie?storeFilterAmp-monitoringProducts-page=${page_index}&storeFilterAmp-monitoringProducts-column=price&storeFilterAmp-monitoringProducts-order=asc&storeFilterAmp-monitoringProducts-archive=0&store=billa,coop-jednota,kaufland,kraj,lidl,metro,potraviny-koruna,tesco,tesco-supermarket&do=storeFilterAmp-monitoringProducts-showProducts" \
      -H 'Host: kompaszliav.sk:443' \
      -H 'Accept: */*' \
      -H 'sec-ch-ua: "Chromium";v="97", " Not;A Brand";v="99"' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'sec-ch-ua-platform: "Linux"' \
      -H 'Sec-Fetch-Dest: empty' \
      -H 'Sec-Fetch-Mode: cors' \
      -H 'Sec-Fetch-Site: same-origin' \
      -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36' \
      -H 'X-Requested-With: XMLHttpRequest' \
      | grep "\{.*\"snippets\":" | sed '/"snippets"/s/":"\s*/":"\n/g' | tail -n -1 \
      | sed 's:\\n::g' \
      | sed 's:[\\/]&quot;::g' \
      | sed 's/\\//g' \
      | sed 's/^\s*//g' \
      | sed 's:<tr>:\n<tr>:g' \
      | sed 's:</tr>::g' \
      | sed 's:<td>:\n<td>:g' \
      | sed 's/<td class="price">/\n<td class="price">/g' \
      | sed 's:</td>::g' \
      | sed 's:\s*</div>::g' \
      | tr --squeeze '[:space:]' \
      | grep \
        -e 'class="store-name"' \
        -e 'class="desc"' \
        -e 'class="validity-cell-wrapper"' \
        -e 'class="price"' \
        -e '<a href="https://kompaszliav.sk/' \
      | sed 's/<tr class="last-detail">/\n<tr>/g' \
      | sed 's/<tr>.*<div>/store=/g' \
      | sed 's#<td> <a href="https://kompaszliav.sk/.*">#subcategory=#g' \
      | sed '/subcategory=/s/\s*<\/a>//g' \
      | sed 's/<td> <div class="desc">\s*/name=/g' \
      | sed '/name=/s/<a href=".*$//g' \
      | sed 's/\. - /\nuntil=/g' \
      | sed 's/<td> <div class="validity-cell-wrapper">.*>\s*/from=/g' \
      | sed '/until=/s/\s*<\/a>.*//g' \
      | sed 's/<td class="price">\s*/price=/g' \
      | sed '/price=/s/<div>\s*.*<\/p>\s*//g' \
      | sed '/price=/s/<div>\s*//g' \
      | sed '/price=/s/<a href="//g' \
      | sed '/price=/s/">.*$//g' \
      | sed '/price=/s/\s*"}}\s*//g' \
      | sed '/price=/s/ €.*\s*//g' \
      | sed '/price=/s/,/\./g' \
      | sed '/price=/s/$/\n---/g' \
  )"

  if [ -z "${products_in_special_offer}" ]
  then
    break
  fi

  printf "%s\n" "${products_in_special_offer}" >> "/tmp/akcie.txt"
  page_index=$(( page_index + 1 ))
done

# TODO load special offers from dohliadac.sk
#  Later... The page has an API but it doesn't find as much special offers as zlacnene.sk
#curl --silent "https://api.dohliadac.sk/v2/discounts/filter?category=5a1a07ba45fdd100244d5377&page=1&order=price"
#curl --silent "https://api.dohliadac.sk/v2/discounts/filter?category=5a1a07ba45fdd100244d5377&page=2&order=price"

#TODO translate unicode codepoint into readable character
#perl -C -e 'print chr 0x00e1'
# or
#echo -ne '\x00\xe1' | iconv -f utf-16be

android_phone_adb_id="$(adb devices | tail -n +2 | head -n 1 | tr '[:blank:]' ' ' | cut --delimiter=' ' --fields=1)"

if [ -n "${android_phone_adb_id}" ]
then
  adb push /tmp/akcie.txt /storage/extSdCard/akcie.txt | grep --invert-match "adb: error: failed to"
  adb push /tmp/akcie.txt /sdcard/akcie.txt | grep --invert-match "adb: error: failed to"
fi

# Push to all 'mtp' directories, i.e. mounted Android phones 
cp "/tmp/akcie.txt" "/run/user/1000/gvfs/mtp:host=SONY_G3121_RQ300688BU/Interner gemeinsamer Speicher/akcie.txt" 2>/dev/null

echo "Open current special offers with e.g."
echo
echo "less "/tmp/akcie.txt""

less "/tmp/akcie.txt"

# README.md
#Sources
#- https://duckduckgo.com/?q=replace+character+in+matched+line+only&ia=web
#- https://duckduckgo.com/?q=append+to+line+sed+pattern&ia=web
#- https://www.golinuxhub.com/2017/12/sed-add-or-append-character-at/ 
#- https://duckduckgo.com/?q=remove+new+line+after+pattern&ia=web
#- https://www.unix.com/shell-programming-and-scripting/95486-sed-how-remove-newline-after-pattern.html#2
#- https://stackoverflow.com/questions/2191989/a-command-line-html-pretty-printer-making-messy-html-readable
#- https://archlinux.org/packages/community/x86_64/jq/
#- https://itsfoss.com/pretty-print-json-linux/
#- https://curl.se/docs/http-cookies.html
#- https://duckduckgo.com/?q=head+except+first+line&ia=web
#- https://duckduckgo.com/?q=curl+get+request+parameters&ia=web
#- https://phoenixnap.com/kb/curl-user-agent
#- https://duckduckgo.com/?q=bash+convert+utf+code+codepoint+to+character&ia=web&iax=qa
#- https://gist.github.com/yasinkuyu/bb3e1abe15ebdc099201724f4cbd2100
#- https://duckduckgo.com/?q=curl+cloudflare&ia=web
#- PHP CURL function which bypasses the Cloudflare: https://gist.github.com/yasinkuyu/bb3e1abe15ebdc099201724f4cbd2100
#- https://stackoverflow.com/questions/18500088/curl-load-a-site-with-cloudflare-protection/27239049#27239049
#- https://duckduckgo.com/?q=copy+file+terminal+mtp+arch+terminal&ia=web
#- https://itectec.com/unixlinux/linux-accessing-mtp-mounted-device-in-terminal/

