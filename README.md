# PCIe AC7265 and HP ProBook 6540b

[Предыстория](prestory.md)

## Hardware

### HP ProBook 6540b

- [Mobile Intel® HM57 Express](doc/HW/5-chipset-3400-chipset-datasheet.pdf)
- Core i5
- SSD
- RAM 8GB (max)
- COM port
- BlueTooth 2.1
- WLAN 3G 
- BIOS 68CDD v0F.60 11/13/2015
- Windows 10 Enterprise Redstone Anniversary Update (1607), обновленная Win7enterprize, шедшей с буком при покупке.
- [Принципиальная схема]('doc/HW/HP ELITEBOOK 6440b 6540b (Compal LA-4891P KELL00 - DIOR DISCRETE ) laptop schematics.pdf')


### Intel® Dual Band Wireless AC 7265 

- Wi-Fi standard 802.11ac 2x2 
- Wi-Fi TX/RX chains 2x2 chains 
- Supported Bands 2.4 GHz, 5 GHz 
- Wi-Fi TX/RX Throughput 867 Mbps 
- Bluetooth Core Bluetooth 4.0 
- [External Product Specification](doc/HW/7265NGW-UserMan-2421860.pdf)


## Список задач и план работы

- Изменить BIOS ноутбука для обеспечения работы WiFi ac7265.
- Упд: обеспечить работоспособность BlueToot 4.0 части модуля ac7265 
- Упд: обеспечить работоспособность WLAN 3g модуля, установленного, но не использовавшегося после перехода с win7


## Литература, ссылки и ПО.

### Software

- Порт git for windows
- [UEFI Tool NE alpha 58](https://github.com/LongSoft/UEFITool/releases/tag/A58)
- UefiTool v028
- [Total commander](https://www.ghisler.com/)


### Ссылки UEFI и потрошению BIOS

- Великолепный цикл академических статей по UEFI на Хабре, которые написал [Николай Шлей](https://habr.com/ru/users/CodeRush/) еще в 2012-2016 годах, но актуальности они не потеряли.
- [Немного о багах в BIOS/UEFI ноутбуков Lenovo/Fujitsu/Toshiba/HP/Dell](https://habr.com/ru/company/aladdinrd/blog/332908/)
- [Возвращаем оригинальные страницы меню в Phoenix SCT UEFI](https://habr.com/ru/post/250611/)


## Последовательность действий:

- [Получить дамп BIOS](get_bios_dump.md)
- [Формат Whitelist WiFi HP]()
- []()
- [Пакетное извлечение из дампа модулей, /work/_0_extract_dxe.cmd](save_bios_modules.md)
- [Пакетное редактирование модулей, /work/_1_patch_dxe.cmd](edit_bios_dump.md)
- []()
- []()


### Original WiFi Whitelist

Для начала [посмотреть, что за WiFi оборудование в белом списке](whitelist_hp6540b.md)

HP ProBook 6540b имеет возможность серфинга и просмотра электронной почты без загрузки основной ОС.  QuickWeb и  QuickLook. То есть в прошивке есть драйвера для WiFi карт из whitelist. Можно быть уверенным, для иной карты эта функциональность работать не будет, и, вероятно, при включении её в BIOS вообще окирпичится.





