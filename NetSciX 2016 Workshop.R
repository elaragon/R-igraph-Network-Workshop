
##======================================================##
##                                                      ##
##    Network analysis con R y igraph                   ##
##                                                      ##
##    Tutorial traducido y adaptado de                  ##
##    Katya Ognyanova (www.kateto.net)                  ##
##                                                      ##
##======================================================##


# Tabla de contenidos
# 1. Recordatorio de R
# 2. Redes en igraph
# 3. Leyendo redes desde fichero
# 4. Convirtiendo redes en objetos igraph
# 5. Mostrando redes con igraph
# 6. Métricas de redes y nodos
# 7. Distancias y caminos
# 8. Detección de comunidades
# 9. Asortatividad y homofilia


# Instala el paquete "igraph" si no tienes su última versión (1.0.1) 
# El paquete (www.igraph.org) está gestionado por Gabor Csardi y Tamas Nepusz.

install.packages("igraph") 


# ================ 1. Recordatorio de R ================


# Puedes asignar un valor a un variables usando "<-", "=", o assign()

x <- 3         # Asignación
x              # Evalúa la expresión y muestra el resultado

y <- 4         # Asignación
y + 5          # Evaluación, y sigue valiendo 4

z <- x + 17*y  # Asignación
z              # Evaluación

rm(z)          # Elimina z: destruye el objeto
z              # Error!


#  ------->> Comparación de valores: --------

# Las comparaciones devuelven valores booleanos: TRUE, FALSE (se suele abreviar como T, F)
 
2==2  # Igualdad
2!=2  # Desigualdad
x <= y # Menor o igual: "<", ">", and ">=" también son válidas


#  ------->> Constantes especiales -------- 

# NA, NULL, Inf, -Inf, NaN

# NA (Not Available)
5 + NA      # Cuando se emplea en una expresión el resultado suele ser NA
is.na(5+NA) # Comprobación

# NULL
10 + NULL     # Su uso devuelve un objeto vacío (longitud cero)
is.null(NULL) # Comprobación

# Inf -Inf  (infinito positivo y negativo) en operaciones mátemáticas (e.g. divisiones por cero)
5/0
is.finite(5/0) # Comprobación

# NaN (Not a Number)
0/0
is.nan(0/0)


#  ------->> Vectores (aka. Componentes) --------  

v1 <- c(1, 5, 11, 33)       # Vector numérico, longitud 4
v2 <- c("hello","world")    # Vector de caracteres, longitud 2 (vector de strings)
v3 <- c(TRUE, TRUE, FALSE)  # Vector de booleano, igual a c(T, T, F)

# La combinación de elementos de diferente tipo en un mismo vector
# obligará a convertir los elementos al tipo menos restrictivo

v4 <- c(v1,v2,v3,"boo") 	# Todos los elements se convierten en strings

# Otros formas de crear vectores:
v <- 1:7         # equivalente a c(1,2,3,4,5,6,7)  
v <- rep(0, 77)  # 77 ocurrencias del valor 0
v <- rep(1:3, times=2) # 2 ocurrencias de la secuencia 1,2,3
v <- rep(1:10, each=2) # la secuencia 1,2,3,4,5,6,7,8,9,10 repitiendo cada elemento
v <- seq(10,20,2) # los valores de 10 a 20 en saltos de 2

length(v)        # longitud del vector

v1 <- 1:5         # 1,2,3,4,5
v2 <- rep(1,5)    # 1,1,1,1,1 

# Operaciones a nivel de elemento:
v1 + v2      # Suma de elementos
v1 + 1       # Suma 1 a cada elemento
v1 * 2       # Multiplica cada elemento por 2
v1 + c(1,7)  # Error! Diferente longitud

# Operaciones matemáticas:
sum(v1)      # Suma
mean(v1)     # Promedio
sd(v1)       # Desviación estándar
cor(v1,v1*5) # Correlación

# Operaciones lógicas:
v1 > 2       # Compara cada elemento con 2 para devolver un vector de booleanos
v1==v2       # Compara los elemento de v1 y v2 para devolver un vector de booleanos
v1!=v2       # Compara los elemento de v1 y v2 para devolver un vector de booleanos
(v1>2) | (v2>0)   # | es el operador OR, devuelve un vector
(v1>2) & (v2>0)   # & es el operador AND, devuelve un vector.
(v1>2) || (v2>0)  # || es el operador OR, devuelve un valor (T si algún elemento es T)
(v1>2) && (v2>0)  # && es el operador AND, devuelve un valor (T si todos los elementos son T)

# Elementos en vectores
v1[3]             # tercer elemento de v1
v1[2:4]           # elementos 2, 3, 4 de v1
v1[c(1,3)]        # elementos 1 y 3 (los índices son un vector)
v1[c(T,T,F,F,F)]  # elementos 1 y 2 (los únicos que son T)
v1[v1>3]          # v1>3 es un vector lógico con T para los elementos >3

# IMPORTANTE: R indexa a partir de 1, mientras que python indexa a partir de 0

# Para añadir más elementos a un vector sólo hay que asignarles un valor
v1[6:10] <- 6:10

# También se puede modificar su longitud
length(v1) <- 15 # los últimos 5 elementos tienen valor NA


#  ------->> Factores --------

# Los factores sirven para almacenar categorías

ojo.col.v <- c("marrón", "verde", "marrón", "azul", "azul", "azul")         #vector
ojo.col.f <- factor(c("marrón", "verde", "marrón", "azul", "azul", "azul")) #factor
ojo.col.v
ojo.col.f

# R identifica los diferentes niveles del factor - e.g. los diferentes valores 
# Internamente los datos se almacenan como enteros (cada número corresponde a un nivel del factor)

levels(ojo.col.f)  # Niveles (valores únicos) del factor (categoría)

as.numeric(ojo.col.f)  # El factor como valores númericos: 1 es blue, 2 es brown, 3 es green
as.numeric(ojo.col.v)  # Error! El vector de caracteres no puede convertirse en números

as.character(ojo.col.f)  
as.character(ojo.col.v) 


#  ------->> Matrices & Arrays --------  

# Una matriz es un vector con dimensiones:
m <- rep(1, 20)   # Vector de 20 elementos con valor 1
dim(m) <- c(5,4)  # Conversión a matriz de dimensiones 5x4

# Matriz usando matrix():
m <- matrix(data=1, nrow=5, ncol=4)  # Equivalente a la anterior
m <- matrix(1,5,4) 			             # Equivalente a la anterior
dim(m)                               # Dimensiones

# Matriz combinando vectores:
m <- cbind(1:5, 5:1, 5:9)  # Como columnas
m <- rbind(1:5, 5:1, 5:9)  # Como filas (rows)

m <- matrix(1:10,10,10)

# Selección de elementos de una matriz: 
m[2,3]  # fila 2, columna 3
m[2,]   # Segunda fila
m[,2]   # Segunda columna
m[1:2,4:6] # Submatriz de filas 1,2 y columnas 4,5,6
m[-1,]     # Todas las filas excepto la primera

m[1,]==m[,1]  # Son equivalentes los elementos de la fila 1 y de la columna 1? 
m>3           # Matriz lógica: T para todos los elementos >3
m[m>3]        # Vector de elementos de m mayores de 3

t(m)          # Transposición
m <- t(m)     # Transposición y asignación
m %*% t(m)    # Multiplicación de matrices
m * m         # Multiplicación de elementos de la matriz

# Arrays: más de 2 dimensiones
# Se crean con la función array()
a <- array(data=1:18,dim=c(3,3,2)) # 3d con dimensiones 3x3x2
a <- array(1:18,c(3,3,2))          # Equivalente al anterior


#  ------->> Listas --------  

# Colecciones de objects (e.g. strings, vectores, matrices, otras listas, etc.)

l1 <- list(boo=v1,foo=v2,moo=v3,zoo="Animals!")  # Lista con 4 componentes
l2 <- list(v1,v2,v3,"Animals!")

l3 <- list()
l4 <- NULL

l1["boo"]      # Acceder a boo: Devuelve una lista
l1[["boo"]]    # Acceder a boo: Devuelve el vector numérico
l1[[1]]        # Devuelve el primer componente de la lista, equivalente al anterior
l1$boo         # Se puede acceder a los elementos con nombre usando el operador $ - equivalente a [[]]

# Añadir elementps a una list:
l3[[1]] <- 11 # Añadir un elemento a la lista vacía l3
l4[[3]] <- c(22, 23) # Añadir un vector como elemento 3 en la lista vacía l4 (los elementos 1 y 2 serán NULL)
l1[[5]] <- "More elements!" # Añadir un string como elemento 5 en la lista l1
l1[[8]] <- 1:11 # Añadir un vector como elemento 8 en la lista l1  (los elementos 6 y 7 serán NULL)
l1$Something <- "A thing"  # Añadir un elemento 9 llamado "Something"


#  ------->> Data Frames --------  

# Los data frames son un tipo especial de lista para almacenar datasets tabulares
# Filas como observaciones y columnas con variables (cada columna es un vector o factor)

# Creación de un data frame:

dfr1 <- data.frame( ID=1:4,
                    Nombre=c("Juan","Jaime","Jana","Julia"),
                    Mujer=c(F,F,T,T), 
                    Edad=c(22,33,44,55) )

dfr1$Nombre   # Acceder a la segunda columna de dfr1. 
# IMPORTANTE: R la considera categoría y la trata como un factor (no como un vector de strings)

# Se puede evitar indicando que trate Nombre como vector:
dfr1$Nombre <- as.vector(dfr1$Nombre)

# También, se puede indicar stringsAsFactors=FALSE
dfr2 <- data.frame(Nombre=c("Juan","Jaime","Jana","Julia"), stringsAsFactors=FALSE)
dfr2$Nombre   

# Acceder a los elementos del data frame
dfr1[1,]   # Primera fila
dfr1[,1]   # Primera columna
dfr1$Edad   # Columna Edad
dfr1[1:2,3:4] # Filas 1 y 2, columnas 3 y 4 - sexo y edad de Juan y Jaime
dfr1[c(1,3),] # Filas 1 y 3, todas las columnas

# Personas mayores de 30
dfr1[dfr1$Edad>30,2]

# Edad media de las mujeres
mean ( dfr1[dfr1$Mujer==TRUE,4] )



#  ------->> Control de Flujo --------

# if (condition) expr1 else expr2
x <- 5; y <- 10
if (x==0) y <- 0 else y <- y/x #  
y

# for (variable in sequence) expr
ASum <- 0; AProd <- 1
for (i in 1:x)  
{
  ASum <- ASum + i
  AProd <- AProd * i
}
ASum  # sum(1:x)
AProd # prod(1:x)

# while (condition) expr
while (x > 0) {print(x); x <- x-1;}

# repeat expr, use break to exit the loop
repeat { print(x); x <- x+1; if (x>10) break}



#  ------->> Gráficos y colores --------

# La mayoría de las funciones permiten colores con nombre o valores hex/rgb:
# x,y coordinadas; pch símbolo; cex tamaño símbolo; col color
# (más parámetros usando ?par)
plot(x=1:10, y=rep(5,10), pch=19, cex=5, col="dark red")
points(x=1:10, y=rep(6, 10), pch=19, cex=5, col="#557799")
points(x=1:10, y=rep(4, 10), pch=19, cex=5, col=rgb(.25, .5, .3))

# Aunque el rango de rgb es 0-1, se puede convertir al rango 0-255
rgb(10, 100, 100, maxColorValue=255) 

# El parámetro alpha (0-1) indica opacidad/transparencia
plot(x=1:5, y=rep(5,5), pch=19, cex=16, col=rgb(.25, .5, .3, alpha=.5), xlim=c(0,6))  

# Colores disponibles
colors()

# Azules disponibles
grep("blue", colors(), value=T)

# En muchas ocasiones se requieren colores que contrasten o degraden, i.e. paletas
pal1 <- heat.colors(5, alpha=1)   # 5 colores de la paleta heat (opaca)
pal2 <- rainbow(5, alpha=.5)      # 5 colores de la paleta rainbow (translúcida)
plot(x=1:10, y=1:10, pch=19, cex=10, col=pal1)
plot(x=10:1, y=1:10, pch=19, cex=10, col=pal2)

# También se pueden generar gradientes con colorRampPalette.
palf <- colorRampPalette(c("gray70", "red")) 
plot(x=10:1, y=1:10, pch=19, cex=10, col=palf(100)) 

# Para añadir transparencia `alpha=TRUE`
palf <- colorRampPalette(c(rgb(1,1,1, .2),rgb(.8,0,0, .7)), alpha=TRUE)
plot(x=10:1, y=1:10, pch=19, cex=10, col=palf(10)) 


#  ------->> Problemas frecuentes --------

# 1) R distingue Mayúsculas, e.g. "Jacobo" es diferente "jacobo", 
#    la función rowSums es diferente a rowsums" o "RowSums".
#
# 2) Objects class. Aunque muchas funciones admiten varios tipos, algunas requieren un vector de
# caracteres o un factor o una matriz o un data frame. Los resultados en ocasiones también
# pertenecen a formatos inesperados
#
# 3) Package namespaces. A veces diferentes paquetes tienen funciones con el mismo mobre.
# R suele avisar con algo como "The following object(s) are masked from 'package:igraph'"
# al cargar el paquete. En caso de conflicto, se pueden utilizar funciones específicas
# como paquete::funcion. Puede haber ocasiones en que no pueda resolverse, para lo que se
# recomienda desplegarlas (detach) cuando se dejen de usar

 library(igraph)          # load a package
 detach(package:igraph)   # detach a package

# Para cuestiones más avanzadas, consultar en try(), tryCatch(), debug()
?tryCatch



# ================ 2. Redes en igraph ================

rm(list = ls()) # Limpiar los objetos del entorno

library(igraph) # Cargar igraph


#  ------->> Generar redes --------

# Grafo no dirigido con aristas 1--2, 2--3, 3--1 (los números son IDs)
g1 <- graph( edges=c(1,2, 2,3, 3,1), n=3, directed=F ) 
plot(g1)
class(g1)
g1

# Grafo dirigido con 10 nodos y aristas 1-->2, 2-->3, 3-->1 (los números son IDs)
g2 <- graph( edges=c(1,2, 2,3, 3,1), n=10 )
plot(g2)   
g2

# Cuando se dan nombres a los nodos, no es necesario indicar el número de nodos
g3 <- graph( c("Juan", "Jaime", "Jaime", "Julia", "Julia", "Juan")) 
plot(g3)
g3

# Se pueden indicar qué nodos están aislados
g4 <- graph( c("Juan", "Jaime", "Jaime", "Jacobo", "Jaime", "Jacobo", "Juan", "Juan"), 
             isolates=c("Jose", "Janis", "Jennifer", "Justin") )  

# Las visualizaciones son parametrizables
plot(g4, edge.arrow.size=.5, vertex.color="gold", vertex.size=15, 
     vertex.frame.color="gray", vertex.label.color="black", 
     vertex.label.cex=1.5, vertex.label.dist=2, edge.curved=0.2) 


# Los grafos pequeños también pueden definirse:
# '-' para aristas no dirigidas, "+-' or "-+" para aristas dirigidas (izda,dcha)
# "++" para aristas recíprocas, and ":" para conjuntos de nodos
# Importante: el número de guiones no importa
plot(graph_from_literal(a---b, b---c)) 
plot(graph_from_literal(a--+b, b+--c))
plot(graph_from_literal(a+-+b, b+-+c)) 
plot(graph_from_literal(a:b:c---c:d:e))

gl <- graph_from_literal(a-b-c-d-e-f, a-g-h-b, h-e:f:i, j)
plot(gl)



#  ------->> Atributos de arista, nodo y red --------

# Acceder a los nodos y aristas
E(g4) # Aristas (Edges)
V(g4) # Nodos (Vertices)


# También se puede manipular directamente la matriz de adyacencia
g4[]
g4[1,]
g4[3,3] <- 1
g4[5,7] <- 1

# Añadir atributos
V(g4)$name # generado automáticamente
V(g4)$gender <- c("male", "male", "male", "male", "female", "female", "male")
E(g4)$type <- "email" 
E(g4)$weight <- 10    # peso de la arista

# Examinar atributos
edge_attr(g4)
vertex_attr(g4)
graph_attr(g4)

# Otra manera de fijar atributos
# (también con set_edge_attr(), set_vertex_attr(), etc.)
g4 <- set_graph_attr(g4, "name", "Email Network")
g4 <- set_graph_attr(g4, "something", "A thing")

graph_attr_names(g4)
graph_attr(g4, "name")
graph_attr(g4)

g4 <- delete_graph_attr(g4, "something")
graph_attr(g4)

plot(g4, edge.arrow.size=.5, vertex.label.color="black", vertex.label.dist=1.5,
     vertex.color=c( "pink", "skyblue")[1+(V(g4)$gender=="male")] ) 

# g4 tiene dos aristas de Jaime a Jacobo, y Juan tiene un bucle.
# Se puede simplicar usando 'edge.attr.comb' e indicando como 
# considerar los atributos: "sum", "mean", "prod" (product), min, max, first/last 
# La opción "ignore" lo descarta
g4s <- simplify( g4, remove.multiple = T, remove.loops = F, 
                 edge.attr.comb=list(weight="sum", type="ignore") )
plot(g4s, vertex.label.dist=1.5)
g4s

# Un objeto de igraph comienza por cuatro letras:
# 1. D o U, para indicar si es dirigido
# 2. N para grafos con nombre
# 3. W para grafos con pesos
# 4. B para grafos bipartitos (los nodos tienen atributo type)
#
# Los dos números siguientes son el númbero de nodos y aristas
# Para cada atributo se indica el alcance y el tipo, por ejemplo
# (g/c) - graph-level, caracter
# (v/c) - vertex-level, caracter
# (e/n) - edge-level, número


# ------->> Grafos específico y modelos  --------

# Grafo vacío
eg <- make_empty_graph(40)
plot(eg, vertex.size=10, vertex.label=NA)

# Grafo completo
fg <- make_full_graph(40)
plot(fg, vertex.size=10, vertex.label=NA)

# Grafo estrella
st <- make_star(40)
plot(st, vertex.size=10, vertex.label=NA) 

# Grafo árbol
tr <- make_tree(40, children = 3, mode = "undirected")
plot(tr, vertex.size=10, vertex.label=NA) 

# Grafo anillo
rn <- make_ring(40)
plot(rn, vertex.size=10, vertex.label=NA)

# Erdos-Renyi ('n' nodos, 'm' aristas)
er <- sample_gnm(n=100, m=40) 
plot(er, vertex.size=6, vertex.label=NA)  

# Watts-Strogatz small-world
# Crea un lattice de 'dim' dimensions con 'size' nodos cada uno, 
# y aristas con probabilidad 'p' (permite 'loops' y aristas 'multiple').
# El neighborhood en el que las aristas se conectan es 'nei'.
sw <- sample_smallworld(dim=2, size=10, nei=1, p=0.1)
plot(sw, vertex.size=6, vertex.label=NA, layout=layout_in_circle)
 
# Redes libres de escala (Barabasi-Albert preferential attachment)
# 'n' nodos, 'power' de attachment (1 es lineal)
# 'm' aristas añadidas en cada time step 
ba <-  sample_pa(n=100, power=1, m=1,  directed=F)
plot(ba, vertex.size=6, vertex.label=NA)
 
# Grafos históricos (e.g. Zachary carate club)
zach <- graph("Zachary") # the 
plot(zach, vertex.size=10, vertex.label=NA)
 
# Rewiring
# 'each_edge()' es un método de rewiring que cambia las terminaciones de las aristas
# de manera uniformemente aleatoria con probabilidad 'prob'.
rn.rewired <- rewire(rn, each_edge(prob=0.1))
plot(rn.rewired, vertex.size=10, vertex.label=NA)
 
# Rewire para conectar nodos a cierta distancia
rn.neigh = connect.neighborhood(rn, 5)
plot(rn.neigh, vertex.size=8, vertex.label=NA) 

# Combinación de grafos (unión disjunta asumiendo conjuntos de vértices separados): %du%
plot(rn, vertex.size=10, vertex.label=NA) 
plot(tr, vertex.size=10, vertex.label=NA) 
plot(rn %du% tr, vertex.size=10, vertex.label=NA) 

  
 
# ================ 3. Leyendo redes desde fichero ================

 
rm(list = ls()) # Limpiar los objetos del entorno

# Fijar el directorio de trabajo al actual
setwd(".")  
 
# DATASET 1: lista de aristas 

nodes <- read.csv("Dataset1-Media-Example-NODES.csv", header=T, as.is=T)
links <- read.csv("Dataset1-Media-Example-EDGES.csv", header=T, as.is=T)

# Examinar los datos
head(nodes)
head(links)
nrow(nodes); length(unique(nodes$id))
nrow(links); nrow(unique(links[,c("from", "to")]))

# Colapsar múltiples enlaces del mismo tipo entre dos nodos
# sumando sus pesos, usando aggregate() con "from", "to", "type"
# (no se usa "simplify()" para no colapsar enlaces de diferentes tipos)
links <- aggregate(links[,3], links[,-3], sum)
links <- links[order(links$from, links$to),]
colnames(links)[4] <- "weight"
rownames(links) <- NULL


# DATASET 2: matriz 

nodes2 <- read.csv("Dataset2-Media-User-Example-NODES.csv", header=T, as.is=T)
links2 <- read.csv("Dataset2-Media-User-Example-EDGES.csv", header=T, row.names=1)

# Examinar los datos
head(nodes2)
head(links2)

# links2 es una matriz de adyancencia para una red bipartita
links2 <- as.matrix(links2)
dim(links2)
dim(nodes2)


# ================ 4. Convirtiendo redes en objetos igraph ================ 
 
library(igraph)

#  ------->> DATASET 1 -------- 

# La función graph.data.frame function, emplea 2 data frames: 'd' y 'vertices'.
# 'd' describe las aristas de la red - debería comenzar con dos columnas indicando
# los IDs de los nodos source y target de cada aristas
# 'vertices' debería comenzar con la columna de ID.
# El resto de columnas se consideran atributos.
net <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 

# Examinar la red, nodos, aristas y atributos
class(net)
net 
E(net)
V(net)
E(net)$type
V(net)$media
plot(net, edge.arrow.size=.4,vertex.label=NA)

# Eliminar bucles
net <- simplify(net, remove.multiple = F, remove.loops = T) 

# La red se puede convertir a una lista de aristas o a una matriz de adyacencia
as_edgelist(net, names=T)
as_adjacency_matrix(net, attr="weight")

# La red se puede convertir data frames de nodos y aristas
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")


#  ------->> DATASET 2 --------

head(nodes2)
head(links2)
net2 <- graph_from_incidence_matrix(links2)

# Conteo de los valores del atributo 'type' en los nodos
table(V(net2)$type)

plot(net2,vertex.label=NA)

# Para transformar una matriz a un objecto igraph se usa graph_from_adjacency_matrix()

# También se pueden generar proyecciones bipartitas
# (los co-miembros se calculan multiplicando la matriz por su transpuesta)
net2.bp <- bipartite.projection(net2)

# También se pueden calcular las proyecciones manualmente
#   as_incidence_matrix(net2)  %*% t(as_incidence_matrix(net2))
# t(as_incidence_matrix(net2)) %*%   as_incidence_matrix(net2)
plot(net2.bp$proj1, vertex.label.color="black", vertex.label.dist=1,
     vertex.label=nodes2$media[!is.na(nodes2$media.type)])

plot(net2.bp$proj2, vertex.label.color="black", vertex.label.dist=1,
     vertex.label=nodes2$media[ is.na(nodes2$media.type)])


# ================ 5. Mostrando redes con igraph ================

 
#  ------->> Parámetros --------

# Empiezan con 'vertex.', 'edge.'. Lista completa en:
?igraph.plotting

# Las opciones pueden especificarse en plot
plot(net, edge.arrow.size=.4, edge.curved=.1)
plot(net, edge.arrow.size=.2, edge.curved=0,
     vertex.color="orange", vertex.frame.color="#555555",
     vertex.label=V(net)$media, vertex.label.color="black",
     vertex.label.cex=.7) 

# Las opciones también pueden añadirse la objeto
colrs <- c("gray50", "tomato", "gold")
V(net)$color <- colrs[V(net)$media.type]
V(net)$size <- V(net)$audience.size*0.7
V(net)$label.color <- "black"
V(net)$label <- NA # sin etiqueta
E(net)$width <- E(net)$weight/6
E(net)$arrow.size <- .2
E(net)$edge.color <- "gray80"
plot(net) 

# Las especificadas en plot sobreescriben a las del objeto
plot(net, edge.color="orange", vertex.color="gray50") 

# También se pueden añadir leyendas
plot(net) 
legend(x=-1.1, y=-1.1, c("Newspaper","Television", "Online News"), pch=21,
       col="#777777", pt.bg=colrs, pt.cex=2.5, bty="n", ncol=1)

# En algunas redes (e.g. semánticas) sólo se muestran las etiquetas a los nodos
plot(net, vertex.shape="none", vertex.label=V(net)$media, 
     vertex.label.font=2, vertex.label.color="gray40",
     vertex.label.cex=.7, edge.color="gray85")

# El color de las aristas puedes basarse en el nodo origen
edge.start <- ends(net, es=E(net), names=F)[,1]
edge.col <- V(net)$color[edge.start]
plot(net, edge.color=edge.col, edge.curved=.1)


#  ------->> Layouts --------

# Algoritmos para posicionar nodos

# Red de 80 nodos
net.bg <- sample_pa(80, 1.2) 
V(net.bg)$size <- 8
V(net.bg)$frame.color <- "white"
V(net.bg)$color <- "orange"
V(net.bg)$label <- "" 
E(net.bg)$arrow.mode <- 0
plot(net.bg)

# El layout se puede indicar en plot
plot(net.bg, layout=layout_randomly)

# O calcularse previamente
l <- layout_in_circle(net.bg)
plot(net.bg, layout=l)

# l es una matriz NxN con las coordinadas x,y de los nodos (puede modificarse)
l
l <- cbind(1:vcount(net.bg), c(1, vcount(net.bg):2))
plot(net.bg, layout=l)

# Layout Aleatorio
l <- layout_randomly(net.bg)
plot(net.bg, layout=l)

# Layout Circular
l <- layout_in_circle(net.bg)
plot(net.bg, layout=l)

# Layour Esfera 3D
l <- layout_on_sphere(net.bg)
plot(net.bg, layout=l)

# Layout Fruchterman-Reingold force-directed (lento para más de 1000 nodos)
l <- layout_with_fr(net.bg)
plot(net.bg, layout=l)

# El layout no es determinista (varía entre ejecuciones)
par(mfrow=c(2,2), mar=c(1,1,1,1))
plot(net.bg, layout=layout_with_fr)
plot(net.bg, layout=layout_with_fr)
plot(net.bg, layout=l)
plot(net.bg, layout=l)
dev.off()

# Por defecto, las coordenadas se reescalan en [-1,1] para x,y.
# Se puede cambiar con "rescale=FALSE" y multiplicando las coordenadas
# por un escalar. Se pueden usar norm_coords para normalizar el plot 
# con los límites.

# Coordenadas del layout
l <- layout_with_fr(net.bg)
# Normalizadas para que figuren en -1, 1
l <- norm_coords(l, ymin=-1, ymax=1, xmin=-1, xmax=1)
par(mfrow=c(2,2), mar=c(0,0,0,0))
plot(net.bg, rescale=F, layout=l*0.4)
plot(net.bg, rescale=F, layout=l*0.8)
plot(net.bg, rescale=F, layout=l*1.2)
plot(net.bg, rescale=F, layout=l*1.6)
dev.off()

# Layout Kamada Kawai
l <- layout_with_kk(net.bg)
plot(net.bg, layout=l)

# Layout LGL (grandes redes). Se puede especificar un nodo raíz (e.g árboles)
plot(net.bg, layout=layout_with_lgl)


# Se puede usar el layout layout_nicely que escoge 
# el más adecuado a las propiedades del grafo. 


# También, se pueden examinar todos los layouts
?igraph::layout_
layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1] 
# Eliminando los que no corresponden a la red en cuestión
layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama|tree", layouts)]
par(mfrow=c(3,3), mar=c(1,1,1,1))
for (layout in layouts) {
  print(layout)
  l <- do.call(layout, list(net)) 
  plot(net, edge.arrow.mode=0, layout=l, main=layout) }
dev.off()


-----------------------------------
# * TAREA

# Plot del Zachary karate club network con cuatro layouts diferentes

-----------------------------------

  

# ------->> Mejorando los plots --------

plot(net)

# Aunque se observa la red con el tipo/tamaño de los nodos, 
# pero no se aprecia bien la estructura por la densidad de aristas.
# Un enfoque consiste en separar la red eliminando aristas con 
# peso menor al promedio
hist(links$weight)
cut.off <- mean(links$weight) 
net.sp <- delete_edges(net, E(net)[weight<cut.off])
plot(net.sp) 

# Otra opción es partir la red según el tipo de enlace (hyperlik, mention)
E(net)$width <- 2
plot(net, edge.color=c("dark red", "slategrey")[(E(net)$type=="hyperlink")+1],
      vertex.color="gray40", layout=layout_in_circle)
net.m <- net - E(net)[E(net)$type=="hyperlink"]
net.h <- net - E(net)[E(net)$type=="mention"]
par(mfrow=c(1,2))
plot(net.h, vertex.color="orange", main="Tie: Hyperlink")
plot(net.m, vertex.color="lightsteelblue2", main="Tie: Mention")
dev.off()


# ------->> Plots interactivos with tkplot -------- 

# Para redes pequeñas
tkid <- tkplot(net) # id de tkplot
l <- tkplot.getcoords(tkid) # guardar las coordenadas de  tkplot
tk_close(tkid, window.close = T)
plot(net, layout=l)


# ------->> Heatmaps -------- 

# Basados en la matriz de adyacencia
netm <- get.adjacency(net, attr="weight", sparse=F)
colnames(netm) <- V(net)$media
rownames(netm) <- V(net)$media

palf <- colorRampPalette(c("gold", "dark orange")) 
heatmap(netm[,17:1], Rowv = NA, Colv = NA, col = palf(20), 
        scale="none", margins=c(10,10) )


# ------->> Mostrando redes bipartitas --------  

head(nodes2)
head(links2)
net2
plot(net2)

# Mostrar nodos según tipo
V(net2)$color <- c("steel blue", "orange")[V(net2)$type+1]
V(net2)$shape <- c("square", "circle")[V(net2)$type+1]
V(net2)$label <- ""
V(net2)$label[V(net2)$type==F] <- nodes2$media[V(net2)$type==F] 
V(net2)$label.cex=.6
V(net2)$label.font=2
plot(net2, vertex.label.color="white", vertex.size=(2-V(net2)$type)*8) 
plot(net2, vertex.label=NA, vertex.size=7, layout=layout_as_bipartite) 

# Nodos como texto
par(mar=c(0,0,0,0))
plot(net2, vertex.shape="none", vertex.label=nodes2$media,
     vertex.label.color=V(net2)$color, vertex.label.font=2, 
     vertex.label.cex=.95, edge.color="gray70",  edge.width=2)



# ================ 6. Métricas de redes y nodos ================

# Densidad
edge_density(net, loops=F)
ecount(net)/(vcount(net)*(vcount(net)-1)) # red dirigida

# Reciprocidad
reciprocity(net)
dyad_census(net) # Mutuos, no mutuos y nulos
2*dyad_census(net)$mut/ecount(net)

# Diámetro (por defecto se consideran los pesos)
diameter(net, directed=F, weights=NA)
diameter(net, directed=F)
diam <- get_diameter(net, directed=T)
diam
as.vector(diam)

# Colorear nodos del diámetro
vcol <- rep("gray40", vcount(net))
vcol[diam] <- "gold"
ecol <- rep("gray80", ecount(net))
ecol[E(net, path=diam)] <- "orange" 
plot(net, vertex.color=vcol, edge.color=ecol, edge.arrow.mode=0)

# Grado ('in','out','all','total')
deg <- degree(net, mode="all")
plot(net, vertex.size=deg*3)
hist(deg, breaks=1:vcount(net)-1, main="Histograma del grado")

# Degree distribution
deg.dist <- degree_distribution(net, cumulative=T, mode="all")
plot( x=0:max(deg), y=1-deg.dist, pch=19, cex=1.2, col="orange", 
      xlab="Degree", ylab="CDF")


# Centralidad de grado
degree(net, mode="in")
centr_degree(net, mode="in", normalized=T)

# Closeness
closeness(net, mode="all", weights=NA) 
centr_clo(net, mode="all", normalized=T) 

# Eigenvector
eigen_centrality(net, directed=T, weights=NA)
centr_eigen(net, directed=T, normalized=T) 

# Betweenness
betweenness(net, directed=T, weights=NA)
edge_betweenness(net, directed=T, weights=NA)
centr_betw(net, directed=T, normalized=T)



-----------------------------------
# * TAREA

# Calcular degree, closeness, eigenvector, and betweenness centrality de los 
# actors en la Zachary karate club network. Mostrar la red, usando tamaños 
# de nodo basados en las diferentes métricas de centralidad.

-----------------------------------

  
  

# HITS: Hubs y authorities
hs <- hub_score(net, weights=NA)$vector
as <- authority_score(net, weights=NA)$vector
par(mfrow=c(1,2))
plot(net, vertex.size=hs*50, main="Hubs")
plot(net, vertex.size=as*30, main="Authorities")

-----------------------------------
  
  
# K-core decomposition
kc <- coreness(net, mode="all")
plot(net, vertex.size=kc*6, vertex.label=kc, vertex.color=colrs[kc])


# ================ 7. Distancias y caminos ================


# Distancia promedio
mean_distance(net, directed=F)
mean_distance(net, directed=T)

# Matriz de distancias
distances(net) # con pesos
distances(net, weights=NA) # sin pesos

# Visualización de las distancias del nodo New York Times al resto de nodos
dist.from.NYT <- distances(net, 
                           v=V(net)[media=="NY Times"], 
                           to=V(net), 
                           weights=NA)
oranges <- colorRampPalette(c("dark red", "gold"))
col <- oranges(max(dist.from.NYT)+1)
col <- col[dist.from.NYT+1]
plot(net, vertex.color=col, vertex.label=dist.from.NYT, edge.arrow.size=.6, 
     vertex.label.color="white")

# Camino más corto entre MSNBC y the New York Post
news.path <- shortest_paths(net, 
                            from = V(net)[media=="MSNBC"], 
                             to  = V(net)[media=="New York Post"],
                             output = "both") # both path nodes and edges
ecol <- rep("gray80", ecount(net))
ecol[unlist(news.path$epath)] <- "orange"
ew <- rep(2, ecount(net))
ew[unlist(news.path$epath)] <- 4
vcol <- rep("gray40", vcount(net))
vcol[unlist(news.path$vpath)] <- "gold"
plot(net, vertex.color=vcol, edge.color=ecol, 
     edge.width=ew, edge.arrow.mode=0)

# Identificar las aristas del nodo WSJ.
inc.edges <- incident(net, 
                      V(net)[media=="Wall Street Journal"], 
                      mode="all")
ecol <- rep("gray80", ecount(net))
ecol[inc.edges] <- "orange"
vcol <- rep("grey40", vcount(net))
vcol[V(net)$media=="Wall Street Journal"] <- "gold"
plot(net, vertex.color=vcol, edge.color=ecol)
dev.off()


# ================ 8. Detección de comunidades ================

# Convertir 'net' a red no dirigida
net.sym <- as.undirected(net, mode="collapse", edge.attr.comb=list(weight="sum", "ignore"))

# Find cliques (complete subgraphs of an undirected graph)
cliques(net.sym) # lista de cliques       
sapply(cliques(net.sym), length) # tamaños de clique
largest_cliques(net.sym) # cliques con el mayor número de nodos
vcol <- rep("grey80", vcount(net.sym))
vcol[unlist(largest_cliques(net.sym))] <- "gold"
plot(net.sym, vertex.label=V(net.sym)$name, vertex.color=vcol)

# Edge betweenness (Newman-Girvan)
ceb <- cluster_edge_betweenness(net) 
dendPlot(ceb, mode="hclust")
plot(ceb, net) 
class(ceb)
length(ceb)     # número de comunidades
membership(ceb) # partición
crossing(ceb, net)   # vector lógico: T para aristas en comunidades
modularity(ceb) # modularidad

# Algorimo voraz basado en la optimización de la modularidad
cfg <- cluster_fast_greedy(as.undirected(net))
plot(cfg, as.undirected(net)) # hulls
V(net)$community <- cfg$membership
colrs <- adjustcolor( c("gray50", "tomato", "gold", "yellowgreen"), alpha=.6)
plot(net, vertex.color=colrs[V(net)$community]) # colores de nodo


-----------------------------------
# * TAREA

# Detectar cliques y aplicar los algoritmos de detección de comunidades
# en la Zachary karate club network. 


# ================ 9. Asortatividad y homofilia ================

# La tendencia de los nodos a conectar a nodos similares
# assortativity_nominal() para categorías (labels)
# assortativity() para números y categorías
# assortativity_degree() por el grado

V(net)$type.label
V(net)$media.type
assortativity_nominal(net, V(net)$media.type, directed=F)
assortativity(net, V(net)$audience.size, directed=F)
assortativity_degree(net, directed=F)
