curl --silent 'https://kompaszliav.sk/zelenina?storeFilterAmp-monitoringProducts-page=0&storeFilterAmp-monitoringProducts-column=price&storeFilterAmp-monitoringProducts-order=asc&storeFilterAmp-monitoringProducts-archive=0&store=billa,coop-jednota,kaufland,kraj,lidl,metro,potraviny-koruna,tesco,tesco-supermarket&do=storeFilterAmp-monitoringProducts-showProducts' \
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
  | nl | less