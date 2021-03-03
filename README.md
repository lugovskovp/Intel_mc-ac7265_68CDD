# HP ProBook 6540b Whitelist WiFi BIOS 68CDD v0F.60 11/13/2015

Отличный ноутбук, работаю на нем с 2008 года. Core i5, SSD, RAM 8GB, COM port, bluetooth, да еще и родная dock-станция к н нему. И по сейчас полностью устраивает. За исключением того, что родной WiFi **Broadcom 802.11g Network Adapter**, [не более 2 Мбит](https://forum.ixbt.com/topic.cgi?id=14:52775-15). **PCI\VEN_14E4&DEV_4315&SUBSYS_1508103C&REV_01\000000FFFF00FFFF00**

# Предыстория

В полной уверенности, что уж с 2008 г должны были решить проблему whitelist, и в сети должен найтись BIOS с отключенной проверкой оборудования, заказал на али [Intel® Dual Band Wireless-AC 7265](https://ark.intel.com/content/www/ru/ru/ark/products/83635/intel-dual-band-wireless-ac-7265.html). Wi-Fi 802,11ac, 2.4GHz + 5GHz, Bluetooth 4.2, ut to 867 Mbps. Модуль пришел, установленный в ASUS нотник показал полную работоспособность и соответствие заявленным характеристикам.

А вот упс. Не найдено успешных примеров прошивок модифицированных BIOS HP 68CDD - ProoBook 6440b, 6550b, 6540b.
- [1. Поиск 68CDD по www.bios-mods.com](https://www.bios-mods.com/search/?cx=partner-pub-9226021234789650%3A6147460733&cof=FORID%3A10&ie=UTF-8&q=68CDD&sa=Search&siteurl=www.bios-mods.com%2Fforum%2FForum-WiFi-WWAN-Whitelist-Removal&ref=www.bios-mods.com%2Fforum%2Farchive%2Findex.php%3Fforum-143.html&ss=172j29584j2)
- []()
- [Устанавливаем неподдерживаемую Wifi карту в HP Pavilion dv6-1319er](https://habr.com/ru/post/108820/)
- [Сказ о том, как я ставил неподдерживаемую Wimax/Wifi карту в Lenovo X201](https://habr.com/ru/post/107598/)

В п.1. [вторая ссылка](https://www.bios-mods.com/forum/Thread-request-HP-ProBook-6440b-whitelist?page=3) - _вроде как_ об успешном опыте - НО с версией BIOS F.50, у меня же последняя - F.60. И к последнему варианту BIOS автор [запретил доступ](https://rghost.net/8yyrTg5xl). Впрочем, в любом случае там автор модификации использовал слитую прошивку с DMI. Важная информация - кроме NoWhiteListMod, автор **replaced all RSA checking Module**, запомним.
 
Остается вариант самому как-то разбираться с этой темой.


# SW

- [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe) - последняя официальная прошивка, уже установлена.
- BIOS Backup ToolKit V2.0 - вроде как (?) сохраняет без SPIпрограмматора содержимое BIOS
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
4. Создать новый темплейт (на предыдущем скриншоте он уже есть) с содержимым листинга ниже. C-like синтаксис, проблем с пониманием не должно быть. Применить <F5>.

		// info from  VEN_14E4&DEV_4315&SUBSYS_1508103C
		LittleEndian();
		// find  E4141543

		FSeek(0x22838c);    

		typedef struct{
			WORD    ven_id <bgcolor=cAqua, format=hex>;
			WORD    dev_id <bgcolor=cLtAqua, format=hex>;
			DWORD   subsys   <bgcolor=cLtGreen, format=hex>;
			WORD mb_rev;
			wchar_t wl_eq[15] <bgcolor=cLtYellow, format=hex>;
		}WL_WIFI<read=Read_WL_WIFI>;
		string Read_WL_WIFI(WL_WIFI &a){
			local string s;
			SPrintf(s, "VEN_%04X&DEV_%04X&SUBSYS_%08X unk: %X; str:\"%s\"",
			a.ven_id, a.dev_id, a.subsys,
			a.mb_rev, a.wl_eq);
			return s;
		}


		// my VEN_14E4&DEV_4315&SUBSYS_1508103C
		WL_WIFI wifi[16]<optimize=false>;


5. Структура WL_WIFI - эмпирическая, слепленная мной "на глаз", значение **mb_rev** мне не понятно, (может, ревизия)? Количество записей в **WL_WIFI wifi[16]** ровно так же - на глаз.  Результат - список оборудования.

![010editor wl equipment](/pix/2021-03-03_11-23-36.png)

6. Поменяв формирование строки на 

		SPrintf(s, "| [PCI\VEN_%04X&DEV_%04X&SUBSYS_%08X](http://driverslab.ru/devsearch/find.php?search=PCI\%5CVEN_%04X\%26DEV_%04X) | %X |\"%s\"| []() | |",
			a.ven_id, a.dev_id, a.subsys,
			a.ven_id, a.dev_id,
			a.mb_rev, a.wl_eq);
			
и скопировав (right click - Copy column) колонку результатов Value  почти получится MarkDown - таблица - к которой осталось только приделать шапку, распознать модели и написать заметки в правом столбце

|VendorID&DeviceID&SubsysID|Unk| String | Model| Notes|
|------					|------		|-----	|-----	|-----|
| [PCI\VEN_8086&DEV_4239&SUBSYS_13118086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239) | B |"PD9622ANHU"| [Centrino Advanced-N 6200 2x2 AGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW)) | |
| [PCI\VEN_8086&DEV_4239&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239) | B |"  "| [Centrino Advanced-N 6200 2x2 ABG](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW)) | |
| [PCI\VEN_8086&DEV_422C&SUBSYS_13018086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422C) | B |"  "| [Centrino Advanced-N 6200 2x2 AGN]() | |
| [PCI\VEN_8086&DEV_422C&SUBSYS_13068086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422C) | B |"  "| [Centrino Advanced-N 6200 2x2 ABG]() | |
| [PCI\VEN_8086&DEV_4238&SUBSYS_11118086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4238) | B |"PD9633ANHU"| [Centrino Ultimate-N 6300 3x3 AGN]() | |
| [PCI\VEN_8086&DEV_422B&SUBSYS_11018086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422B) | B |"  "| [Centrino Ultimate-N 6300 3x3 AGN]() | |
| [PCI\VEN_14E4&DEV_4315&SUBSYS_1507103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4315) | A |"QDS-BRCM1030"| [U98Z049.00 Wireless Mini PCIe Card]() | Broadcom Corporation |
| [PCI\VEN_14E4&DEV_4315&SUBSYS_1508103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4315) | A |"  "| []() | Моя карта. А на сайте её вообще нет. BCM4312 802.11b/g LP-PHY, SUBSYS не найден|
| [PCI\VEN_14E4&DEV_432B&SUBSYS_1509103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_432B) | F |"QDS-BRCM1031"| []() | BCM4322 802.11a/b/ g/n Wireless LAN Controller, SUBSYS не найден|
| [PCI\VEN_14E4&DEV_432B&SUBSYS_1510103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_432B) | F |"  "| []() |BCM4322 802.11a/b/ g/n Wireless LAN Controller,  SUBSYS не найден |
| [PCI\VEN_14E4&DEV_4353&SUBSYS_1509103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4353) | A |"QDS-BRCM1041"| [WMIB-275N Half-size Mini PCIe Card]() | |
| [PCI\VEN_14E4&DEV_4353&SUBSYS_1510103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4353) | A |"  "| []() | BCM43224 802.11a/b/ g/n,  SUBSYS не найден |
| [PCI\VEN_8086&DEV_0083&SUBSYS_13058086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0083) | B |"  "| [Centrino Wireless-N 1000 BGN]() | |
| [PCI\VEN_8086&DEV_0084&SUBSYS_13158086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0084) | A |"PD9112BNHU"| [Centrino Wireless-N 1000 BGN]() | |
| [PCI\VEN_8086&DEV_0083&SUBSYS_13068086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0083) | B |"  "| [Centrino Wireless-N 1000 BG]() | |
| [PCI\VEN_8086&DEV_0084&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0084) | B |"  "| [Centrino Wireless-N 1000 BG]() | |








##



##
