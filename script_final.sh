#! /bin/bash

for N in 100
do
	echo $N "nodos"
	#$N denota el número de nodos que tiene la red.
	#El segundo valor es el número de vecinos de cada nodo
	#El último valor es el número de corridas (repeticones) que se quieren hacer
	#En este ejemplo particular:
		#N = 100
		#k = 6
		#r = 100
 	./repeticiones_final.sh $N 6 100 >> bitacora$N 
	#Las siguientes lineas son para guardar los resultados en un directorio propio
	mkdir Resultados_k_2_$N 
	#mv *.csv Resultados_$N
	#mv *.png Resultados_$N
	mv bitacora$N Resultados_$N
done

