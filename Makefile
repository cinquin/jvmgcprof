CC=cc
OS=$(shell uname -s | tr '[A-Z]' '[a-z]')

ifeq ("$(OS)", "darwin")
JAVA_HOME?=$(shell /usr/libexec/java_home)
INCLUDE=-I$(JAVA_HOME)/include/ -I$(JAVA_HOME)/include/darwin/
endif

ifeq ("$(OS)", "linux")
JAVA_HOME?=/usr/java/default/
INCLUDE=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux
endif

CFLAGS=-Ijava_crw_demo -fno-strict-aliasing                                  \
        -fPIC -fno-omit-frame-pointer -W -Wall  -Wno-unused -Wno-parentheses \
        $(INCLUDE)
LDFLAGS=-fno-strict-aliasing -fPIC -fno-omit-frame-pointer \
        -shared $(PLATFORM_LDFLAGS)

all: libgcprof.dylib GcProf.class

libgcprof.dylib: gcprof.o u.o java_crw_demo/java_crw_demo.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ -lc

%.class: %.java
	javac -Xlint:unchecked $<

clean:
	rm -f *.o
	rm -f libgcprof.dylib
	rm -f java_crw_demo/*.o

.PHONY: all clean
