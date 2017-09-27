TITLE Program Template     (yathzee.asm)

; Program Description:
; Author:
; Date Created:
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

oniki BYTE 0
string1 BYTE "Welcome to Yathzee game",0dh,0ah ;menü deðiþkeni
 BYTE "Order          Combination          Score",0dh,0ah
 BYTE "1              Ones                 0",0dh,0ah
 BYTE "2              Twos                 0",0dh,0ah
 BYTE "3              Threes               0",0dh,0ah
 BYTE "4              Fours                0",0dh,0ah
 BYTE "5              Fives                0",0dh,0ah
 BYTE "6              Sixs                 0",0dh,0ah
 BYTE "7              3 of a kind          0",0dh,0ah
 BYTE "8              4 of a kind          0",0dh,0ah
 BYTE "9              Yahtzee              0",0dh,0ah
 BYTE "10             4 in a row           0",0dh,0ah
 BYTE "11             5 in a row           0",0dh,0ah
 BYTE "12             Anything             0",0dh,0ah
 BYTE "Zarlari atmak icin enter'a basinizz ",0dh,0ah,0
 zar1 BYTE "   ",0dh,0ah
	  BYTE " . ",0dh,0ah
	  BYTE "   ",0
zar2 BYTE " . ",0dh,0ah
	  BYTE "   ",0dh,0ah
	  BYTE " . ",0	 
zar3 BYTE "  .",0dh,0ah
	  BYTE " . ",0dh,0ah
	  BYTE ".  ",0	 
zar4 BYTE ". .",0dh,0ah
	  BYTE "   ",0dh,0ah
	  BYTE ". .",0	 
zar5 BYTE ". .",0dh,0ah
	  BYTE " . ",0dh,0ah
	  BYTE ". .",0
zar6 BYTE ". .",0dh,0ah
	  BYTE ". .",0dh,0ah
	  BYTE ". .",0	  
 arr DWord 5 Dup(?) ;zarlarýn tutulduðu array
 arr2 DWord 5 Dup (?) ;zarlarýn sýralandýktan sonra tutulduðu array
 one DWord 0
 two DWord 0
 three DWord 0
 four DWord 0
 five DWord 0
 six DWord 0
 topla3 BYTE 0
 topla4 BYTE 0
 strn BYTE "Your Score",0
 string2 BYTE "Tablodan secim yapmak istiyor musun? e/h",0
 string3 BYTE "Tutmak istediginiz zarlari giriniz:",0 
 kac BYTE "kac sayi tutmak istiyorsun",0
 sec BYTE "hangini secmek istiyorsaniz numarasini giriniz:",0
 bos BYTE "                                                            ",0
 secim BYTE 9 Dup(?)
 TArray DWord 12 Dup(0) ;zarlarýn konbiinasyanlarýnýn tutulduðu array
 TArray2 DWord 12 Dup(0) ;tablodaki deðerlerin tutulduðu array
 say DWord 0
 say2 DWord 0
 yat DWord 0
 boss BYTE "  ",0
 boolean BYTE 12 Dup (0) ;tabloda yerlerin seçildiyse 1 seçilmediyse 0 olduðunu gösteren array

; (insert variables here)
;-------------------------------------------------------
.code
main PROC
call clrscr
mov edx, OFFSET string1  ;menüyü yazdýrma
call writeString
entr:
call readChar
cmp al,13  ;enter kontrol ediliyor
je zar
jne entr
mov ecx,12


zar:
push ecx
call rollAllDice ;zarlar atýlýyor
call Bubble ;bubble sort yapýlýyor
call tablo ;1-6 arasýndaki tablodaki deðerler yazýlýyor
call ThreeofaKind ;three of a kind bulunuyor
call FourofaKind ;four of kind bulunuyor
call FourInaRow ;four in a row bulunuyor
call FiveInaRow ;five in a row bulunuyor
call Yahtzee ;yahtzee bulunuyor
call Anything ;tüm zarlarýn toplamý bulunuyor
;call dumpregs
mov dl,0
mov dh,20
call gotoxy

mov ecx,2

head:
mov dl,0
mov dh,20
call gotoxy
mov edx, OFFSET string2  ;secme sorusu
call writeString
call readChar
cmp al,101 ;yazýlan karakter e ise secme label'ý na jump yapýlýyor
je secme
cmp al,104 ;yazýlan karakter h ise devam label'ý na jump yapýlýyor
je devam
devam:
mov dl,0
mov dh,20
call gotoxy
mov edx, OFFSET bos  ;boþluk
call writeString
mov dl,0
mov dh,20
call gotoxy
push ecx
mov edx, OFFSET kac  ;sayý alma
call writeString
call tekinput ;kullanýcýdan input alýnýyor
call Bubble 
call tablo
call ThreeofaKind
call FourofaKind
call FourInaRow
call FiveInaRow
call Yahtzee
call Anything
pop ecx
sub ecx,1
cmp ecx,0
jne head ;eðer ecx 2 den küçükse head label'ýna jump yapýlýyor

secme: ;tablodan seçim yapýlan label
pop ecx
mov dl,0
mov dh,20
call gotoxy
mov edx, OFFSET bos  ;boþluk
call writeString
mov dl,0
mov dh,20
call gotoxy
mov edx,offset sec
call writeString
mov dl,48
mov dh,20
call gotoxy
push ecx
call tablosec ;tablodan seçim yapmak için tablosec metodu çaðýrýlýyor
mov dl,0
mov dh,20
call gotoxy
mov edx, OFFSET bos  ;boþluk
call writeString
mov dl,0
mov dh,20
call gotoxy
pop ecx

cmp oniki,12 ;loop 12 kez dönüp dönmediði kontrol ediliyor
je final
je final
jne zar


final: ;toplam skor yazýlýyor ve oyun bitiyor

mov dh,8
mov dl,55
call gotoxy
mov eax,3+(black*16)
call setTextColor
mov ecx,12
mov edi,0
mov eax,0
sema:
add eax,TArray2[edi]
add edi,4
loop sema
call writeDec
mov dh,7
mov dl,50
call gotoxy
mov edx,OFFSET strn
call writeString
mov eax,white+(black*16)
call setTextColor




	exit	; exit to operating system
main ENDP
;--------------------------------------------------------------tüm zarlarý atma
rollAllDice PROC ;Beþ zar atma

call randomize
mov ecx,5
mov esi,0
L1:
mov eax,6
call randomRange   ;random sayý üretiyor 0 ile 5 arasýnda
add eax,1
mov arr[esi],eax   ;zar sayýlarýný arraye atma
add esi,4
push eax
;kaçýncý zar olduðu kontrol ediliyor
cmp ecx,5 
je bir
cmp ecx,4
je iki
cmp ecx,3
je uc
cmp ecx,2
je dort
cmp ecx,1
je bes
jne other
;zarlar çizdirilip sayýlar içine yazýlýyor
bir:
call birincizar
pop eax
mov dl,2
mov dh,17
call gotoxy
push eax
mov eax,5+(black*16)
call setTextColor
pop eax
call writeDec
mov eax,white+(black*16)
call setTextColor

jmp other
iki:	
call ikincizar
pop eax
mov dl,8
mov dh,17
call gotoxy
push eax
mov eax,5+(black*16)
call setTextColor
pop eax
call writeDec
mov eax,white+(black*16)
call setTextColor

jmp other
uc:
call ucuncuzar
pop eax
mov dl,14
mov dh,17
call gotoxy
push eax
mov eax,5+(black*16)
call setTextColor
pop eax
call writeDec
mov eax,white+(black*16)
call setTextColor

jmp other
dort:
call dorduncuzar
pop eax
mov dl,20
mov dh,17
call gotoxy
push eax
mov eax,5+(black*16)
call setTextColor
pop eax
call writeDec
mov eax,white+(black*16)
call setTextColor

jmp other
bes:
call besincizar
pop eax
mov dl,26
mov dh,17
call gotoxy
push eax
mov eax,5+(black*16)
call setTextColor
pop eax
call writeDec
mov eax,white+(black*16)
call setTextColor

other:
dec ecx
cmp ecx,0
jne L1
	
ret
rollAllDice ENDP
;-------------------------------------------birinci zarý çizme
birincizar PROC ;zar çizme
mov al,201
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,187
call writeChar
mov dl,0
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,4
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,0
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,4
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,0
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,4
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,0
mov dh,19
call gotoxy
mov al,200
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,188
call writeChar

ret
birincizar ENDP
;-------------------------------------------ikinci zarý çizme
ikincizar PROC ;zar çizme
mov dl,6
mov dh,15
call gotoxy
mov al,201
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,187
call writeChar
mov dl,6
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,10
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,6
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,10
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,6
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,10
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,6
mov dh,19
call gotoxy
mov al,200
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,188
call writeChar

ret
ikincizar ENDP
;------------------------------------------üçüncü zarý çizme
ucuncuzar PROC ;zar çizme
mov dl,12
mov dh,15
call gotoxy
mov al,201
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,187
call writeChar
mov dl,12
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,16
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,12
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,16
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,12
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,16
mov dh,18

call gotoxy
mov al,186
call writeChar
mov dl,12
mov dh,19
call gotoxy
mov al,200
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,188
call writeChar

ret
ucuncuzar ENDP
;-----------------------------------------------dördüncü zarý çizme
dorduncuzar PROC ;zar çizme
mov dl,18
mov dh,15
call gotoxy
mov al,201
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,187
call writeChar
mov dl,18
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,22
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,18
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,22
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,18
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,22
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,18
mov dh,19
call gotoxy
mov al,200
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,188
call writeChar

ret
dorduncuzar ENDP
;--------------------------------------------Beþinci zarý çizme
besincizar PROC ;zar çizme
mov dl,24
mov dh,15
call gotoxy
mov al,201
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,187
call writeChar
mov dl,24
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,28
mov dh,16
call gotoxy
mov al,186
call writeChar
mov dl,24
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,28
mov dh,17
call gotoxy
mov al,186
call writeChar
mov dl,24
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,28
mov dh,18
call gotoxy
mov al,186
call writeChar
mov dl,24
mov dh,19
call gotoxy
mov al,200
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,205
call writeChar
mov al,188
call writeChar

ret
besincizar ENDP
;---------------------------------------------Tablo doldurma 1-6 arasý
tablo PROC ;tablonun ilk bölümünü doldurma
mov ecx,5
mov esi,0
L1:
cmp arr[esi],1 ;eðer zar 1 ise one deðiþkenine 1 ekleniyor
jne twos
add one,1
jmp L2
twos:
cmp arr[esi],2 ;eðer zar 2 ise one deðiþkenine 2 ekleniyor
jne threes
add two,2
jmp L2
threes:
cmp arr[esi],3 ;eðer zar 3 ise one deðiþkenine 3 ekleniyor
jne fours
add three,3
jmp L2
fours:
cmp arr[esi],4 ;eðer zar 4 ise one deðiþkenine 5 ekleniyor
jne fives
add four,4
jmp L2
fives:
cmp arr[esi],5 ;eðer zar 5 ise one deðiþkenine 5 ekleniyor
jne sixs
add five,5
jmp L2
sixs:
;cmp arr[esi],6
add six,6 ;eðer zar 6 ise one deðiþkenine 6 ekleniyor
L2:
dec ecx
add esi,4
cmp ecx,0
je son
jne L1
son:

mov dh,2
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,2
mov dl,36
call gotoxy
mov eax,TArray2[0] ;eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,2
mov dl,36
call gotoxy
mov eax,one
mov one,0

cmp boolean[0],0
jne iki
mov TArray[0],eax ;eðer sayý seçilmemiþse 
call writeDec
iki:
mov dh,3
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,3
mov dl,36
call gotoxy
mov eax,TArray2[4];eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,3
mov dl,36
call gotoxy
mov eax,two
mov two,0

cmp boolean[4],0
jne uc
mov TArray[4],eax ;eðer sayý seçilmemiþse
call writeDec
uc:
mov dh,4
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,4
mov dl,36
call gotoxy
mov eax,TArray2[8] ;eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,4
mov dl,36
call gotoxy
mov eax,three
mov three,0

cmp boolean[8],0
jne dort
mov TArray[8],eax ;eðer sayý seçilmemiþse
call writeDec
dort:
mov dh,5
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,5
mov dl,36
call gotoxy
mov eax,TArray2[12] ;eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,5
mov dl,36
call gotoxy
mov eax,four
mov four,0

cmp boolean[12],0
jne bes
mov TArray[12],eax ;eðer sayý seçilmemiþse
call writeDec
bes:
mov dh,6
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,6
mov dl,36
call gotoxy
mov eax,TArray2[16] ;eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,6
mov dl,36
call gotoxy
mov eax,five
mov five,0

cmp boolean[16],0
jne alti
mov TArray[16],eax ;eðer sayý seçilmemiþse
call writeDec
alti:
mov dh,7
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,7
mov dl,36
call gotoxy
mov eax,TArray2[20] ;eðer sayý seçilmiþse o deðeri yazýlýyor
call writeDec
mov dh,7
mov dl,36
call gotoxy
mov eax,six
mov six,0

cmp boolean[20],0
jne bitir
mov TArray[20],eax ;eðer sayý seçilmemiþse
call writeDec
bitir:
ret
tablo ENDP
;-------------------------------------------Three of a kind
ThreeofaKind PROC
mov dh,20
mov dl,0
call gotoxy
mov ecx,4
mov esi,0
mov ebx,0
L1:
push ecx
mov eax,arr[esi]

L2:
;call dumpregs
cmp eax,arr[ebx+4] ;sayýlar ayný mý deðil mi kontrol ediliyor
;je say
jne bitir ;ayný deðilse bitir label'ýna gidiliyor
;say:
add topla3,1 ;ayný ise topla3 deðiþkenine 1 ekleniyor

bitir:
add ebx,4

loop L2

cmp topla3,2 ;eðer topla3 deðiþkeni 2 olduysa yaz3 label'ýna gidiliyor
je yaz3
mov topla3,0 ;deðilse deðiþken sýfýrlanýyor
pop ecx
add esi,4
mov ebx,esi

loop L1

jmp finall
yaz3: ;3 of kind ýn tabloda deðeri yazýlýyor
mov dh,8
mov dl,36
call gotoxy
mov esi,0
mov ecx,5
mov eax,0
L3:
add eax,arr[esi]

add esi,4
loop L3


cmp boolean[24],1 ;3 of a kind seçilmiþse atma label'ýna gidiliyor
je atma
mov TArray[24],eax ;seçilmemiþse tabloda deðeri yazýlýyor
call writeDec
pop ecx
jmp finall
atma: ;3 of a kind tablodaki deðerinin ayný kalmasý için 
mov dh,8
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,8
mov dl,36
call gotoxy
mov TArray[24],0
mov eax,TArray2[24]
call writeDec
pop ecx
finall:
mov topla3,0
ret
ThreeofaKind ENDP
;-----------------------------------------Four of a kind
FourofaKind PROC
mov ecx,4
mov esi,0
mov edi,0

L1:
push ecx
mov eax,arr[esi]
L2:

cmp eax,arr[edi+4] ;sayýlar ayný mý deðil mi kontrol ediliyor
;je say1
jne bitir ;ayný deðilse bitir label'ýna gidiliyor
;say1:
add topla4,1 ;ayný ise topla4 deðiþkenine 1 ekleniyor

bitir:
add edi,4
loop L2

cmp topla4,3 ;eðer topla4 deðiþkeni 3 olduysa yaz3 label'ýna gidiliyor
je yaz4
mov topla4,0 ;deðilse deðiþken sýfýrlanýyor
pop ecx
add esi,4
mov edi,esi
add ebx,1
loop L1


jmp finalll
yaz4: ;4 of kind ýn tabloda deðeri yazýlýyor
mov dh,9
mov dl,36
call gotoxy
mov esi,0
mov ecx,5
mov eax,0
L3:
add eax,arr[esi]
add esi,4
loop L3


cmp boolean[28],1 ;4 of a kind seçilmiþse atma label'ýna gidiliyor
je atma
mov TArray[28],eax ;seçilmemiþse tabloda deðeri yazýlýyor
call writeDec
pop ecx
jmp finalll
atma: ;4 of a kind tablodaki deðerinin ayný kalmasý için 
mov dh,9
mov dl,36
call gotoxy
mov edx,offset boss
call writeString
mov dh,9
mov dl,36
call gotoxy
mov TArray[28],0
mov eax,TArray2[28]
call writeDec
pop ecx
finalll:
mov topla4,0

ret
FourofaKind ENDP

;-------------------------------------Bubble sort
Bubble PROC ;Bubble sort yapýlýyor
mov dl,0
mov dh,21
call gotoxy
mov esi,0
mov ecx,5
L1:
mov eax,arr[esi]
mov arr2[esi],eax
add esi,4
loop L1
mov esi,0
L2:
mov eax,arr2[esi]
mov ebx,arr2[esi+4]
cmp eax,ebx
jg swap
jl cont
je cont

cont:
;mov arr2[esi],eax
add esi,4
cmp esi,16
je final
jl L2

swap:
mov eax,arr2[esi]
mov ebx,arr2[esi+4]
mov arr2[esi],ebx
mov arr2[esi+4],eax
mov esi,0
jmp L2
final:
mov esi,0
mov ecx,5

L3:
mov eax,arr2[esi]
;call writeDec
call crlf
add esi,4
loop L3
ret
Bubble ENDP
;-------------------------------------4 in a row
FourInaRow PROC
mov dl,0
mov dh,26
call gotoxy


mov esi,0
mov ecx,4
L1:
mov eax,arr2[esi]
mov ebx,arr2[esi+4]
sub ebx,eax
cmp ebx,1 ;sýralanmýþ zarlarýn ardýþýk iki zarý arsýndaki fark bir ise say deðiþkenine 1 ekleniyor
jne fin ;deðilse loop'un sonuna gidiliyor
add say,1

fin:
add esi,4
loop L1
bak:
cmp say,3 ;say deðiþkeni 3 ise tabloya yazdýrýlýyor
jne bitir
mov dl,36
mov dh,11
call gotoxy
mov eax,30

cmp boolean[36],1
je bitir
mov TArray[36],eax
call writeDec
jmp final
bitir:
mov dl,36
mov dh,11
call gotoxy
mov edx,offset boss
call writeString
mov dl,36
mov dh,11
call gotoxy
mov TArray[36],0
mov eax,TArray2[36]
call writeDec
mov dl,0
mov dh,20
call gotoxy
final:
mov say,0
ret
FourInaRow ENDP
;-----------------------------------5 in a row
FiveInaRow PROC
mov dl,0
mov dh,26
call gotoxy


mov esi,0
mov ecx,4
L1:
mov eax,arr2[esi]
mov ebx,arr2[esi+4]
sub ebx,eax
;call dumpregs
cmp ebx,1
jne fin
add say2,1


fin:
add esi,4
loop L1
bak:
cmp say2,4
jne bitir
mov dl,36
mov dh,12
call gotoxy
mov eax,40

cmp boolean[40],1
je bitir
mov TArray[40],eax
call writeDec
jmp final
bitir:
mov dl,36
mov dh,12
call gotoxy
mov edx,offset boss
call writeString
mov dl,36
mov dh,12
call gotoxy
mov TArray[40],0
mov eax,TArray2[40]
call writeDec
mov dl,0
mov dh,20
call gotoxy
final:
mov say2,0
ret
FiveInaRow ENDP
;---------------------------Yahtzee
Yahtzee PROC

mov esi,0
mov ecx,4
L1:
mov eax,arr2[esi]
mov ebx,arr2[esi+4]
cmp eax,ebx
jne bitir
inc yat
add esi,4
loop L1

cmp yat,4
jne bitir
mov dl,36
mov dh,10
call gotoxy
mov eax,50

cmp boolean[32],1
je bitir
mov TArray[32],eax
call writeDec
jmp son
bitir:
mov dl,36
mov dh,10
call gotoxy
mov edx,offset boss
call writeString
mov dl,36
mov dh,10
call gotoxy
mov eax,TArray2[32]
call writeDec
son:
mov yat,0
ret
Yahtzee ENDP
;---------------------------Anything
Anything PROC
mov esi,0
mov ecx,5
mov eax,0
L1:
add eax,arr[esi]
add esi,4
loop L1
mov dl,36
mov dh,13
call gotoxy

cmp boolean[44],1
je bitir
mov TArray[44],eax
call writeDec
bitir:
ret
Anything ENDP

;----------------------------------input alma
tekinput PROC
call randomize
call readInt
mov ecx,eax
mov dl,0
	mov dh,20
	call gotoxy
	mov edx,offset bos
	call writeString
	mov dl,0
	mov dh,20
	call gotoxy
	mov edx,offset string3
	call writeString
	mov dl,0
	mov dh,20
	call gotoxy
	mov edx,offset bos
	call writeString
	mov dl,0
	mov dh,20
	call gotoxy
don:
	call readInt

	cmp eax,1
    je birinci    
    cmp eax,2
	je ikinci
	cmp eax,3
	je ucuncu
	cmp eax,4
	je dorduncu
	cmp eax,5
	je besinci
	jne other
	birinci:
	mov eax,6
	call randomRange
	add eax,1
	mov dl,2
	mov dh,17
	call gotoxy
	mov arr[0],eax
	call writeDec
	jmp other
	ikinci:
	mov eax,6
	call randomRange
	add eax,1
	mov dl,8
	mov dh,17
	call gotoxy
	mov arr[4],eax
	call writeDec
	jmp other
	ucuncu:
	mov eax,6
	call randomRange
	add eax,1
	mov dl,14
	mov dh,17
	call gotoxy
	mov arr[8],eax
	call writeDec
	jmp other
	dorduncu:
	mov eax,6
	call randomRange
	add eax,1
	mov dl,20
	mov dh,17
	call gotoxy
	mov arr[12],eax
	call writeDec
	jmp other
	besinci:
	mov eax,6
	call randomRange
	add eax,1
	mov dl,26
	mov dh,17
	call gotoxy
	mov arr[16],eax
	call writeDec
	other:
	mov dl,0
	mov dh,20
	call gotoxy
	mov edx,offset bos
	call writeString
	mov dl,0
	mov dh,20
	call gotoxy
	dec ecx
	cmp ecx,0
	je final
	jne don
	
	final:
	
ret
tekinput ENDP

;----------------------------------------------tablodan seçim yapma
tablosec PROC
call readInt
cmp eax,1
je y1
cmp eax,2
je y2
cmp eax,3
je y3
cmp eax,4
je y4
cmp eax,5
je y5
cmp eax,6
je y6
cmp eax,7
je y7
cmp eax,8
je y8
cmp eax,9
je y9
cmp eax,10
je y10
cmp eax,11
je y11
cmp eax,12
je y12
jne bitir
y1:

cmp boolean[0],0
jne bitir
mov eax,TArray[0]
mov TArray2[0],eax
mov boolean[0],1
add oniki,1
jmp yazdir
y2:

cmp boolean[4],0
jne bitir
mov eax,TArray[4]
mov TArray2[4],eax
mov boolean[4],1
add oniki,1
jmp yazdir
y3:

cmp boolean[8],0
jne bitir
mov eax,TArray[8]
mov TArray2[8],eax
mov boolean[8],1
add oniki,1
jmp yazdir
y4:

cmp boolean[12],0
jne bitir
mov eax,TArray[12]
mov TArray2[12],eax
mov boolean[12],1
add oniki,1
jmp yazdir
y5:

cmp boolean[16],0
jne bitir
mov eax,TArray[16]
mov TArray2[16],eax
mov boolean[16],1
add oniki,1
jmp yazdir
y6:

cmp boolean[20],0
jne bitir
mov eax,TArray[20]
mov TArray2[20],eax
mov boolean[20],1
add oniki,1
jmp yazdir
y7:

cmp boolean[24],0
jne bitir
mov eax,TArray[24]
mov TArray2[24],eax
mov boolean[24],1
add oniki,1
jmp yazdir
y8:

cmp boolean[28],0
jne bitir
mov eax,TArray[28]
mov TArray2[28],eax
mov boolean[28],1
add oniki,1
jmp yazdir
y9:

cmp boolean[32],0
jne bitir
mov eax,TArray[32]
mov TArray2[32],eax
mov boolean[32],1
add oniki,1
jmp yazdir
y10:

cmp boolean[36],0
jne bitir
mov eax,TArray[36]
mov TArray2[36],eax
mov boolean[36],1
add oniki,1
jmp yazdir
y11:

cmp boolean[40],0
jne bitir
mov eax,TArray[40]
mov TArray2[40],eax
mov boolean[40],1
add oniki,1
jmp yazdir
y12:

cmp boolean[44],0
jne bitir
mov eax,TArray[44]
mov TArray2[44],eax
mov boolean[44],1
add oniki,1
yazdir:
mov ecx,lengthof TArray2

mov dl,36
mov dh,2
mov esi,0
L1:
push edx
call gotoxy

mov edx, offset boss
call writeString
pop edx
call gotoxy
mov eax,TArray2[esi]
call writeDec
add dh,1
add esi,4
loop L1
mov dl,0
mov dh,20
call gotoxy
bitir:

ret
tablosec ENDP
arrayyaz PROC
mov dl,0
mov dh,30
call gotoxy
mov esi,0
mov ecx,12
l1:
mov eax,TArray[esi]
call writeDec
add esi,4
loop l1
ret
arrayyaz ENDP

END main