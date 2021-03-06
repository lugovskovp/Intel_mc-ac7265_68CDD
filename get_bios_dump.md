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

## Used SW

- Проект FW программатора на STM32 [vseprog](https://github.com/dword1511/stm32-vserprog)
- [flashrom "serprog"](https://www.flashrom.org/)



## Road

### Toolchain stm32flash

Для компиляции vserprog необходимы тулчейны https://sourceforge.net/p/stm32flash/ Под linux установка тривиальна, под виндой придется чуть помучаться.


### vserprog

#### MSYS2 
https://www.msys2.org/

### stm32flash



### vseprog

git clone --recurse-submodules https://github.com/dword1511/stm32-vserprog.git
cd stm32-vserprog
make BOARD=stm32-bluepill
>>boards/stm32-bluepill.mk:1: *** missing separator.  Stop.

-  - последняя официальная прошивка, уже установлена.