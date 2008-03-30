	global	_DelayMs
	signat	_DelayMs,4216
	global	_main
	signat	_main,88
	FNCALL	_main,_DelayMs
	global	start
	processor	16F877A
	psect	text0,local,class=CODE,delta=2
	psect	text1,local,class=CODE,delta=2
	file	"C:\DOCUME~1\rglenn\LOCALS~1\Temp\_2GK.AAB"


	psect	text0
	file	"C:\bbtest\delaytest.c"
	line	6
_main
	line	7
;delaytest.c: 7: DelayMs(250);
	movlw	-6
	call	_DelayMs
	line	8
;delaytest.c: 8: DelayMs(250);
	movlw	-6
	call	_DelayMs
	line	9
;delaytest.c: 9: }
	ljmp	start
