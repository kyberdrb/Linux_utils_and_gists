#!/bin/sh

#set -x

# TODO rework into C++
#  - download special offers from links in txt file
#  - sort the list
#  - merge duplicate offers into one
#  - show the list in a table?

# Test internet connection - prevention against content erasure of previously populated special offer file
curl ifconfig.co > /dev/null 2>&1
if [ $? -ne 0 ]
then
    printf "%s\n" "This app needs a connection to the internet to download the latest special offers."
    printf "%s\n" "Please, connect the device to the internet wirelessly, e.g. via Wi-Fi, or via cable, e.g. Ethernet, and run the app again."
    exit 1
fi

SPECIAL_OFFERS_FILE_PATH="/tmp/akcie.txt"

cat /dev/null > "${SPECIAL_OFFERS_FILE_PATH}"

{
  date
  echo
} > "${SPECIAL_OFFERS_FILE_PATH}"

# Load special offers from zlacnene.sk

NAJLACNEJSIA_ZELENINA_ZLACNENE_SK_BASE_URL="https://www.zlacnene.sk/akciovy-tovar/zelenina/najlacnejsie/strana-"
#NAJLACNEJSIA_ZELENINA_ZLACNENE_SK_BASE_URL="https://www.zlacnene.sk/akciovy-tovar/sk-potraviny/najlacnejsie/strana-"

number_of_pages="$(curl --silent "${NAJLACNEJSIA_ZELENINA_ZLACNENE_SK_BASE_URL}1/" | grep page-link | tidy -omit -quiet 2>/dev/null | grep "<\/a>" | tail --lines=2 | head --lines=1 | sed 's/<\/a>//' | sed 's/>/\n/' | tail --lines=1)"

{
  echo '[zelenina - zlacnene.sk]'
  printf "%s\n" "---"
} >> "${SPECIAL_OFFERS_FILE_PATH}"

for page_number in $(seq 1 "${number_of_pages}")
do
  # gather all links for products in special offer from current page
  URLs_for_all_products_from_current_page="$(curl --silent "${NAJLACNEJSIA_ZELENINA_ZLACNENE_SK_BASE_URL}${page_number}/" | tidy -quiet 2>/dev/null | grep "^\"/akcia/.*class=$" | uniq | sed 's/"*\stitle=.*$//' | sed 's/"*\sclass=.*$//' | sed 's#^"#https://www.zlacnene.sk#g')"

  for URL_for_product_in_special_offer in ${URLs_for_all_products_from_current_page}
  do
    curl --silent "${URL_for_product_in_special_offer}" \
      | sed 's/<h1 class="nadpis-zbozi" itemprop="name">/\nnameOfProductInSpecialOffer=/g' \
      | sed 's/itemtype="http:\/\/schema.org\/Organization"/\nstoreOfProductInSpecialOffer=/g' \
      | sed 's/itemprop="price" content="/\npriceOfProductInSpecialOffer=/g' \
      | sed 's/itemprop="priceValidUntil" content="/\nspecialOfferValidUntil=/g' \
      | grep -e 'nameOfProductInSpecialOffer' -e 'priceOfProductInSpecialOffer' -e 'storeOfProductInSpecialOffer' -e 'specialOfferValidUntil' -e 'catalogue' \
      | sed '/storeOfProductInSpecialOffer=.*0">$/d' \
      | sed '/priceOfProductInSpecialOffer=.*0">$/d' \
      | sed '/.*class="letak-img-proklik"/d' \
      | sed '/.*class="dispNone"/d' \
      | sed 's/nameOfProductInSpecialOffer/name/g' \
      | sed 's/priceOfProductInSpecialOffer/price/g' \
      | sed 's/storeOfProductInSpecialOffer/store/g' \
      | sed 's/specialOfferValidUntil/until/g' \
      | less >> "${SPECIAL_OFFERS_FILE_PATH}"

      printf "%s%s\n" "link=" "${URL_for_product_in_special_offer}" >> "${SPECIAL_OFFERS_FILE_PATH}"

    printf "%s\n" "---" >> "${SPECIAL_OFFERS_FILE_PATH}"
  done
done

echo '[zelenina - kompaszliav.sk]' >> "${SPECIAL_OFFERS_FILE_PATH}"
echo '---' >> "${SPECIAL_OFFERS_FILE_PATH}"

page_index=0
while true
do
  products_in_special_offer="$(\
    curl --silent "https://kompaszliav.sk/n/zelenina?storeFilterAmp-monitoringProducts-page=${page_index}&storeFilterAmp-monitoringProducts-column=price&storeFilterAmp-monitoringProducts-order=asc&storeFilterAmp-monitoringProducts-archive=0&store=billa,coop-jednota,fresh,kaufland,kraj,lidl,metro,terno,tesco,tesco-supermarket&do=storeFilterAmp-monitoringProducts-showProducts" \
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
      | grep "\{.*\"snippets\":" \
      | sed '/"snippets"/s/":"\s*/":"\n/g' \
      | tail --lines=1 \
      | sed -E 's/\s+/ /g' \
      | sed 's/\\n/ /g' \
      | sed -E 's/\s+/ /g' \
      | sed 's/\\"/"/g' \
      | sed -E 's/<td class="store-name">/\n<td class="store-name">/g' \
      | sed -E 's/<div class="desc">/\n<div class="desc">/g' \
      | sed -E 's/<div class="validity-cell-wrapper">/\n<div class="validity-cell-wrapper">/g' \
      | sed -E 's/<button class="snapchat">/\n<button class="snapchat">/g' \
      | sed -E 's/<td class="price"/\n<td class="price"/g' \
      | sed -E 's/<\/tr> <tr>/<\/tr> <tr>\n---/g' \
      | sed -E 's/<\/td> <\/tr> "}}$/<\/td> <\/tr> "}}\n---/g' \
      | tail --lines=+2 \
      | sed -E 's/<td class="store-name">\s+/store=/g' \
      | sed -E 's/<div class="desc">\s+/name=/g' \
      | sed -E 's/<div class="validity-cell-wrapper">\s+/catalogueAndUntil=/g' \
      | sed -E 's/<button class="snapchat">\s+/image=/g' \
      | sed -E 's/<td class="price">\s+/price=/g'
  )"

  if [ -z "${products_in_special_offer}" ]
  then
    break
  fi

  printf "%s\n" "${products_in_special_offer}" >> "${SPECIAL_OFFERS_FILE_PATH}"
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

# Send the special offers file to currently connected Android phone

android_phone_adb_id="$(adb devices | tail -n +2 | head -n 1 | tr '[:blank:]' ' ' | cut --delimiter=' ' --fields=1)"

if [ -n "${android_phone_adb_id}" ]
then
  adb push /tmp/akcie.txt /storage/extSdCard/akcie.txt | grep --invert-match "adb: error: failed to"
  adb push /tmp/akcie.txt /sdcard/akcie.txt | grep --invert-match "adb: error: failed to"
fi

# Mount all available Android phones and MTP devices
gio mount mtp://SONY_G3121_RQ300688BU/
#gio mount -li | grep mtp | cut --delimiter='=' --fields=2

# Push to all available internal and external storages of all mounted Android phones and MTP devices
#find "/run/user/1000/gvfs/$(echo "mtp://SONY_G3121_RQ300688BU/" | sed 's#mtp://#mtp:host=#g')" -maxdepth 1 | tail -n +2 | xargs -I {} gio copy "${SPECIAL_OFFERS_FILE_PATH}" "{}/"
cp "${SPECIAL_OFFERS_FILE_PATH}" "/run/user/1000/gvfs/mtp:host=SONY_G3121_RQ300688BU/Interner gemeinsamer Speicher/akcie.txt" 2>/dev/null

# unmount the mtp filesystem as soon as it's idle, instead of a fixed time
#while true
#do
#  if the output of the command "gio mount -u mtp://SONY_G3121_RQ300688BU/" is not "The connection is closed"
#  then
#     break
#  fi
#done

printf "%s" "less --ignore-case "${SPECIAL_OFFERS_FILE_PATH}"" | xclip -selection clipboard -in

sleep 1
gio mount -u mtp://SONY_G3121_RQ300688BU/

echo "Open current special offers with e.g."
echo "  less --ignore-case "${SPECIAL_OFFERS_FILE_PATH}""

printf "%s" "less --ignore-case "${SPECIAL_OFFERS_FILE_PATH}"" | xclip -in -selection clipboard

less --ignore-case "${SPECIAL_OFFERS_FILE_PATH}"

echo "Ceny pre 'METRO' na portáli 'kompaszliav.sk' sú uvedené bez DPH."
echo "Prices for 'METRO' on the page 'kompaszliav.sk' are without VAT."

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
#- https://stackoverflow.com/questions/34504311/how-to-tail-all-lines-except-first-row#34504344
#- https://duckduckgo.com/?q=bash+check+if+connected+to+network&ia=web
#- https://stackoverflow.com/questions/929368/how-to-test-an-internet-connection-with-bash
#- https://stackoverflow.com/questions/929368/how-to-test-an-internet-connection-with-bash/47375551#47375551

