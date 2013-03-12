OUTPUT_FORMAT("elf32-i386-freebsd")
OUTPUT_ARCH(i386)
ENTRY(_start)
SEARCH_DIR("/usr/lib32")

PHDRS
{
  text PT_LOAD FILEHDR PHDRS ;
  data PT_LOAD ;
  note PT_NOTE ;

  swtm_table PT_LOAD ;
  swtm_code PT_LOAD ;
}

SECTIONS
{
  . = 0x08048000 + SIZEOF_HEADERS;

  .note.ABI-tag : { *(.note.ABI-tag) } :text :note

  .init           :
  {
    KEEP (*(.init))
  } :text =0x90909090
  .text           :
  {
    *(.text .stub .text.* .gnu.linkonce.t.*)
    *(.gnu.warning)
  } =0x90909090
  .fini           :
  {
    KEEP (*(.fini))
  } =0x90909090
  .rodata         : { *(.rodata .rodata.* .gnu.linkonce.r.*) }

  . = ALIGN (0x1000) - ((0x1000 - .) & (0x1000 - 1));

  . = DATA_SEGMENT_ALIGN (0x1000, 0x1000);

  . = ALIGN(32 / 8);

  .data           :
  {
    *(.data .data.* .gnu.linkonce.d.*)
    SORT(CONSTRUCTORS)
  } :data
  .eh_frame       : { KEEP (*(.eh_frame)) }
  .ctors          :
  {
    KEEP (*crtbegin*.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  }
  .dtors          :
  {
    KEEP (*crtbegin*.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  }
  .bss            :
  {
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
   . = ALIGN(32 / 8);
  }
  . = ALIGN(32 / 8);

  _end = .;

  . = DATA_SEGMENT_END (.);

  .comment       0 : { *(.comment) }

  .swtm_table 0x10000000 : { *(.swtm_table) } :swtm_table
  .swtm_code 0x40000000 : { *(.swtm_code) } :swtm_code

  /DISCARD/ : { *(.note.GNU-stack) }
}
