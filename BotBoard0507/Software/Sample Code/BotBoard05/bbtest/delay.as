	global	?a_DelayMs
	global	_DelayMs
	signat	_DelayMs,4216
	FNSIZE	_DelayMs,3,0
	processor	16F877A
	psect	text0,local,class=CODE,delta=2
	psect	text1,local,class=CODE,delta=2
	file	"C:\DOCUME~1\rglenn\LOCALS~1\Temp\_2HO.AAB"


	psect	text0
	file	"C:\bbtest\delay.c"
	line	12
_DelayMs
;	_cnt assigned to ?a_DelayMs+0
_DelayMs$cnt	set	?a_DelayMs
;	_i assigned to ?a_DelayMs+1
_DelayMs$i	set	?a_DelayMs+1
;	__dcnt assigned to ?a_DelayMs+2
_DelayMs$_dcnt	set	?a_DelayMs+2
	line	21
;_cnt stored from w
	clrf	3	;select bank 0
	movwf	?a_DelayMs
l4
	line	22
;delay.c: 20: unsigned char i;
;delay.c: 22: i = 4;
	movlw	4
	movwf	?a_DelayMs+1
	line	23
l7
	line	24
;delay.c: 23: do {
;delay.c: 24: { unsigned char _dcnt; _dcnt = (250)/((12*1000L)/(4*1000L))|1; while(--_dcnt != 0) continue; };
	movlw	83
	movwf	?a_DelayMs+2
l9
	decfsz	?a_DelayMs+2
	goto	l9
	line	25
;delay.c: 25: } while(--i);
	decfsz	?a_DelayMs+1
	goto	l7
	line	26
;delay.c: 26: } while(--cnt);
	decfsz	?a_DelayMs
	goto	l4
	return
