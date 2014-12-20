this program uses "qeum" to run.

#How to compile and run.
assemble
$nasm "filename.s"

write flopy disk
$mformat -f 1440 -C -B "filename" -i fd.img ::

run
$qemu -fda fd.img -boot a
