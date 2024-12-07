QEMU := /usr/bin/qemu-system-riscv64
ARCH ?= riscv64

ifeq ($(ARCH), riscv64)
  TARGET := riscv64gc-unknown-none-elf
else ifeq ($(ARCH), x86_64)
  TARGET := x86_64-unknown-none
endif

OUT_ELF := target/riscv64gc-unknown-none-elf/release/study_asterinas
OUT_BIN := $(OUT_ELF).bin
LD_SCRIPT := src/arch/riscv/riscv64.ld
RUSTFLAGS := -C link-arg=-T$(LD_SCRIPT) -C link-arg=-no-pie
export RUSTFLAGS

CARGO_ARGS := --target=$(TARGET) --release

all: build
  @:

build:
	cargo build $(CARGO_ARGS)
	rust-objcopy --binary-architecture=riscv64 $(OUT_ELF) --strip-all -O binary $(OUT_BIN)

run:
	$(QEMU) -m 128M -smp 1 -machine virt -bios default -kernel $(OUT_BIN) -nographic \
	-D qemu.log -d in_asm,int,mmu,pcall,cpu_reset,guest_errors

clean:
	cargo clean

.PHONY: all build run clean
