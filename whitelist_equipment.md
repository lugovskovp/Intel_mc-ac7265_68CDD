# Original WiFi Whitelist

Для начала неплохо бы составить список - а что вообще входит в белый лист.


## Used SW

- [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe) - последняя официальная прошивка, уже прошита ранее.
- [010 Editor](https://www.sweetscape.com/010editor/) как продвинутый hex-редактор
- [HxD](https://mh-nexus.de/en/hxd/) - как простой hex-редактор


## Что есть в WL


1. Взятый из распакованной прошивки HP update **BIOS 68CDD rev.F60** открываю в 010Editor.  (в репозитории **/BIOS/68CDD.Ver.F.60 hp.BIN**)
2. В Диспетчере устройств pci id сетевой WiFi карты VEN_14E4&DEV_4315&SUBSYS_1508103C. Ищу в 010 Editor &lt;ctrl&gt;+&lt;F&gt; последовательность байт E4141543 - LittleEndian.
3. Явно прослеживаются повторяющиеся структуры. Заметно, где они начинаются, с offset 0x22838c.

![0x22838c](/pix/2021-03-03_10-56-13.png)

4. Создаю новый темплейт (на предыдущем скриншоте он уже присутствует) с содержимым листинга ниже. C-like синтаксис, проблем с пониманием не должно быть.

		// info from  VEN_14E4&DEV_4315&SUBSYS_1508103C
		LittleEndian();
		// find  E4141543

		FSeek(0x22838c);    

		typedef struct{
			WORD    ven_id <bgcolor=cAqua, format=hex>;
			WORD    dev_id <bgcolor=cLtAqua, format=hex>;
			DWORD   subsys   <bgcolor=cLtGreen, format=hex>;
			WORD mb_rev;
			wchar_t FCCID[15] <bgcolor=cLtYellow, format=hex>;
		}WL_WIFI <read=Read_WL_WIFI>;
		
		string Read_WL_WIFI(WL_WIFI &a){
			local string s;
		SPrintf(s, "| [PCI\\VEN_%04X&DEV_%04X&SUBSYS_%08X](http://driverslab.ru/devsearch/find.php?search=PCI%%5CVEN_%04X%%26DEV_%04X) | %X |\"%s\"| []() | |",
			a.ven_id, a.dev_id, a.subsys,
			a.ven_id, a.dev_id,
			a.mb_rev, a.FCCID);
			return s;
		}


		// my VEN_14E4&DEV_4315&SUBSYS_1508103C
		WL_WIFI wifi[16];

 Применить &lt;F5&gt; к открытому файлу BIOS.
 
 ![010editor wl equipment](/pix/2021-03-03_11-23-36.png)
 
5. Структура WL_WIFI - эмпирическая, слепленная мной "на глаз", значение **mb_rev** мне не понятно, (может, ревизия, а, может, вариант драйверов) Количество записей в **WL_WIFI wifi[16]** ровно так же - на глаз.  Результат - список оборудования. На скрине - предварительная, старая версия темплейта, новая **whitelist_equipment.bt ** в /src репозитория.

Там изменено формирование строки структуры 

		[PCI\VEN_%04X&DEV_%04X&SUBSYS_%08X](http://driverslab.ru/devsearch/find.php?search=PCI\%5CVEN_%04X\%26DEV_%04X) | %X |\"%s\"| []() | |"
			
Чтобы скопировав (right click - Copy column) колонку результатов Value получлась почти MarkDown - таблица, к которой осталось только приделать шапку, распознать модели и написать заметки в правом столбце

|VendorID&DeviceID&SubsysID|Unk| FCCID |Name|Notes|802.11|
|------					|------|-----	|-----|-----|-------|
| [PCI\VEN_8086&DEV_4239&SUBSYS_13118086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239) | B |"PD9622ANHU"| [Centrino Advanced-N 6200 2x2 AGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW)) | | gn|
| [PCI\VEN_8086&DEV_4239&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239) | B |"  "| [Centrino Advanced-N 6200 2x2 ABG](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW)) | | bg|
| [PCI\VEN_8086&DEV_422C&SUBSYS_13018086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422C) | B |"  "| [Centrino Advanced-N 6200 2x2 AGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW))  | | gn|
| [PCI\VEN_8086&DEV_422C&SUBSYS_13068086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422C) | B |"  "| [Centrino Advanced-N 6200 2x2 ABG](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Advanced-N_6200_(622ANHMW))  | | bg|
| [PCI\VEN_8086&DEV_4238&SUBSYS_11118086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4238) | B |"PD9633ANHU"| [Centrino Ultimate-N 6300 3x3 AGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Ultimate-N_6300) | | gn|
| [PCI\VEN_8086&DEV_422B&SUBSYS_11018086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_422B) | B |"  "| [Centrino Ultimate-N 6300 3x3 AGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Ultimate-N_6300) | |gn |
| [PCI\VEN_14E4&DEV_4315&SUBSYS_1507103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4315) | A |"QDS-BRCM1030"| [U98Z049.00 Wireless Mini PCIe Card](http://en.techinfodepot.shoutwiki.com/wiki/Foxconn_U98Z049.00_(HP)) | [На Broadcom BCM4312 и Dell и Lite-On делали карты с таким FCCID](http://en.techinfodepot.shoutwiki.com/w/index.php?title=Special%3ASearch&search=QDS-BRCM1030&fulltext=1) |bg|
| [PCI\VEN_14E4&DEV_4315&SUBSYS_1508103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4315) | A |"  "| []() | Моя карта. А на сайте DEV_4315 вообще нет. BCM4312 802.11b/g LP-PHY, SUBSYS не найден, subvendor HP, на BCM4312 | g|
| [PCI\VEN_14E4&DEV_432B&SUBSYS_1509103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_432B) | F |"QDS-BRCM1031"| [Foxconn U98Z051.00 (HP)](http://en.techinfodepot.shoutwiki.com/wiki/Foxconn_U98Z051.00_(HP)) | BCM4322 802.11a/b/ g/n Wireless LAN Controller, SUBSYS не найден, производство HP|bgn?|
| [PCI\VEN_14E4&DEV_432B&SUBSYS_1510103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_432B) | F |"  "| []() |BCM4322 802.11a/b/ g/n Wireless LAN Controller,  SUBSYS не найден | |
| [PCI\VEN_14E4&DEV_4353&SUBSYS_1509103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4353) | A |"QDS-BRCM1041"| [WMIB-275N Half-size Mini PCIe Card](http://en.techinfodepot.shoutwiki.com/wiki/Gemtek_WMIB-275N_(HP)) | |bgn? | 
| [PCI\VEN_14E4&DEV_4353&SUBSYS_1510103C](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_14E4%26DEV_4353) | A |"  "| []() | BCM43224 802.11a/b/g/n,  SUBSYS не найден | |
| [PCI\VEN_8086&DEV_0083&SUBSYS_13058086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0083) | B |"  "| [Centrino Wireless-N 1000 BGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Wireless-N_1000_(112BNHMW)) | |bgn|
| [PCI\VEN_8086&DEV_0084&SUBSYS_13158086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0084) | A |"PD9112BNHU"| [Centrino Wireless-N 1000 BGN](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Wireless-N_1000_(112BNHMW)) | | bgn|
| [PCI\VEN_8086&DEV_0083&SUBSYS_13068086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0083) | B |"  "| [Centrino Wireless-N 1000 BG](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Wireless-N_1000_(112BNHMW)) | | bg|
| [PCI\VEN_8086&DEV_0084&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_0084) | B |"  "| [Centrino Wireless-N 1000 BG](http://en.techinfodepot.shoutwiki.com/wiki/Intel_Centrino_Wireless-N_1000_(112BNHMW)) | |bg |

VENDORs: 
- 8086 : Intel
- 14e4 : Broadcom Corporation

SUBVENDORs: 
- 103c : Hewlett Packard
- 8086 : Intel
- 14e4 : Broadcom Corporation

## Mini PCIe Intel® Dual Band Wireless-AC 7265

Хотя на aliexpress есть множество предложений, но Intel уверен, что 7265, в отличие от 7260, выпускается исключительно в форм-факторах платы ```M,2 2230``` и ```M.2 1216```.

Однако у меня на руках карта в формате```mPCIe```, вставленная в ноутбук ASER (без whitelist) с Linux Mint, считает себя именно ```Intel® Dual Band Wireless-AC 7265```.

Команда **lspci** с параметром **-d 8086:** выдаст только PCI-утройства Intel, параметр **-nn** выведет и цифровые значения, и человекочитаемые, среди массы оборудования будет и строка c DevID модуля.

                $> lspci -nn -d 8086:
                ...
                03:00.0 Network controller [0280]: Intel Corporation Wireless 7265 [8086:095a] (rev 59)

ОК, DEV=095a, теперь узнать SUBSYS. Параметр **-d 8086:095a** ограничит вывод только этой картой, **-v** даст побольше информации

                  $> lspci -d 8086:095a -v -nn
                  03:00.0 Network controller [0280]: Intel Corporation Wireless 7265 [8086:095a] (rev 59)
	                  Subsystem: Intel Corporation Dual Band Wireless-AC 7265 [8086:9010]
	                  Flags: bus master, fast devsel, latency 0, IRQ 37
	                  Memory at ddc00000 (64-bit, non-prefetchable) [size=8K]
	                  Capabilities: <access denied>
                      Kernel driver in use: iwlwifi
	                  Kernel modules: iwlwifi

Т.о. получается PCI\VEN_8086&DEV_095A&SUBSYS_90108086&REV_59, или, в "терминах HP whitelist" hex-последовательность, описывающая оборудование, будет **86805a0986801090** (LittleEndian)

Однако, кроме WiFi, на карте есть и BlueTooth, который доступен через выведенный на mini PCIe USB. Команда **lsusb** выведет список установленных USB устройств, параметр **-v** выведет дополнительную информацию. Среди массы устройств выбираю информацию, относящуюся к BT подсисеме карты.

		$> lsusb -v
		...
		Bus 001 Device 003: ID 8087:0a2a Intel Corp. 
		Device Descriptor:
		  bLength                18
		  bDescriptorType         1
		  bcdUSB               2.01
		  bDeviceClass          224 Wireless
		  bDeviceSubClass         1 Radio Frequency
		  bDeviceProtocol         1 Bluetooth
		  bMaxPacketSize0        64
		  idVendor           0x8087 Intel Corp.
		  idProduct          0x0a2a 
		  bcdDevice            0.01
		  iManufacturer           0 
		  iProduct                0 
		  iSerial                 0 
		  bNumConfigurations      1 
		...


Поиск **USB\VID_8087&PID_0A2A** находит в папке с драйверами **c:\Program Files (x86)\Intel\Bluetooth\drivers\ibtusb\STP\Win10Release\x64\ibtusb.inf** "Intel(R) Wireless Bluetooth(R)"


## Итоги: 

Лучший - 300Мбит [Intel_Centrino_Advanced-N_6200_(622ANHMW)](https://aliradar.com/search?q=622ANHMW) не встанет, там SUBSYS_13218086, и всё же Centrino Advanced-N 6200 смотрится интерееснее моей карты.

Экземпляр [Intel® Dual Band Wireless-AC 7265](https://ark.intel.com/content/www/ru/ru/ark/products/83635/intel-dual-band-wireless-ac-7265.html) - в исполнении half mini PCI-e полностью работоспособен, как в части WiFi 802.11ac, в диапазонах 2.4HGz, 5HGz, (PCI\VEN_8086&DEV_095A&SUBSYS_90108086&REV_59), так и в части BlueTooth ().

Дальше - [сливаю дамп flash памяти](get_bios_dump.md)