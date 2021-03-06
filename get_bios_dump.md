# Get BIOS 68CDD dump.

Редактировать и программатором образ из [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe) - не путь. Официальный программатор не признает редактированню прошивку - RSA подпись не будет валидна. Загнать образ патченной (без проверки .sig) официальной или SPI-программатором - убить машинку, затрутся информационные блоки, характерные для конкретного экземпляра нотника - VSS, ME-region и иже с ними.

BIOS Backup ToolKit V2.0 - вроде как (?) сохраняет без SPI-программатора содержимое BIOS. Ноистинность можно подвердить только сравнив слитый с флешки дамп с результатом BIOS Backup ToolKit

Микросхема flash **MX25L3205D**



https://www.flashrom.org/Supported_hardware

Vendor	Device	Size [kB]	Type	Status	Voltage [V]
 	Probe	Read	Erase	Write	Min	Max
Macronix	MX25L3205D/MX25L3208D	4096	SPI	OK	OK	OK	OK	2.700	3.600

## Used SW

- https://github.com/dword1511/stm32-vserprog
- https://www.flashrom.org/





-  - последняя официальная прошивка, уже установлена.