 CFLAGS = -Wall -Wextra -Wno-deprecated-declarations

#ifeq ($(DEBUG),1)
	GRAMINE_LOG_LEVEL = debug
#	CFLAGS += -g
#else
#	GRAMINE_LOG_LEVEL = error
#	CFLAGS += -O3
#endif

LDFLAGS = $(CFLAGS) -L/usr/lib/x86_64-linux-gnu/sgx -lcrypto

.PHONY: all
all: test-gramine-short test-gramine-short.manifest
#ifeq ($(SGX),1)
#	all: test-gramine-short.manifest.sgx test-gramine-short.sig
#endif
ifeq ($(SGX),1)
	gramine-manifest -Dlog_level=error test-gramine-short.manifest.template test-gramine-short.manifest
	#make
	gramine-sgx-sign --manifest test-gramine-short.manifest --output test-gramine-short.manifest.sgx
endif
test-gramine-short: test-gramine-short.o
	$(CC) $^ -o $@ $(LDFLAGS) -lssl -lcrypto

test-gramine-short.o: test-gramine-short.c

test-gramine-short.manifest: test-gramine-short.manifest.template
	gramine-manifest -Dlog_level=$(GRAMINE_LOG_LEVEL) $< $@

test-gramine-short.sig test-gramine-short.manifest.sgx: sgx_sign
	@:

.INTERMEDIATE: sgx_sign
sgx_sign: test-gramine-short.manifest test-gramine-short
	gramine-sgx-sign --manifest $< --output $<.sgx

ifeq ($(SGX),)
	GRAMINE = LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu gramine-direct
else
	GRAMINE = LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu gramine-sgx
endif

.PHONY: check
check: all
	$(GRAMINE) ./test-gramine-short <input-file> | $(SHA512_CMD) > OUTPUT
	echo "SHA512 hash of input file:"
	cat OUTPUT
	@echo "[ Success ]"

.PHONY: clean
clean:
	$(RM) *.token *.sig *.manifest.sgx *.manifest test-gramine-short.o test-gramine-short OUTPUT

.PHONY: distclean
distclean: clean
	rm -rf .gbuild

SHA512_CMD = sha512sum
