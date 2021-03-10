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

### Поиск модулей c WiFi IDs.

Из [списка оборудования](whitelist_equipment.md) в whitelist выбираю вариант, которого у меня на руках нет, и который вряд ли задумаю купить: [PCI\VEN_8086&DEV_4239&SUBSYS_13168086](http://driverslab.ru/devsearch/find.php?search=PCI%5CVEN_8086%26DEV_4239), *Centrino Advanced-N 6200 2x2 ABG*. В LittleEndian цифры ID выглядят как **8680394286801613**

Открываю UEFIToolNE alpha 58 **hp_bios_4ed.bin**, меню *Action-Search*, строка поиска hex **8680394286801613*
![8680394286801613](/pix/2021-03-09 13.03.59.png)

И получаю 4 (четыре) результата: в DXE драйверах WLAN и PlatformSetup, в PEI-модулях PlatformStage1 и PlatformStage2.

		Hex pattern "8680394286801613" found as "8680394286801613" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at body-offset AE8h
		Hex pattern "8680394286801613" found as "8680394286801613" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at body-offset 7AF8h
		Hex pattern "8680394286801613" found as "8680394286801613" in 53984C6A-1B4A-4174-9512-A65E5BC8B278/PE32 image section at body-offset 2928h
		Hex pattern "8680394286801613" found as "8680394286801613" in 233DF097-3218-47B2-9E09-FE58C2B20D22/PE32 image section at body-offset 30A8h

Интерфейс UEFITool удобен тем, что клик на результат поиска, синхронизирует главное окно, переходя к необходимому модулю. 
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
	

Сохраняю модуль: клик на строку результата поиска, правый клик на **модуль** с найденным PE32 image section, Extract as is... **File_DXE_driver_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN.ffs**
![Extract as is..](2021-03-10_13-35-06.png)

Открываю его в **HxD**, ищу смещение для hex последовательности *8680394286801613*, offset= B64h.

Создаю текстовый файл, формат элементарный: строка с комментариями начинается с # или ;. Строка с заменами - смещение от начала, двоеточие, ожидаемый байт, пробел, новое значение байта в шестнадцатеричном виде.
		
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

Сохраняю все 4 body, последовательно клик на строку результата поиска, правый клик на найденный PE32 image section, Extract body...

В командной строке **dir /b Sect*>patch_list.cmd**


### Замена ID в модулях.

Оборудование PCI\VEN_8086&DEV_4239&SUBSYS_13168086 (LittleEndian строка 8680394286801613) заменяю на новые значения - PCI\VEN_8086&DEV_095A&SUBSYS_90108086, т.е. на 86805A0986801090 по смещениям из результатов поиска.

Возможно, придется повторять этот этап, я сварщик не настоящий, и в правках BIOSов до этого момента замечен не был, и поэтому не руками в hex-редакторе, а создав командный файл **patch_list.cmd**. Его закотовка - с именами файлов модулей - была создана последним шагом прошлого этапа.

В начале каждой строки добавляю **bincmp**, в конце - **-patch patch_OFFSETVALUEFROMSEARCH.txt**, 

		bincmp Section_PE32_image_233DF097-3218-47B2-9E09-FE58C2B20D22_PlatformStage2_body.efi -patch patch_30A8h.txt
		bincmp Section_PE32_image_53984C6A-1B4A-4174-9512-A65E5BC8B278_PlatformStage1_body.efi -patch patch_2928h.txt
		bincmp Section_PE32_image_5EE86B35-0839-4A21-8845-F1ACB0F688AB_WLAN_body.efi -patch patch_AE8h.txt
		bincmp Section_PE32_image_PlatformSetup_PlatformSetup_body.efi -patch patch_7AF8h.txt
		pause

И создаю 4 текстовых файла с патчами, формат элементарный: строка с комментариями начинается с # или ;. Строка с заменами - смещение от начала, двоеточие, ожидаемый байт, пробел новое значение байта в шестнадцатеричных значениях.

		# start from 7af8 value  86803942 86801613 changed 86805A09 86801090 
		# found as "8680394286801613" in EfiCrc32GuidedSectionExtractionGuid/PE32 image section at body-offset AE8h
		ae8: 86 86
		ae9: 80 80
		aea: 39 5a
		aeb: 42 09
		aec: 86 86
		aed: 80 80
		aee: 16 10
		aef: 13 90


В репозитории эти файлы в папке **/src** . При запуске **patch_list.cmd** по каждому файлу вывод примерно такой:

		   >bincmp Section_PE32.efi -patch patch_7AF8h.txt
			>  00007AF8:  86  86  ; skip (old 86 == new 86)
			>  00007AF9:  80  80  ; skip (old 80 == new 80)
			>  00007AFA:  39  5A  ; done
			>  00007AFB:  42  09  ; done
			>  00007AFC:  86  86  ; skip (old 86 == new 86)
			>  00007AFD:  80  80  ; skip (old 80 == new 80)
			>  00007AFE:  16  10  ; done
			>  00007AFF:  13  90  ; done


Использование EFIPatch_0.28.0 невозможно, т.к. HP BIOS несколько отличается от ожидаемого парсером формата, и при открытии UEFI Tool выдает список ошибок:
v.A58:
FfsParser::parseRawArea: volume size stored in header 8000h differs from calculated using block map 10000h
FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume's free space
MeParser::parseFptRegion: FPT partition table header checksum is invalid

v.0.28
parseVolume: non-UEFI data found in volume's free space
parseVolume: unknown file system FFF12B8D-7696-4C8B-A985-2747075B4F50
parseBios: volume size stored in header 8000h differs from calculated using block map 65536h

**unknown file system FFF12B8D-** - NVRAM
**non-UEFI data found in volume's free space** - это RSA подпись, проверяемая BIOSом при загрузке.

48000: HP BB BFR OKU
Blood Flow Restriction, Big Ffff...flying Rocket, Brominated Flame Retardants, 



###
- [Простые приемы реверс-инжиниринга UEFI PEI-модулей на полезном примере](https://habr.com/ru/post/249655/)
- [Николай Шлей CodeRush](https://habr.com/ru/users/CodeRush/)

###

 загружаю в PhoenixTool v.2.66.








					
 
 


##


##



##











