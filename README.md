# PCIe AC7265 and HP ProBook 6540b

[Предыстория](prestory.md)

## Hardware

### HP ProBook 6540b

- [Mobile Intel® HM57 Express](doc/HW/5-chipset-3400-chipset-datasheet.pdf)
- Intel Core i5 M520
- ATI Mobility Radeon HD 4500. Да, не для игр, старенькая, слабенькая, но пройти Subnautica получилось. 
- SSD
- RAM 8GB. Это максимум, увы. С докерами не поработаешь.
- COM port. И это здорово.
- Fingerprint - сканирование отпечатка пальца вместо ввода пароля.
- BlueTooth 2.1
- WLAN 3G. Не особо актуально, учитывая подешевевший трафик на доступе с телефона по LTE.
- BIOS 68CDD v0F.60 11/13/2015
- Windows 10 Enterprise Redstone Anniversary Update (1607), обновленная Win7enterprize, шедшей с буком при покупке.
- [Принципиальная схема](doc/HW/HP%20ELITEBOOK%206440b%206540b%20(Compal%20LA-4891P%20KELL00%20-%20DIOR%20DISCRETE%20)%20laptop%20schematics.pdf)


### Intel® Dual Band Wireless AC 7265 

- Wi-Fi standard 802.11ac 2x2 
- Wi-Fi TX/RX chains 2x2 chains 
- Supported Bands 2.4 GHz, 5 GHz 
- Wi-Fi TX/RX Throughput 867 Mbps 
- Bluetooth Core Bluetooth 4.0 
- [External Product Specification](doc/HW/7265NGW-UserMan-2421860.pdf)


## План работ

| Задача | Выполнено          |
| ------- | ------------------ |
| Изменить BIOS ноутбука для обеспечения работы WiFi ac7265.  | :x: |
| Обеспечить работоспособность BlueToot 4.0 части модуля ac726  | :white_check_mark:                |
| Обеспечить обеспечить работоспособность WLAN 3g модуля, установленного, но не использовавшегося после перехода с win7 | :white_check_mark: |




## Последовательность действий:

ВНИМАНИЕ! **ЛЮБОЕ ковыряние в BIOS необходимо начинать с создания бекапа содержимого конкретного компьютера.**


- [Получить дамп BIOS](get_bios_dump.md)
- [Формат Whitelist WiFi HP](whitelist_hp6540b.md)
- [How to hack BIOS RSA checker](hack_rsa.md)
- [USB ports]()
- [VSS variables](VSS_variables.md)
- [ACPI tables](acpi_in_BIOS.md)

- [Пакетное извлечение из дампа модулей, /work/_0_extract_dxe.cmd](save_bios_modules.md)
- [Пакетное редактирование модулей, /work/_1_patch_dxe.cmd](edit_bios_dump.md)

- [Собрать новый образ отредактированного биос из модулей]()
- [Залить BIOS]()

[Сборка содержимого UEFI flash и прошивка](build_bios_dump.md)

## Литература, ссылки и ПО.

### Software

- [UEFI Tool NE alpha 58](https://github.com/LongSoft/UEFITool/releases/tag/A58)
- UefiTool v028
- [Total commander](https://www.ghisler.com/)




### Ссылки UEFI и потрошению BIOS

- [Великолепный цикл академических статей](https://habr.com/ru/users/coderush/posts/page2/) по UEFI на Хабре, которые написал [Николай Шлей](https://habr.com/ru/users/CodeRush/) еще в 2012-2016 годах, но актуальности они не потеряли.
- [Немного о багах в BIOS/UEFI ноутбуков Lenovo/Fujitsu/Toshiba/HP/Dell](https://habr.com/ru/company/aladdinrd/blog/332908/)
- [Возвращаем оригинальные страницы меню в Phoenix SCT UEFI](https://habr.com/ru/post/250611/)

Heap of links.
- [Устанавливаем неподдерживаемую Wifi карту в HP Pavilion dv6-1319er](https://habr.com/ru/post/108820/)
- [ REQUEST HP 6735s F.21 BIOS Whitelist Removal - sp58130](https://www.bios-mods.com/forum/Thread-REQUEST-HP-6735s-F-21-BIOS-Whitelist-Removal-sp58130?page=2)
- [http://xdel.ru/downloads/bios-mods.com-tools/](http://xdel.ru/downloads/bios-mods.com-tools/)
- [How to Reset BIOS Password on a HP Laptop (Probook, Elitebook or Pavilion)](https://www.repairwin.com/how-to-reset-bios-password-hp-probook-elitebook-pavilion-laptop/#method-3)
- [Искусство перешивки BIOS](http://www.rom.by/Iskusstvo_pereshivki_BIOS)
- [request HP ProBook 6440b whitelist](https://www.bios-mods.com/forum/Thread-request-HP-ProBook-6440b-whitelist?page=3)
- [Правильный запрос биосов НР, методы их распаковки из апдейта](https://ascnb1.ru/forma1/viewtopic.php?f=387&t=96778)


