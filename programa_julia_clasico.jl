#!/usr/bin/env julia
# coding: utf-8
#$ julia code.jl

################################## LIBRERIAS QUE SE USAN #################################################


using Graphs
using LinearAlgebra
using SimpleGraphs
using Plots
using DataFrames
using CSVFiles
using GraphPlot
using LaTeXStrings
using Random 


################################### PARAMETROS QUE USA EL MODELO, N: NUMERO DE NODOS
#                                       k: No. DE VECINOS, p: PROBA DE ENLACE ################################################


#Se llama a la variable N como el primer argumento 
# N es el numero de nodos 
N=parse(Int64,ARGS[1]) 
#Se llama a la variable k como el segundo argumento 
# k es el numero de vecinos 
k=parse(Int64,ARGS[2])
#Se llama a la variable p como el tercer argumento  
# p es la proba de enlaces
p=parse(Float64,ARGS[3]) 
#Se llama a la variable r como el cuarto argumento
# r es el número de corrida
r=parse(Int64,ARGS[4])
#Se llama a la variable s como el quinto argumento
# s es para definir una nueva semilla y enerar números aleatorios sin problema
s=parse(Int64,ARGS[5])
Random.seed!(s)


##################################### EIGENVECTORES ###############################################

function Eigen_vectors(eigen_vecs, eigen_values)
    """función que regresa los eigenvectores en una lista"""
    len = length(eigen_values)
    vectors = []
    for i in 1:len
        append!(vectors, [eigen_vecs[:,i]])
    end
    return vectors
end

###################################### PROBABILIDAD DE RETORNO #################################################


function PI0(eigen_values, N, t)
    """
    Función que calcula la probabilidad de retorno clásica
    """
    proba_retorno = 0
    for i in 1:N
        proba_retorno += exp(-eigen_values[i]*t)
    end
    return proba_retorno/N
end

######################################### PROBA DE RETORNO DEPENDIENTE DEL TIEMPO ##########################################


function PI0_t(T_0, T_final, incremento)
    """
    Función que calcula la probabilidad de retorno Π_0 para cualquier tiempo.
    para cualquier tiempo.
    T_0: Tiempo inicial. 
    T_final: Tiempo final 
    incremento: Incremento en los pasos de tiempo. 
    """
    tiempo = []
    probas = []
    t = T_0
    while t<= T_final
        p_0 = real(PI0(eigen_values, N, t))
        append!(tiempo,t)
        append!(probas,p_0)
        t+= incremento
    end
    return tiempo, probas
end

############################################ RED DE MUNDO PEQUEÑO Y SU EIGENSISTEMA ASOCIADO ###############################################

#Red de mundo pequeño
G=watts_strogatz(N,k,p)

#Matriz laplaciana 
L = laplacian_matrix(G)
#Se transforma de una manera adecuada la matriz 
matriz_L = Matrix(L)

#Cálculo del eigensistema
eigen_values= eigvals(matriz_L)
eigen_vecs = eigvecs(matriz_L)

#Se llama a la función Eigen_vecs 
eigen_vectors = Eigen_vectors(eigen_vecs, eigen_values);

########################################## PROBA DE RETORNO DEPENDIENTE DEL TIEMPO #######################################################

#Se obtienen los tiempos que se utilizaron
tiempo = PI0_t(0, 100, 0.01)[1]
#Se hace el cálculo de la probabilidad de retorno
probas = PI0_t(0, 100, 0.01)[2];

########################################### SE GUARDAN LOS DATOS EN UN ARCHIVO .csv #################################################

#Se guardan los datos del tiempo y de la probabilidad de retorno en un DataFrame
data_python = DataFrame(
    Tiempo = tiempo,
    Probabilidades = probas
    )

#Este es el nombre del archivo
    #r: número de corrida
    #N: número de nodos
    #k: número de vecinos
    #p: probabilidad de enlace
x = "$r,$N,$k,$p"

#Se guardan los datos en un archivo de tipo .csv
save("$x.csv", data_python)

########################################### SE GRAFICA EL RESULTADO (opcional)  #################################################

# fig = plot(tiempo, probas,
#    title = "Probabilidad de Retorno con r=$r, N=$N, k=$k, p=$p",
#    legend=false,
#    size = (width = 700, height = 500),
#    ) 
# xlabel!(L"tiempo \ [t]")
# ylabel!(L"\pi_0(t)")

# savefig(fig, "$r,$N,$k,$p.png" )

