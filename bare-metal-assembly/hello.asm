format pe64 efi
entry main

section '.text' executable readable
string du 'Hello, WOrld!', 0xD, 0xA, 0
main:
  mov rcx, [rdx + 64]
  mov rax, [rcx + 8]
  mov rdx, string
  sub rsp, 32
  call rax
  add rsp, 32
  ret
