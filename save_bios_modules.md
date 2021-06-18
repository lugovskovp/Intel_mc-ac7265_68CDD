# Извлечение модулей, , /work/_0_extract_dxe.cmd

Слитый программатором [в предыдущей части](get_bios_dump.md) дамп биоса **hp_bios_original.bin** копирую под именем **hp_bios.bin** в папку **./work**.



## Used SW
- Утилита UEFIExtract.exe из пакета [UEFI Tool NE alpha 58](https://github.com/LongSoft/UEFITool/releases/tag/A58).



## Подмена в BIOS одного из VEN_DEV_SUBSYS в whitelist модулей. 

Используя понимание [формата Whitelist WiFi HP](whitelist_hp6540b.md), ясно, что заменять можно любую запись в whitelist, кроме, пожалуй, родного модуля - чтобы сохранить возможность использовать и его.

Под замену - самый первый Вот на место самой первой, **Centrino Advanced-N 6200 2x2 AGN**. 

Задачи:
- заменить 
- Убрать самопроверку RSA подписи HP в BIOS




Результат прошлого шага - несколько файлов модулей с whitelist, модуль RSA чекера, хранилище VSS/NVRAM переменных целиком и файл с ACPI таблицами в папке **\work\patches\**.