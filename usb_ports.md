# USB порты


## TOC
- [Used SW](#used-sw)


## Used SW 

- [010 Editor](https://www.sweetscape.com/010editor/) как продвинутый hex-редактор
- [RW Everithing](http://rweverything.com/download/) - низкоуровневый доступ к памяти


[Статический анализ «BIOS/UEFI» или как получить Dependency Graph](https://habr.com/ru/post/440052/)







## Intel® Dual Band Wireless-AC 7265 и Bluetooth 4.2

[Intel® Dual Band Wireless-AC 7265](https://ark.intel.com/content/www/ru/ru/ark/products/83635/intel-dual-band-wireless-ac-7265.html). Wi-Fi 802,11ac, 2.4GHz + 5GHz, Bluetooth 4.2, up to 867 Mbps. 

Bluetooth 4.2 на mini PCIe плате подключается "отдельным" интерфейсом - USB, присутствующим по стандарту на разьёме Mini PCI Express - контакты 36 и 38.

![7265 mpcie](/pix/mPCIe_7265.png)

Видно, что контакт 51 разъёма не задействован, в отличие от Intel 7260, где его функция BT_DISABLE и неработоспособность BT можно вылечить заклеиванием этого контакта. Здесь, по всей видимости, отключает и WiFi и Bluetooth контакт 20 - W_DISABLE.

Проблема в том, что ни одна из одобренных (HP WhiteList) сетевых карт не использует выводы USB разьёма, т.е. при тестировании BIOS вообще не было необходимости проверять работоспособность разведенного (согласно [принципиальной схеме ноутбука](/doc/HP%20ELITEBOOK%206440b%206540b%20(Compal%20LA-4891P%20KELL00%20-%20DIOR%20DISCRETE%20)%20laptop%20schematics.pdf)) USB порта #6.

![mpcie usb](/pix/usb-ibexpeak.png) 

![mpcie usb](/pix/usb-mpcie.png) 

USB20
# - USE - Page
---------------
0 - CONN - 31
1 -  CONN - 31
2 - CONN - 34
3 - CONN - 34
4 EXPRESS card - 34
5 GLAN - 27
6 - WLAN (!!!) - 29
7 - n/c

8 - BLUETOOTH - 31
9 - WWAN - 29
10 - Fingerprint -32
11 - DOCK - 33
12 - USB Camera - 20
13 - DOCK - 33


PCI-шина 0, устройство 29 (0x1D), функция 0
    Расширенный хост-контроллер Intel(R) 5 Series/3400 Series Chipset Family USB — 3B34
	     Port_#0001.Hub_#0002
		 
		 
USB port #6 разведен, но в Диспетчере устройств выглядит, как будто к нему не присоединено никаких устройств.

PCI-шина 0, устройство 26 (0x1A), функция 0
   Расширенный хост-контроллер Intel(R) 5 Series/3400 Series Chipset Family USB — 3B3C
       Port_#0001.Hub_#0001



## USB EHCI Controller #1 

PCI-шина 0, устройство 29 (0x1D), функция 0

Mapping memory (Диспетчер устройств): 00000000D0608000 - 00000000D06083FF - 0x3FF=1023 bytes 

По [документации на 5 поколение](doc/5-chipset-3400-chipset-datasheet.pdf) чипсетов Intel




------------
5.18.1 EHC Initialization The following descriptions step through the expected PCH Enhanced Host Controller (EHC) initialization sequence in chronological order, beginning with a complete power cycle in which the suspend well and core well have been off. 5.18.1.1 BIOS Initialization BIOS performs a number of platform customization steps after the core well has powered up. Contact your Intel Field Representative for additional PCH BIOS information. 5.18.1.2 Driver Initialization See Chapter 4 of the Enhanced Host Controller Interface Specification for Universal Serial Bus, Revision 1.0.

------------
16.1 USB EHCI Configuration Registers  (USB EHCI—D29:F0, D26:F0)



-------------------

RWE:

Bus 00, Device 1D, Function 00 - Intel Corporation EHCI USB Controller
 ID=3B348086, SID=1726103C, Int Pin=INTA, IRQ=14
 MEM=D0608000  IO=None








-----------
##


##


##