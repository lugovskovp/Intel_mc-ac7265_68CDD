# Сборка содержимого UEFI flash и прошивка

## Used SW

- [BinCmp2](https://sourceforge.net/projects/bincmp/files/bincmp2/bincmp%202.9.0/) - сравнение файлов, поиск и замена бинарных данных из коммандной строки
- [UEFI Tool 0.28](https://github.com/LongSoft/UEFITool/releases/tag/0.28.0) - старый движок, но полнофункциональный билдер.
- PhoenixTool v.2.66.





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


 загружаю в PhoenixTool v.2.66.

48000: HP BB BFR OKU
Blood Flow Restriction, Big Ffff...flying Rocket, Brominated Flame Retardants, 





