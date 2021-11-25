TARGET  := accessws.exe
INCS = -I ../network -I ../utils
LIBS = -L ../utils -lutils -L ../network -lnetwork -Wl,-Bstatic -lev -ljansson -lmpdec -lz -llz4 -lssl -lcrypto -lhiredis -Wl,-Bdynamic -lm -lpthread -lrdkafka -ldl -lzstd -lcurl
include ../makefile.inc
