.DEFAULT_GOAL := all

# [CONFIGURE] Toolchain
GCC_DIR    = /opt/riscv
GCC_PREFIX = riscv32-unknown-elf
GCC_VER    = 15.1.0

# [CONFIGURE] CoreMark specific definitions
ITERATIONS     = 120        # Iterations of CoreMark (120 for score in ariscv)
CLOCKS_PER_SEC = 100000000  # Core clock speed
FLAGS_STR      = ""
CORE_DEBUG     = 0 # 1 to activate debug prompts
VALIDATION_RUN = 0
PERFORMANCE_RUN = 1

# Target architecture and tools
ARCH    = rv32i
ABI     = ilp32
CC      = $(GCC_PREFIX)-gcc
AS      = $(GCC_PREFIX)-as
LD      = $(GCC_PREFIX)-ld
EF      = $(GCC_PREFIX)
OBJDUMP = $(GCC_PREFIX)-objdump
OBJCOPY = $(GCC_PREFIX)-objcopy
NM      = $(GCC_PREFIX)-nm

# Linker script
LINKER_SCRIPT = linker.ld

# Directories
PORT_DIR = barebones
MEM_DIR  = ../mem

# Output files
PRJNAME  = coremark_bmrk
TARGET   = $(PRJNAME).elf
TEXT_BIN = $(PRJNAME)_iram.bin
DATA_BIN = $(PRJNAME)_dram.bin

# Compiler & Assembler flags
CFLAGS = \
    -g \
    -O3 \
	-march=$(ARCH) \
	-mabi=$(ABI) \
	-ffreestanding \
	-fno-stack-protector \
	-fno-zero-initialized-in-bss \
	-mstrict-align \
	-fno-builtin

# Assembler flags
ASFLAGS = \
	-march=$(ARCH) \
	-mabi=$(ABI)

# Linker flags
LDFLAGS = \
    -T $(LINKER_SCRIPT) \
    -static \
    -nostartfiles \
    -Xlinker \
    -Map=$(PRJNAME)_linker.map

# Extra flags for CC
XCFLAGS = \
	-g \
	-O2 \
	-DITERATIONS=$(ITERATIONS) \
	-DCLOCKS_PER_SEC=$(CLOCKS_PER_SEC) \
	-I ./ \
	-I $(PORT_DIR) \
	-DFLAGS_STR=\"$(FLAGS_STR)\" \
	-DCORE_DEBUG=$(CORE_DEBUG) \
	-DPERFORMANCE_RUN=$(PERFORMANCE_RUN) \
	-DVALIDATION_RUN=$(VALIDATION_RUN)

# C Libraries for compilation/linking
# These are reqd. to link mul/div/mod SW routines of GCC used by ilp32 ABI
LIBC =
LIBGCC = \
    -L$(GCC_DIR)/lib/gcc/$(GCC_PREFIX)/$(GCC_VER)/$(ARCH)/$(ABI) \
	-lgcc \
	-L$(GCC_DIR)/$(GCC_PREFIX)/lib/$(ARCH)/$(ABI) \

# Core Source files
CORE_SRC_FILES  = \
	core_list_join.c \
	core_main.c \
	core_matrix.c \
	core_state.c \
	core_util.c 

# Ported Source files
PORT_SRC_FILES = \
	$(PORT_DIR)/core_portme.c \
	$(PORT_DIR)/ee_printf.c

# Start-up code source file
STARTUP = startup.s

# Source, object code, linker files
CSRCS  = $(CORE_SRC_FILES) $(PORT_SRC_FILES)
ASRCS  = $(STARTUP) 
OBJS   = $(ASRCS:.s=.o) $(CSRCS:.c=.o) 

# Message before compilation
.PHONY: msgc
msgc:
	@echo ""
	@echo "| COREMARK_MAKE: Compiling..."

# Default rule: build everything
all: clean $(TARGET) dump binary sections symbols

# Minimal build
build: $(TARGET) binary sections

# Compile C & Assembly files to object files
%.o: %.c
	$(CC) $(CFLAGS) $(XCFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@

# Link everything and generate ELF
$(TARGET): msgc $(OBJS) $(LINKER_SCRIPT)
	@echo ""
	@echo "| COREMARK_MAKE: Linking..."
	$(CC) $(LIBGCC) $(LIBC) $(LDFLAGS) $(OBJS) -o $(TARGET)
	$(EF)-readelf -S $(TARGET)
	@echo ""
	@echo "ELF size:"
	@$(EF)-size $(TARGET)

# Dump entire disassembly of ELF
dump: $(TARGET)
	@echo ""
	@echo "| COREMARK_MAKE: Dumping the disassembly of the ELF..."
	$(OBJDUMP) -D $(TARGET) > $(PRJNAME).dump

# Dump only .text section
textdump: $(TARGET)
	@echo ""
	@echo "Dumping the disassembly of the ELF (.text only)..."
	$(OBJDUMP) -d $(TARGET) > $(PRJNAME).text.dump
	@cat $(PRJNAME).text.dump

# Show section memory layout
sections: $(TARGET)
	@echo ""
	@echo "## SECTION MEMORY LAYOUT ##"
	$(OBJDUMP) -h $(TARGET) > $(PRJNAME).sections
	@cat $(PRJNAME).sections

# Show symbol table
symbols: $(TARGET)
	@echo ""
	@echo "## SYMBOL TABLE ##"
	@$(NM) -n $(TARGET) > $(PRJNAME).symbols
	@cat $(PRJNAME).symbols

# Extract text and data sections separately and dump binary files
binary: $(TARGET)
	@echo ""
	@echo "| COREMARK_MAKE: Dumping the binaries..."
	$(OBJCOPY) -O binary --only-section=.text $(TARGET) $(TEXT_BIN)
	$(OBJCOPY) -O binary --only-section=.data --only-section=.rodata $(TARGET) $(DATA_BIN)

# Clean output files
.PHONY: clean
clean:
	@echo ""
	@echo "| COREMARK_MAKE: Cleaning all generated files!"
	rm -f $(OBJS) $(TARGET) $(TEXT_BIN) $(DATA_BIN)
	rm -f $(PRJNAME)_linker.map
	rm -f $(PRJNAME).dump
	rm -f $(PRJNAME).text.dump
	rm -f $(PRJNAME).sections
	rm -f $(PRJNAME).symbols