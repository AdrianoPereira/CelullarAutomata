function countNeighbors(cell, val)
  if val == nil then
    return #cell:getNeighborhood()
  end

  local count = 0
  forEachNeighbor(cell, function(neigh)
    if neigh.past.state == val then
        count = count + 1
    end
  end)
  return count
end

dimension = 10

Evacuation = Model{
    finalTime = 100,
    dim = dimension,
    people = 20,
    pos_door = Random({min=0, max=3, step=1}):sample(),
    idx_door = Random({min=0, max=dimension-1, step=1}):sample(),
    random = true,
    
    init = function(self)
        self.cell = Cell {
            state = Random{"empty", "people"},
            execute = function(cell)
                local count = countNeighbors(cell, "p")
                
                for i=0, self.dim-1 do
                    print('pos_door: '..self.pos_door..' idx_door: '..self.idx_door..' i: '..i)
                    if cell.x == 0 and cell.y == i then
                        cell.state = "wall"
                        if self.pos_door == 0.0 and self.idx_door == i then
                            cell.state = "door"
                        end
                    elseif cell.x == i and cell.y == 0 then
                        cell.state = "wall"
                        if self.pos_door == 3.0 and self.idx_door == i then
                            cell.state = "door"
                        end
                    elseif cell.x == self.dim-1 and cell.y == i then
                        cell.state = "wall"
                        if self.pos_door == 2.0 and self.idx_door == i then
                            cell.state = "door"
                        end
                    elseif cell.x == i and cell.y == self.dim-1 then
                        cell.state = "wall"
                        if self.pos_door == 1.0 and self.idx_door == i then
                            cell.state = "door"
                        end
                    end
                end
            end
        }

        self.space = CellularSpace {
            xdim = self.dim,
            instance = self.cell,
        }

        self.space:createNeighborhood{strategy = "vonneumann"}

        self.map = Map {
            target = self.space,
            select = "state",
            value = {"wall", "people", "door", "empty"},
            color = {"black", "red", "green", "white"}
        }

        self.timer = Timer {
            Event { action = self.space },
            Event { action = self.map }
        }
    end
}

evacuation = Evacuation{}
evacuation:run()

evacuation.map:save("evacuation.png")