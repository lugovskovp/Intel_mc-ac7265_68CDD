# Контрольная сумма BIOS.

При открытии дампа UEFI Tool выдает список предостережений - ошибок:

	v.A58:
	- FfsParser::parseRawArea: volume size stored in header 8000h differs from calculated using block map 10000h
	- FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume's free space
	- MeParser::parseFptRegion: FPT partition table header checksum is invalid

	v.0.28
	- parseVolume: non-UEFI data found in volume's free space
	- parseVolume: unknown file system FFF12B8D-7696-4C8B-A985-2747075B4F50
	- parseBios: volume size stored in header 8000h differs from calculated using block map 65536h
	 
**unknown file system FFF12B8D-..** - в старом парсере - область NVRAM, VSS переменные

**volume size stored in header 8000h differs from calculated using block map** - это, похоже, какое-то своё, глубоко личное, прочтение стандарта инженерами Hewlett Packard. Как и **FPT partition table header checksum is invalid**

**non-UEFI data found in volume's free space** - это RSA подпись (на самом деле, не факт, что это именно RSA алгоритм, но называть буду так для краткости), проверяемая BIOSом при загрузке, о назначении которой в BIOSах HP [Николай Шлей aka CodeRush](https://habr.com/ru/users/CodeRush/) подробнейше рассказывал в своей статье[Простые приемы реверс-инжиниринга UEFI PEI-модулей на полезном примере](https://habr.com/ru/post/249655/).


## Dirty hack RSA checking.

Собственно его статья [Простые приемы реверс-инжиниринга UEFI PEI-модулей на полезном примере](https://habr.com/ru/post/249655/) определяет этот раздел. Посему читать прежде всего его, тут только те моменты, которые отличаются.


### Делай раз!

Сообщение парсера **FfsParser::parseVolumeNonUefiData: non-UEFI data found in volume's free space** приводит к информации в области паддинга, которая вообще то ожидается заполненной FF.
![RSA? checksum - flag vs BIOS editing](/pix/2021-03-10_15-32-14.png)

В конце строка **"$SIG0F 6068CDD"**, версия BIOS, напомню, *F.60*, платформа BIOS *68CDD*.


### Делай два!

На скриншоте видно, что смещение внутри тома не 12FEE0h, как в статье, а 14FEE0h. Поэтому ищу E0FE14h.

		Hex pattern "E0FE14" found as "E0FE14" in Compressed section/PE32 image section at body-offset 10D2h
		Hex pattern "E0FE14" found as "E0FE14" in Compressed section/PE32 image section at body-offset 10F7h

Оба вхождения - в PE32 image section модуля с названием **SecureUpdating**, GUID которого **E64E8AEE-0C78-4D9D-86A9-40C97845A3D4** полностью совпадает с описанным в статье.


### Делай три!

```int __cdecl start(EFI_FFS_FILE_HEADER *FfsFileHeader, EFI_PEI_SERVICES **PeiServices)```

start:

		pop     ecx
		push    [ebp+PeiServices]
		call    sub_10004303    ; Сохранение PeiServices на стеке.
		pop     ecx
		push    [ebp+PeiServices]
		call    sub_10000F76    ; А тут проверка RSA с загрузкой по смещению 14FEE0h
		pop     ecx
		mov     [ebp+var_11+1], eax
		movzx   eax, byte_10006A30
		cmp     eax, 0DEh
		jnz     short loc_1000178E




```int __cdecl sub_10000F76(EFI_PEI_SERVICES **PeiServices)```




"*11h в данном случае — это BOOT_ON_S3_RESUME, т.е. если система просыпается из ACPI Sleep Mode*" (c)

Кстати, все варианты EFI_BOOT_MODE, [согласно документации](https://dox.ipxe.org/PiBootMode_8h.html)

			#define 	BOOT_WITH_FULL_CONFIGURATION   0x00
			#define 	BOOT_WITH_MINIMAL_CONFIGURATION   0x01
			#define 	BOOT_ASSUMING_NO_CONFIGURATION_CHANGES   0x02
			#define 	BOOT_WITH_FULL_CONFIGURATION_PLUS_DIAGNOSTICS   0x03
			#define 	BOOT_WITH_DEFAULT_SETTINGS   0x04
			#define 	BOOT_ON_S4_RESUME   0x05
			#define 	BOOT_ON_S5_RESUME   0x06
			#define 	BOOT_WITH_MFG_MODE_SETTINGS   0x07
			#define 	BOOT_ON_S2_RESUME   0x10
			#define 	BOOT_ON_S3_RESUME   0x11
			#define 	BOOT_ON_FLASH_UPDATE   0x12
			#define 	BOOT_IN_RECOVERY_MODE   0x20

И место, где проверяется RSA подпись.

![rsa check](/pix/2021-03-10_16-41-25.png)


**.text:10000FA9                 jnz     short loc_10000FB2 ; There need NOP NOP**

![jnz     short loc_10000FB2](/pix/2021-03-10_17-53-50.png)

В HxD:

![jnz     short loc_10000FB2](/pix/2021-03-10_18-01-51.png)




### Ремарка по UPD из статьи 

В дампе самой флешки НЕ хранится "запасной" копии BIOS, о которой Николай Шлей упоминает в конце своей статьи, а вот в файле BIOS с сайта hp.com - копия есть. Слева - дамп, справа - вытащенный из SoftPack BIOS.

![BIOSes](/pix/2021-03-10_20-07-02.png)



### Замена JNZ на NOP NOP

Задача - заменить по смещению fa9 байты 75 07 на 90 90



Возможен вопрос: а нафига все эти лишние телодвижения, создание файлов патчей, командных файлов, использование дополнительной утилиты? 

Ответ простой - просто я очень ленивый. Если потребуется итеративно пересобирать - то эти, уже отлаженные действия можно будет выполнить практически на автомате. И через год совершенно не буду помнить по какому смещению что и куда правил. Какие именно файлы, и не ошибся ли циферкой. Поэтому мне спокойнее работа с логгируемыми действиями, повторение которых или объяснение кому-либо потребуют минимальных усилий. 

А так никто не запрещает прямо в HxD править значения руками.
