# HP ProBook 6540b BIOS 68CDD v0F.60 11/13/2015

[Отличный ноутбук](https://h10057.www1.hp.com/ecomcat/hpcatalog/specs/provisioner/05/WD689EA.htm), служит мне с 2008 года. Великолепная матрица дисплея, чипсет Mobile Intel® HM57 Express, Core i5, SSD, RAM 8GB, COM port (!), bluetooth 2.1, да еще и родная dock-станция к нему. И сейчас, в 2021, полностью устраивает. 

За исключением того, что родной WiFi **Broadcom 802.11g Network Adapter**, обеспечивает скорость в DL от роутера максимум 2.9 Мбайт/с, что грустно. Интернет говорит, что [адаптер умеет не более 2 Мбайт](https://forum.ixbt.com/topic.cgi?id=14:52775-15). 

**PCI\VEN_14E4&DEV_4315&SUBSYS_1508103C&REV_01\000000FFFF00FFFF00**

И для одного из проектов потребовался BlueTooth 4.0.


## Предыстория

В полной уверенности, что уж с 2008 г должны были решить проблему whitelist, и в сети должен найтись BIOS с отключенной проверкой оборудования, заказал на али [Intel® Dual Band Wireless-AC 7265](https://ark.intel.com/content/www/ru/ru/ark/products/83635/intel-dual-band-wireless-ac-7265.html). Wi-Fi 802,11ac, 2.4GHz + 5GHz, Bluetooth 4.2, up to 867 Mbps. 

Модуль пришел. Установленный в другой нотник, в ASUS к53, показал полную работоспособность и соответствие заявленным характеристикам.

C HP ProBook 6540b, естественно, при попытке загрузки получил **104-Unsupported wireless network device**.

Примеров успешной прошивки модифицированных BIOS HP для платформы **68CDD** - ProoBook 6440b, 6550b, 6540b - в сети не нашлось.
- [Поиск 68CDD по www.bios-mods.com](https://www.bios-mods.com/search/?cx=partner-pub-9226021234789650%3A6147460733&cof=FORID%3A10&ie=UTF-8&q=68CDD&sa=Search&siteurl=www.bios-mods.com%2Fforum%2FForum-WiFi-WWAN-Whitelist-Removal&ref=www.bios-mods.com%2Fforum%2Farchive%2Findex.php%3Fforum-143.html&ss=172j29584j2)
- [Устанавливаем неподдерживаемую Wifi карту в HP Pavilion dv6-1319er](https://habr.com/ru/post/108820/)
- [Сказ о том, как я ставил неподдерживаемую Wimax/Wifi карту в Lenovo X201](https://habr.com/ru/post/107598/)

В п.1. [вторая ссылка](https://www.bios-mods.com/forum/Thread-request-HP-ProBook-6440b-whitelist?page=3) - _вроде как_ об успешном опыте - НО с ранней версией BIOS F.50, у меня же последняя - F.60. И к последнему варианту BIOS автор [запретил доступ](https://rghost.net/8yyrTg5xl). Впрочем, в любом случае там автор модификации использовал слитую прошивку с DMI. Важная информация - кроме NoWhiteListMod, автор еще и **replace all RSA checking Module**, запомним.
 
Остается вариант создать репозиторий и самому разбираться с этой темой.