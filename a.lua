




grow = {0.0, 1.0, 0.2, 0.0, 0.6, 0.6, 0.1, 0.4}
seed = {0.0, 0.2, 0.2, 1.0, 0.2, 0.6, 0.6, 0.5}
tissue = {0.0, 0.0, 0.95, 0.0, 0.8, 0.0, 0.8, 0.7}


disturbance = 0.81
resource = 0.2


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
@description Verifica se há recursos suficientes
para manter a planta na celula
--]]
Maintain = function(self)
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
    cell.stateNow = 0
    cell.stateNext = 0
    --cell.state = "Now"
    --cell.state = "Next
end -- vegDeath.function


--stateNow = 0
--stateNext = 1


modelo = Model{

    cell = Cell{
    --print(state.Now),
    stateNow = math.random(),
    stateNext = math.random(),
    execute = function(cell)
        if math.random() < disturbance then
            vegDeath(cell)
        else
            Maintain(cell)
        end
    end, --execute
    init = function(cell)


    -- Espaço Celular --
    cs = CellularSpace
    {
        xdim = 32,
        instance = cell,
    } -- CellularSpace


    -- Criação da Vizinhança --
    cs:createNeighborhood{name="moore"}


    t = Timer{
        Event{action = cs}
    }

    map = Map{
        target = cs,
        select="stateNow",
        color= "Greens",
        slices=4,
        min=0,
        max=3}

        --print("INIT")

        --vegDeath(cell)
        --Maintain(cell)
    
    end -- init.function

} -- cell

} -- model

    --value={"Now", "Next"}}


modelo:run(1)

--[[forEachCell(cs, function(self)
        print("Agora  ".. self.now)
        print("Futuro " .. self.next)
        print("\n")

        --print("\n")
        --print(gtotal)


        end)--]]
--print(cell.now)


