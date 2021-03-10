# Get BIOS 68CDD dump.

**ЛЮБОЕ ковыряние в BIOS необходимо начинать с создания бекапа содержимого конкретного компьютера.**

Редактировать и заливать программатором образ из [HP update BIOS 68CDD rev.F60 - latest and newest](https://ftp.hp.com/pub/softpaq/sp73501-74000/sp73934.exe) - не путь. Официальный программатор не признает редактированню прошивку - RSA подпись не будет валидна. Загнать образ патченной (без проверки .sig) официальной программой или SPI-программатором - убить машинку, затрутся информационные блоки, характерные для конкретного экземпляра нотника - VSS, ME-region и иже с ними, да и сам BIOS - это только часть содержимого флешки.

Если нет SPI-программатора, как не было у меня, то варианты либо сходить в сервис слить дамп, либо собрать по-быстрому свой, поддерживающий работу с конкретной микросхемой.  


## Used SW

- Открытый проект SPI программатора на STM32 [stm32-vseprog](https://github.com/dword1511/stm32-vserprog) 
- [flashrom "serprog"](https://www.flashrom.org/) - впрочем, он как субмодуль vseprog идет
- Linux Mint, установленный на другом ноутбуке.


## Микросхема flash с BIOS

Клавиатура крепится на трех винтах с нижней части корпуса нотника. Под ней - Микросхема flash **MX25L3205D**.

![Микросхема flash **MX25L3205D**](pix/IMG_20210305_081229.jpg)

В репозитории лежит [datasheet](/doc/MX25L3205D%2C%203V%2C%2032Mb%2C%20v1.5.pdf) на эту микросхему, Macronix	MX25L3205D, SPI-flash, Voltage 2.700-3.600 V, 4096kB. В [списке поддерживаемых flashrom](https://www.flashrom.org/Supported_hardware) она присутствует.


## SPI-программатор vserprog	

Ждать CH-314 c алиэкспресса - долго. Если найдется в закромах BluePill STM32F103C8T6, то, считай железная часть уже есть, FW программатора [stm32-vseprog](https://github.com/dword1511/stm32-vserprog) может быть откомпилировано с целевой платформой BluePill. Выпаивать чип для программирования, или припаиваться к ножкам - не хотелось, а клипса-прищепка для внутрисхемного программирования SOIC-8 [стоит в марте-2021](https://roboshop.spb.ru/tools/sop-8-clips) всего 250р. Лучше, конечно, было бы взять за 330р её же уже [с кабелем и переходником](https://roboshop.spb.ru/tools/sop-8-clips-cabel), если бы была в наличии. 


Немножко падеде танцев с бубном, не прописанных в его документации.

Для прошивки BluePill нужен USB-TTL адаптер, у меня он на Prolific PL2303.

		$> lsusb
		...
		Bus 002 Device 013: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
		...
		
1. Install libpci headers

		$> apt search libpci
		$> apt install libpci-dev
	   
2. Клонирую репозиторий проекта vseprog и собираю его под BluePill.

		$> cd ~/Work/
		$> git clone --recurse-submodules https://github.com/dword1511/stm32-vserprog.git
		$> cd stm32-vserprog
		$> make BOARD=stm32-bluepill

3. Add "**-b 115200 -m 8e1**" in stm32-vseprog/Makefile in goal :

		flash-uart: $(HEX)
			stm32flash -b 115200 -m 8e1 -w $< -v $(SERIAL)

4. BluePill: set BOOT0 jumper to 1. Присоединяю USB-TTL адаптер к BluePill: 
- +3.3v --- +3.3v
- GND 	--- GND
- TX	--- A10 (31)
- RX	--- A9 (30)

5. Запуск прошивки программатора - под sudo. Instead

          $> make BOARD=stm32-bluepill flash-uart
    must run as
	
          $> sudo make BOARD=stm32-bluepill flash-uart


6. Отсоединяю USB-TTL адаптер. BluePill: BOOT0 jumper set to 0.  Connect throw USB. If green led start flashing about 5-6 ticks per second - change your USB cabel, its damaged. PC13 LED must be on without flasing.

Проверяю появление SPI-программатора в устройствах (должен видеться как **ttyACM0**):

		$> ls /dev/ttyA*
		/dev/ttyACM0

7. Припаиваю провода к клипсе и к BluePill. 

![Схема присоединеня к SPI-flash микросхеме](/pix/schem_vseprog.jpg)

Пара оранжевых проводов - к 3.3v через резистор 2к2, (подойдёт от 1к до 10к), на фото он в зеленой термоусадке.

![И фото.](/pix/IMG_20210308_193759.jpg)

В окончательном виде, с задутой термоусадкой.

![В сборе 1.](/pix/IMG_20210308_194425.jpg)
![В сборе 2.](/pix/IMG_20210308_194627.jpg) 


## Дамп прошивки.

Отсоединяю шнур питания, и батарею ноутбука. Снимаю 3.3в. батарейку - CMOS слетит, при загрузке будет предупреждение, но внутренняя схематика платы мне неизвестна, мало ли где-то как-то эти вольты захотят выскочить. Присоединяю клипсу к микросхеме flash, соблюдая полярность. Включаю USP кабель программатора в нотник с Linux.

		$> cd ~/Work/stm32-vserprog/flashrom$
		$> ./flashrom -p serprog:dev=/dev/ttyACM0

Ошибка, не может открыть порт. Запускаю из-под sudo.

		$> sudo ./flashrom -p serprog:dev=/dev/ttyACM0

Выводит список возможных вариантов микросхемы и просит конкретизировать - что же там стоит.

		$> sudo ./flashrom -p serprog:dev=/dev/ttyACM0:4000000 -c MX25L3205D/MX25L3208D -r ~/Work/hp_bios_original.bin

Итог - в файле **~/Work/hp_bios_original.bin** - содержимое флешки.





BIOS Backup ToolKit V2.0 - вроде как (?) сохраняет без SPI-программатора содержимое BIOS. Ноистинность можно подвердить только сравнив слитый с флешки дамп с результатом BIOS Backup ToolKit





Нужен программатор SPI, SW которого поддерживает этот чип.