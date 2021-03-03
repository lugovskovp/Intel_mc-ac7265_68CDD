# HP ProBook 6540b Whitelist WiFi BIOS 68CDD v0F.60 11/13/2015

Отличный ноутбук, с 2008 года и по сейчас полностью устраивает. За исключением того, что родной WiFi **Broadcom 802.11g Network Adapter
*, [не более 2 Мбит](https://forum.ixbt.com/topic.cgi?id=14:52775-15). **PCI\VEN_14E4&DEV_4315&SUBSYS_1508103C&REV_01\000000FFFF00FFFF00
**

# Предыстория

В полной уверенности, что уж с 2008 г должны были решить проблему whitelist, и на просторах сети должен найтись BIOS с отключенной проверкой оборудования, заказал на али [Intel® Dual Band Wireless-AC 7265](https://ark.intel.com/content/www/ru/ru/ark/products/83635/intel-dual-band-wireless-ac-7265.html). Wi-Fi 802,11ac, 2.4GHz + 5GHz, Bluetooth 4.2, ut to 867 Mbps

А вот упс. Не найдено успешных примеров прошивок модифицированных BIOS HP 68CDD - ProoBook 6440b, 6550b, 6540b.
- [1. Поиск 68CDD по www.bios-mods.com](https://www.bios-mods.com/search/?cx=partner-pub-9226021234789650%3A6147460733&cof=FORID%3A10&ie=UTF-8&q=68CDD&sa=Search&siteurl=www.bios-mods.com%2Fforum%2FForum-WiFi-WWAN-Whitelist-Removal&ref=www.bios-mods.com%2Fforum%2Farchive%2Findex.php%3Fforum-143.html&ss=172j29584j2)
- []()
- [Устанавливаем неподдерживаемую Wifi карту в HP Pavilion dv6-1319er](https://habr.com/ru/post/108820/)
- [Сказ о том, как я ставил неподдерживаемую Wimax/Wifi карту в Lenovo X201](https://habr.com/ru/post/107598/)

В п.1. [вторая ссылка](https://www.bios-mods.com/forum/Thread-request-HP-ProBook-6440b-whitelist?page=3) - _вроде как_ об успешном опыте - НО с версией BIOS F.50, у меня же последняя - F.60. И к последнему варианту BIOS автор [запретил доступ](https://rghost.net/8yyrTg5xl). Впрочем, в любом случае там автор модификации использовал слитую прошивку с DMI. Важная информация - кроме NoWhiteListMod, автор **replaced all RSA checking Module**, запомним.
 

# SW

- [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe)
- BIOS Backup ToolKit V2.0
- [Newest UEFITool A58 win32](https://github.com/LongSoft/UEFITool/releases/tag/A58)
- rufus-3.13p
- [010 Editor](https://www.sweetscape.com/010editor/) как продвинутый hex-редактор
- HxD - как простой hex-редактор


# Road

## Что есть в WL

1. Cохраненный BIOS Backup ToolKit V2.0 или взятый из распакованной прошивки HP update BIOS 68CDD rev.F60, открыть в 010Editor. 
2. В Диспетчере устройств сетевая карта id VEN_14E4&DEV_4315&SUBSYS_1508103C. Значит, надо найти <ctrl>+<F> последовательность байт E4141543.
3. Явно прослеживаются повторяющиеся структуры. Заметно, где они начинаются, с offset 0x22838c.

![0x22838c](/pix/2021-03-03_10-56-13.png)
4. Создать новый темплейт с содержимым


BIOS





##



##
