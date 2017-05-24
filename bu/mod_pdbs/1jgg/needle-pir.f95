program pirer
implicit none

integer, parameter :: ikind=selected_real_kind(p=6)! p= 6, 15 o 18 (nro de figuras)
integer, parameter :: jkind=selected_real_kind(p=15)! p= 6, 15 o 18 (nro de figuras)
character*20 infile, outfile, seq1, seq2, test, seq1pir
character*80  string1(100), string2(100), fasta(100), line1, line2, last, line
integer i, j, k, n, m, t, fe, cont, ierr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! este codigo agarra la salida del clustal con el alinamiento entre 2 seq.s 'seq' (template, seq1) 
! y 'struct' (target, seq2) y lo pone en formato pir. Las identificaciones, "seq1" y "seq2", tienen
! q ser de 6 caracteres max (ej 1NH4_A). Sino, sale feo.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

n=0
m=0
i=0
j=0
k=0
cont=0
call getarg (1, infile)! nombre del archivo de alineamiento salido del needle
call getarg (2, outfile)! nombre del archivo de alineamiento en PIR 
call getarg (3, seq1)! nombre de la 1era secuencia, ej: 1XKK_A
call getarg (4, seq2)! nombre de la 2da secuencia, canonical
call getarg (5, seq1pir)! nombre de la 1era secuencia, pero con el ".pir", ej:1XKK_A.pir
open (11, file=infile)	
open (21, file=outfile)	
open (12, file=seq1pir)! aca esta la 2da linea del archivo de structure
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!! extrae del alineamiento !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
do
	n= n +1
	read (11, 91, iostat= ierr) fasta(n)
	if ( ierr/= 0 ) exit
enddo

do i=30, n, 1
		test= fasta(i)(1:10)
		if ( test == seq2 ) then
			j= j + 1
			string1(j)= fasta(i)(22:71)
		else if  ( test == seq1 ) then
			k= k + 1
			string2(k)= fasta(i)(22:71)
		endif
		do t=1, 79, 1
			if  (fasta(i)(t:t) == '.' ) then
				write(66,*)'error', i, t! aca veo los mismatchs. Se deben a las mutaciones q tiene la structura.pir respecto a la canonical.
			else if  (fasta(i)(t:t) == ':' ) then
				write(66,*)'error', i, t! idem
			endif
		enddo


enddo
!ya tiene las lineas de las 2 secuencias en string1 y string2, y sus nros de lineas en j y k, respectivamente.
close(11)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!escribe target (struct)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
line1='>P1;'
line1(5:13)=seq1
read(12,91) line2
read(12,91) line2! leo 2 veces pq en la 2da linea está lo q quiero leer

write(21,91) line1
write(21,91) line2
do i=1, k, 1

	if ( i == k ) then
	do t=1, 80, 1
		if ( string2(i)(t:t) == ' ' ) then
			string2(i)(t:t)='*'
			exit
		endif
	enddo
		write(21,91) string2(i)
	else
		write(21,91) string2(i)
	endif

enddo

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!! escribe template (seq) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
line1='>P1;'
line1(5:10)=seq1
line1(11:15)='_full'
line2='sequence:::::::::'

write(21,91) ' '!pone blank line entre secuencia y secuencia
write(21,91) line1
write(21,91) line2
do i=1, j, 1

	if ( i == j ) then
	do t=1, 80, 1
		if ( string1(i)(t:t) == ' ' ) then
			string1(i)(t:t)='*'
			exit
		endif
	enddo
		write(21,91) string1(i)
	else
		write(21,91) string1(i)
	endif

enddo

close(21)
91	format(1a80)
92	format(1a10)
93	format(2a80)

end program pirer 


