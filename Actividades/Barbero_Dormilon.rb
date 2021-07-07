####     CLASE PARA ALMACENAR DATOS DEL CLIENTE
class Cliente
    attr_accessor :nombre, :hora_llegada, :hora_salida, :hora_atendido
    attr_accessor :tiempo_corte, :numero_silla
    def initialize(numero_cliente)
        @nombre = "Cliente_#{numero_cliente.to_s}"
        @tiempo_corte = Random.rand(1...30)
        @hora_llegada = Random.rand(1...30)
    end
    def to_string()
        print "\n--------------------\nNombre: #{@nombre}\nHora de llegada: #{@hora_llegada}\n"
        print "Hora de atencion: #{@hora_atendido}\nDuracion del corte: #{@tiempo_corte}\nHora de salida: #{@hora_salida}\n"
        print "Numero de silla: #{@numero_silla}\n--------------------\n"
    end
end

######################################## variables de control #########################################################
tiempo = 0                          # Simula minutos
contador_atendidos = 0              # Lleva la cuenta para cerrar el ciclo while
sillas_espera_3 = [-1 ,-1, -1]      # Arreglo de simulacion de sillas, almacena el index del elemento que esta sentado
silla_siguiente = 0                 # Indica el numero de la silla siguiente en caso de haber cola
barbero = true                      # Es una bandera solamente         
arreglo_clientes = []               # Almacena el conjunto de clientes desordenado 
cliente_en_atencion = -1            # Indica el index del elemento al que se le esta cortando el cabello
orden_atencion = []                 # Arreglo de elementos ordenados cuando ya fueron atendidos
cola = 0                            # Indica que tan larga es la cola de espera
aux_primero = -1                    # Variable auxiliar para cuando no hay cola y el barbero esta dormido

###################    Pedimos la candidad de clientes que se van a generar
print "Ingrese el numero de clientes a generar: "
clientes = gets

##################     Inicializa el arreglo de clientes
for i in 1..clientes.to_i do
    arreglo_clientes.push(Cliente.new(i))
end

################    Ciclo while que continua hasta que sean atendidos todos los clientes
while  contador_atendidos < clientes.to_i 
    i = 0                                               ### Index del cliente
    arreglo_clientes.each do |elemento|                 # Recorremos el arreglo desordenado de clientes 
        if elemento.hora_llegada == tiempo              # Si el cliente llego en esta fraccion de tiempo se le asigna un lugar 
            if cola == 0 && barbero && aux_primero == -1 # Este caso es cuando no hay fila y el barbero esta dormido esta segunda ->
                                                        # -> condicion valida que si dos llegan en la misma fraccion de tiempo, ->
                                                        # -> se atienda al primero dentro del arreglo y el segundo entre a una silla
                aux_primero = i + 1                     # Asignamos el index del elemento 
                elemento.numero_silla = "Entro directo por que no habia fila"       # Guardamos como entro y como lo atendieron
                print "\n**  Tiempo: #{tiempo.to_i}, Llega #{elemento.nombre}, Entrara directo por que no hay fila\n" # Mostramos en pantalla lo que esta pasando
            elsif sillas_espera_3[0] == -1              # Este caso es cuando el barbero esta atendiendo y no hay cola, se sienta en la primer silla
                elemento.numero_silla = 1               # Guardamos como entro y donde se sento
                cola += 1                               # Aumenta el tamaño de la cola
                sillas_espera_3[0] = i + 1              # En el arreglo de sillas indicamos el index del cliente que se sento
                print "\n**  Tiempo: #{tiempo.to_i}, Llega #{elemento.nombre} y Se sienta en silla 1\n"      # Mostramos en pantalla lo que esta pasando
            elsif sillas_espera_3[1] == -1              # Este caso es cuando el barbero esta atendiendo y hay cola de 1, se sienta en la segunda silla
                elemento.numero_silla = 2               # Guardamos como entro y donde se sento
                cola += 1                               # Aumenta el tamaño de la cola
                sillas_espera_3[1] = i + 1              # En el arreglo de sillas indicamos el index del cliente que se sento
                print "\n** Tiempo: #{tiempo.to_i}, Llega #{elemento.nombre} y Se sienta en silla 2\n"      # Mostramos en pantalla lo que esta pasando
            elsif sillas_espera_3[2] == -1              # Este caso es cuando el barbero esta atendiendo y hay cola de 2, se sienta en la tercer silla
                elemento.numero_silla = 3               # Guardamos como entro y donde se sento
                cola += 1                               # Aumenta el tamaño de la cola
                sillas_espera_3[2] = i + 1              # En el arreglo de sillas indicamos el index del cliente que se sento  
                print "\n** Tiempo: #{tiempo.to_i}, Llega #{elemento.nombre} y Se sienta en silla 3\n" # Mostramos en pantalla lo que esta pasando
            else                                        # Este caso es cuando el barbero esta ocupado y las sillas estan ocupadas
                elemento.hora_llegada = Random.rand(tiempo+1...tiempo+40)     #Le asignamos otra hora de llegada desde el momento actual + 1 hasta 40 fracciones mas
                print "\n** Tiempo: #{tiempo.to_i}, Llega #{elemento.nombre} Pero! no hay sillas disponibles... *c va*\n" # Mostramos en pantalla lo que esta pasando
            end
        end
        i += 1                                          # Aumenta el index para ver en cual va
    end 
    if barbero && (cola > 0 || aux_primero != -1)           # Si el barbero esta libre y hay cola o solo llega un cliente entra
        barbero = !barbero                                  # Barbero cambia de estado libre a ocupado
        if aux_primero != -1                                # Si es un cliente que llega directo al no haber cola
            cliente_en_atencion = aux_primero               # Asignamos el cliente que se esta atendiendo
            aux_primero = -1                                # Liberamos variable que indica que es unico cliente
        else                                                # Si es un cliente de cola
            j = 0                                           # Bloque auxiliar por si en el ultimo cliente no esta en la silla que continua
            if contador_atendidos == clientes.to_i - 1      # Verifica que sea solo uno el que falte
                sillas_espera_3.each do |elemento|          # Recorremos las sillas
                    if elemento != -1                       # Si la silla no esta vacia
                        silla_siguiente = j                 # Indicamos en que silla esta
                    end
                    j +=1                                   #Variable de control para recorrer las sillas
                end
            end
            cliente_en_atencion = sillas_espera_3[silla_siguiente]      # Asignamos el cliente que sera atendido, segun su turno
            sillas_espera_3[silla_siguiente] = -1                       # Liberamos la silla del cliente que acaba de ser atendido
            if cola > 0                                                 # Si la cola es mayor a 0 
                cola -= 1                                               # Decrementamos el tamaño de la cola
            end
            if sillas_espera_3[silla_siguiente + 1] != -1       # Si la silla silla que sigue esta ocupada 
                silla_siguiente == 2 ? silla_siguiente = 0 : silla_siguiente += 1   # Sera el siguiente en ser atendido
                # La silla que sigue es la ultima ? si, entonces la silla que sigue es 0(Volvemos a reccorer las sillas), si no, avanzamos
            end
        end
        index = 1               # Variable para buscar el elemento que sera atendido
        print "\n<< Sera atendido "       # Mostramos en pantalla lo que esta pasando
        arreglo_clientes.each do |elemento|             # Recorremos el arreglo de clientes desordenado
            if cliente_en_atencion == index             # Si es el index del elemento que sera atendido
                elemento.hora_atendido = tiempo         # Guardamos la hora en la que fue atendido             
                orden_atencion.push(elemento)           # Guardamos el elemento en un arreglo ordenado segun su hora de atencion
                print "#{elemento.nombre}, hora de atencion: #{tiempo}\n "   # Mostramos en pantalla el elemento que va a entrar
            end
            index += 1              # Aumentamos el valor del index
        end
    else                        # Si el barbero no esta disponible verifica si ya acabo
        index = 1               # Variable para buscar el elemento que sera atendido
        arreglo_clientes.each do |elemento|
            if cliente_en_atencion == index             # Recorremos el arreglo de clientes desordenado
                if tiempo == elemento.tiempo_corte + elemento.hora_atendido     # Si ya se cumplio el tiempo del corte indicamos la salida
                    barbero = !barbero                  # Barbero cambia de estado a disponible
                    elemento.hora_salida = tiempo       # Guardamos en el elemento la hora en la que salio
                    contador_atendidos += 1             # Aumenta el contador de clientes atendidos
                    print "\n>> Sale cliente: #{elemento.nombre}, hora de salida = #{tiempo}" # Mostramos en pantalla lo que esta pasando
                    if cola > 0
                        print ", silla siguiente: #{silla_siguiente + 1}\n"
                    end
                end
            end
            index += 1              # Aumentamos el valor del index
        end
    end
    tiempo += 1             # El tiempo aumenta en 1
end
puts "\n\n\nTodos los clientes han sido atendidos\n"
print "\n*********** orden de atencion *****************\n" ##  Mostramos en pantalla el orden en el que se atendieron los clientes
orden_atencion.each do |elemento|
    elemento.to_string
end
print "\n***********************************************\n"