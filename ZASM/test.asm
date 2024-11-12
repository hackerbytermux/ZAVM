#main
mov r0, 101
in r1
cmp r0, r1
jne err

#if password correct
mov r0, 1
out r0
jmp end

#if password isnt correct
label err
xor r0, r0
out r0

#end
label end
hlt