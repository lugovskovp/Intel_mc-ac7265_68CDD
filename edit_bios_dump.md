# Правка BIOS

Задачи:
- заменить в BIOS какой-то из VEN_DEV_SUBSYS в whitelist. 
- Убрать самопроверку RSA подписи HP в BIOS



[Слитый программатором](get_bios_dump.md) дамп биоса **hp_bios_original.bin** копирую под именем **hp_bios_4ed.bin** в отдельную папку.


## Used SW

- [UEFI Tool NE alpha 58](https://github.com/LongSoft/UEFITool/releases/tag/A58) - latest release, новый движок парсинга, но пока что нет функционала редактирования - только просмотр/поиск, и возможность извлечения модулей.
- [UEFI Tool 0.28](https://github.com/LongSoft/UEFITool/releases/tag/0.28.0) - старый движок, но полнофункциональный билдер.
- [BinCmp2](https://sourceforge.net/projects/bincmp/files/bincmp2/bincmp%202.9.0/) - сравнение файлов, поиск и замена бинарных данных из коммандной строки


- PhoenixTool v.2.66.



## Замена в whitelist ID оборудования.

Модуль **Intel® Dual Band Wireless-AC 7265** я поставил в ноутбук с Linux Mint. 

### Поиск модулей c WiFi IDs.

Из [списка оборудования](whitelist_equipment.md) в whitelist выбираю вариант, которого у меня на руках нет, и который вряд ли задумаю купить: [PCI\VEN_8086&DEV_4239&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239), *Centrino Advanced-N 6200 2x2 ABG*. В LittleEndian цифры ID выглядят как **8680394286801613**

Открываю в UEFIToolNE alpha 58 **hp_bios_4ed.bin**. Меню *Action-Search*, строка поиска hex **8680394286801613*
![8680394286801613](/pix/2021-03-09 13.03.59.png)

И получаю 4 (четыре) результата: в DXE драйверах WLAN и PlatformSetup, в PEI-модулях PlatformStage1 и PlatformStage2.

		Hex pattern "8680394286801613" found as "8680394286801613" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at body-offset AE8h
		Hex pattern "8680394286801613" found as "8680394286801613" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at body-offset 7AF8h
		Hex pattern "8680394286801613" found as "8680394286801613" in 53984C6A-1B4A-4174-9512-A65E5BC8B278/PE32 image section at body-offset 2928h
		Hex pattern "8680394286801613" found as "8680394286801613" in 233DF097-3218-47B2-9E09-FE58C2B20D22/PE32 image section at body-offset 30A8h

Интерфейс UEFITool удобен, клик на результат поиска синхронизирует главное окно, переходя к необходимому модулю. 
![результат поиска](/pix/2021-03-09 13.06.03.png)

	FileSystem GUID: 7A9354D9-0468-444A-81CE-0BF617D890DF (DXE том)
		|- File GUID: 4A538818-5AE0-4EB2-B2EB-488B23657022 - FvMainCompact
			|- Compressed section
				|- Raw section
					|- FileSystem GUID: 7A9354D9-0468-444A-81CE-0BF617D890DF 
						|- File GUID: 5EE86B35-0839-4A21-8845-F1ACB0F688AB - WLAN
						|- File GUID: F6D35FBB-63EA-4B25-81A5-5E62B4886292 - PlatformSetup
					
	 FileSystem GUID: 7A9354D9-0468-444A-81CE-0BF617D890DF (PEI том)
		|-	File GUID: 53984C6A-1B4A-4174-9512-A65E5BC8B278 - PlatformStage1
		|-	File GUID: 233DF097-3218-47B2-9E09-FE58C2B20D22 - PlatfirmStage2
	

Сохраняю весь модуль: клик на строку результата поиска, правый клик на **модуль** с найденным PE32 image section, Extract as is... **File_DXE_driver_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN.ffs**
![Extract as is..](2021-03-10_13-35-06.png)

Открываю его в **HxD**, ищу смещение для hex последовательности *8680394286801613*, offset= B64h.

Создаю текстовый файл, формат элементарный: строка с комментариями начинается с # или ;. Строка с заменами - смещение от начала, двоеточие, пробел, ожидаемый байт, пробел, новое значение байта в шестнадцатеричном виде.
		
		# module 5EE86B35-0839-4A21-8845-F1ACB0F688AB - WLAN
		# offset B64h value  86803942 86801613 change to 86805A09 86801090 
		b64: 86 86
		b65: 80 80
		b66: 39 5a
		b67: 42 09
		b68: 86 86
		b69: 80 80
		b6a: 16 10
		b6b: 13 90

Сохраняю как **5EE86B35-0839-4A21-8845-F1ACB0F688AB_patch.txt**.

Аналогично сохраняю модули **File_DXE_driver_PlatformSetup_PlatformSetup.ffs** (offset: 7b98h), **File_PEI_module_53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1** (offset 294сh) и **File_PEI_module_233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2.ffs** (offset 3108h),
а так же создаю соответствующие файлы патчей **F6D35FBB-63EA-4B25-81A5-5E62B4886292_PlatformSetup_patch.txt**, **53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1_patch.txt** и **233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2_patch.txt**. В репозитории они в папке **/src**


В командной строке: **dir /b File_\*>patch_list.cmd**. 

### Замена ID WiFi в модулях.

Оборудование PCI\VEN_8086&DEV_4239&SUBSYS_13168086 (LittleEndian строка 8680394286801613) заменяю на новые значения - PCI\VEN_8086&DEV_095A&SUBSYS_90108086, т.е. на 86805A0986801090 по смещениям из результатов поиска.

Возможно, придется повторять этот этап, я сварщик не настоящий, и в правках BIOSов до этого момента замечен не был, и поэтому не руками в hex-редакторе, а создав командный файл **patch_list.cmd**. Его закотовка - с именами файлов модулей - была создана последним шагом прошлого этапа.

Редактирую получившийся коммандный файл. В начале каждой строки добавляю **bincmp**, в конце - **-patch имя_файла_с_патчем.txt**,  :

		bincmp File_DXE_driver_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN.ffs -patch 5EE86B35-0839-4A21-8845-F1ACB0F688AB_patch.txt
		bincmp File_DXE_driver_PlatformSetup_PlatformSetup.ffs -patch F6D35FBB-63EA-4B25-81A5-5E62B4886292_PlatformSetup_patch.txt
		bincmp File_PEI_module_233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2.ffs -patch 233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2_patch.txt
		bincmp File_PEI_module_53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1.ffs -patch 53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1_patch.txt
		pause
		

При запуске **patch_list.cmd** по каждому файлу вывод примерно такой:

		   >bincmp Section_PE32.efi -patch patch_7AF8h.txt
			>  00007AF8:  86  86  ; skip (old 86 == new 86)
			>  00007AF9:  80  80  ; skip (old 80 == new 80)
			>  00007AFA:  39  5A  ; done
			>  00007AFB:  42  09  ; done
			>  00007AFC:  86  86  ; skip (old 86 == new 86)
			>  00007AFD:  80  80  ; skip (old 80 == new 80)
			>  00007AFE:  16  10  ; done
			>  00007AFF:  13  90  ; done


Утилита EFIPatch_0.28.0 гораздо удобнее, но её здесь использовать невозможно, т.к. HP BIOS несколько отличается от ожидаемого парсером формата, и при открытии UEFI Tool выдает список ошибок:
v.A58:
FfsParser::parseRawArea: volume size stored in header 8000h differs from calculated using block map 10000h
FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume's free space
MeParser::parseFptRegion: FPT partition table header checksum is invalid

v.0.28
parseVolume: non-UEFI data found in volume's free space
parseVolume: unknown file system FFF12B8D-7696-4C8B-A985-2747075B4F50
parseBios: volume size stored in header 8000h differs from calculated using block map 65536h

**unknown file system FFF12B8D-** - в старом парсере - область NVRAM

**volume size stored in header 8000h differs from calculated using block map** - это, похоже, какое-то своё, глубоко личное, прочтение стандарта инженерами Hewlett Packard. Как и **FPT partition table header checksum is invalid**

**non-UEFI data found in volume's free space** - это RSA подпись, проверяемая BIOSом при загрузке, о назначении которой в BIOSах HP [Николай Шлей aka CodeRush](https://habr.com/ru/users/CodeRush/) подробнейше рассказывал в своей статье[Простые приемы реверс-инжиниринга UEFI PEI-модулей на полезном примере](https://habr.com/ru/post/249655/).


## Dirty hack RSA checking.

Собственно его статья [Простые приемы реверс-инжиниринга UEFI PEI-модулей на полезном примере](https://habr.com/ru/post/249655/) определяет этот раздел. Посему читать прежде всего его, тут только те моменты, которые отличаются.

### Делай раз!

Сообщение парсера **FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume's free space** приводит к информации в области паддинга, которая вообще то ожидается заполненной FF.
![RSA? checksum - flag vs BIOS editing](/pix/2021-03-10_15-32-14.png)

В конце строка **"SIG0F 6068CDD"**, версия BIOS, напомню, *F.60*, платформа BIOS *68CDD*.


### Делай два!

Как видно на скриншоте, смещение внутри тома не 12FEE0h, как в статье, а 14FEE0h. Поэтому ищу E0FE14h.

		Hex pattern "E0FE14" found as "E0FE14" in Compressed section/PE32 image section at body-offset 10D2h
		Hex pattern "E0FE14" found as "E0FE14" in Compressed section/PE32 image section at body-offset 10F7h

Оба вхождения - в PE32 image section модуля с названием **SecureUpdating**, GUID которого полностью совпадает с описанным в статье.
Сохраняю и весь модуль как **File_PEI_module_E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating.ffs** и запакованное тело PE32 **Section_PE32_image_E64E8AEE-0C78-4D9D-86A9-40C97845A3D4_SecureUpdating_body**.


### Делай три!

Облом нумер раз: в стандартных структурах, подгруженных из behemoth.h, EFI_GUID и EFI_GUID находятся, а вот с EFI_PEI_SERVICES - облом. Нет, _EFI_PEI_SERVICES так же не находится, хотя в самом файле обе структуры есть.

![EFI_PEI_SERVICES](/pix/2021-03-10_16-11-53.png)

Ок, в IDA-view A переименовываю **fdwReason** в **PeiServices**. Сходство с описанным в статье просто поразительное.

Сохранение PeiServices на стеке.

![2021-03-10_16-24-27.png](/pix/2021-03-10_16-24-27.png)

Внутри следующей переименовываю **arg_0** в **PeiServices**


"11h в данном случае — это BOOT_ON_S3_RESUME, т.е. если система просыпается из ACPI Sleep Mode" (c)

И место, где проверяется RSA подпись.

![rsa check](/pix/2021-03-10_16-41-25.png)


**.text:10000FA9                 jnz     short loc_10000FB2 ; There need NOP NOP**

![jnz     short loc_10000FB2](/pix/2021-03-10_17-53-50.png)

В HxD:

![jnz     short loc_10000FB2](2021-03-10_18-01-51.png)

Создаю 


 загружаю в PhoenixTool v.2.66.

48000: HP BB BFR OKU
Blood Flow Restriction, Big Ffff...flying Rocket, Brominated Flame Retardants, 






					
 
 


##


##



##











