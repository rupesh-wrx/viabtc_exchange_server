TARGET  := matchengine.exe
INCS = -I ../network -I ../utils
LIBS = -L ../utils -lutils -L ../network -lnetwork -Wl,-Bstatic -lev -ljansson -lmpdec  -lz -lcurl -lssl -lcrypto -lhiredis -Wl,-Bdynamic -lm -lpthread -ldl -lrdkafka -lmysqlclient
include ../makefile.inc
