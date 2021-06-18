@echo off
echo -----------------------------------------------------
echo File %2 Offset: %1

:: Make patch file
echo 0%1: 86 80 5A 09 86 80 10 90 0f 00 50 00 44 00 39 00 37 00 32 00 36 00 50 00 4e 00 47 00 55 00 00 00 >./patches/wl/%2.patch

:: backup
cp -f ./patches/%2.efi ./patches/wl/%2.new
xxd -g1 -c32 -r ./patches/wl/%2.patch ./patches/wl/%2.new

:: checking sucsess
xxd -g2 ./patches/%2.efi>./patches/old.hex
xxd -g2 ./patches/wl/%2.new>./patches/new.hex
diff ./patches/old.hex ./patches/new.hex 
diff ./patches/old.hex ./patches/new.hex > ./patches/wl/%2.hexpatch.diff

:: clear temp files
rm -f ./patches/*.hex

::moving result to folder build
mv -f ./patches/wl/*.new ./build
@echo on


