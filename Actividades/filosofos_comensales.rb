######## Clases de control ################
class Filosofo 
    attr_accessor :nombre, :hora_llegada, :hora_inicio, :hora_salida, :tiempo_comida, :tenedor_izq, :tenedor_der, :estado
    def initialize(numero_filosofo)
        @nombre = numero_filosofo.to_i
        @tiempo_comida = Random.rand(1...10)
        @hora_llegada = Random.rand(1...50)
        @estado = 0
    end
    def to_string()
        print "\n\nNombre: Filosofo_#{@nombre}\nHora de llegada: #{@hora_llegada}\nHora de inicio: #{@hora_inicio}"
        print "\nHora de salida: #{@hora_salida}\nTiempo de comida: #{@tiempo_comida}"
    end
end

########## Variables de control ###########
tiempo = 0
contador_terminados = 0
filosofos_hambrientos = []
filosofos_atendidos = []
cola = []
tenedores = []       

print "Ingrese el número de filosofos: "
n_filosofos = gets

for i in 0 .. n_filosofos.to_i - 1 do ##### inicializacion de variables
    tenedores.push(-1)
    filosofos_hambrientos.push(Filosofo.new(i))
end
while contador_terminados < n_filosofos.to_i 
    i_filosofos = 0             ###### variable para llevar control del filosofo actual
    filosofos_hambrientos.each do |filosofo_hambriento| ### comprobamos horas de llegada
        if filosofo_hambriento.hora_llegada == tiempo && filosofo_hambriento.estado == 0 ##### si el filosofo acaba de llegar
            tenedores[i_filosofos] == -1 ? filosofo_hambriento.tenedor_izq = 0 : filosofo_hambriento.tenedor_izq = 1 ### verifica si el tenedor de su lado esta libre
            if i_filosofos == n_filosofos.to_i - 1.to_i ##### si el filosofo es el que esta al final buscara al inicio de la lista
                tenedores[0] == -1  ? filosofo_hambriento.tenedor_der = 0 : filosofo_hambriento.tenedor_der = 1 
            else ###### si no, busca al siguiente
                tenedores[i_filosofos + 1] == -1 ? filosofo_hambriento.tenedor_der = 0 : filosofo_hambriento.tenedor_der = 1
            end
            filosofo_hambriento.estado = 1 #### cambia el estado (verificado al llegar)
        end
        if filosofo_hambriento.estado == 1 ### si ya fue verificado (o esta en espera)
            if filosofo_hambriento.tenedor_izq == 0 && filosofo_hambriento.tenedor_der == 0 #### si ambos tenedores estan libres
                tenedores[i_filosofos] = i_filosofos  ###### ocupamos el tenedor
                filosofo_hambriento.hora_inicio = tiempo  #### asignamos la hora de inicio
                i_filosofos == n_filosofos.to_i - 1.to_i ? tenedores[0] = i_filosofos : tenedores[i_filosofos] = i_filosofos #### ocupamos el tenedor
                filosofo_hambriento.estado = 2 #### cambiamos el estado a "comiendo"
                tiempo += 1
            end
            if filosofo_hambriento.tenedor_izq == 1 #### vuelve a verificar si ya se libero el tenedor izquierdo
                if tenedores[i_filosofos] == -1
                    filosofo_hambriento.tenedor_izq = 0
                end
            end
            if filosofo_hambriento.tenedor_der == 1 #### vuelve a verificar si ya se libero el tenedor derecho
                if i_filosofos == n_filosofos.to_i - 1.to_i  #### si es el ultimo verificamos al inicio de la lista de tenedores
                    if tenedores[0] == -1
                        filosofo_hambriento.tenedor_der = 0
                    end
                else
                    if tenedores[i_filosofos + 1] == -1     #### si no, verificamos el siguiente
                        filosofo_hambriento.tenedor_der = 0
                    end
                end
            end     
        end
        if filosofo_hambriento.estado == 2 ##### si el filosofo esta comiendo
            if filosofo_hambriento.hora_inicio.to_i + filosofo_hambriento.tiempo_comida.to_i == tiempo ##### verifica si ya acabo de comer
                contador_terminados += 1    #### variable de control para detener el ciclo principal
                filosofo_hambriento.estado = 3 #### cambiamos de estado a terminado
                filosofo_hambriento.hora_salida = tiempo    ### asignamos la hora que acabo
                tenedores[i_filosofos] = -1 ###### liberamos el tenedor izquierdo
                i_filosofos == n_filosofos.to_i - 1.to_i   ? tenedores[0] = -1 : tenedores[i_filosofos + 1] = -1 #### Liberamos el tenedor derecho
                filosofos_atendidos.push(filosofo_hambriento) #### añadimos a otra lista el orden en que fueron atendidos
            end
        end
        i_filosofos += 1 ### aumentamos la variable de control
    end
    tiempo += 1 #### aumentamos la variable de control de tiempo
end

print "\n\nLista de filosofos en orden de atencion" ### impresion de resultados
filosofos_atendidos.each do |filosofo|
    filosofo.to_string()
end