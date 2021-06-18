
# Внесение изменений в сохраненные файлы модулей, /work/_1_patch_dxe.cmd

Результат запуска коммандного файла прошлого шага **_0_extract_dxe.cmd** - четыре файла модулей с whitelist, модуль RSA чекера, хранилище VSS/NVRAM переменных целиком и файл с ACPI таблицами в папке **\work\patches\**.

	
	F6D35FBB-PlatformSetup.efi
	5EE86B35-WLAN.efi
	53984C6A-PlatformStage1.efi
	233DF097-PlatformStage2.efi
	E64E8AEE-RSAchecker.efi
	FFF12B8D_VSS_body.efi
	7E374E25_PlatformAcpiTable.efi

Данный текст - развернутый комментарий к **\work\_1_patch_dxe.cmd**, запуск которого должен внести изменения в эти файлы.

Теоретически, утилита EFIPatch_0.28.0 могла бы сделать всё это и без извлечения модулей, но её здесь использовать невозможно, т.к. HP BIOS несколько отличается от ожидаемого парсером формата, и при открытии UEFI Tool выдает список ошибок:
v.A58:
		- FfsParser::parseRawArea: volume size stored in header 8000h differs from calculated using block map 10000h
		- FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume’s free space
		- MeParser::parseFptRegion: FPT partition table header checksum is invalid

v.0.28
		- parseVolume: non-UEFI data found in volume’s free space
		- parseVolume: unknown file system FFF12B8D-7696-4C8B-A985-2747075B4F50
		- parseBios: volume size stored in header 8000h differs from calculated using block map 65536h



## TOC

 - [Used SW](#used-sw)
 - [Подмена в whitelist BIOS одного из VEN_DEV_SUBSYS](#%D0%BF%D0%BE%D0%B4%D0%BC%D0%B5%D0%BD%D0%B0-%D0%B2-bios-%D0%BE%D0%B4%D0%BD%D0%BE%D0%B3%D0%BE-%D0%B8%D0%B7-ven_dev_subsys-%D0%B2-whitelist)
 - [Исправление RSA checker](#%D0%B8%D1%81%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-rsa-checker)
 - [Внесение изменений в VSS variable HP_Setup](#%D0%B2%D0%BD%D0%B5%D1%81%D0%B5%D0%BD%D0%B8%D0%B5-%D0%B8%D0%B7%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D0%B9-%D0%B2-vss-variable-hh_setup)
 - [Добавление новой таблицы SSD](#%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BD%D0%BE%D0%B2%D0%BE%D0%B9-%D1%82%D0%B0%D0%B1%D0%BB%D0%B8%D1%86%D1%8B-ssd)
 - [Итоги](#%D0%B8%D1%82%D0%BE%D0%B3%D0%B8)



## Used SW

- Утилиты xxd и diff, устанавливающиеся вместе с [git for windows](https://git-scm.com/downloads)
- HxD


## Подмена в BIOS одного из VEN_DEV_SUBSYS в whitelist

Строка с новой записью в Whitelist PCI\VEN_8086&DEV_095A&SUBSYS_90108086, F - initialisation var, FCC ID = PD97265NGU в шестнадцатеричных значениях выглядит вот так:
		
		86 80 5A 09 86 80 10 90 0f 00 50 00 44 00 39 00 37 00 32 00 36 00 50 00 4e 00 47 00 55 00 00 00

Установленный пакет git (пссст... у вас установлен git?) включает так же утилиту xxd, которая "создаёт представление указанного файла или данных, прочитанных из потока стандартного ввода, в виде шестнадцатеричных кодов"(с)man. 

Но, кроме этого, дает возможность удобного бинарного patch. Чуть подробнее. 

Напомню, поиск в BIOS по последовательности hex **8680394286801113** в UEFITool NE a58 дал 4 результата, которые были сохранены отдельными файлами.

		Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset AC4h
		Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset 7AD4h
		Hex pattern "8680394286801113" found as "8680394286801113" in 53984C6A-1B4A-4174-9512-A65E5BC8B278/PE32 image section at header-offset 2904h
		Hex pattern "8680394286801113" found as "8680394286801113" in 233DF097-3218-47B2-9E09-FE58C2B20D22/PE32 image section at header-offset 3084h

Первый найдёныш - DXE driver WLAN, сохраненный ранее как 5EE86B35-WLAN.efi. Сохраняя PE32 image как "Extract body" - "теряются" первые 4 байта, и смещение искомой последовательности в сохраненном body - 0xAC0.

		:: создать файл с патчем
		echo 0AC0: 86 80 5A 09 86 80 10 90 0f 00 50 00 44 00 39 00 37 00 32 00 36 00 50 00 4e 00 47 00 55 00 00 00 >5EE86B35-WLAN.patch
		:: бекап
		cp -f 5EE86B35-WLAN.efi 5EE86B35-WLAN.new
		:: применить патч.
		xxd -g1 -c32 -r 5EE86B35-WLAN.patch 5EE86B35-WLAN.new
		:: -g1  - групировать в строке по 1 байту в выводе
		:: -c32 - каждая строка вывода - по 32 байта (чтобы влез мой длииииннный патч в одну строку)
		:: -r   - реверс, т.е. из хекс-представления - собрать в бинарный код (и это круто)

		:: старый файл в текстовый hex
		xxd -g2 5EE86B35-WLAN.efi>old.hex 
		:: новый файл с примененным патчем в текстовый hex
		xxd -g2 5EE86B35-WLAN.new>new.hex
		:: разница на экран
		diff old.hex new.hex 
		:: и сохранить разницу - задокументировать если что то пойдет не так
		diff old.hex new.hex > 5EE86B35-WLAN.hexpatch.diff
		
		

Я завернул все это дело в batch [sub_1_1_wl_patch.cmd](work/sub_1_1_wl_patch.cmd), первый аргумент - рассчитанное смещение, второй - имя файла. Файлы патчей создадутся в /work/patches/wl, результаты работы появится в /work/build с расширением .new

И вызываю его 4 раза из  **_1_patch_dxe.cmd**
 
		::        Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset AC4h
		@call sub_1_1_wl_patch.cmd 0ac0 5EE86B35-WLAN

		::        Hex pattern "8680394286801113" found as "8680394286801113" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at header-offset 7AD4h
		@call sub_1_1_wl_patch.cmd 07ad0 F6D35FBB-PlatformSetup

		::        Hex pattern "8680394286801113" found as "8680394286801113" in 53984C6A-1B4A-4174-9512-A65E5BC8B278/PE32 image section at header-offset 2904h
		@call sub_1_1_wl_patch.cmd 02900 53984C6A-PlatformStage1

		::        Hex pattern "8680394286801113" found as "8680394286801113" in 233DF097-3218-47B2-9E09-FE58C2B20D22/PE32 image section at header-offset 3084h
		@call sub_1_1_wl_patch.cmd 03080 233DF097-PlatformStage2		
 
 
 
По выводу **diff old.hex new.hex** сразу видно, если где-то неправильно рассчитано смещение и байты пишутся куда-то не туда ))

		-----------------------------------------------------
		File 53984C6A-PlatformStage1 Offset: 02900
		657,658c657,658
		< 00002900: 8680 3942 8680 1113 0b00 5000 4400 3900  ..9B......P.D.9.
		< 00002910: 3600 3200 3200 4100 4e00 4800 5500 0000  6.2.2.A.N.H.U...
		---
		> 00002900: 8680 5a09 8680 1090 0f00 5000 4400 3900  ..Z.......P.D.9.
		> 00002910: 3700 3200 3600 5000 4e00 4700 5500 0000  7.2.6.P.N.G.U...
		-----------------------------------------------------
		File 233DF097-PlatformStage2 Offset: 03080
		777,778c777,778
		< 00003080: 8680 3942 8680 1113 0b00 5000 4400 3900  ..9B......P.D.9.
		< 00003090: 3600 3200 3200 4100 4e00 4800 5500 0000  6.2.2.A.N.H.U...
		---
		> 00003080: 8680 5a09 8680 1090 0f00 5000 4400 3900  ..Z.......P.D.9.
		> 00003090: 3700 3200 3600 5000 4e00 4700 5500 0000  7.2.6.P.N.G.U...
 
 
 
## Исправление RSA checker

По-моему, после [How to hack BIOS RSA checker](hack_rsa.md) дополнительных комментариев не требуется.

		@cd ./patches
		@mkdir rsa
		@cd ..

		:: Make patch file - set NOP NOP 90 90 instead JNZ 75 07
		@echo E64E8AEE-RSAchecker
		@echo 0fa9: 90 90 >./patches/rsa/E64E8AEE-RSAchecker.patch

		:: backup
		@cp -f ./patches/E64E8AEE-RSAchecker.efi ./patches/rsa/E64E8AEE-RSAchecker.new
		@xxd -g1 -c16 -r ./patches/rsa/E64E8AEE-RSAchecker.patch ./patches/rsa/E64E8AEE-RSAchecker.new

		:: checking sucsess
		@xxd -g1 ./patches/E64E8AEE-RSAchecker.efi>./patches/old.hex
		@xxd -g1 ./patches/rsa/E64E8AEE-RSAchecker.new>./patches/new.hex
		@diff ./patches/old.hex ./patches/new.hex 
		@diff ./patches/old.hex ./patches/new.hex > ./patches/rsa/E64E8AEE-RSAchecker.hexpatch.diff

		:: clear temp files
		@rm -f ./patches/*.hex

		::moving result to folder build
		@mv -f ./patches/rsa/*.new ./build



## Внесение изменений в VSS variable HH_Setup



## Добавление новой таблицы SSD


## Итоги.

Результат - пропатченные бинарники в папке /work/build, которыми буду [заменять оригинальные файлы]() в дампе BIOS.











