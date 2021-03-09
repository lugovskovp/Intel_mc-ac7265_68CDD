# Get BIOS 68CDD dump.

Редактировать и программатором образ из [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe) - не путь. Официальный программатор не признает редактированню прошивку - RSA подпись не будет валидна. Загнать образ патченной (без проверки .sig) официальной или SPI-программатором - убить машинку, затрутся информационные блоки, характерные для конкретного экземпляра нотника - VSS, ME-region и иже с ними.

BIOS Backup ToolKit V2.0 - вроде как (?) сохраняет без SPI-программатора содержимое BIOS. Ноистинность можно подвердить только сравнив слитый с флешки дамп с результатом BIOS Backup ToolKit

Микросхема flash **MX25L3205D** - будущий дамп - в ней.
![Микросхема flash **MX25L3205D**](pix/IMG_20210305_081229.jpg)


Нужен программатор SPI, SW которого поддерживает этот чип.


https://www.flashrom.org/Supported_hardware

Vendor	Device	Size [kB]	Type	Status	Voltage [V]
 	Probe	Read	Erase	Write	Min	Max
Macronix	MX25L3205D/MX25L3208D	4096	SPI	OK	OK	OK	OK	2.700	3.600

Ждать CH-314 c алиэкспресса и/или использовать факт, что FW программатора vserprog может быть откомпилировано с целевой платформой BluePill, а клипса-прищепка для SOIC-8 [стоит в марте-2021](https://roboshop.spb.ru/tools/sop-8-clips) 250р. Лучше, конечно было бы взять за 330р её же [с кабелем и переходником](https://roboshop.spb.ru/tools/sop-8-clips-cabel), но не было в наличии.


- [flashrom "serprog"](https://www.flashrom.org/)



## vserprog

SPI-программатор, если валяется в закромах BluePill STM32F103, считай есть - прошить его FW программатора на STM32 [vseprog](https://github.com/dword1511/stm32-vserprog)

Немножко падеде танцев с бубном, не прописанных в его документации.

Для прошивки BluePill нужен USB-TTL адаптер, у меня он на Prolific PL2303

$> ~/Work/stm32-vserprog$ lsusb
Bus 002 Device 013: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port

1. Install libpci headers or disable all features
       apt search libpci
       apt install libpci-dev


2. Add "-b 115200 -m 8e1" in stm32-vseprog/Makefile in goal :
flash-uart: $(HEX)
	stm32flash -b 115200 -m 8e1 -w $< -v $(SERIAL)


3. BluePill: BOOT0 jumper set to 1.


4. Instead
          make BOARD=stm32-bluepill flash-uart
    must run as
         sudo make BOARD=stm32-bluepill flash-uart


5. BluePill: BOOT0 set to 0.
Connect throw USB.
If green led start flashing about 5-6 ticks per second - change your USB cabel, its damaged. PC13 LED must be on, without flasing.
Check:
   $> ls /dev/ttyA*
   /dev/ttyACM0
ttyACM0 - это id нового SPI-программатора.




### stm32flash



### vseprog

git clone --recurse-submodules https://github.com/dword1511/stm32-vserprog.git
cd stm32-vserprog
make BOARD=stm32-bluepill
>>boards/stm32-bluepill.mk:1: *** missing separator.  Stop.

-  - последняя официальная прошивка, уже установлена.