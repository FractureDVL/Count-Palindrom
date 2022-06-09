.model small
.386
.stack 64
.data

 ;cad1 db "hola"
 ;cad2 db "aloaloh"

 msg1 db "Digite su primera cadena: $" ;mensaje1
 msg2 db "Digite su segunda cadena: $" ;mensaje2

 rta1 db "V1: $"
 rta2 db "V2: $"

valoral db ?
valorax dw ?

 sg db 5			;delay (seg)

 v1 db 0, 24h
 v2 db 0, 24h

 cadena1 label byte
  max1 db 20
  real1 db ?
  cad1 db 21 dup ('$')

 cadena2 label byte
  max2 db 20
  real2 db ?
  cad2 db 21 dup ('$')

.code
 main proc far
 mov ax, @data
 mov ds, ax
 mov es, ax

 mov bh,79h
 call limpiar
 mov dx,0202h
 call ubicar

;------------- muestra mensaje 1 --------------

 call tecla

 lea dx,msg1
 call mostrar

 lea dx,cadena1
 call captura

 mov bh,0F9h
 call limpiar

  mov dx,0202h
  call ubicar

;------------- muestra mensaje 2 --------------

 call tecla

 lea dx,msg2
 call mostrar

 lea dx,cadena2
 call captura

 mov bh,0F9h
 call limpiar

  mov dx,0202h
  call ubicar

;------------- proceso logico --------------

 mov ax, 0
 lea si, cad1
 lea di, cad2

 mov cl, real1		;cad1 length

 setch:
 mov ch, real2		;cad2 length

 contar:
 mov al,[si]
 cmp al,[di]
 je sumar
 inc di
 dec ch

 reset:
 cmp ch, 0
 je sigcad1
 jmp contar

 sumar:
 inc ah
 inc di
 dec ch
 jmp reset

 sigcad1:
 lea di, cad2
 dec cl
 inc si
 cmp cl, 0
 je ordenar
 jmp setch

;---------------- PALINDROME ---------------------

 ordenar:
 mov dl, ah
 mov v1, dl
 mov ax, 0
 lea si, cad1
 lea di, cad2

 mov cl, real1        ;cad1 length

;---------------- AQUI HAY CAMBIOS ---------------------

 mov bl, real1        ;metemos tamano cad1
 mov ch, real2        ;cad2 length
 mov dx, 0
 mov dl, real1
 sub dl, 0001h
 add si, dx

 ; si = "aloh"  di = "aloaloh"

volver:
 contarpal:
 mov al,[si]
 cmp ch, 0
 je fin
 cmp al,[di]
 je sumarpal
 mov bh, 0
 lea si, cad1
;---------------- AQUI HAY CAMBIOS ---------------------
 add si, dx

 sumarpal:
 inc bh ; letra x letra veces que se repite
 dec si
 inc di
 dec ch
 cmp bh, bl
 je sumardh ; V2++
 jmp volver
 
 sumardh:
 inc v2
 mov bh, 0
 jmp contarpal

fin:
 add v1, 30h
 add v2, 30h
;------------- muestra respuesta v1 --------------

  mov dx,0202h
  call ubicar

  lea dx,rta1
  call mostrar

  mov dx,0302h
  call ubicar

  lea dx,v1
  call mostrar

;------------- muestra respuesta v2 --------------

  mov dx,0502h
  call ubicar

  lea dx, rta2
  call mostrar

  mov dx,0602h
  call ubicar

  lea dx,v2
  call mostrar

  mov bx,0
  call delay
 
  mov ax,4c00h
  int 21h
main endp



;**************PROCEDIMIENTOS************
tecla proc near
  mov ah,10H
  int 16h
  ret
tecla endp
;****************************************
DELAY proc near

 ; devuelve ch: horas
 ; devuelve cl: minutos
 ; devuelve dh: segundos

  mov ah,2cH  ; devolver la hora del procesador
  int 21h
  mov bh,dh
  add bh,sg  ; le suma a los sg devueltos los seg del delay 
  cmp bh,59 ; si se pasa de 60 segundos para el control se debe restar 59
  jna siga
  sub bh,59
siga:
  mov ah,2cH  ; devolver la hora del procesador
  int 21h
  
  cmp bh,dh
  ja siga
 
  ret
DELAY endp

;****************************************
UBICAR proc near   	  
  mov ah,02h           	   
  mov bh,00h            	   
  int 10h                 	
  ret                   		   
UBICAR endp         	  

;****************************************
LIMPIAR proc near         
  mov ah,06h               	
  mov al,00h  
  mov cx,0000h                   
  mov dx,184fh           	  
  int 10h                  	
  ret                      	
LIMPIAR endp     	

;****************************************
MOSTRAR proc near 	  
  mov ah,09h             	  
  int 21h                 	 
  ret                     		 
MOSTRAR endp      
;****************************************
CAPTURA proc near	
    mov ah,0ah
    int 21h
    ret
CAPTURA endp
end