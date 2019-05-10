
grow = {0.0, 1.0, 0.2, 0.0, 0.6, 0.6, 0.1, 0.4}
seed = {0.0, 0.2, 0.2, 1.0, 0.2, 0.6, 0.6, 0.5}
tissue = {0.0, 0.0, 0.95, 0.0, 0.8, 0.0, 0.8, 0.7}


disturbance = 0.5
resource = 0.5


-- teste --
teste_funcao = function(self)
    local gw = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    local sw = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    local well = {0, 0, 0, 0, 0, 0, 0, 0, 0}
    local choice = 0.0
    local gtotal = 0.0
    local stotal = 0.0
    local i = 0
    print("aquadsdsadsadsadasdadi")

    --forEachCell(model.cs, function(cell)
    forEachNeighbor(self, function(neigh) -- 4-Neighbors
        gtotal = gtotal + grow[neigh.now + 1]
        stotal = stotal + seed[neigh.now + 1]
        gw[i] = gtotal
        sw[i] = stotal
        well[i] = neigh.stateNow
        i = i + 1
    end) -- foreachend
end -- teste_funcao


--[[
@name Maintain.function
@deion Verifica se há recursos suficientes
para manter a planta na celula
--]]
Maintain = function(self)
    --print("entrou maintain")
    if math.random() < 0.4 or math.random() < 0.2 then
            self.stateNext = self.stateNow
    else
        vegDeath(self)
    end -- if
end -- Maintain.function


--[[
@name: vegDeath.function
@descripition Mata a vetação
--]]
vegDeath = function(cell)
    --print("entrou vegDeath")
    cell.stateNow = 0
    cell.stateNext = 0
    --cell.state = "Now"
    --cell.state = "Next
end -- vegDeath.function


stateNow = 0
stateNext = 1


part1 = function()
    print ("Entrou na Parte 1")
    cell1 = Cell{
        stateNow = 0,
        stateNext = 1,
        execute = function(self)
            print ("Parte 1")
            if math.random() < disturbance then
                vegDeath(self)
            else
                Maintain(self)
            end --if
        end -- execute
    }
    return cell1
end --part1




modelo = Model{
    finalTime = 1,
    exec = 1,
    dim = 5,

    init = function(self)
        -- customError("borhood' first.")
        self.celular = part1()


            -- Espaço Celular --
        self.space = CellularSpace{
            xdim = 2,
            instance = self.celular
        } -- CellularSpace


        -- Criação da Vizinhança --
        self.space:createNeighborhood{name="moore"}
        --self.space:createNeighborhood{name="vonneumann"}

        self.mapa = Map{
            target = self.space,
            select="stateNow",
            color= "Greens",
            slices=4,
            min=0,
            max=3
        }
        self:notify()
        self.t = Timer{
            Event {action = self.space},
            Event { action = self.mapa}
        }

    end, -- init

    execute = function(modelo)
       print("Execute!!")
    end

} -- model

    --value={"Now", "Next"}}


-- modelo:run()
modelo:configure()

--[[forEachCell(cs, function(self)
        print("Agora  ".. self.now)
        print("Futuro " .. self.next)
        print("\n")

        --print("\n")
        --print(gtotal)


        end)--]]
--print(cell.now)


