#! /bin/bash


# El valor que se hace variar es el número de vecinos, N.
# Se itera sobre los valores de las probabilidades de enlace, p. 

# 'reps' es el número de realizaciones que se quieren hacer, se pasa como tercer argumento en el programa: script_final.sh
reps=$3

# Se hace el cálculo de la probabilidad de retorno 100 veces, para cada valor de 'p' 
# por lo tanto, se ejecuta un bucle 'for' para repetir el proceso.
for r in $(seq 1 $reps)
#Es equivalente a: for r in {1..N}
do
	#Valores de la probabilidad de enlace
	for p in 0.0001 0.00025 0.0005 0.00075 0.001 0.0025 0.005 0.0075 0.01 0.025 0.05 0.075 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0
	do
		# Se está tomando un valor aleatorio (entero) para que se tome como semilla
		s=$RANDOM
		echo "ejecución" $r
		echo "proba" $p
		# Se almacena el tiempo de ejecución de cada ejecución en una bitácora para monitorearla
  		#En este apartado se ejecuta el script que calcula la probabilidad de retorno (cuántica)
		{ time julia programa_julia_final.jl $1 $2 $p $r $s; } 2>> bitacora$1
		echo "-------------------"
		# Se guardan los archivos en carpetas 
		mkdir $p
		mv *$p.csv* $p
	done
done
