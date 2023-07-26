INCLUDE IRVINE32.inc

.data

; ****** Strings of messages to display ********

msg1	 BYTE 0AH
		 BYTE	"	--------------------------------------------", 0dh, 0ah
		 BYTE	"	--  WELCOME TO LIBRARY MANAGEMENT SYSTEM  --", 0dh, 0ah
		 BYTE	"	--------------------------------------------", 0dh, 0ah, 0ah
		 BYTE	"	1-> Register a Member", 0dh, 0ah
		 BYTE	"	2-> View Members", 0dh, 0ah
		 BYTE	"	3-> Add Book", 0dh, 0ah
		 BYTE	"	4-> View Books", 0dh, 0ah
		 BYTE	"	5-> Exit Program", 0dh, 0ah
		 BYTE	"	Choose Your Option : ", 0
REG_MSG	 BYTE "	Enter Member's Name to register: ",0
VIEW_MEMBERS_MSG BYTE 0Ah,"	Viewing Registered Members: ",0AH, 0DH, 0
ADD_MSG			 BYTE "	Enter Book Name & Author Name to Add: ", 0dh, 0ah,
			 "	Separated By Comma:",0
VIEW_BOOKS_MSG BYTE 0Ah, "	Viewing Books in Library: ",  0dh, 0ah, 0
EXIT_MSG	   BYTE 0AH,
				    "	----------------- ",0dh, 0ah,
				    "	 Exiting Program ",0dh, 0ah,
					"	-----------------", 0
					
					
; variables 

REGISTER	 DWORD 1
VIEW_MEMBERS DWORD 2
ADD_BOOK	 DWORD 3
VIEW_BOOKS	 DWORD 4
EXITP		 DWORD 5	

MEMBER_SIZE = 50
MEMBER1 DB MEMBER_SIZE DUP (?)
MEMBER2 DB MEMBER_SIZE DUP (?)
MEMBER3 DB MEMBER_SIZE DUP (?)
MEMBER4 DB MEMBER_SIZE DUP (?)
MEMBER5 DB MEMBER_SIZE DUP (?)
MEMBER6 DB MEMBER_SIZE DUP (?)
NUM_MEMBERS DWORD 0
MEMBERS DD MEMBER1, MEMBER2, MEMBER3, MEMBER4, MEMBER5, MEMBER6, 0AH, 0DH, 0

BOOK_SIZE = 50
BOOK1 DB BOOK_SIZE DUP (?)
BOOK2 DB BOOK_SIZE DUP (?)
BOOK3 DB BOOK_SIZE DUP (?)
BOOK4 DB BOOK_SIZE DUP (?)
BOOK5 DB BOOK_SIZE DUP (?)
BOOK6 DB BOOK_SIZE DUP (?)
NUM_BOOKS DWORD 0
BOOKS DD BOOK1, BOOK2, BOOK3, BOOK4, BOOK5, BOOK6, 0AH, 0DH, 0


; *************** Code Section *****************

.code
MSG_DISPLAY proto, var: PTR DWORD
STRING_INPUT proto, var1: PTR DWORD
main PROC
	START:
	INVOKE MSG_DISPLAY,addr MSG1
	CALL READINT	; input for options
	
	CMP EAX, REGISTER
	JE REG_M		; jump to Register Member section

	CMP EAX, VIEW_MEMBERS
	JE VIEW_M		; jump to View Members section

	CMP EAX, ADD_BOOK
	JE ADD_B		; jump to View Books section

	CMP EAX, VIEW_BOOKS
	JE VIEW_B		; calling function to display message
		JMP EXIT_MENU

;----------------------------------------
;------------REGISTER MEMBERS------------
;----------------------------------------

	REG_M:
		INVOKE MSG_DISPLAY, ADDR REG_MSG

	MOV ESI, OFFSET MEMBERS
	MOV EAX, MEMBER_SIZE
	ADD ESI, EAX
	MOV EDX, ESI
	MOV ECX, MEMBER_SIZE
	CALL READSTRING
	INC NUM_MEMBERS

		JMP START

;--------------------------------------
;--------------VIEW MEMBERS------------
;--------------------------------------

	VIEW_M:
		INVOKE MSG_DISPLAY, ADDR VIEW_MEMBERS_MSG
	MOV ECX, NUM_MEMBERS
	cmp ECX, 0
	JE START
	MOV EBX, 0
OUTPUT:
	MOV ESI, OFFSET MEMBERS
	MOV EAX, MEMBER_SIZE
	ADD ESI, Eax
	MOV EDX, ESI
	CALL WRITESTRING
	INC EBX
	CALL CRLF
LOOP OUTPUT
		JMP START

;------------------------------------
;--------------ADD BOOKS-------------
;------------------------------------
	ADD_B:

	INVOKE MSG_DISPLAY, ADDR ADD_MSG
	MOV ESI, OFFSET BOOKS
	MOV EAX, BOOK_SIZE
	ADD ESI, EAX
	MOV EDX, ESI
	MOV ECX, BOOK_SIZE
	CALL READSTRING
	INC NUM_BOOKS
		
	JMP START
;------------------------------------
;-------------VIEW BOOKS-------------
;------------------------------------
	VIEW_B:
	
	INVOKE MSG_DISPLAY, ADDR VIEW_BOOKS_MSG
	MOV ECX, NUM_BOOKS
	cmp ECX, 0
	JE START
	MOV EBX, 0
OUTPUTB:
	MOV ESI, OFFSET BOOKS
	MOV EAX, BOOK_SIZE
	MUL EBX
	ADD ESI, Eax
	MOV EDX, ESI
	CALL WRITESTRING
	INC EBX
	CALL CRLF	
LOOP OUTPUTB
		
JMP START

;-------------------------------------------
;----------------EXIT MENU------------------
;-------------------------------------------
	EXIT_MENU:
		INVOKE MSG_DISPLAY, ADDR EXIT_MSG
	
	invoke ExitProcess,0
main endp

;-------------------------------------------
;--------FUNCTION TO DISPLAY A STRING-------
;-------------------------------------------
MSG_DISPLAY PROC USES EDX, VAR: ptr dword
	MOV EDX, VAR
	CALL WRITESTRING
	RET
	MSG_DISPLAY ENDP

STRING_INPUT PROC USES EDX ECX, var: ptr dword
		
	MOV EDX, VAR
	MOV ECX, 5000
	CALL READSTRING
	RET
	STRING_INPUT ENDP

end main