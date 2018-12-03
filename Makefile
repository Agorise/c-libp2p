COMPONENTS = conn crypto db thirdparty hashmap identify net os peer record routing secio swarm utils yamux

export DEBUG = true
export SHARED = true

ROOT= $(shell pwd)
export INCLUDE = -I$(ROOT)/include -I$(ROOT)/c-protobuf -I$(ROOT)/c-multihash/include -I$(ROOT)/c-multiaddr/include
export CFLAGS = $(INCLUDE) -Wall -O0 -fPIC

ifdef DEBUG
CFLAGS += -g3
endif


OBJS = $(shell (find $(COMPONENTS) -name *.o))

all: test

link: compile
	$(AR) rcs libp2p.a $(OBJS) $(LINKER_FLAGS)
#ifdef SHARED
	gcc -shared -o libp2p.so $(OBJS) $(LINKER_FLAGS)
#endif

compile:
	$(foreach dir,$(COMPONENTS), $(MAKE) -C $(dir) all ;)

test: link
	make -C test all;

rebuild: clean all

clean:
	$(foreach dir,$(COMPONENTS), $(MAKE) -C $(dir) clean ;)
	make -C test clean
